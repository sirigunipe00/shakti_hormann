import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/features/push_notifications.dart/ui/notifications.dart';
import 'package:shakti_hormann/core/utils/date_format_util.dart';
import 'package:shakti_hormann/features/push_notifications.dart/model/notification_model.dart';
import 'package:shakti_hormann/features/push_notifications.dart/ui/bloc/bloc_provider.dart';

class NotificationListScreen extends StatelessWidget {
  const NotificationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications',style: TextStyle(fontFamily: 'urbanist',fontSize: 30,
      color: Colors.black),)),
      body: BlocBuilder<NotificationList, NotificationState>(
        builder: (context, state) {
          
          return state.maybeWhen(
            loading: () => const Center(child: CircularProgressIndicator()),

            success: (data) {
              if (data.isEmpty) {
                return const Center(child: Text('No Notifications'));
              }return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final NotificationModel item = data[index];
                  return NotificationCard(
                    title: item.notificationType ?? '',
                    description: item.notificationMessage ?? '',
                    time: DFU.timeFromStr(item.sentAt ?? ''),
                    date : DFU.ddMMyyyyFromStr(item.sentAt ?? ''),
                    onTap: () {},
                  );
                },
              );
            },
            orElse: () => const Center(child: Text('No data')),
          );
        },
      ),
    );
  }
}
