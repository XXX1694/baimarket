import 'package:json_annotation/json_annotation.dart';

part 'category_product_model.g.dart';

@JsonSerializable()
class CategoryProductModel {
  final int id;
  final String? name;
  final int? price;
  final int? oldPrice;
  final List<String>? photoUrls;
  final int? inStockCount;
  final String? descriptionKz;
  final String? descriptionRu;
  final String? descriptionEn;
  final List<Map<String, dynamic>>? collections;
  final bool isInFavorite;

  CategoryProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.oldPrice,
    required this.photoUrls,
    required this.inStockCount,
    required this.descriptionKz,
    required this.descriptionRu,
    required this.descriptionEn,
    required this.collections,
    required this.isInFavorite,
  });
  factory CategoryProductModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryProductModelFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryProductModelToJson(this);
}
