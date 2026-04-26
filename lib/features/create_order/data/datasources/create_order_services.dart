import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../core/network/app_dio.dart';
import '../../../../core/urls.dart';
import '../../domain/repositories/create_order_repository.dart';

class CreateOrderServices implements CreateOrderRepository {
  final Dio _dio = appDio;

  @override
  Future<String?> createOrder({
    required int cartId,
    required String fullName,
    required String phoneNumber,
    required bool selfPick,
    required String postalCode,
    required int cityId,
    required String deliveryAddress,
    required String comment,
    required String? pickupUrl,
    required String? selfPickDate,
    required int? filialId,
  }) async {
    final deliveryUrl = '${mainUrl}delivery';
    final orderUrl = '${mainUrl}order/new/';
    try {
      final response = await _dio.post(
        deliveryUrl,
        data: jsonEncode({
          "cartId": cartId,
          "fullName": fullName,
          "phoneNumber": phoneNumber,
          "selfPick": selfPick,
          "postalCode": postalCode,
          "cityId": cityId,
          "deliveryAddress": deliveryAddress,
          "comment": comment,
          "pickupUrl": pickupUrl,
          "selfPickDate": selfPickDate,
          "filialId": filialId,
        }),
      );
      if (response.statusCode != 201) return null;
      final orderResponse = await _dio.post(
        orderUrl,
        data: jsonEncode({"paymentTypeSlug": "ONEV"}),
      );
      if (orderResponse.statusCode != 201) return null;
      return orderResponse.data['redirectUrl'].toString();
    } catch (_) {
      return null;
    }
  }
}
