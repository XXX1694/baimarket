import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasources/raffle_services.dart';
import '../../data/models/raffle_model.dart';
import '../../domain/repositories/raffle_repository.dart';

part 'raffle_list_state.dart';

class RaffleListCubit extends Cubit<RaffleListState> {
  RaffleListCubit({RaffleRepository? repository})
    : _repository = repository ?? RaffleServices(),
      super(RaffleListInitial());

  final RaffleRepository _repository;

  Future<void> load() async {
    emit(RaffleListLoading());
    try {
      final raffles = await _repository.getRaffles();
      emit(RaffleListLoaded(raffles: raffles));
    } catch (_) {
      emit(RaffleListError());
    }
  }
}
