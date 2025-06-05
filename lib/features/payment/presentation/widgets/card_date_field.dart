import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../../core/app_pallete.dart';

class CardDateField extends StatelessWidget {
  const CardDateField({super.key, required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final dateFormatter = MaskTextInputFormatter(
      mask: '##/##',
      filter: {"#": RegExp(r'[0-9]')},
    );

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              '00/00',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            inputFormatters: [dateFormatter],
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              filled: true,
              fillColor: lightGray,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              hintText: 'MM/YY',
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
            autofillHints: const [AutofillHints.creditCardExpirationDate],
            style: const TextStyle(
              fontSize: 15,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
            enableSuggestions: true,
            autocorrect: true,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
