import 'package:json_annotation/json_annotation.dart';

import '../../../product/data/models/product_model.dart';

part 'cart_item_model.g.dart';

@JsonSerializable()
class CartItemModel {
  final int id;
  int quantity;
  final int? totalPrice;
  final ProductModel? model;

  CartItemModel({
    required this.id,
    required this.totalPrice,
    required this.model,
    required this.quantity,
  });
  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$CartItemModelToJson(this);
}
