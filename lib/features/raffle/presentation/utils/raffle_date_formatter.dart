import 'package:flutter/material.dart';

class RaffleDateFormatter {
  const RaffleDateFormatter._();

  /// Formats an ISO date string as "21 март (19:00)" in the current locale.
  static String formatDrawDate({
    required BuildContext context,
    required String? iso,
  }) {
    final parsed = _tryParseLocal(iso);
    if (parsed == null) return '';
    final locale = Localizations.localeOf(context).languageCode;
    final month = _monthShort(locale, parsed.month);
    final hh = parsed.hour.toString().padLeft(2, '0');
    final mm = parsed.minute.toString().padLeft(2, '0');
    return '${parsed.day} $month ($hh:$mm)';
  }

  /// Formats an ISO date string as "21 марта 2026" in the current locale.
  static String formatDayMonth({
    required BuildContext context,
    required String? iso,
  }) {
    final parsed = _tryParseLocal(iso);
    if (parsed == null) return '';
    final locale = Localizations.localeOf(context).languageCode;
    final month = _monthFull(locale, parsed.month);
    return '${parsed.day} $month';
  }

  static DateTime? _tryParseLocal(String? iso) {
    if (iso == null || iso.isEmpty) return null;
    final parsed = DateTime.tryParse(iso);
    return parsed?.toLocal();
  }

  static String _monthShort(String locale, int month) {
    final index = month.clamp(1, 12) - 1;
    switch (locale) {
      case 'kk':
        return _monthsKkShort[index];
      case 'en':
        return _monthsEnShort[index];
      case 'ru':
      default:
        return _monthsRuShort[index];
    }
  }

  static String _monthFull(String locale, int month) {
    final index = month.clamp(1, 12) - 1;
    switch (locale) {
      case 'kk':
        return _monthsKkFull[index];
      case 'en':
        return _monthsEnFull[index];
      case 'ru':
      default:
        return _monthsRuFull[index];
    }
  }

  static const _monthsRuShort = [
    'янв', 'фев', 'март', 'апр', 'май', 'июнь',
    'июль', 'авг', 'сен', 'окт', 'ноя', 'дек',
  ];
  static const _monthsRuFull = [
    'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
    'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря',
  ];

  static const _monthsKkShort = [
    'қаң', 'ақп', 'нау', 'сәу', 'мам', 'мау',
    'шіл', 'там', 'қыр', 'қаз', 'қар', 'жел',
  ];
  static const _monthsKkFull = [
    'қаңтар', 'ақпан', 'наурыз', 'сәуір', 'мамыр', 'маусым',
    'шілде', 'тамыз', 'қыркүйек', 'қазан', 'қараша', 'желтоқсан',
  ];

  static const _monthsEnShort = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  static const _monthsEnFull = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];
}
