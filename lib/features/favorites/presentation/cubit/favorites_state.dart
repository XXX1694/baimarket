part of 'favorites_cubit.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object> get props => [];
}

class FavoritesInitial extends FavoritesState {}

class FavoritesGetting extends FavoritesState {}

class FavoritesDeleted extends FavoritesState {}

class FavoritesAdded extends FavoritesState {}

class FavoritesGot extends FavoritesState {
  final List<FavoriteModel> favorites;
  const FavoritesGot({required this.favorites});
}

class FavoritesGetError extends FavoritesState {}
