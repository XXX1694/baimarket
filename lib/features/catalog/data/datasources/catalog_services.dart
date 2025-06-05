import 'package:dio/dio.dart';
import '../../../../core/urls.dart';
import '../../domain/repositories/catalog_repostory.dart';
import '../models/catalog_model.dart';

class CatalogServices implements CatalogRepostory {
  final Dio _dio = Dio();

  @override
  Future<List<CatalogModel>> getCatalog({required String slug}) async {
    final url = mainUrl;
    String finalUrl = '${url}category/by-collection/$slug';
    try {
      final response = await _dio.get(finalUrl);
      List data = response.data;
      List<CatalogModel> catalogs = [];
      for (int i = 0; i < data.length; i++) {
        CatalogModel catalog = CatalogModel.fromJson(data[i]);
        catalogs.add(catalog);
      }
      if (response.statusCode == 200) {
        return catalogs;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
