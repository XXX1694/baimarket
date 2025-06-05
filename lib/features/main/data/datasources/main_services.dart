import 'package:bai_market/features/main/data/models/banner_model.dart';
import 'package:bai_market/features/main/domain/repositories/main_repository.dart';
import 'package:dio/dio.dart';
import '../../../../core/urls.dart';

class MainServices implements MainRepository {
  final Dio _dio = Dio();

  @override
  Future<List<BannerModel>> getBanners() async {
    final url = mainUrl;
    String finalUrl = '${url}banner';

    try {
      final response = await _dio.get(finalUrl);
      List data = response.data;
      List<BannerModel> banners = [];
      for (int i = 0; i < data.length; i++) {
        BannerModel banner = BannerModel.fromJson(data[i]);
        banners.add(banner);
      }
      if (response.statusCode == 200) {
        return banners;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
