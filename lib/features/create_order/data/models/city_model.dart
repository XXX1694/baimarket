import 'package:json_annotation/json_annotation.dart';

part 'city_model.g.dart';

@JsonSerializable()
class CityModel {
  final int id;
  final String? nameKz;
  final String? nameRu;
  final String? nameEn;
  final List<String>? pickupUrls;

  CityModel({
    required this.id,
    required this.nameEn,
    required this.nameKz,
    required this.nameRu,
    required this.pickupUrls,
  });
  factory CityModel.fromJson(Map<String, dynamic> json) =>
      _$CityModelFromJson(json);
  Map<String, dynamic> toJson() => _$CityModelToJson(this);
}
