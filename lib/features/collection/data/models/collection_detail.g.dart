// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CollectionDetail _$CollectionDetailFromJson(Map<String, dynamic> json) =>
    CollectionDetail(
      id: (json['id'] as num).toInt(),
      nameKz: json['nameKz'] as String?,
      nameRu: json['nameRu'] as String?,
      nameEn: json['nameEn'] as String?,
      backgroundUrl: json['backgroundUrl'] as String?,
      createdAt: json['createdAt'] as String?,
      descriptionEn: json['descriptionEn'] as String?,
      descriptionKz: json['descriptionKz'] as String?,
      descriptionRu: json['descriptionRu'] as String?,
      iconUrl: json['iconUrl'] as String?,
      slug: json['slug'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$CollectionDetailToJson(CollectionDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'nameKz': instance.nameKz,
      'nameRu': instance.nameRu,
      'nameEn': instance.nameEn,
      'descriptionKz': instance.descriptionKz,
      'descriptionRu': instance.descriptionRu,
      'descriptionEn': instance.descriptionEn,
      'iconUrl': instance.iconUrl,
      'backgroundUrl': instance.backgroundUrl,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
