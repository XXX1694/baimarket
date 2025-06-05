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
    String finalUrl1 = '${url}collection/$slug';
    try {
      final response = await _dio.get(finalUrl);
      List data = response.data;
      List<CategoryProductModel> products = [];
      for (int i = 0; i < data.length; i++) {
        CategoryProductModel productModel = CategoryProductModel.fromJson(
          data[i],
        );
        products.add(productModel);
      }
      final response1 = await _dio.get(finalUrl1);
      CollectionDetail detail = CollectionDetail.fromJson(response1.data);

      if (response.statusCode == 200 && response1.statusCode == 200) {
        return Collection(detail: detail, products: products);
      } else {
        return null;
      }
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
