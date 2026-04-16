import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasources/raffle_services.dart';
import '../../data/models/raffle_model.dart';
import '../../data/models/raffle_products_response.dart';
import '../../domain/repositories/raffle_repository.dart';

part 'raffle_detail_state.dart';

class RaffleDetailCubit extends Cubit<RaffleDetailState> {
  RaffleDetailCubit({RaffleRepository? repository})
    : _repository = repository ?? RaffleServices(),
      super(const RaffleDetailState());

  final RaffleRepository _repository;

  Future<void> load({required int id, String sort = 'popular'}) async {
    emit(state.copyWith(status: RaffleDetailStatus.loading, sort: sort));
    try {
      final results = await Future.wait([
        _repository.getRaffleById(id),
        _repository.getRaffleProducts(id: id, sort: sort),
      ]);

      final raffle = results[0] as RaffleModel?;
      final products = results[1] as RaffleProductsResponse?;

      if (raffle == null || products == null) {
        emit(state.copyWith(status: RaffleDetailStatus.error));
        return;
      }

      emit(
        state.copyWith(
          status: RaffleDetailStatus.loaded,
          raffle: raffle,
          products: products,
          sort: sort,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: RaffleDetailStatus.error));
    }
  }

  Future<void> changeSort({required int id, required String sort}) async {
    if (sort == state.sort) return;
    emit(state.copyWith(status: RaffleDetailStatus.sorting, sort: sort));
    try {
      final products = await _repository.getRaffleProducts(id: id, sort: sort);
      if (products == null) {
        emit(state.copyWith(status: RaffleDetailStatus.error));
        return;
      }
      emit(
        state.copyWith(
          status: RaffleDetailStatus.loaded,
          products: products,
          sort: sort,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: RaffleDetailStatus.error));
    }
  }
}
