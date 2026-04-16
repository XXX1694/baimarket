import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/payment_card_model.dart';

part 'cards_state.dart';

class CardsCubit extends Cubit<CardsState> {
  CardsCubit() : super(const CardsLoaded(cards: []));

  int _nextId = 1;

  void addCard(PaymentCardModel card) {
    final current = (state as CardsLoaded).cards;
    emit(CardsLoaded(cards: [...current, card]));
  }

  void addMockCard() {
    final current = (state as CardsLoaded).cards;
    final brand = current.length.isEven
        ? PaymentCardBrand.visa
        : PaymentCardBrand.mastercard;
    addCard(
      PaymentCardModel(
        id: _nextId++,
        brand: brand,
        maskedNumber: '516949-XX-XXXX-2499',
      ),
    );
  }

  void removeCard(int id) {
    final current = (state as CardsLoaded).cards;
    emit(
      CardsLoaded(cards: current.where((c) => c.id != id).toList()),
    );
  }
}
