import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../../l10n/app_localizations.dart';
import 'labeled_text_field.dart';

class BirthDateField extends StatelessWidget {
  BirthDateField({super.key, required this.controller});

  final TextEditingController controller;

  final MaskTextInputFormatter _mask = MaskTextInputFormatter(
    mask: '##-##-####',
    filter: {'#': RegExp(r'\d')},
    type: MaskAutoCompletionType.lazy,
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return LabeledTextField(
      label: l10n.dateOfBirth,
      hint: l10n.birthDateHint,
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [_mask],
    );
  }
}
