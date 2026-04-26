import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../routing/app_routing.dart';
import '../secure_token_storage.dart';

/// Single Dio instance for all authenticated HTTP traffic.
///
/// Behavior:
/// 1. Adds `Authorization: Bearer <token>` to every request when a token exists.
/// 2. If no token exists, the request is rejected locally as a 401 — no
///    network call is made. The flag `extra['hadAuth']` stays false.
/// 3. On a real 401 from the server (token expired), the token is wiped and
///    the user is sent to /auth. Only triggers when `extra['hadAuth']` is true,
///    so foreground requests from guests don't kick anyone out.
final Dio appDio = _build();

const _hadAuthKey = 'hadAuth';

Dio _build() {
  final dio = Dio();
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await getAuthToken();
        if (token != null) {
          options.headers['authorization'] = 'Bearer $token';
          options.extra[_hadAuthKey] = true;
          return handler.next(options);
        }
        options.extra[_hadAuthKey] = false;
        return handler.reject(
          DioException(
            requestOptions: options,
            response: Response(
              requestOptions: options,
              statusCode: 401,
              data: {'error': 'no auth token'},
            ),
            type: DioExceptionType.cancel,
            error: 'no auth token',
          ),
          true,
        );
      },
      onError: (e, handler) async {
        final hadAuth = e.requestOptions.extra[_hadAuthKey] == true;
        if (e.response?.statusCode == 401 && hadAuth) {
          debugPrint('🔒 401 with valid token — logging out');
          await removeAuthToken();
          try {
            router.go('/auth');
          } catch (_) {
            // router not yet attached — ignore
          }
        }
        return handler.next(e);
      },
    ),
  );
  return dio;
}
