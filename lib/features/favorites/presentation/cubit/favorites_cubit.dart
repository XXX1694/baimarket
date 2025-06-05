import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasources/favorites_services.dart';
import '../../data/models/favorite_model.dart';
import '../../domain/repositories/favorite_repository.dart';

part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoriteRepository _favoriteRepository;

  FavoritesCubit({FavoriteRepository? favoriteRepository})
    : _favoriteRepository = favoriteRepository ?? FavoritesServices(),
      super(FavoritesInitial());

  Future<void> getFavorites() async {
    emit(FavoritesGetting());
    try {
      List<FavoriteModel> favorites = await _favoriteRepository.getFavorites();

      if (favorites.isNotEmpty) {
        emit(FavoritesGot(favorites: favorites));
      } else {
        emit(FavoritesGetError());
      }
    } catch (e) {
      emit(FavoritesGetError());
    }
  }

  Future<void> removeFromFavorites({required int id}) async {
    try {
      bool deleted = await _favoriteRepository.removeFromFavorite(id: id);
      if (deleted) {
        emit(FavoritesDeleted());
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> removeFromFavoritesById({required int id}) async {
    try {
      bool deleted = await _favoriteRepository.removeFromFavoriteById(id: id);
      if (deleted) {
        emit(FavoritesDeleted());
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> addfavorite({required int id}) async {
    try {
      bool added = await _favoriteRepository.addFavorite(id: id);
      if (added) {
        emit(FavoritesAdded());
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
