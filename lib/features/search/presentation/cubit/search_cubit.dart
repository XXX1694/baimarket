import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/services/app_logger.dart';
import '../../../catalog/data/models/category_product_model.dart';
import '../../data/datasources/search_services.dart';
import '../../domain/repositories/search_repository.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit({SearchRepository? repository})
      : _repo = repository ?? SearchServices(),
        super(const SearchInitial());

  final SearchRepository _repo;
  Timer? _debounce;
  String _lastQuery = '';

  static const _debounceDuration = Duration(milliseconds: 350);

  /// Дебаунс на ввод. Пустой запрос сбрасывает в Initial.
  void onQueryChanged(String raw) {
    final q = raw.trim();
    _debounce?.cancel();
    if (q.isEmpty) {
      _lastQuery = '';
      searchLog.step('query cleared → Initial');
      emit(const SearchInitial());
      return;
    }
    _debounce = Timer(_debounceDuration, () => _runSearch(q));
  }

  Future<void> _runSearch(String q) async {
    if (q == _lastQuery && state is SearchResults) return;
    _lastQuery = q;
    searchLog.step('search', '"$q"');
    emit(SearchSearching(query: q));
    try {
      final items = await _repo.search(q);
      // Игнорируем устаревшие ответы.
      if (q != _lastQuery) {
        searchLog.info('stale result discarded', '"$q" vs "$_lastQuery"');
        return;
      }
      emit(SearchResults(query: q, items: items));
    } catch (e) {
      if (q != _lastQuery) return;
      emit(SearchError(query: q, message: e.toString()));
    }
  }

  void clear() {
    _debounce?.cancel();
    _lastQuery = '';
    emit(const SearchInitial());
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
