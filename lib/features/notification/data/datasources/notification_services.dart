import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/urls.dart';
import '../../domain/repositories/notification_repository.dart';
import '../models/notification_model.dart';

class NotificationServices implements NotificationRepository {
  final Dio _dio = Dio();
  final _storage = SharedPreferences.getInstance();
  @override
  Future<List<NotificationModel>> getNotification() async {
    final url = mainUrl;
    String finalUrl = '${url}notification?limit=20&cursor=';

    try {
      var storage = await _storage;
      String? token = storage.getString('auth_token');
      if (token == null) return [];
      _dio.options.headers["authorization"] = "Bearer $token";
      final response = await _dio.get(finalUrl);
      List data = response.data['items'];
      List<NotificationModel> notifications = [];
      for (int i = 0; i < data.length; i++) {
        NotificationModel notificationModel = NotificationModel.fromJson(
          data[i],
        );
        notifications.add(notificationModel);
      }
      if (response.statusCode == 200) {
        return notifications;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }
}
