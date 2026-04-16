import 'package:json_annotation/json_annotation.dart';

part 'gift_model.g.dart';

@JsonSerializable()
class GiftModel {
  final int id;
  final String? name;
  final String? photoUrl;

  const GiftModel({
    required this.id,
    required this.name,
    required this.photoUrl,
  });

  factory GiftModel.fromJson(Map<String, dynamic> json) =>
      _$GiftModelFromJson(json);
  Map<String, dynamic> toJson() => _$GiftModelToJson(this);
}
