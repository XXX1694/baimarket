import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../../l10n/app_localizations.dart';

class NewCardNumberField extends StatelessWidget {
  const NewCardNumberField({super.key, required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return _LabeledField(
      label: l10n.cardNumber,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        autofillHints: const [AutofillHints.creditCardNumber],
        inputFormatters: [
          MaskTextInputFormatter(
            mask: '#### #### #### ####',
            filter: {'#': RegExp(r'[0-9]')},
          ),
        ],
        decoration: _decoration(l10n.cardNumber),
        style: _inputTextStyle,
      ),
    );
  }
}

class NewCardExpiryField extends StatelessWidget {
  const NewCardExpiryField({super.key, required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return _LabeledField(
      label: l10n.cardExpiryLabel,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        autofillHints: const [AutofillHints.creditCardExpirationDate],
        inputFormatters: [
          MaskTextInputFormatter(
            mask: '##/##',
            filter: {'#': RegExp(r'[0-9]')},
          ),
        ],
        decoration: _decoration(l10n.cardExpiryHint),
        style: _inputTextStyle,
      ),
    );
  }
}

class NewCardCvvField extends StatelessWidget {
  const NewCardCvvField({super.key, required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return _LabeledField(
      label: l10n.cardCvvLabel,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        obscureText: true,
        autofillHints: const [AutofillHints.creditCardSecurityCode],
        inputFormatters: [
          LengthLimitingTextInputFormatter(3),
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: _decoration(l10n.cardCvvLabel),
        style: _inputTextStyle,
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({required this.label, required this.child});
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Gilroy',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6E6E6E),
            ),
          ),
        ),
        child,
      ],
    );
  }
}

InputDecoration _decoration(String hint) => InputDecoration(
      filled: true,
      fillColor: const Color(0xFFEFEFEF),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 18,
      ),
      hintText: hint,
      hintStyle: const TextStyle(
        fontFamily: 'Gilroy',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Color(0xFF8C8C8C),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );

const TextStyle _inputTextStyle = TextStyle(
  fontFamily: 'Gilroy',
  fontSize: 16,
  fontWeight: FontWeight.w500,
  color: Colors.black,
);
