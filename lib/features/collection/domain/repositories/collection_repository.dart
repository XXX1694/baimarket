import '../../data/datasources/collection_services.dart';

abstract class CollectionRepository {
  Future<Collection?> getCollection({
    required String slug,
    required String sort,
  });
}
