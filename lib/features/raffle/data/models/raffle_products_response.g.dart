// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'raffle_products_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RaffleProductsResponse _$RaffleProductsResponseFromJson(
  Map<String, dynamic> json,
) => RaffleProductsResponse(
  total: (json['total'] as num).toInt(),
  models:
      (json['models'] as List<dynamic>?)
          ?.map((e) => CategoryProductModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$RaffleProductsResponseToJson(
  RaffleProductsResponse instance,
) => <String, dynamic>{
  'total': instance.total,
  'models': instance.models.map((e) => e.toJson()).toList(),
};
