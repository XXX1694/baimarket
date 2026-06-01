import 'package:json_annotation/json_annotation.dart';

import '../../../product/data/models/product_model.dart';

part 'order_product_model.g.dart';

@JsonSerializable()
class OrderProductModel {
  final int id;
  final ProductModel model;

  OrderProductModel({required this.id, required this.model});
  factory OrderProductModel.fromJson(Map<String, dynamic> json) =>
      _$OrderProductModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderProductModelToJson(this);
}
