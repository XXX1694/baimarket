import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/main_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubit/auth_cubit.dart';
import '../widgets/phone_number_input.dart';
import '../../../../core/app_pallete.dart';

class SetPasswordPage extends StatefulWidget {
  final String token;
  const SetPasswordPage({super.key, required this.token});

  @override
  State<SetPasswordPage> createState() => _SetPasswordPageState();
}

class _SetPasswordPageState extends State<SetPasswordPage> {
  late TextEditingController passwordController;
  late AuthCubit cubit;

  @override
  void initState() {
    passwordController = TextEditingController();
    cubit = AuthCubit();
    super.initState();
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: BlocConsumer<AuthCubit, AuthState>(
            bloc: cubit,
            listener: (context, state) {
              if (state is CodeVerified) {
                context.go('/main');
              } else if (state is AuthError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            builder: (context, state) {
              final isLoading = state is AuthLoading;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 64),
                  Text(
                    'Создайте новый пароль',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: mainColorLight,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Придумайте надежный пароль для входа',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  PasswordInput(controller: passwordController),
                  const SizedBox(height: 32),
                  MainButton(
                    onPressed:
                        isLoading
                            ? null
                            : () {
                              cubit.setPassword(
                                token: widget.token,
                                newPassword: passwordController.text,
                              );
                            },
                    text: isLoading ? 'Загрузка...' : 'Установить пароль',
                  ),
                  const SizedBox(height: 40),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
