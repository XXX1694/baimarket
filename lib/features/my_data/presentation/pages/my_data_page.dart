import 'package:bai_market/core/urls.dart';
import 'package:bai_market/core/widgets/main_button.dart';
import 'package:bai_market/features/my_data/presentation/widgets/first_name_field.dart';
import 'package:bai_market/features/my_data/presentation/widgets/last_name_field.dart';
import 'package:bai_market/features/profile/data/models/profile_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../../core/secure_token_storage.dart';

import '../../../../l10n/app_localizations.dart';
import '../widgets/delete_account_button.dart';
import '../widgets/select_avatar.dart';

class MyDataPage extends StatefulWidget {
  const MyDataPage({super.key, required this.profileModel});
  final ProfileModel profileModel;

  @override
  State<MyDataPage> createState() => _MyDataPageState();
}

class _MyDataPageState extends State<MyDataPage> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  final Dio dio = Dio(); // Инициализация Dio

  @override
  void initState() {
    firstNameController = TextEditingController(
      text: widget.profileModel.firstName,
    );
    lastNameController = TextEditingController(
      text: widget.profileModel.lastName,
    );
    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    dio.close(); // Закрытие Dio для освобождения ресурсов
    super.dispose();
  }

  Future<void> _updateProfile() async {
    final l10n = AppLocalizations.of(context)!;
    const String baseUrl = mainUrl;
    final url = Uri.parse('${baseUrl}profile');
    String? token = await getAuthToken();

    // Валидация полей
    if (firstNameController.text.isEmpty || lastNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.fillAllFields),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
        ),
      );
      return;
    }

    try {
      dio.options.headers["authorization"] = "Bearer $token";
      final response = await dio.patch(
        url.toString(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            // Если требуется токен авторизации, добавьте его здесь
            // 'Authorization': 'Bearer your_token_here',
          },
        ),
        data: {
          'firstName': firstNameController.text,
          'lastName': lastNameController.text,
        },
      );

      if (response.statusCode == 200) {
        profileCubitGlobal.getProfileData();
        // Успешно обновлено, выполняем pop
        Navigator.pop(context);
      } else {
        // Ошибка, показываем SnackBar с деталями
        final errorMessage = response.data['message'] ?? 'Unknown error';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.profileUpdateError(errorMessage)),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    } catch (e) {
      // Обработка исключений (например, нет интернета)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.error(e.toString())),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          l10n.myData,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 32),
              SelectAvatar(imageUrl: widget.profileModel.avatarUrl ?? ''),
              const SizedBox(height: 32),
              FirstNameField(controller: firstNameController),
              LastNameField(controller: lastNameController),
              // PhoneNumberField(), // Раскомментируйте, если нужно
              const SizedBox(height: 4),
              MainButton(onPressed: _updateProfile, text: l10n.save),
              const Spacer(),
              DeleteAccountButton(text: l10n.deleteAccount, onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
