// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationModelImpl _$$NotificationModelImplFromJson(
  Map<String, dynamic> json,
) => _$NotificationModelImpl(
  name: json['name'] as String?,
  owner: json['owner'] as String?,
  notificationType: json['notification_type'] as String?,
  notificationId: json['notification_id'] as String?,
  user: json['user'] as String?,
  notificationMessage: json['notification_message'] as String?,
  sentAt: json['sent_at'] as String?,
);

Map<String, dynamic> _$$NotificationModelImplToJson(
  _$NotificationModelImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'owner': instance.owner,
  'notification_type': instance.notificationType,
  'notification_id': instance.notificationId,
  'user': instance.user,
  'notification_message': instance.notificationMessage,
  'sent_at': instance.sentAt,
};
