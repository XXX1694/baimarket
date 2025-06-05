import 'package:bai_market/core/app_pallete.dart';
import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

class PhoneNumberField extends StatefulWidget {
  const PhoneNumberField({super.key});

  @override
  _PhoneNumberFieldState createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends State<PhoneNumberField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            l10n.phoneNumber,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: lightGray, // фон
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12), // скруглённые углы
              borderSide: BorderSide.none, // убираем границу
            ),
          ),
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
          keyboardType: TextInputType.phone,
          autofillHints: const [AutofillHints.telephoneNumber],
          enableSuggestions: true, // Включаем подсказки клавиатуры
          autocorrect: true, // Включаем автокоррекцию
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
