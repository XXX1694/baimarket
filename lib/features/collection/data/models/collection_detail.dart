import 'package:json_annotation/json_annotation.dart';

part 'collection_detail.g.dart';

@JsonSerializable()
class CollectionDetail {
  final int id;
  final String? slug;
  final String? nameKz;
  final String? nameRu;
  final String? nameEn;
  final String? descriptionKz;
  final String? descriptionRu;
  final String? descriptionEn;
  final String? iconUrl;
  final String? backgroundUrl;
  final String? createdAt;
  final String? updatedAt;

  CollectionDetail({
    required this.id,
    required this.nameKz,
    required this.nameRu,
    required this.nameEn,
    required this.backgroundUrl,
    required this.createdAt,
    required this.descriptionEn,
    required this.descriptionKz,
    required this.descriptionRu,
    required this.iconUrl,
    required this.slug,
    required this.updatedAt,
  });
  factory CollectionDetail.fromJson(Map<String, dynamic> json) =>
      _$CollectionDetailFromJson(json);
  Map<String, dynamic> toJson() => _$CollectionDetailToJson(this);
}
