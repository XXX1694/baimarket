import 'dart:convert';

import 'package:bai_market/features/cart/data/models/cart_model.dart';
import 'package:bai_market/features/cart/domain/repositories/cart_repository.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/urls.dart';

class CartServices implements CartRepository {
  final Dio _dio = Dio();
  final _storage = SharedPreferences.getInstance();
  @override
  Future<CartModel?> getCart() async {
    final url = mainUrl;
    var storage = await _storage;
    String finalUrl = '${url}cart';
    String? token = storage.getString('auth_token');
    // String token =
    //     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEwNDI0OCwiaWF0IjoxNzQ0OTk3Mjk2LCJleHAiOjE3NDU2MDIwOTZ9.Bhm9ULK7tZPjaQg8zcmx6YbWV-rkmTCA_eyFb8fb_RM';
    if (token == null) return null;
    _dio.options.headers["authorization"] = "Bearer $token";
    print(token);
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
    var storage = await _storage;
    String finalUrl = '${url}cart';

    String? token = storage.getString('auth_token');
    // String token =
    //     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEwNDI0OCwiaWF0IjoxNzQ0OTk3Mjk2LCJleHAiOjE3NDU2MDIwOTZ9.Bhm9ULK7tZPjaQg8zcmx6YbWV-rkmTCA_eyFb8fb_RM';
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
    var storage = await _storage;
    String finalUrl = '${url}cart';
    print(finalUrl);
    String? token = storage.getString('auth_token');
    // String token =
    //     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEwNDI0OCwiaWF0IjoxNzQ0OTk3Mjk2LCJleHAiOjE3NDU2MDIwOTZ9.Bhm9ULK7tZPjaQg8zcmx6YbWV-rkmTCA_eyFb8fb_RM';
    if (token == null) return false;
    print(token);
    _dio.options.headers["authorization"] = "Bearer $token";
    print(jsonEncode({"modelId": id, "quantity": 1}));
    try {
      final response = await _dio.post(
        finalUrl,
        data: jsonEncode({"modelId": id, "quantity": 1}),
      );
      print(response.data);
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
}
