// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => OrderModel(
  id: (json['id'] as num).toInt(),
  cartItems:
      (json['cartItems'] as List<dynamic>)
          .map((e) => OrderProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
  totalPrice: (json['totalPrice'] as num).toInt(),
  userId: (json['userId'] as num).toInt(),
  deliveryInfo: json['deliveryInfo'] as Map<String, dynamic>?,
  createdAt: json['createdAt'] as String,
  paymentFailureReason: json['paymentFailureReason'] as String?,
  paymentId: json['paymentId'] as String?,
  paymentTypeSlug: json['paymentTypeSlug'] as String?,
  paymentUrl: json['paymentUrl'] as String?,
  status: json['status'] as String?,
  trackingNumber: (json['trackingNumber'] as num?)?.toInt(),
);

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'trackingNumber': instance.trackingNumber,
      'paymentUrl': instance.paymentUrl,
      'paymentTypeSlug': instance.paymentTypeSlug,
      'paymentFailureReason': instance.paymentFailureReason,
      'paymentId': instance.paymentId,
      'cartItems': instance.cartItems,
      'deliveryInfo': instance.deliveryInfo,
      'createdAt': instance.createdAt,
      'totalPrice': instance.totalPrice,
      'status': instance.status,
    };
