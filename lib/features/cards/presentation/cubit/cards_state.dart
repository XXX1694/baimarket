part of 'cards_cubit.dart';

abstract class CardsState extends Equatable {
  const CardsState();

  @override
  List<Object> get props => [];
}

class CardsLoaded extends CardsState {
  final List<PaymentCardModel> cards;

  const CardsLoaded({required this.cards});

  @override
  List<Object> get props => [cards];
}
