import '../../data/models/banner_model.dart';

abstract class MainRepository {
  Future<List<BannerModel>> getBanners();
}
