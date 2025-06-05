import 'package:json_annotation/json_annotation.dart';

part 'profile_model.g.dart';

@JsonSerializable()
class ProfileModel {
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? language;
  final String? avatarUrl;
  final int? favoritesCount;
  final int? prizesCount;
  final int? lotteryTicketsCount;

  ProfileModel({
    required this.favoritesCount,
    required this.firstName,
    required this.language,
    required this.lastName,
    required this.avatarUrl,
    required this.lotteryTicketsCount,
    required this.phoneNumber,
    required this.prizesCount,
  });
  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);
}
