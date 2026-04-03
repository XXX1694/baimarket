import 'dart:convert';

import 'package:bai_market/features/cart/data/models/cart_model.dart';
import 'package:bai_market/features/cart/domain/repositories/cart_repository.dart';
import 'package:dio/dio.dart';
import '../../../../core/secure_token_storage.dart';
import '../../../../core/urls.dart';

class CartServices implements CartRepository {
  final Dio _dio = Dio();
  @override
  Future<CartModel?> getCart() async {
    final url = mainUrl;
    String finalUrl = '${url}cart';
    String? token = await getAuthToken();
    if (token == null) return null;
    _dio.options.headers["authorization"] = "Bearer $token";
    try {
      final response = await _dio.get(finalUrl);
      if (response.statusCode == 200) {
        CartModel cartModel = CartModel.fromJson(response.data['cart']);
        if (cartModel.cartItems!.isEmpty) return null;
        return cartModel;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> removeCart({required int id}) async {
    final url = mainUrl;
    String finalUrl = '${url}cart';

    String? token = await getAuthToken();
    if (token == null) return false;
    _dio.options.headers["authorization"] = "Bearer $token";

    try {
      final response = await _dio.post(
        finalUrl,
        data: jsonEncode({"modelId": id, "quantity": -1}),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> addCart({required int id}) async {
    final url = mainUrl;
    String finalUrl = '${url}cart';
    String? token = await getAuthToken();
    if (token == null) return false;
    _dio.options.headers["authorization"] = "Bearer $token";
    try {
      final response = await _dio.post(
        finalUrl,
        data: jsonEncode({"modelId": id, "quantity": 1}),
      );
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
