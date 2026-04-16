import 'package:dio/dio.dart';

import '../../../../core/urls.dart';
import '../../domain/repositories/raffle_repository.dart';
import '../models/raffle_model.dart';
import '../models/raffle_products_response.dart';
import 'raffle_mock.dart';

class RaffleServices implements RaffleRepository {
  RaffleServices({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  @override
  Future<List<RaffleModel>> getRaffles() async {
    try {
      final response = await _dio.get('${mainUrl}raffle');
      if (response.statusCode != 200) return RaffleMock.raffles();
      final List data = response.data as List;
      final parsed = data
          .whereType<Map<String, dynamic>>()
          .map(RaffleModel.fromJson)
          .toList();
      return parsed.isEmpty ? RaffleMock.raffles() : parsed;
    } catch (_) {
      return RaffleMock.raffles();
    }
  }

  @override
  Future<RaffleModel?> getRaffleById(int id) async {
    if (RaffleMock.isMockId(id)) return RaffleMock.raffleById(id);
    try {
      final response = await _dio.get('${mainUrl}raffle/$id');
      if (response.statusCode != 200) return null;
      return RaffleModel.fromJson(response.data as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<RaffleProductsResponse?> getRaffleProducts({
    required int id,
    required String sort,
  }) async {
    if (RaffleMock.isMockId(id)) return RaffleMock.products(sort: sort);
    try {
      final response = await _dio.get(
        '${mainUrl}raffle/$id/models',
        queryParameters: {'sort': sort},
      );
      if (response.statusCode != 200) return null;
      return RaffleProductsResponse.fromJson(
        response.data as Map<String, dynamic>,
      );
    } catch (_) {
      return null;
    }
  }
}
