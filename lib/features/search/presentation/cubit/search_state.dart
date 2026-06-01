part of 'search_cubit.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {
  const SearchInitial();
}

class SearchSearching extends SearchState {
  final String query;
  const SearchSearching({required this.query});

  @override
  List<Object?> get props => [query];
}

class SearchResults extends SearchState {
  final String query;
  final List<CategoryProductModel> items;
  const SearchResults({required this.query, required this.items});

  @override
  List<Object?> get props => [query, items.length];
}

class SearchError extends SearchState {
  final String query;
  final String message;
  const SearchError({required this.query, required this.message});

  @override
  List<Object?> get props => [query, message];
}
