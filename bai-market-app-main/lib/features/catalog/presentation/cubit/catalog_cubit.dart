import 'package:bai_market/features/catalog/data/datasources/catalog_services.dart';
import 'package:bai_market/features/catalog/data/models/catalog_model.dart';
import 'package:bai_market/features/catalog/domain/repositories/catalog_repostory.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'catalog_state.dart';

class CatalogCubit extends Cubit<CatalogState> {
  final CatalogRepostory _catalogRepostory;

  CatalogCubit({CatalogRepostory? catalogRepository})
    : _catalogRepostory = catalogRepository ?? CatalogServices(),
      super(CatalogInitial()) {
    getCategories(slug: 'all');
  }

  Future<void> getCategories({required String slug}) async {
    emit(CatalogGetting());
    try {
      List<CatalogModel> categories = await _catalogRepostory.getCatalog(
        slug: slug,
      );

      if (categories.isNotEmpty) {
        emit(CatalogGot(categories: categories));
      } else {
        emit(CatalogGetError());
      }
    } catch (e) {
      emit(CatalogGetError());
    }
  }
}
