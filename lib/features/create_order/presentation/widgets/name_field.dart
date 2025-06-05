import 'package:flutter/material.dart';

import '../../../../core/app_pallete.dart';

class NameField extends StatelessWidget {
  const NameField({super.key, required this.controller});
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: const Text(
              'Кто встретит (ФИО)?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: lightGray, // фон
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              hintText: 'Например: Даниял Асылбеков',
              hintStyle: const TextStyle(
                fontSize: 15,
                color: Colors.black38,
                fontWeight: FontWeight.w400,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
            keyboardType: TextInputType.name,
            autofillHints: const [
              AutofillHints.name,
              AutofillHints.nickname,
              AutofillHints.namePrefix,
              AutofillHints.nameSuffix,
              AutofillHints.givenName,
              AutofillHints.familyName,
              AutofillHints.middleName,
              AutofillHints.newUsername,
            ],
            enableSuggestions: true, // Включаем подсказки клавиатуры
            autocorrect: false, // Включаем автокоррекцию
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
