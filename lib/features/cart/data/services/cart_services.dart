import 'dart:convert';

import 'package:bai_market/features/cart/data/models/cart_model.dart';
import 'package:bai_market/features/cart/domain/repositories/cart_repository.dart';
import 'package:dio/dio.dart';

import '../../../../core/network/app_dio.dart';
import '../../../../core/urls.dart';

class CartServices implements CartRepository {
  final Dio _dio = appDio;

  @override
  Future<CartModel?> getCart() async {
    final finalUrl = '${mainUrl}cart';
    try {
      final response = await _dio.get(finalUrl);
      if (response.statusCode == 200) {
        final cartModel = CartModel.fromJson(response.data['cart']);
        if (cartModel.cartItems!.isEmpty) return null;
        return cartModel;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<bool> removeCart({required int id}) async {
    final finalUrl = '${mainUrl}cart';
    try {
      final response = await _dio.post(
        finalUrl,
        data: jsonEncode({"modelId": id, "quantity": -1}),
      );
      return _isSuccess(response.statusCode);
    } catch (_) {
      return false;
    }
  }

  @override
  Future<AddCartResult> addCart({required int id}) async {
    final finalUrl = '${mainUrl}cart';
    try {
      final response = await _dio.post(
        finalUrl,
        data: jsonEncode({"modelId": id, "quantity": 1}),
      );
      if (_isSuccess(response.statusCode)) return AddCartResult.success;
      return AddCartResult.failed;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) return AddCartResult.unauthenticated;
      return AddCartResult.failed;
    } catch (_) {
      return AddCartResult.failed;
    }
  }

  bool _isSuccess(int? code) => code != null && code >= 200 && code < 300;
}
