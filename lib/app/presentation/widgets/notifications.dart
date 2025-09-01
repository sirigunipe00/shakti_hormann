import 'package:flutter/material.dart';
import 'package:shakti_hormann/styles/app_color.dart';

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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: const Border(
          left: BorderSide(color: AppColors.darkBlue, width: 2), 
        ),
        boxShadow: [
          const BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset:  Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        onTap: onTap,
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 109, 104, 104),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
        trailing: Text(
          time,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
