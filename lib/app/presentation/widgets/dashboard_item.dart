import 'package:flutter/material.dart';
import 'package:shakti_hormann/features/auth/model/logged_in_user.dart';
import 'package:shakti_hormann/styles/app_icons.dart';

enum DashboardSection {
  logistics,
  scanningPackaging,
}

class DashboardItem {
  const DashboardItem({
    required this.title,
    required this.icon,
    required this.onTap,
    required this.section,
    required this.permissionSelector,
    this.iconSize,
    this.featureColor,
  });

  final DashboardSection section;
  final String title;
  final AppIcon icon;
  final Size? iconSize;
  final Color? featureColor;

  final void Function(BuildContext context) onTap;
  final int? Function(RoleStatus? roleStatus) permissionSelector;

  bool canShow(RoleStatus? roleStatus) {
    return permissionSelector.call(roleStatus) == 1;
  }
}