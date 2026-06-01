import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/urls.dart';
import '../../domain/repositories/auth_repository.dart';

class VerifyOtpResult {
  final bool success;
  final bool needsPasswordSetup;
  final String? accessToken;
  VerifyOtpResult({
    required this.success,
    required this.needsPasswordSetup,
    this.accessToken,
  });
}

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
  Future<VerifyOtpResult> verifyOtp({
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
        final data = response.data;
        final needsPasswordSetup = data['needsPasswordSetup'] == true;
        final accessToken = data['accessToken'] as String?;
        if (accessToken != null) {
          storage.setString('auth_token', accessToken);
        }
        return VerifyOtpResult(
          success: true,
          needsPasswordSetup: needsPasswordSetup,
          accessToken: accessToken,
        );
      } else {
        return VerifyOtpResult(success: false, needsPasswordSetup: false);
      }
    } catch (e) {
      return VerifyOtpResult(success: false, needsPasswordSetup: false);
    }
  }

  @override
  Future<bool> login({
    required String phoneNumber,
    required String password,
  }) async {
    final url = mainUrl;
    var storage = await _storage;
    String finalUrl = '${url}auth/login';
    try {
      final response = await _dio.post(
        finalUrl,
        data: jsonEncode({
          "phoneNumber": removeAllSpaces(phoneNumber),
          "password": password,
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data is Map && response.data['accessToken'] != null) {
          storage.setString('auth_token', response.data['accessToken']);
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> setPassword({
    required String token,
    required String newPassword,
  }) async {
    final url = mainUrl;
    String finalUrl = '${url}auth/set-password';
    try {
      final response = await _dio.post(
        finalUrl,
        data: jsonEncode({"newPassword": newPassword}),
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }
}

String removeAllSpaces(String input) {
  return input.replaceAll(' ', '');
}
