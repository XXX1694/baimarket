import 'package:bai_market/features/orders/data/models/order_model.dart';
import 'package:bai_market/features/orders/domain/repositories/order_repository.dart';
import 'package:dio/dio.dart';

import '../../../../core/network/app_dio.dart';
import '../../../../core/urls.dart';

class OrderServices implements OrderRepository {
  final Dio _dio = appDio;

  @override
  Future<List<OrderModel>> getOrders() async {
    final finalUrl = '${mainUrl}order';
    try {
      final response = await _dio.get(finalUrl);
      if (response.statusCode != 200) return [];
      final List data = response.data;
      return [for (final entry in data) OrderModel.fromJson(entry)];
    } catch (_) {
      return [];
    }
  }
}
