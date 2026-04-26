import 'dart:convert';

import 'package:bai_market/features/product/data/models/product_model.dart';
import 'package:dio/dio.dart';

import '../../../../core/network/app_dio.dart';
import '../../../../core/urls.dart';
import '../../domain/repositories/favorite_repository.dart';
import '../models/favorite_model.dart';

class FavoritesServices implements FavoriteRepository {
  final Dio _dio = appDio;

  @override
  Future<List<FavoriteModel>> getFavorites() async {
    final finalUrl = '${mainUrl}favorite';
    try {
      final response = await _dio.get(finalUrl);
      if (response.statusCode != 200) return [];
      final List data = response.data;
      return [
        for (final entry in data)
          FavoriteModel(
            id: entry['id'],
            models: ProductModel.fromJson(entry['model']),
          ),
      ];
    } catch (_) {
      return [];
    }
  }

  @override
  Future<bool> removeFromFavorite({required int id}) async {
    final finalUrl = '${mainUrl}favorite/$id';
    try {
      final response = await _dio.delete(
        finalUrl,
        data: jsonEncode({"modelId": id}),
      );
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> removeFromFavoriteById({required int id}) async {
    final finalUrl = '${mainUrl}favorite/remove';
    try {
      final response = await _dio.post(
        finalUrl,
        data: jsonEncode({"modelId": id}),
      );
      return response.statusCode == 201;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> addFavorite({required int id}) async {
    final finalUrl = '${mainUrl}favorite';
    try {
      final response = await _dio.post(
        finalUrl,
        data: jsonEncode({"modelId": id}),
      );
      return response.statusCode == 201;
    } catch (_) {
      return false;
    }
  }
}
