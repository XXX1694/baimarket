import 'dart:io';
import 'package:bai_market/core/urls.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class FirebaseMessagingService {
  static final FirebaseMessagingService _instance =
      FirebaseMessagingService._internal();
  factory FirebaseMessagingService() => _instance;
  FirebaseMessagingService._internal();

  static final _firebaseMessaging = FirebaseMessaging.instance;
  static final _dio = Dio();

  // Константы для каналов уведомлений
  static const String _defaultChannelId = 'default_channel';
  static const String _defaultChannelName = 'Основные уведомления';
  static const String _defaultChannelDescription =
      'Канал для основных уведомлений приложения';

  // Инициализация сервиса
  static Future<void> init() async {
    try {
      await _configureFirebaseMessaging();
      await _configureAwesomeNotifications();
      await _setupNotificationHandlers();
      await _handleInitialMessage();
    } catch (e) {
      print('Ошибка инициализации Firebase Messaging: $e');
    }
  }

  // Настройка Firebase Messaging
  static Future<void> _configureFirebaseMessaging() async {
    try {
      // Настройка разрешений для iOS
      if (Platform.isIOS) {
        // Request permission first
        final settings = await _firebaseMessaging.requestPermission(
          alert: true,
          badge: true,
          sound: true,
          provisional: false,
          criticalAlert: true,
        );

        print('User granted permission: ${settings.authorizationStatus}');

        // Wait a bit for the permission to be fully processed
        await Future.delayed(const Duration(seconds: 1));

        // Get APNS token with retry logic
        String? apnsToken;
        int retryCount = 0;
        const maxRetries = 3;

        while (apnsToken == null && retryCount < maxRetries) {
          try {
            apnsToken = await _firebaseMessaging.getAPNSToken();
            if (apnsToken != null) {
              print('APNS Token successfully obtained: $apnsToken');
            } else {
              print(
                'APNS Token is null, attempt ${retryCount + 1} of $maxRetries',
              );
              await Future.delayed(const Duration(seconds: 1));
            }
          } catch (e) {
            print(
              'Error getting APNS token, attempt ${retryCount + 1} of $maxRetries: $e',
            );
            await Future.delayed(const Duration(seconds: 1));
          }
          retryCount++;
        }

        if (apnsToken == null) {
          print('Failed to get APNS token after $maxRetries attempts');
        }
      }

      // Настройка фоновых сообщений
      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );

      // Получение и отправка начального токена
      await _handleInitialToken();
    } catch (e) {
      print('Ошибка настройки Firebase Messaging: $e');
      rethrow; // Rethrow to handle it in the init method
    }
  }

  // Настройка Awesome Notifications
  static Future<void> _configureAwesomeNotifications() async {
    try {
      await AwesomeNotifications().initialize(
        null, // null означает использование иконки приложения
        [
          NotificationChannel(
            channelKey: _defaultChannelId,
            channelName: _defaultChannelName,
            channelDescription: _defaultChannelDescription,
            defaultColor: const Color(0xFF00320F),
            ledColor: const Color(0xFF00320F),
            importance: NotificationImportance.High,
            channelShowBadge: true,
            enableVibration: true,
            enableLights: true,
            playSound: true,
          ),
        ],
        debug: true,
      );

      // Запрос разрешений
      await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
        if (!isAllowed) {
          AwesomeNotifications().requestPermissionToSendNotifications();
        }
      });

      // Настройка обработчиков уведомлений
      AwesomeNotifications().setListeners(
        onActionReceivedMethod: _onNotificationActionReceived,
        onNotificationCreatedMethod: _onNotificationCreated,
        onNotificationDisplayedMethod: _onNotificationDisplayed,
        onDismissActionReceivedMethod: _onDismissActionReceived,
      );
    } catch (e) {
      print('Ошибка настройки Awesome Notifications: $e');
    }
  }

  // Настройка обработчиков уведомлений
  static Future<void> _setupNotificationHandlers() async {
    try {
      // Обработка уведомлений в foreground
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Обработка открытия уведомления
      FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationOpened);

      // Обработка обновления токена
      _firebaseMessaging.onTokenRefresh.listen(_handleTokenRefresh);
    } catch (e) {
      print('Ошибка настройки обработчиков уведомлений: $e');
    }
  }

  // Обработка начального сообщения
  static Future<void> _handleInitialMessage() async {
    try {
      final initialMessage = await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        _handleNotificationOpened(initialMessage);
      }
    } catch (e) {
      print('Ошибка обработки начального сообщения: $e');
    }
  }

  // Обработка уведомления в foreground
  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    try {
      final notification = message.notification;
      final data = message.data;

      if (notification != null || data.isNotEmpty) {
        final title =
            notification?.title ?? data['title'] ?? 'Новое уведомление';
        final body = notification?.body ?? data['body'] ?? '';

        await _showNotification(
          id: message.hashCode,
          title: title,
          body: body,
          payload: data,
        );
      }
    } catch (e) {
      print('Ошибка обработки foreground сообщения: $e');
    }
  }

  // Показ уведомления
  static Future<void> _showNotification({
    required int id,
    required String title,
    required String body,
    Map<String, dynamic>? payload,
  }) async {
    try {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: _defaultChannelId,
          title: title,
          body: body,
          payload: payload?.map(
            (key, value) => MapEntry(key, value?.toString()),
          ),
          notificationLayout: NotificationLayout.Default,
          category: NotificationCategory.Message,
        ),
      );
    } catch (e) {
      print('Ошибка показа уведомления: $e');
    }
  }

  // Обработчики Awesome Notifications
  @pragma('vm:entry-point')
  static Future<void> _onNotificationActionReceived(
    ReceivedAction receivedAction,
  ) async {
    try {
      print('Уведомление нажато: ${receivedAction.payload}');
      // Здесь можно добавить навигацию или другую логику при нажатии
    } catch (e) {
      print('Ошибка обработки нажатия на уведомление: $e');
    }
  }

  @pragma('vm:entry-point')
  static Future<void> _onNotificationCreated(
    ReceivedNotification receivedNotification,
  ) async {
    try {
      print('Уведомление создано: ${receivedNotification.title}');
    } catch (e) {
      print('Ошибка создания уведомления: $e');
    }
  }

  @pragma('vm:entry-point')
  static Future<void> _onNotificationDisplayed(
    ReceivedNotification receivedNotification,
  ) async {
    try {
      print('Уведомление показано: ${receivedNotification.title}');
    } catch (e) {
      print('Ошибка отображения уведомления: $e');
    }
  }

  @pragma('vm:entry-point')
  static Future<void> _onDismissActionReceived(
    ReceivedAction receivedAction,
  ) async {
    try {
      print('Уведомление закрыто: ${receivedAction.title}');
    } catch (e) {
      print('Ошибка закрытия уведомления: $e');
    }
  }

  // Обработка открытия уведомления
  static void _handleNotificationOpened(RemoteMessage message) {
    try {
      print('Уведомление открыто: ${message.data}');
      // Здесь можно добавить навигацию или другую логику при открытии
    } catch (e) {
      print('Ошибка обработки открытия уведомления: $e');
    }
  }

  // Обработка обновления токена
  static Future<void> _handleTokenRefresh(String newToken) async {
    try {
      print('FCM Token обновлён: $newToken');
      await _sendTokenToBackend(newToken);
    } catch (e) {
      print('Ошибка обработки обновления токена: $e');
    }
  }

  // Обработка начального токена
  static Future<void> _handleInitialToken() async {
    try {
      final fcmToken = await _firebaseMessaging.getToken();
      if (fcmToken != null) {
        print('FCM Token получен: $fcmToken');
        await _sendTokenToBackend(fcmToken);
      }
    } catch (e) {
      print('Ошибка обработки начального токена: $e');
    }
  }

  // Отправка токена на бэкенд
  static Future<void> _sendTokenToBackend(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('auth_token');
      // print(authToken);
      if (authToken == null) {
        print('Токен авторизации не найден');
        return;
      }

      _dio.options.headers['Authorization'] = 'Bearer $authToken';

      final response = await _dio.post(
        '${mainUrl}firebase-token/',
        data: {'token': token},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('FCM токен успешно отправлен на сервер');
      } else {
        print('Ошибка отправки FCM токена: ${response.statusCode}');
      }
    } catch (e) {
      print('Ошибка отправки FCM токена на сервер: $e');
    }
  }
}

// Обработчик фоновых сообщений
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    print('Получено фоновое сообщение: ${message.messageId}');
    // Здесь можно добавить дополнительную логику для фоновых сообщений
  } catch (e) {
    print('Ошибка обработки фонового сообщения: $e');
  }
}
