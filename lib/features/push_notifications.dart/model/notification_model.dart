

import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'owner') String? owner,
    @JsonKey(name: 'notification_type') String? notificationType,
    @JsonKey(name: 'notification_id') String? notificationId,
    @JsonKey(name: 'user') String? user,
    @JsonKey(name: 'notification_message') String? notificationMessage,
    @JsonKey(name: 'sent_at') String? sentAt,
  }) = _NotificationModel;
factory NotificationModel.fromJson(Map<String, dynamic> json) => _$NotificationModelFromJson(json);
}