import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/collection_services.dart';
import '../../domain/repositories/collection_repository.dart';

part 'collection_state.dart';

class CollectionCubit extends Cubit<CollectionState> {
  final CollectionRepository _collectionRepository;
  final Map<String, Collection> _cache = {};

  CollectionCubit({CollectionRepository? collectionRepository})
    : _collectionRepository = collectionRepository ?? CollectionServices(),
      super(CollectionInitial());

  Future<void> getCollection({
    required String slug,
    required String sort,
    bool forceRefresh = false,
  }) async {
    final cacheKey = '$slug|$sort';
    if (!forceRefresh) {
      final cached = _cache[cacheKey];
      if (cached != null) {
        emit(CollectionGot(collection: cached));
        return;
      }
    }
    emit(CollectionGetting());
    try {
      Collection? collection = await _collectionRepository.getCollection(
        slug: slug,
        sort: sort,
      );

      if (collection != null) {
        _cache[cacheKey] = collection;
        emit(CollectionGot(collection: collection));
      } else {
        emit(CollectionGetError());
      }
    } catch (e) {
      emit(CollectionGetError());
    }
  }
}
