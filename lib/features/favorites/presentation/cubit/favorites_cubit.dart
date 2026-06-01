import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/app_logger.dart';
import '../../data/datasources/favorites_services.dart';
import '../../data/models/favorite_model.dart';
import '../../domain/repositories/favorite_repository.dart';

part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoriteRepository _favoriteRepository;

  FavoritesCubit({FavoriteRepository? favoriteRepository})
    : _favoriteRepository = favoriteRepository ?? FavoritesServices(),
      super(FavoritesInitial());

  void reset() => emit(FavoritesInitial());

  Future<void> getFavorites() async {
    favLog.step('getFavorites()');
    emit(FavoritesGetting());
    try {
      List<FavoriteModel> favorites = await _favoriteRepository.getFavorites();
      favLog.state('emit FavoritesGot', 'count=${favorites.length}');
      emit(FavoritesGot(favorites: favorites));
    } catch (e, st) {
      favLog.error('getFavorites exception', e.toString(), e, st);
      emit(FavoritesGetError());
    }
  }

  Future<void> removeFromFavorites({required int id}) async {
    favLog.step('removeFromFavorites', 'favId=$id');
    try {
      bool deleted = await _favoriteRepository.removeFromFavorite(id: id);
      favLog.api('remove ok=$deleted');
      if (deleted) emit(FavoritesDeleted());
    } catch (e, st) {
      favLog.error('removeFromFavorites exception', e.toString(), e, st);
    }
  }

  Future<void> removeFromFavoritesById({required int id}) async {
    favLog.step('removeFromFavoritesById', 'productId=$id');
    try {
      bool deleted = await _favoriteRepository.removeFromFavoriteById(id: id);
      favLog.api('removeById ok=$deleted');
      if (deleted) emit(FavoritesDeleted());
    } catch (e, st) {
      favLog.error('removeFromFavoritesById exception', e.toString(), e, st);
    }
  }

  Future<void> addfavorite({required int id}) async {
    favLog.step('addFavorite', 'productId=$id');
    try {
      bool added = await _favoriteRepository.addFavorite(id: id);
      favLog.api('add ok=$added');
      if (added) emit(FavoritesAdded());
    } catch (e, st) {
      favLog.error('addFavorite exception', e.toString(), e, st);
    }
  }
}
