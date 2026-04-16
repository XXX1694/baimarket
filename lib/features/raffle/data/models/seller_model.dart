import 'package:json_annotation/json_annotation.dart';

part 'seller_model.g.dart';

@JsonSerializable()
class SellerModel {
  final int id;
  final String? nameKz;
  final String? nameRu;
  final String? nameEn;
  final String? slug;
  final bool isOwn;

  const SellerModel({
    required this.id,
    required this.nameKz,
    required this.nameRu,
    required this.nameEn,
    required this.slug,
    required this.isOwn,
  });

  factory SellerModel.fromJson(Map<String, dynamic> json) =>
      _$SellerModelFromJson(json);
  Map<String, dynamic> toJson() => _$SellerModelToJson(this);
}
