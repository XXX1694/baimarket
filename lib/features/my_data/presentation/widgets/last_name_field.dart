import 'package:bai_market/core/app_pallete.dart';
import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

class LastNameField extends StatefulWidget {
  const LastNameField({super.key, required this.controller});
  final TextEditingController controller;
  @override
  State<LastNameField> createState() => _LastNameFieldState();
}

class _LastNameFieldState extends State<LastNameField> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              l10n.surname,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: widget.controller,
            decoration: InputDecoration(
              hintText: l10n.enterSurname,
              hintStyle: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
                fontWeight: FontWeight.w400,
              ),
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
            autofillHints: const [AutofillHints.familyName],
            enableSuggestions: true, // Включаем подсказки клавиатуры
            autocorrect: true, // Включаем автокоррекцию
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
