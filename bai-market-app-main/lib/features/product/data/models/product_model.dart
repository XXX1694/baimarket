import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel {
  final int id;
  final String? name;
  final int? price;
  final int? oldPrice;
  final bool? deal;
  final List<String>? photoUrls;
  final String? descriptionKz;
  final String? descriptionRu;
  final String? descriptionEn;
  final String? detailedDescriptionKz;
  final String? detailedDescriptionRu;
  final String? detailedDescriptionEn;
  final int? inStockCount;
  final double? weightInKg;
  final List<Map<String, dynamic>>? collections;
  final Map<String, dynamic>? product;
  final bool? isInFavorite;

  ProductModel({
    required this.id,
    required this.collections,
    required this.deal,
    required this.descriptionEn,
    required this.descriptionKz,
    required this.descriptionRu,
    required this.detailedDescriptionEn,
    required this.detailedDescriptionKz,
    required this.detailedDescriptionRu,
    required this.inStockCount,
    required this.isInFavorite,
    required this.name,
    required this.oldPrice,
    required this.photoUrls,
    required this.price,
    required this.product,
    required this.weightInKg,
  });
  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}
