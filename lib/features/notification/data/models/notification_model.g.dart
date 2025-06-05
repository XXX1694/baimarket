// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    NotificationModel(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      title: json['title'] as String?,
      body: json['body'] as String?,
      read: json['read'] as bool,
      data: json['data'] as Map<String, dynamic>?,
      createdAt: json['createdAt'] as String,
      backgroundPhotoUrl: json['backgroundPhotoUrl'] as String?,
      buttonText: json['buttonText'] as String?,
      buttonLink: json['buttonLink'] as String?,
      deeplink: json['deeplink'] as String?,
      type: json['type'] as String?,
      structure: json['structure'] as String?,
    );

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'body': instance.body,
      'type': instance.type,
      'structure': instance.structure,
      'data': instance.data,
      'read': instance.read,
      'createdAt': instance.createdAt,
      'backgroundPhotoUrl': instance.backgroundPhotoUrl,
      'buttonText': instance.buttonText,
      'buttonLink': instance.buttonLink,
      'deeplink': instance.deeplink,
    };
