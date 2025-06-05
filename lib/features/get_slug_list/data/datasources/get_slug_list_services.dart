import 'package:bai_market/features/get_slug_list/data/models/slug_model.dart';
import 'package:bai_market/features/get_slug_list/domain/repositories/get_slug_list_repository.dart';
import 'package:dio/dio.dart';
import '../../../../core/urls.dart';

class GetSlugListServices implements GetSlugListRepository {
  final Dio _dio = Dio();

  @override
  Future<List<SlugModel>> getSlugs() async {
    final url = mainUrl;
    String finalUrl = '${url}collection';
    try {
      final response = await _dio.get(finalUrl);
      List data = response.data;
      List<SlugModel> slugs = [];
      for (int i = 0; i < data.length; i++) {
        SlugModel slug = SlugModel.fromJson(data[i]);
        slugs.add(slug);
      }
      if (response.statusCode == 200) {
        return slugs;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
