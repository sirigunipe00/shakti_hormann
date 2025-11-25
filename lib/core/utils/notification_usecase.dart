import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/core/utils/device_info_mixin.dart';
import 'package:shakti_hormann/features/push_notifications.dart/data/notification_repo.dart';

@lazySingleton
class NotificationUsecase with DeviceInfoMixin {
  const NotificationUsecase({required this.repo});

  final NotificationRepo repo;

  void updateOSDetails() async {
    final info = await getDeviceInfo();


    print('info . ....:$info');
    // Avoid logging full device info which may contain identifiers.
    await repo.updateDeviceInfo(info);
  }
}
