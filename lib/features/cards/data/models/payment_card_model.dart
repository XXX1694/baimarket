enum PaymentCardBrand { visa, mastercard }

class PaymentCardModel {
  final int id;
  final PaymentCardBrand brand;
  final String maskedNumber;

  const PaymentCardModel({
    required this.id,
    required this.brand,
    required this.maskedNumber,
  });
}
