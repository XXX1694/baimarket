import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../../core/app_pallete.dart';
import '../../../../l10n/app_localizations.dart';

class CardCvvField extends StatelessWidget {
  const CardCvvField({super.key, required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final cvvFormatter = MaskTextInputFormatter(
      mask: '###',
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
              l10n.cvv,
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
            inputFormatters: [cvvFormatter],
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              filled: true,
              fillColor: lightGray,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              hintText: '000',
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
            autofillHints: const [AutofillHints.creditCardSecurityCode],
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
