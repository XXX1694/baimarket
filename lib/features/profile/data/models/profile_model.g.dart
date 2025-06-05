// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) => ProfileModel(
  favoritesCount: (json['favoritesCount'] as num?)?.toInt(),
  firstName: json['firstName'] as String?,
  language: json['language'] as String?,
  lastName: json['lastName'] as String?,
  avatarUrl: json['avatarUrl'] as String?,
  lotteryTicketsCount: (json['lotteryTicketsCount'] as num?)?.toInt(),
  phoneNumber: json['phoneNumber'] as String?,
  prizesCount: (json['prizesCount'] as num?)?.toInt(),
);

Map<String, dynamic> _$ProfileModelToJson(ProfileModel instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phoneNumber': instance.phoneNumber,
      'language': instance.language,
      'avatarUrl': instance.avatarUrl,
      'favoritesCount': instance.favoritesCount,
      'prizesCount': instance.prizesCount,
      'lotteryTicketsCount': instance.lotteryTicketsCount,
    };
