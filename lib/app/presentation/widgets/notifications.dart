import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {

  const NotificationCard({
    super.key,
    required this.title,
    required this.description,
    required this.time,
    this.onTap,
  });
  final String title;
  final String description;
  final String time;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        onTap: onTap,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(description,style: const TextStyle(fontWeight: FontWeight.bold,color: Color.fromARGB(255, 109, 104, 104))),
            const SizedBox(height: 8),
            // Text(time, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        trailing: Text(time, style: const TextStyle(fontSize: 12, color: Colors.grey,fontWeight: FontWeight.w600)),
      ),
    );
  }
}
