import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../../core/secure_token_storage.dart';
import '../../../../core/urls.dart';
import '../../domain/repositories/create_order_repository.dart';

class CreateOrderServices implements CreateOrderRepository {
  final Dio _dio = Dio();
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
    final url = mainUrl;
    String finalUrl = '${url}delivery';
    String finalUrl1 = '${url}order/new/';
    String? token = await getAuthToken();
    if (token == null) return null;
    _dio.options.headers["authorization"] = "Bearer $token";
    try {
      final response = await _dio.post(
        finalUrl,
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
      if (response.statusCode == 201) {
        final response1 = await _dio.post(
          finalUrl1,
          data: jsonEncode({"paymentTypeSlug": "ONEV"}),
        );
        print(response1.statusCode);
        if (response1.statusCode == 201) {
          return response1.data['redirectUrl'].toString();
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
