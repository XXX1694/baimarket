import 'package:bai_market/features/product/data/models/product_model.dart';

abstract class ProductRepository {
  Future<ProductModel?> getProductDetail({required int id});
}
