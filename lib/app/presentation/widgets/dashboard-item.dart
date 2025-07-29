import 'package:flutter/material.dart';
import 'package:shakti_hormann/styles/app_icons.dart';

class DashboardItem {
  final String title;
  final AppIcon icon;
  final void Function(BuildContext context) onTap;

  const DashboardItem({
    required this.title,
    required this.icon,
    required this.onTap
  });
}
