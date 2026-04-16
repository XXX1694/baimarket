// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seller_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SellerModel _$SellerModelFromJson(Map<String, dynamic> json) => SellerModel(
  id: (json['id'] as num).toInt(),
  nameKz: json['nameKz'] as String?,
  nameRu: json['nameRu'] as String?,
  nameEn: json['nameEn'] as String?,
  slug: json['slug'] as String?,
  isOwn: json['isOwn'] as bool,
);

Map<String, dynamic> _$SellerModelToJson(SellerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nameKz': instance.nameKz,
      'nameRu': instance.nameRu,
      'nameEn': instance.nameEn,
      'slug': instance.slug,
      'isOwn': instance.isOwn,
    };
