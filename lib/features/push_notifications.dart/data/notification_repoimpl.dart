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
      // Do not log subscription ids here to avoid leaking identifiers
      final subsId = OneSignal.User.pushSubscription.id;

      // print('subsId ....:$subsId');

      final config = RequestConfig(
        url: Urls.oneSignal,
        // headers: addCommonApiHeaders(),
        body: jsonEncode({
          'user': user().email,
          'device_type': info.deviceType,
          'installed_app_version': info.installedAppVersion,
          // 'role': info.role,
          // 'os_details': info.osDetails,
          // 'os_name': info.osName,
          'unique_id': info.deviceUniqueId,
          'player_id': subsId,
          // 'description': '',
          // 'function': 'update',
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
        'filters': [
          ['user', '=', userName],
        ],
        'limit_page_length': 'None',
        'order_by': 'creation desc',
        'doctype': 'Notifications Request',
        'fields': jsonEncode(['*']),
      };

      final config = RequestConfig(
        url: Urls.getList,

        parser: (json) {
          final data = json['message'];
          final listdata = data as List<dynamic>;
          return listdata.map((e) => NotificationModel.fromJson(e)).toList();
        },

        reqParams: reqParams,

        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );

      final response = await get(config);
      $logger.devLog('request params....$config');
      $logger.devLog('response.....$response');
      return response.processAsync((r) async {
        return right((r.data!));
      });
    });
  }
}
