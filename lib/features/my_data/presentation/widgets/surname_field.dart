import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import 'labeled_text_field.dart';

class SurnameField extends StatelessWidget {
  const SurnameField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return LabeledTextField(
      label: l10n.surname,
      hint: l10n.surname,
      controller: controller,
      keyboardType: TextInputType.name,
      autofillHints: const [AutofillHints.familyName],
      textCapitalization: TextCapitalization.words,
    );
  }
}
