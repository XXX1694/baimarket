// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banner_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BannerModel _$BannerModelFromJson(Map<String, dynamic> json) => BannerModel(
  id: (json['id'] as num).toInt(),
  nameKz: json['nameKz'] as String?,
  nameRu: json['nameRu'] as String?,
  nameEn: json['nameEn'] as String?,
  descriptionKz: json['descriptionKz'] as String?,
  descriptionRu: json['descriptionRu'] as String?,
  descriptionEn: json['descriptionEn'] as String?,
  photoUrl: json['photoUrl'] as String?,
  link: json['link'] as String?,
  isActive: json['isActive'] as bool?,
  order: (json['order'] as num?)?.toInt(),
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
);

Map<String, dynamic> _$BannerModelToJson(BannerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nameKz': instance.nameKz,
      'nameRu': instance.nameRu,
      'nameEn': instance.nameEn,
      'descriptionKz': instance.descriptionKz,
      'descriptionRu': instance.descriptionRu,
      'descriptionEn': instance.descriptionEn,
      'photoUrl': instance.photoUrl,
      'link': instance.link,
      'isActive': instance.isActive,
      'order': instance.order,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
