import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/push_notifications.dart/data/notification_repo.dart';
import 'package:shakti_hormann/features/push_notifications.dart/model/notification_model.dart';
import 'package:shakti_hormann/features/push_notifications.dart/model/user_device_info.dart';

@LazySingleton(as: NotificationRepo)
class NoticationRepoImpl extends BaseApiRepository implements NotificationRepo {
  const NoticationRepoImpl(super.client);

  @override
  AsyncValueOf<bool> updateDeviceInfo(UserDeviceInfo info) async {
    return await executeSafely(() async {
      final subsId = OneSignal.User.pushSubscription.id;

      final config = RequestConfig(
        url: Urls.oneSignal,
        body: jsonEncode({
          'user': user().email,
          'device_type': info.deviceType,
          'installed_app_version': info.installedAppVersion,
          'unique_id': info.deviceUniqueId,
          'player_id': subsId,
        }),
        parser: (json) => json,
      );
      final response = await post(config);

      return response.process((r) => right(true));
    });
  }

  @override
  AsyncValueOf<List<NotificationModel>> fetchNotifications(String name) async {
    return await executeSafely(() async {
      final userName = user().email;

      final reqParams = {
        'limit_start': 0,
        // Cap page size — 'None' previously loaded the full table and hung.
        'limit_page_length': 50,
        'order_by': 'creation desc',
        'doctype': 'Notifications Request',
        'fields': jsonEncode([
          'name',
          'notification_type',
          'notification_message',
          'user',
          'sent_at',
        ]),
        // Must be JSON-encoded so RestUtils keeps the filter on the URL.
        'filters': jsonEncode([
          ['user', '=', userName],
        ]),
      };

      final config = RequestConfig(
        url: Urls.getList,
        parser: (json) {
          final data = json['message'];
          if (data is! List) return <NotificationModel>[];
          return data
              .map(
                (e) => NotificationModel.fromJson(
                  Map<String, dynamic>.from(e as Map),
                ),
              )
              .toList();
        },
        reqParams: reqParams,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );

      final response = await get(config);
      $logger
        ..devLog('notification request....$config')
        ..devLog('notification response.....$response');
      return response.processAsync((r) async {
        return right(r.data ?? <NotificationModel>[]);
      });
    });
  }
}
