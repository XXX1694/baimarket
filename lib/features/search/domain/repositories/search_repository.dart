import '../../../catalog/data/models/category_product_model.dart';

abstract class SearchRepository {
  Future<List<CategoryProductModel>> search(String query);
}
