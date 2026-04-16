import 'package:shared_preferences/shared_preferences.dart';

const _kUserCityKey = 'user_city_name';
const _kDefaultCity = 'Алматы';

Future<String> getUserCity() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(_kUserCityKey) ?? _kDefaultCity;
}

Future<void> setUserCity(String name) async {
  final trimmed = name.trim();
  if (trimmed.isEmpty) return;
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_kUserCityKey, trimmed);
}
