import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/core/utils/date_format_util.dart';
import 'package:shakti_hormann/features/push_notifications.dart/model/notification_model.dart';
import 'package:shakti_hormann/features/push_notifications.dart/ui/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/push_notifications.dart/ui/notifications.dart';
import 'package:shakti_hormann/styles/app_color.dart';

class NotificationListScreen extends StatelessWidget {
  const NotificationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontFamily: 'Urbanist',
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: () => context.read<NotificationList>().request(),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: BlocBuilder<NotificationList, NotificationState>(
        builder: (context, state) {
          return state.when(
            initial: () => const Center(child: CircularProgressIndicator()),
            loading: () => const Center(child: CircularProgressIndicator()),
            failure: (err) => _NotificationStatus(
              icon: Icons.error_outline_rounded,
              title: 'Could not load notifications',
              message: err.error,
              actionLabel: 'Try again',
              onAction: () => context.read<NotificationList>().request(),
            ),
            success: (data) {
              if (data.isEmpty) {
                return const _NotificationStatus(
                  icon: Icons.notifications_none_rounded,
                  title: 'No notifications',
                  message: 'You are all caught up for now.',
                );
              }
              return RefreshIndicator(
                onRefresh: () async {
                  await context.read<NotificationList>().request();
                },
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 96),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final NotificationModel item = data[index];
                    return NotificationCard(
                      title: item.notificationType ?? '',
                      description: item.notificationMessage ?? '',
                      time: DFU.timeFromStr(item.sentAt ?? ''),
                      date: DFU.ddMMyyyyFromStr(item.sentAt ?? ''),
                      onTap: () {},
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _NotificationStatus extends StatelessWidget {
  const _NotificationStatus({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: AppColors.darkBlue.withValues(alpha: 0.7)),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0E1446),
              ),
            ),
            if (message != null && message!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 14,
                  color: Color(0xFF5B6178),
                ),
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 16),
              FilledButton(
                onPressed: onAction,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.darkBlue,
                ),
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
