part of 'collection_cubit.dart';

abstract class CollectionState extends Equatable {
  const CollectionState();

  @override
  List<Object> get props => [];
}

class CollectionInitial extends CollectionState {}

class CollectionGetting extends CollectionState {}

class CollectionGot extends CollectionState {
  final Collection collection;
  const CollectionGot({required this.collection});
}

class CollectionGetError extends CollectionState {}
