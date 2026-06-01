import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

class PaymentTermsText extends StatelessWidget {
  const PaymentTermsText({super.key, this.onTermsTap});
  final VoidCallback? onTermsTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const baseStyle = TextStyle(
      fontFamily: 'Gilroy',
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Color(0xFF7E7E7E),
      height: 1.35,
    );
    final linkStyle = baseStyle.copyWith(color: const Color(0xFF2F8DDA));

    return Text.rich(
      TextSpan(
        style: baseStyle,
        children: [
          TextSpan(text: l10n.paymentTermsPart1),
          TextSpan(text: ' '),
          TextSpan(
            text: l10n.paymentTermsLinkText,
            style: linkStyle,
            recognizer: onTermsTap != null
                ? (TapGestureRecognizer()..onTap = onTermsTap)
                : null,
          ),
          TextSpan(text: ' '),
          TextSpan(text: l10n.paymentTermsPart2),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
