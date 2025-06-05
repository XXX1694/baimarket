import 'package:json_annotation/json_annotation.dart';
import 'cart_item_model.dart';

part 'cart_model.g.dart';

@JsonSerializable()
class CartModel {
  final int id;
  final int userId;
  final int? totalPrice;
  final List<CartItemModel>? cartItems;
  final Map<String, dynamic>? deliveryInfo;

  CartModel({
    required this.id,
    required this.cartItems,
    required this.totalPrice,
    required this.userId,
    required this.deliveryInfo,
  });
  factory CartModel.fromJson(Map<String, dynamic> json) =>
      _$CartModelFromJson(json);
  Map<String, dynamic> toJson() => _$CartModelToJson(this);
}
