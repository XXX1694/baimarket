import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import 'labeled_text_field.dart';

class NameField extends StatelessWidget {
  const NameField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return LabeledTextField(
      label: l10n.name,
      hint: l10n.name,
      controller: controller,
      keyboardType: TextInputType.name,
      autofillHints: const [AutofillHints.givenName],
      textCapitalization: TextCapitalization.words,
    );
  }
}
