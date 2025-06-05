import 'package:bai_market/features/product/data/models/product_model.dart';
import 'package:bai_market/features/product/domain/repositories/product_repository.dart';
import 'package:dio/dio.dart';
import '../../../../core/urls.dart';

class ProductServices implements ProductRepository {
  final Dio _dio = Dio();

  @override
  Future<ProductModel?> getProductDetail({required int id}) async {
    final url = mainUrl;
    String finalUrl = '${url}model/$id';

    try {
      final response = await _dio.get(finalUrl);

      ProductModel productModel = ProductModel.fromJson(response.data);
      if (response.statusCode == 200) {
        return productModel;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
