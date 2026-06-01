part of 'payment_cubit.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

class PaymentReady extends PaymentState {
  final List<PaymentCardModel> cards;
  final int? selectedCardId;

  const PaymentReady({required this.cards, required this.selectedCardId});

  PaymentCardModel? get selectedCard {
    if (selectedCardId == null) return null;
    for (final c in cards) {
      if (c.id == selectedCardId) return c;
    }
    return null;
  }

  PaymentReady copyWith({
    List<PaymentCardModel>? cards,
    int? selectedCardId,
    bool clearSelected = false,
  }) {
    return PaymentReady(
      cards: cards ?? this.cards,
      selectedCardId:
          clearSelected ? null : (selectedCardId ?? this.selectedCardId),
    );
  }

  @override
  List<Object?> get props => [cards, selectedCardId];
}
