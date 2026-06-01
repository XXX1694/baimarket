import '../../data/models/favorite_model.dart';

abstract class FavoriteRepository {
  Future<List<FavoriteModel>> getFavorites();
  Future<bool> removeFromFavorite({required int id});
  Future<bool> removeFromFavoriteById({required int id});
  Future<bool> addFavorite({required int id});
}
