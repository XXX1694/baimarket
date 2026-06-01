import '../../../cards/data/models/payment_card_model.dart';

/// Аргументы экрана оплаты `/payment`. Передаётся через `state.extra`.
class PaymentArgs {
  final int amount;
  final int commission;
  final String? paymentUrl;

  // Контекст заказа (нужен для success-экрана и чека).
  final int? itemsTotal;
  final int? oldTotal;
  final int? savings;
  final int? ticketsEarned;
  final String? deliveryAddressLine;
  final String? deliveryPostalCode;
  final List<String> productImageUrls;

  /// Бренд выбранной карты — заполняется когда уходим на WebView
  /// банка, чтобы success-экран показал правильный VISA/MasterCard.
  final PaymentCardBrand? cardBrand;

  const PaymentArgs({
    required this.amount,
    this.commission = 0,
    this.paymentUrl,
    this.itemsTotal,
    this.oldTotal,
    this.savings,
    this.ticketsEarned,
    this.deliveryAddressLine,
    this.deliveryPostalCode,
    this.productImageUrls = const [],
    this.cardBrand,
  });

  PaymentArgs copyWith({PaymentCardBrand? cardBrand}) => PaymentArgs(
        amount: amount,
        commission: commission,
        paymentUrl: paymentUrl,
        itemsTotal: itemsTotal,
        oldTotal: oldTotal,
        savings: savings,
        ticketsEarned: ticketsEarned,
        deliveryAddressLine: deliveryAddressLine,
        deliveryPostalCode: deliveryPostalCode,
        productImageUrls: productImageUrls,
        cardBrand: cardBrand ?? this.cardBrand,
      );
}
