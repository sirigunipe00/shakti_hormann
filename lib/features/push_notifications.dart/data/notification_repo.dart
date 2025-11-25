


import 'package:shakti_hormann/core/utils/typedefs.dart';
import 'package:shakti_hormann/features/push_notifications.dart/model/notification_model.dart';
import 'package:shakti_hormann/features/push_notifications.dart/model/user_device_info.dart';

abstract interface class NotificationRepo {
  // AsyncValueOf<List<QMSNotification>> fetchNotifications(int start, int end);
  AsyncValueOf<bool> updateDeviceInfo(UserDeviceInfo info);
  AsyncValueOf<List<NotificationModel>> fetchNotifications(String user);
}