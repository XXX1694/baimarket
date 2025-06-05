import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../../core/app_pallete.dart';
import '../../../../l10n/app_localizations.dart';

class CardNumberField extends StatelessWidget {
  const CardNumberField({super.key, required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final cardNumberFormatter = MaskTextInputFormatter(
      mask: '#### #### #### ####',
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
              l10n.cardNumber,
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
            inputFormatters: [cardNumberFormatter],
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              filled: true,
              fillColor: lightGray,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              hintText: '0000 0000 0000 0000',
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
            autofillHints: const [AutofillHints.creditCardNumber],
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
