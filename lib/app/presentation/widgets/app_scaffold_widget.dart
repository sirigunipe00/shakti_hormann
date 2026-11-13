import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shakti_hormann/features/auth/model/logged_in_user.dart';
import 'package:shakti_hormann/styles/app_color.dart';

class AppScaffoldWidget extends StatelessWidget {
  const AppScaffoldWidget({
    super.key,
    required this.navigationShell,
    required this.roleStatus,
  });

  final StatefulNavigationShell navigationShell;
  final RoleStatus? roleStatus;

  int get dashboardStatus => roleStatus?.showDashboards == 1 ? 1 : 0;

  int getVisibleTabIndex(int branchIndex) {
    if (dashboardStatus == 1) return branchIndex;
    return branchIndex == 0 ? 0 : 1;
  }

  void _goBranch(int tabIndex) {
    final int branchIndex;
    if (dashboardStatus == 1) {
      branchIndex = tabIndex;
    } else {
      branchIndex = tabIndex == 0 ? 0 : 2;
    }
    navigationShell.goBranch(branchIndex);
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithNavigationBar(
      body: navigationShell,
      selectedIndex: getVisibleTabIndex(navigationShell.currentIndex),
      onDestinationSelected: _goBranch,
      dashboardStatus: dashboardStatus,
    );
  }
}

class ScaffoldWithNavigationBar extends StatelessWidget {
  const ScaffoldWithNavigationBar({
    super.key,
    required this.body,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.dashboardStatus,
  });

  final Widget body;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final int dashboardStatus;

  static const _accent = Color(0xFFF2A93E);
  static const _navBg = Color(0xF2163A6B);

  @override
  Widget build(BuildContext context) {
    final items = <_NavItem>[
      const _NavItem(
        index: 0,
        iconPath: 'assets/images/home (1).png',
        label: 'Home',
      ),
      if (dashboardStatus == 1)
        const _NavItem(
          index: 1,
          iconPath: 'assets/images/dashboard.png',
          label: 'Dashboard',
        ),
      _NavItem(
        index: dashboardStatus == 1 ? 2 : 1,
        iconPath: 'assets/images/profile.png',
        label: 'Profile',
      ),
    ];

    return Scaffold(
      body: body,
      resizeToAvoidBottomInset: false,
      extendBody: true,
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(14, 0, 14, 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              height: 62,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: _navBg,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.14),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.darkBlue.withValues(alpha: 0.3),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  for (final item in items)
                    Expanded(
                      child: _NavDestination(
                        item: item,
                        selected: selectedIndex == item.index,
                        accent: _accent,
                        onTap: () => onDestinationSelected(item.index),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({
    required this.index,
    required this.iconPath,
    required this.label,
  });

  final int index;
  final String iconPath;
  final String label;
}

class _NavDestination extends StatelessWidget {
  const _NavDestination({
    required this.item,
    required this.selected,
    required this.accent,
    required this.onTap,
  });

  final _NavItem item;
  final bool selected;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: selected ? accent : Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: SizedBox.expand(
            child: selected
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ImageIcon(
                        AssetImage(item.iconPath),
                        size: 18,
                        color: AppColors.darkBlue,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          item.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Urbanist',
                            fontWeight: FontWeight.w700,
                            fontSize: 12.5,
                            color: AppColors.darkBlue,
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ImageIcon(
                        AssetImage(item.iconPath),
                        size: 18,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.w600,
                          fontSize: 10.5,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
