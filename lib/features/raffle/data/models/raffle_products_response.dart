import 'package:json_annotation/json_annotation.dart';

import '../../../catalog/data/models/category_product_model.dart';

part 'raffle_products_response.g.dart';

@JsonSerializable(explicitToJson: true)
class RaffleProductsResponse {
  final int total;
  @JsonKey(defaultValue: <CategoryProductModel>[])
  final List<CategoryProductModel> models;

  RaffleProductsResponse({
    required this.total,
    required this.models,
  });

  factory RaffleProductsResponse.fromJson(Map<String, dynamic> json) =>
      _$RaffleProductsResponseFromJson(json);
  Map<String, dynamic> toJson() => _$RaffleProductsResponseToJson(this);
}
