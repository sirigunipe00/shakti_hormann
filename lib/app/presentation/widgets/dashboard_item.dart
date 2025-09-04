import 'package:flutter/material.dart';
import 'package:shakti_hormann/styles/app_icons.dart';

class DashboardItem {

  const DashboardItem({
    required this.title,
    required this.icon,
    required this.onTap
  });
  final String title;
  final AppIcon icon;
  final void Function(BuildContext context) onTap;
}
