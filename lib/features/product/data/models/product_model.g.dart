// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
  id: (json['id'] as num).toInt(),
  collections:
      (json['collections'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
  deal: json['deal'] as bool?,
  descriptionEn: json['descriptionEn'] as String?,
  descriptionKz: json['descriptionKz'] as String?,
  descriptionRu: json['descriptionRu'] as String?,
  detailedDescriptionEn: json['detailedDescriptionEn'] as String?,
  detailedDescriptionKz: json['detailedDescriptionKz'] as String?,
  detailedDescriptionRu: json['detailedDescriptionRu'] as String?,
  inStockCount: (json['inStockCount'] as num?)?.toInt(),
  isInFavorite: json['isInFavorite'] as bool?,
  name: json['name'] as String?,
  oldPrice: (json['oldPrice'] as num?)?.toInt(),
  photoUrls:
      (json['photoUrls'] as List<dynamic>?)?.map((e) => e as String).toList(),
  price: (json['price'] as num?)?.toInt(),
  product: json['product'] as Map<String, dynamic>?,
  weightInKg: (json['weightInKg'] as num?)?.toDouble(),
);

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'oldPrice': instance.oldPrice,
      'deal': instance.deal,
      'photoUrls': instance.photoUrls,
      'descriptionKz': instance.descriptionKz,
      'descriptionRu': instance.descriptionRu,
      'descriptionEn': instance.descriptionEn,
      'detailedDescriptionKz': instance.detailedDescriptionKz,
      'detailedDescriptionRu': instance.detailedDescriptionRu,
      'detailedDescriptionEn': instance.detailedDescriptionEn,
      'inStockCount': instance.inStockCount,
      'weightInKg': instance.weightInKg,
      'collections': instance.collections,
      'product': instance.product,
      'isInFavorite': instance.isInFavorite,
    };
