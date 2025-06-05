import 'package:json_annotation/json_annotation.dart';

part 'slug_model.g.dart';

@JsonSerializable()
class SlugModel {
  final int id;
  final String? slug;
  final String? nameKz;
  final String? nameRu;
  final String? nameEn;
  final String? iconUrl;
  final String? createdAt;
  final String? updatedAt;

  SlugModel({
    required this.id,
    required this.slug,
    required this.nameKz,
    required this.nameRu,
    required this.nameEn,
    required this.iconUrl,
    required this.createdAt,
    required this.updatedAt,
  });
  factory SlugModel.fromJson(Map<String, dynamic> json) =>
      _$SlugModelFromJson(json);
  Map<String, dynamic> toJson() => _$SlugModelToJson(this);
}
