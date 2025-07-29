import 'package:flutter/material.dart';
import 'package:shakti_hormann/app/presentation/widgets/dashboard-item.dart';
import 'package:shakti_hormann/app/presentation/widgets/greeting_widget.dart';
import 'package:shakti_hormann/app/presentation/widgets/task_widget.dart';
import 'package:shakti_hormann/features/gate_entry/gate_entry_list.dart';
import 'package:shakti_hormann/styles/app_icons.dart';

class AppHomePage extends StatefulWidget {
  const AppHomePage({super.key});

  @override
  State<AppHomePage> createState() => _AppHomePageState();
}

class _AppHomePageState extends State<AppHomePage> {
  int _selectedIndex = 0;

  final List<DashboardItem> dashboardItems = [
   DashboardItem(
    title: "Gate Entry",
    icon: AppIcons.gateeEntry,
    onTap: (context) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const GateEntryScreen()),
      );
    },
  ),
    DashboardItem(
      title: "Gate Exit",
      icon: AppIcons.gateExit,
      onTap: (context) {},
    ),
    DashboardItem(
      title: "Logistic Request",
      icon: AppIcons.logisticRequest,
      onTap: (context) {},
    ),
    DashboardItem(
      title: "Transport\nConfirmation",
      icon: AppIcons.transportrterConfirmation,
      onTap: (context) {},
    ),
    DashboardItem(
      title: "Vehicle Reporting\nEntry",
      icon: AppIcons.vehicleReporting,
      onTap: (context) {},
    ),
    DashboardItem(
      title: "Loading\nConfirmation",
      icon: AppIcons.loadingConfirmation,
      onTap: (context) {},
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget buildDashboardCard(DashboardItem item) {
    return GestureDetector(
      onTap: () => item.onTap(context),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade400, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade100,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            item.icon.toWidget(height: 60, width: 60),
            const SizedBox(height: 10),
            Text(
              item.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Color(0xFF0D0D0D),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Column(
          children: [
            // Greeting + Notification
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GreetingHeader(
                   
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.notifications_none,
                      size: 30,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),

            // Task Widget
            const TaskWidget(
              title: "Your Today's Task",
              subtitle: "Almost done!",
              icon: Icons.check_circle,
              onCancel: null,
            ),

            // Dashboard Grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  itemCount: dashboardItems.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemBuilder: (context, index) {
                    return buildDashboardCard(dashboardItems[index]);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedIconTheme: const IconThemeData(color: Colors.orange),
        unselectedIconTheme: const IconThemeData(color: Colors.black),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
