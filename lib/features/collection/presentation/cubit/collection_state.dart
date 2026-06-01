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

  // Equatable со списком props=[] делает все CollectionGot равными — emit
  // в Bloc-е гасится при cache-hit с тем же типом state. Сравниваем по
  // ссылке на collection (каждый getCollection возвращает новый объект),
  // чтобы повторный сорт не "залипал" на предыдущем результате.
  @override
  List<Object> get props => [collection];
}

class CollectionGetError extends CollectionState {}
