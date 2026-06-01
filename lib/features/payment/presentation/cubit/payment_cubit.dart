import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cards/data/models/payment_card_model.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(_seed());

  static PaymentReady _seed() {
    const seedCards = <PaymentCardModel>[
      PaymentCardModel(
        id: 1,
        brand: PaymentCardBrand.visa,
        maskedNumber: '516949-XX-XXXX-2499',
      ),
      PaymentCardModel(
        id: 2,
        brand: PaymentCardBrand.mastercard,
        maskedNumber: '516949-XX-XXXX-2499',
      ),
    ];
    return const PaymentReady(cards: seedCards, selectedCardId: 1);
  }

  int _nextId = 3;

  void selectCard(int id) {
    final s = state as PaymentReady;
    if (s.selectedCardId == id) return;
    emit(s.copyWith(selectedCardId: id));
  }

  void removeCard(int id) {
    final s = state as PaymentReady;
    final remaining = s.cards.where((c) => c.id != id).toList();
    final newSelected = s.selectedCardId == id
        ? (remaining.isEmpty ? null : remaining.first.id)
        : s.selectedCardId;
    emit(PaymentReady(cards: remaining, selectedCardId: newSelected));
  }

  /// Добавить новую карту по введённому номеру. Возвращает добавленный id.
  int addCardFromInput({required String rawNumber}) {
    final masked = _maskCardNumber(rawNumber);
    final brand = _detectBrand(rawNumber);
    final card = PaymentCardModel(
      id: _nextId++,
      brand: brand,
      maskedNumber: masked,
    );
    final s = state as PaymentReady;
    emit(PaymentReady(
      cards: [...s.cards, card],
      selectedCardId: card.id,
    ));
    return card.id;
  }

  PaymentCardBrand _detectBrand(String rawNumber) {
    final digits = rawNumber.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('4')) return PaymentCardBrand.visa;
    return PaymentCardBrand.mastercard;
  }

  String _maskCardNumber(String rawNumber) {
    final digits = rawNumber.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 6) return digits;
    final first6 = digits.substring(0, 6);
    final last4 = digits.length >= 10
        ? digits.substring(digits.length - 4)
        : digits.substring(digits.length - 4);
    return '$first6-XX-XXXX-$last4';
  }
}
