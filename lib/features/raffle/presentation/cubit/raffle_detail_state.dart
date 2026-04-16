part of 'raffle_detail_cubit.dart';

enum RaffleDetailStatus { initial, loading, sorting, loaded, error }

class RaffleDetailState extends Equatable {
  const RaffleDetailState({
    this.status = RaffleDetailStatus.initial,
    this.raffle,
    this.products,
    this.sort = 'popular',
  });

  final RaffleDetailStatus status;
  final RaffleModel? raffle;
  final RaffleProductsResponse? products;
  final String sort;

  RaffleDetailState copyWith({
    RaffleDetailStatus? status,
    RaffleModel? raffle,
    RaffleProductsResponse? products,
    String? sort,
  }) {
    return RaffleDetailState(
      status: status ?? this.status,
      raffle: raffle ?? this.raffle,
      products: products ?? this.products,
      sort: sort ?? this.sort,
    );
  }

  @override
  List<Object?> get props => [status, raffle, products, sort];
}
