part of 'catalog_cubit.dart';

abstract class CatalogState extends Equatable {
  const CatalogState();

  @override
  List<Object> get props => [];
}

class CatalogInitial extends CatalogState {}

class CatalogGetting extends CatalogState {}

class CatalogGot extends CatalogState {
  final List<CatalogModel> categories;
  const CatalogGot({required this.categories});
}

class CatalogGetError extends CatalogState {}
