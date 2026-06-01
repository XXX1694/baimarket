import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/collection_services.dart';
import '../../domain/repositories/collection_repository.dart';

part 'collection_state.dart';

class CollectionCubit extends Cubit<CollectionState> {
  final CollectionRepository _collectionRepository;

  CollectionCubit({CollectionRepository? collectionRepository})
    : _collectionRepository = collectionRepository ?? CollectionServices(),
      super(CollectionInitial());

  Future<void> getCollection({
    required String slug,
    required String sort,
  }) async {
    emit(CollectionGetting());
    try {
      Collection? collection = await _collectionRepository.getCollection(
        slug: slug,
        sort: sort,
      );

      if (collection != null) {
        emit(CollectionGot(collection: collection));
      } else {
        emit(CollectionGetError());
      }
    } catch (e) {
      emit(CollectionGetError());
    }
  }
}
