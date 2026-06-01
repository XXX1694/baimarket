import 'dart:convert';

import 'package:bai_market/features/product/data/models/product_model.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/urls.dart';
import '../../domain/repositories/favorite_repository.dart';
import '../models/favorite_model.dart';

class FavoritesServices implements FavoriteRepository {
  final Dio _dio = Dio();
  final _storage = SharedPreferences.getInstance();
  @override
  Future<List<FavoriteModel>> getFavorites() async {
    final url = mainUrl;
    var storage = await _storage;
    String finalUrl = '${url}favorite';
    String? token = storage.getString('auth_token');
    if (token == null) return [];
    // String token =
    //     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEwNDI0OCwiaWF0IjoxNzQ0OTk3Mjk2LCJleHAiOjE3NDU2MDIwOTZ9.Bhm9ULK7tZPjaQg8zcmx6YbWV-rkmTCA_eyFb8fb_RM';
    _dio.options.headers["authorization"] = "Bearer $token";
    try {
      final response = await _dio.get(finalUrl);
      List data = response.data;
      List<FavoriteModel> products = [];
      for (int i = 0; i < data.length; i++) {
        ProductModel product = ProductModel.fromJson(data[i]['model']);
        products.add(FavoriteModel(id: data[i]['id'], models: product));
      }
      if (response.statusCode == 200) {
        return products;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Future<bool> removeFromFavorite({required int id}) async {
    final url = mainUrl;
    var storage = await _storage;
    String finalUrl = '${url}favorite/$id';

    String? token = storage.getString('auth_token');
    if (token == null) return false;
    // String token =
    //     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEwNDI0OCwiaWF0IjoxNzQ0OTk3Mjk2LCJleHAiOjE3NDU2MDIwOTZ9.Bhm9ULK7tZPjaQg8zcmx6YbWV-rkmTCA_eyFb8fb_RM';
    _dio.options.headers["authorization"] = "Bearer $token";

    try {
      final response = await _dio.delete(
        finalUrl,
        data: jsonEncode({"modelId": id}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<bool> removeFromFavoriteById({required int id}) async {
    final url = mainUrl;
    var storage = await _storage;
    String finalUrl = '${url}favorite/remove';

    String? token = storage.getString('auth_token');
    if (token == null) return false;
    // String token =
    //     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEwNDI0OCwiaWF0IjoxNzQ0OTk3Mjk2LCJleHAiOjE3NDU2MDIwOTZ9.Bhm9ULK7tZPjaQg8zcmx6YbWV-rkmTCA_eyFb8fb_RM';
    _dio.options.headers["authorization"] = "Bearer $token";

    try {
      final response = await _dio.post(
        finalUrl,
        data: jsonEncode({"modelId": id}),
      );

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

  @override
  Future<bool> addFavorite({required int id}) async {
    final url = mainUrl;
    var storage = await _storage;
    String finalUrl = '${url}favorite';

    String? token = storage.getString('auth_token');
    if (token == null) return false;
    _dio.options.headers["authorization"] = "Bearer $token";
    // String token =
    //     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEwNDI0OCwiaWF0IjoxNzQ0OTk3Mjk2LCJleHAiOjE3NDU2MDIwOTZ9.Bhm9ULK7tZPjaQg8zcmx6YbWV-rkmTCA_eyFb8fb_RM';
    // _dio.options.headers["authorization"] = "Bearer $token";

    try {
      final response = await _dio.post(
        finalUrl,
        data: jsonEncode({"modelId": id}),
      );

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
