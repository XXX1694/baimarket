import '../../../../core/network/app_dio.dart';
import '../../../../core/services/app_logger.dart';
import '../../../../core/urls.dart';
import '../../../catalog/data/models/category_product_model.dart';
import '../../domain/repositories/search_repository.dart';

class SearchServices implements SearchRepository {
  @override
  Future<List<CategoryProductModel>> search(String query) async {
    final q = query.trim();
    if (q.isEmpty) return const [];
    try {
      final response = await appDio.get(
        '${mainUrl}model',
        queryParameters: {'q': q},
      );
      if (response.statusCode != 200 || response.data is! List) {
        searchLog.warn(
          'unexpected response',
          'status=${response.statusCode}, data=${response.data.runtimeType}',
        );
        return const [];
      }
      final data = response.data as List;
      final list = data
          .whereType<Map>()
          .map((e) {
            final m = Map<String, dynamic>.from(e);
            // Бэк на /model?q=... не всегда присылает `isInFavorite`,
            // а в модели поле non-nullable bool — дефолтим, чтобы
            // .g.dart-генератор не упал на `as bool`.
            m['isInFavorite'] ??= false;
            return CategoryProductModel.fromJson(m);
          })
          .toList();
      searchLog.api('search "$q" → ${list.length} items');
      return list;
    } catch (e, st) {
      searchLog.error('search exception', e.toString(), e, st);
      rethrow;
    }
  }
}
