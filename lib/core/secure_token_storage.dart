import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _kAuthTokenKey = 'auth_token';
const _secureStorage = FlutterSecureStorage();

Future<String?> getAuthToken() async {
  return await _secureStorage.read(key: _kAuthTokenKey);
}

Future<void> setAuthToken(String token) async {
  await _secureStorage.write(key: _kAuthTokenKey, value: token);
}

Future<void> removeAuthToken() async {
  await _secureStorage.delete(key: _kAuthTokenKey);
}
