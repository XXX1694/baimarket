import 'package:json_annotation/json_annotation.dart';

part 'banner_model.g.dart';

@JsonSerializable()
class BannerModel {
  final int id;
  final String? nameKz;
  final String? nameRu;
  final String? nameEn;
  final String? descriptionKz;
  final String? descriptionRu;
  final String? descriptionEn;
  final String? photoUrl;
  final String? link;
  final bool? isActive;
  final int? order;
  final String? createdAt;
  final String? updatedAt;

  BannerModel({
    required this.id,
    required this.nameKz,
    required this.nameRu,
    required this.nameEn,
    required this.descriptionKz,
    required this.descriptionRu,
    required this.descriptionEn,
    required this.photoUrl,
    required this.link,
    required this.isActive,
    required this.order,
    required this.createdAt,
    required this.updatedAt,
  });
  factory BannerModel.fromJson(Map<String, dynamic> json) =>
      _$BannerModelFromJson(json);
  Map<String, dynamic> toJson() => _$BannerModelToJson(this);
}
