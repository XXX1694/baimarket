import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class NotificationModel {
  final int id;
  final int userId;
  final String? title;
  final String? body;
  final String? type;
  final String? structure;
  final Map<String, dynamic>? data;
  final bool read;
  final String createdAt;
  final String? backgroundPhotoUrl;
  final String? buttonText;
  final String? buttonLink;
  final String? deeplink;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.read,
    required this.data,
    required this.createdAt,
    required this.backgroundPhotoUrl,
    required this.buttonText,
    required this.buttonLink,
    required this.deeplink,
    required this.type,
    required this.structure,
  });
  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);
}
