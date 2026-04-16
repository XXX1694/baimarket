// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gift_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GiftModel _$GiftModelFromJson(Map<String, dynamic> json) => GiftModel(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String?,
  photoUrl: json['photoUrl'] as String?,
);

Map<String, dynamic> _$GiftModelToJson(GiftModel instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'photoUrl': instance.photoUrl,
};
