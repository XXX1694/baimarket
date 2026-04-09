import 'package:bai_market/features/collection/data/models/collection_detail.dart';
import 'package:dio/dio.dart';
import '../../../../core/urls.dart';
import '../../../catalog/data/models/category_product_model.dart';
import '../../domain/repositories/collection_repository.dart';

class CollectionServices implements CollectionRepository {
  final Dio _dio = Dio();

  @override
  Future<Collection?> getCollection({
    required String slug,
    required String sort,
  }) async {
    final url = mainUrl;
    String finalUrl = '${url}model/by-collection/$slug?sort=$sort';
    try {
      final response = await _dio.get(finalUrl);
      if (response.statusCode != 200) return null;

      List data = response.data;
      List<CategoryProductModel> products = data
          .map((e) => CategoryProductModel.fromJson(e))
          .toList();

      // "all" tab has no collection detail endpoint — use dummy
      if (slug == 'all') {
        final dummy = CollectionDetail(
          id: 0,
          slug: 'all',
          nameKz: 'Бәрі',
          nameRu: 'Все',
          nameEn: 'All',
          descriptionKz: null,
          descriptionRu: null,
          descriptionEn: null,
          iconUrl: null,
          backgroundUrl: null,
          createdAt: null,
          updatedAt: null,
        );
        return Collection(detail: dummy, products: products);
      }

      final response1 = await _dio.get('${url}collection/$slug');
      if (response1.statusCode != 200) return null;
      CollectionDetail detail = CollectionDetail.fromJson(response1.data);
      return Collection(detail: detail, products: products);
    } catch (e) {
      return null;
    }
  }
}

class Collection {
  final CollectionDetail detail;
  final List<CategoryProductModel> products;
  const Collection({required this.detail, required this.products});
}
