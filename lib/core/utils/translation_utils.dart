import 'package:flutter/material.dart';

class TranslationUtils {
  static String getLocalizedName({
    required BuildContext context,
    String? nameKz,
    String? nameRu,
    String? nameEn,
    String? name,
  }) {
    final locale = Localizations.localeOf(context).languageCode;

    if (locale == 'kk' && nameKz != null && nameKz.isNotEmpty) {
      return nameKz;
    } else if (locale == 'ru' && nameRu != null && nameRu.isNotEmpty) {
      return nameRu;
    } else if (locale == 'en' && nameEn != null && nameEn.isNotEmpty) {
      return nameEn;
    } else if (name != null && name.isNotEmpty) {
      return name;
    }

    return '';
  }

  static String getLocalizedDescription({
    required BuildContext context,
    String? descriptionKz,
    String? descriptionRu,
    String? descriptionEn,
  }) {
    final locale = Localizations.localeOf(context).languageCode;

    if (locale == 'kk' && descriptionKz != null && descriptionKz.isNotEmpty) {
      return descriptionKz;
    } else if (locale == 'ru' &&
        descriptionRu != null &&
        descriptionRu.isNotEmpty) {
      return descriptionRu;
    } else if (locale == 'en' &&
        descriptionEn != null &&
        descriptionEn.isNotEmpty) {
      return descriptionEn;
    }

    return '';
  }
}
