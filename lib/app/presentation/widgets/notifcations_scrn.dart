import 'package:flutter/material.dart';
import 'package:shakti_hormann/app/presentation/widgets/notifications.dart';

class NotificationListScreen extends StatelessWidget {
  final List<Map<String, String>> notifications = [
    {
      "title": "New Gate Entry",
      "description": "Vehicle TS11AU1234 entered at 10:00 AM",
      "time": "1 hour ago"
    },
    {
      "title": "Invoice Approved",
      "description": "Invoice #123 has been approved",
      "time": "2 days ago"
    },
    {
      "title": "New Document Uploaded",
      "description": "A new purchase order has been added",
      "time": "3 days ago"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final item = notifications[index];
          return NotificationCard(
            title: item["title"] ?? "",
            description: item["description"] ?? "",
            time: item["time"] ?? "",
            onTap: () {
             
            },
          );
        },
      ),
    );
  }
}
