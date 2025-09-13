import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shakti_hormann/features/auth/model/logged_in_user.dart';

class AppScaffoldWidget extends StatelessWidget {
  const AppScaffoldWidget({super.key, required this.navigationShell,required this.roleStatus});

  final StatefulNavigationShell navigationShell;
  final RoleStatus? roleStatus;
    int get dashboardStatus => roleStatus?.showDashboards == 1 ? 1 : 0;


int getVisibleTabIndex(int branchIndex) {
  if (dashboardStatus == 1) return branchIndex;
  return branchIndex == 0 ? 0 : 1;
}

void _goBranch(int tabIndex) {
  int branchIndex;
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(top: 12,bottom: 5,left: 5,right: 5),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFEAF1FF),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFBDD5FF)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Padding(
                padding: const EdgeInsets.only(top: 10,bottom: 0),
                child: NavigationBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  height: 60,
                  labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                  onDestinationSelected: onDestinationSelected,
                  indicatorColor: Colors.transparent,
                  selectedIndex: selectedIndex,
                  destinations: [
                    _buildDestination(
                      index: 0,
                      selectedIndex: selectedIndex,
                      iconPath: 'assets/images/home.png',
                      label: 'Home',
                    ),
                    if(dashboardStatus == 1)
                    _buildDestination(
                      index: 1,
                      selectedIndex: selectedIndex,
                      iconPath: 'assets/images/dashboard.png',
                      label: 'Dashboard',
                    ),
                    _buildDestination(
                      index: dashboardStatus == 1 ? 2 :1,
                      selectedIndex: selectedIndex,
                      iconPath: 'assets/images/profile.png',
                      label: 'Profile',
                    ),
                  ],
                  labelTextStyle: const WidgetStatePropertyAll(
                    TextStyle(
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

NavigationDestination _buildDestination({
  required int index,
  required int selectedIndex,
  required String iconPath,
  required String label,
}) {
  final isSelected = index == selectedIndex;

  return NavigationDestination(
    label: '',
    icon: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ImageIcon(
          AssetImage(iconPath),
          size: 24,
          color: isSelected ? const Color(0xFFFFB800) : Colors.black54,
        ),
        const SizedBox(height: 8), 
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Urbanist',
            fontWeight: FontWeight.w600,
            fontSize: 12.5,
            color: Colors.black87,
          ),
        ),
        if (isSelected)
          Container(
            margin: const EdgeInsets.only(top:7),
            height: 3,
            width: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF2957A4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
      ],
    ),
  );
}


}