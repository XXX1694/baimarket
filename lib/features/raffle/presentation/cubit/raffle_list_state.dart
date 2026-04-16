part of 'raffle_list_cubit.dart';

abstract class RaffleListState extends Equatable {
  const RaffleListState();

  @override
  List<Object?> get props => [];
}

class RaffleListInitial extends RaffleListState {}

class RaffleListLoading extends RaffleListState {}

class RaffleListLoaded extends RaffleListState {
  const RaffleListLoaded({required this.raffles});
  final List<RaffleModel> raffles;

  @override
  List<Object?> get props => [raffles];
}

class RaffleListError extends RaffleListState {}
