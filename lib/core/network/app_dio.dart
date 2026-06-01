import 'package:dio/dio.dart';

import '../routing/app_routing.dart';
import '../secure_token_storage.dart';
import '../services/app_logger.dart';

/// Single Dio instance for all authenticated HTTP traffic.
///
/// Behavior:
/// 1. Adds `Authorization: Bearer <token>` to every request when a token exists.
/// 2. If no token exists, the request is rejected locally as a 401 — no
///    network call is made. The flag `extra['hadAuth']` stays false.
/// 3. On a real 401 from the server (token expired), the token is wiped and
///    the user is sent to /auth. Only triggers when `extra['hadAuth']` is true,
///    so foreground requests from guests don't kick anyone out.
/// 4. Каждый запрос/ответ пишется через `netLog` (тег `NET`) с методом,
///    путём, статусом и временем. При нужде в payload-ах — поднять
///    [logBodies] до `true`.
final Dio appDio = _build();

const _hadAuthKey = 'hadAuth';
const _startTimeKey = 'reqStartMs';

/// Если включить — успешные response пишутся вместе с телом (truncated).
/// Полезно при глубокой отладке, выключено по умолчанию чтобы не флудить.
const bool logBodies = false;

Dio _build() {
  final dio = Dio();
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        options.extra[_startTimeKey] = DateTime.now().millisecondsSinceEpoch;
        final token = await getAuthToken();
        if (token != null) {
          options.headers['authorization'] = 'Bearer $token';
          options.extra[_hadAuthKey] = true;
          netLog.api(
            '→ ${options.method} ${options.uri.path}',
            'auth=yes',
          );
          return handler.next(options);
        }
        options.extra[_hadAuthKey] = false;
        netLog.warn(
          'rejected locally — no token',
          '${options.method} ${options.uri.path}',
        );
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
      onResponse: (response, handler) {
        final dt = _elapsedMs(response.requestOptions);
        final tail = logBodies && response.data != null
            ? '${dt}ms · ${response.data}'
            : '${dt}ms';
        netLog.api(
          '← ${response.statusCode} ${response.requestOptions.method} '
              '${response.requestOptions.uri.path}',
          tail,
        );
        return handler.next(response);
      },
      onError: (e, handler) async {
        final dt = _elapsedMs(e.requestOptions);
        final hadAuth = e.requestOptions.extra[_hadAuthKey] == true;
        final code = e.response?.statusCode;
        netLog.warn(
          '← ${code ?? '-'} ${e.requestOptions.method} '
              '${e.requestOptions.uri.path}',
          '${dt}ms · ${e.response?.data ?? e.message}',
        );
        if (code == 401 && hadAuth) {
          netLog.warn('401 with valid token → sign-out');
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

int _elapsedMs(RequestOptions options) {
  final start = options.extra[_startTimeKey];
  if (start is int) {
    return DateTime.now().millisecondsSinceEpoch - start;
  }
  return -1;
}
