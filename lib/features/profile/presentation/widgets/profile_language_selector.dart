import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider;
import '../../../../core/providers/language_provider.dart';
import '../../../../l10n/app_localizations.dart';

class ProfileLanguageSelector extends StatelessWidget {
  const ProfileLanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final languageProvider = provider.Provider.of<LanguageProvider>(context);
    final currentLang = languageProvider.currentLocale.languageCode;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF5B5BFF).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Icon(
                Icons.translate,
                color: Color(0xFF5B5BFF),
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Text(
            l10n.language,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const Spacer(),
          _LangPill(
            label: 'Қазақша',
            isSelected: currentLang == 'kk',
            onTap: () => languageProvider.changeLanguage('kk'),
          ),
          const SizedBox(width: 6),
          _LangPill(
            label: 'Русский',
            isSelected: currentLang == 'ru',
            onTap: () => languageProvider.changeLanguage('ru'),
          ),
        ],
      ),
    );
  }
}

class _LangPill extends StatelessWidget {
  const _LangPill({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3D3D3D) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}
