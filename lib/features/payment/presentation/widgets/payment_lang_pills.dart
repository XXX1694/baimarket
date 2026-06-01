import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider;

import '../../../../core/app_pallete.dart';
import '../../../../core/providers/language_provider.dart';

class PaymentLangPills extends StatelessWidget {
  const PaymentLangPills({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = provider.Provider.of<LanguageProvider>(context);
    final code = lang.currentLocale.languageCode;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Pill(
          label: 'Қазақша',
          isActive: code == 'kk',
          onTap: () => lang.changeLanguage('kk'),
        ),
        const SizedBox(width: 6),
        _Pill(
          label: 'Русский',
          isActive: code == 'ru',
          onTap: () => lang.changeLanguage('ru'),
        ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.isActive,
    required this.onTap,
  });
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: const Size(0, 0),
      onPressed: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: isActive ? mainColorLight : const Color(0xFFEFEFEF),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Gilroy',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : const Color(0xFF8C8C8C),
          ),
        ),
      ),
    );
  }
}
