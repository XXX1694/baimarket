import 'package:dio/dio.dart';

import '../../../../core/network/app_dio.dart';
import '../../../../core/urls.dart';
import '../../domain/repositories/notification_repository.dart';
import '../models/notification_model.dart';

class NotificationServices implements NotificationRepository {
  final Dio _dio = appDio;

  @override
  Future<List<NotificationModel>> getNotification() async {
    final finalUrl = '${mainUrl}notification?limit=20&cursor=';
    try {
      final response = await _dio.get(finalUrl);
      if (response.statusCode != 200) return [];
      final List data = response.data['items'];
      return [for (final item in data) NotificationModel.fromJson(item)];
    } catch (_) {
      return [];
    }
  }
}
