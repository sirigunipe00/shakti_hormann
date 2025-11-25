import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/core/cubit/network_request/network_request_cubit.dart';
import 'package:shakti_hormann/core/di/injector.dart';
import 'package:shakti_hormann/features/push_notifications.dart/data/notification_repo.dart';
import 'package:shakti_hormann/features/push_notifications.dart/model/notification_model.dart';

typedef NotificationList
    = NetworkRequestCubit<List<NotificationModel>, String>;
typedef NotificationState
    = NetworkRequestState<List<NotificationModel>>;

@lazySingleton
class NotificationBlocProvider {
  const NotificationBlocProvider(this.repo);

  final NotificationRepo repo;

  static NotificationBlocProvider get() => $sl.get<NotificationBlocProvider>();
  

  NotificationList fetchNotifications() => NotificationList(
    onRequest: (params, state) => repo.fetchNotifications(params ?? ''),
  );

}