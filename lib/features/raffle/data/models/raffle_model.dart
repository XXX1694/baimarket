import 'package:json_annotation/json_annotation.dart';

import 'gift_model.dart';
import 'seller_model.dart';

part 'raffle_model.g.dart';

@JsonSerializable(explicitToJson: true)
class RaffleModel {
  final int id;
  final String? startDate;
  final String? endDate;
  final bool isActive;
  final String? createdAt;
  final SellerModel? seller;
  @JsonKey(defaultValue: <GiftModel>[])
  final List<GiftModel> gifts;

  const RaffleModel({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.createdAt,
    required this.seller,
    required this.gifts,
  });

  factory RaffleModel.fromJson(Map<String, dynamic> json) =>
      _$RaffleModelFromJson(json);
  Map<String, dynamic> toJson() => _$RaffleModelToJson(this);
}
