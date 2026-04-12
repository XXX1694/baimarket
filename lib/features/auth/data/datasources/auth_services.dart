import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/secure_token_storage.dart';
import '../../../../core/urls.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthServices implements AuthRepository {
  final Dio _dio = Dio();
  @override
  Future<bool> sendOtp({required String phoneNumber}) async {
    final url = mainUrl;
    String finalUrl = '${url}auth/otp/request';
    debugPrint('🌐 POST $finalUrl');
    debugPrint('🌐 body: {"phoneNumber": "$phoneNumber"}');
    try {
      final response = await _dio.post(
        finalUrl,
        data: jsonEncode({"phoneNumber": phoneNumber}),
      );
      debugPrint('🌐 response status: ${response.statusCode}');
      debugPrint('🌐 response data: ${response.data}');
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint('🌐 ❌ sendOtp error: $e');
      return false;
    }
  }

  @override
  Future<bool> verifyOtp({
    required String phoneNumber,
    required String code,
  }) async {
    final url = mainUrl;
    String finalUrl = '${url}auth/otp/confirm';
    try {
      final response = await _dio.post(
        finalUrl,
        data: jsonEncode({"phoneNumber": phoneNumber, "code": code}),
      );
      if (response.statusCode == 201) {
        await setAuthToken(response.data['accessToken']);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}

