import 'package:json_annotation/json_annotation.dart';

import 'category_product_model.dart';

part 'catalog_model.g.dart';

@JsonSerializable()
class CatalogModel {
  final int id;
  final String? nameKz;
  final String? nameRu;
  final String? nameEn;
  final List<CategoryProductModel> models;

  CatalogModel({
    required this.id,
    required this.nameKz,
    required this.nameRu,
    required this.nameEn,
    required this.models,
  });
  factory CatalogModel.fromJson(Map<String, dynamic> json) =>
      _$CatalogModelFromJson(json);
  Map<String, dynamic> toJson() => _$CatalogModelToJson(this);
}
