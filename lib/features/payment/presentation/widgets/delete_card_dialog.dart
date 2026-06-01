import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

/// Показывает диалог подтверждения удаления карты.
/// Возвращает `true` — пользователь подтвердил, `false`/`null` — отменил.
Future<bool?> showDeleteCardDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    barrierColor: Colors.black54,
    builder: (_) => const _DeleteCardDialog(),
  );
}

class _DeleteCardDialog extends StatelessWidget {
  const _DeleteCardDialog();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.removeCardTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Gilroy',
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              l10n.removeCardSubtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Gilroy',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF8C8C8C),
                height: 1.3,
              ),
            ),
            const SizedBox(height: 22),
            _DialogButton(
              label: l10n.removeAction,
              backgroundColor: const Color(0xFFEC3A3A),
              textColor: Colors.white,
              onPressed: () => Navigator.pop(context, true),
            ),
            const SizedBox(height: 10),
            _DialogButton(
              label: l10n.cancel,
              backgroundColor: Colors.white,
              textColor: Colors.black,
              onPressed: () => Navigator.pop(context, false),
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogButton extends StatelessWidget {
  const _DialogButton({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.onPressed,
  });
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(14),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Gilroy',
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
