import '../../data/models/catalog_model.dart';

abstract class CatalogRepostory {
  Future<List<CatalogModel>> getCatalog({required String slug});
}
