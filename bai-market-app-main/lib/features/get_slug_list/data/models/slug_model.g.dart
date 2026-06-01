// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slug_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SlugModel _$SlugModelFromJson(Map<String, dynamic> json) => SlugModel(
  id: (json['id'] as num).toInt(),
  slug: json['slug'] as String?,
  nameKz: json['nameKz'] as String?,
  nameRu: json['nameRu'] as String?,
  nameEn: json['nameEn'] as String?,
  iconUrl: json['iconUrl'] as String?,
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
);

Map<String, dynamic> _$SlugModelToJson(SlugModel instance) => <String, dynamic>{
  'id': instance.id,
  'slug': instance.slug,
  'nameKz': instance.nameKz,
  'nameRu': instance.nameRu,
  'nameEn': instance.nameEn,
  'iconUrl': instance.iconUrl,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
};
