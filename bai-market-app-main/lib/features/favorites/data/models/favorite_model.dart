import 'package:json_annotation/json_annotation.dart';

import '../../../product/data/models/product_model.dart';

part 'favorite_model.g.dart';

@JsonSerializable()
class FavoriteModel {
  final int id;
  final ProductModel models;

  FavoriteModel({required this.id, required this.models});
  factory FavoriteModel.fromJson(Map<String, dynamic> json) =>
      _$FavoriteModelFromJson(json);
  Map<String, dynamic> toJson() => _$FavoriteModelToJson(this);
}
