import 'package:bai_market/features/orders/data/models/order_model.dart';
import 'package:bai_market/features/orders/domain/repositories/order_repository.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/urls.dart';

class OrderServices implements OrderRepository {
  final Dio _dio = Dio();
  final _storage = SharedPreferences.getInstance();
  @override
  Future<List<OrderModel>> getOrders() async {
    final url = mainUrl;
    var storage = await _storage;
    String finalUrl = '${url}order';
    String? token = storage.getString('auth_token');
    // String token =
    //     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEwNDI0OCwiaWF0IjoxNzQ0OTk3Mjk2LCJleHAiOjE3NDU2MDIwOTZ9.Bhm9ULK7tZPjaQg8zcmx6YbWV-rkmTCA_eyFb8fb_RM';
    if (token == null) return [];
    _dio.options.headers["authorization"] = "Bearer $token";
    try {
      final response = await _dio.get(finalUrl);
      if (response.statusCode == 200) {
        List data = response.data;
        List<OrderModel> orders = [];
        for (int i = 0; i < data.length; i++) {
          OrderModel order = OrderModel.fromJson(data[i]);
          orders.add(order);
        }
        return orders;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }
}
