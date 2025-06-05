import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/urls.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthServices implements AuthRepository {
  final Dio _dio = Dio();
  final _storage = SharedPreferences.getInstance();
  @override
  Future<bool> sendOtp({required String phoneNumber}) async {
    final url = mainUrl;
    String finalUrl = '${url}auth/otp/request';
    try {
      final response = await _dio.post(
        finalUrl,
        data: jsonEncode({"phoneNumber": removeAllSpaces(phoneNumber)}),
      );
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> verifyOtp({
    required String phoneNumber,
    required String code,
  }) async {
    final url = mainUrl;
    var storage = await _storage;
    String finalUrl = '${url}auth/otp/confirm';
    try {
      final response = await _dio.post(
        finalUrl,
        data: jsonEncode({"phoneNumber": phoneNumber, "code": code}),
      );
      if (response.statusCode == 201) {
        storage.setString('auth_token', response.data['accessToken']);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}

String removeAllSpaces(String input) {
  return input.replaceAll(' ', '');
}
