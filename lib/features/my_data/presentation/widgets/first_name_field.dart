import 'package:bai_market/core/app_pallete.dart';
import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

class FirstNameField extends StatefulWidget {
  const FirstNameField({super.key, required this.controller});
  final TextEditingController controller;

  @override
  State<FirstNameField> createState() => _FirstNameFieldState();
}

class _FirstNameFieldState extends State<FirstNameField> {
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
              l10n.name,
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
              hintText: l10n.enterName,
              hintStyle: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
                fontWeight: FontWeight.w400,
              ),
              filled: true,
              fillColor: lightGray, // фон
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
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
            keyboardType: TextInputType.name,
            autofillHints: const [
              AutofillHints.givenName,
            ], // Уточнённый hint для имени
            enableSuggestions: true, // Включаем подсказки клавиатуры
            autocorrect: true, // Включаем автокоррекцию
            textCapitalization:
                TextCapitalization
                    .words, // Первая буква каждого слова заглавная
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
