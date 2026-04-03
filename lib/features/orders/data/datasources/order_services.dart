import 'package:bai_market/features/orders/data/models/order_model.dart';
import 'package:bai_market/features/orders/domain/repositories/order_repository.dart';
import 'package:dio/dio.dart';
import '../../../../core/secure_token_storage.dart';
import '../../../../core/urls.dart';

class OrderServices implements OrderRepository {
  final Dio _dio = Dio();
  @override
  Future<List<OrderModel>> getOrders() async {
    final url = mainUrl;
    String finalUrl = '${url}order';
    String? token = await getAuthToken();
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
      return [];
    }
  }
}
