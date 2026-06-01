import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

/// Получить токен авторизации из SharedPreferences
Future<String?> getAuthToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('auth_token');
}

/// Проверить, авторизован ли пользователь (есть ли токен)
Future<bool> isAuthorized() async {
  final token = await getAuthToken();
  return token != null && token.isNotEmpty;
}
