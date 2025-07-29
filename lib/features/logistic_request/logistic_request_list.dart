import 'package:flutter/material.dart';
import 'package:shakti_hormann/features/gate_exit/gate_exit_details.dart';
import 'package:shakti_hormann/features/logistic_request/logistic_request_details.dart';
import 'package:shakti_hormann/styles/app_color.dart';

class LogisticRequestScreen extends StatelessWidget {
  const LogisticRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: AppColors.yellow),
        title: const Text('Logistic Request', style: TextStyle(color: Colors.black)),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Icon(Icons.menu_outlined, color: AppColors.yellow),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search LR / SO',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade200,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Today / Tomorrow Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF002060),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Text(
                          "Today",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        "Tomorrow",
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                buildEntryCard(
                  context,
                  "QL",
                  "LR-SO-0001",
                  "Quantum Logistics | TS11AS9269 | Steel",
                  "2025-07-23",
                  "10:00 AM",
                  "Draft",
                  Colors.deepPurple.shade100,
                ),
                buildEntryCard(
                  context,
                  "AT",
                  "LR-SO-0002",
                  "Apex Transport | TS14AG9270 | Aluminum",
                  "2025-08-15",
                  "2:30 PM",
                  "Submitted",
                  Colors.orange.shade100,
                ),
                buildEntryCard(
                  context,
                  "NC",
                  "LR-SO-0003",
                  "Nova Carriers | TS05AN9271 | Plastic",
                  "2025-08-15",
                  "1:15 PM",
                  "Rejected",
                  Colors.pink.shade100,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom:20.0,top:5.0),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GateExitDetailScreen()),
            );
          },
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text('New', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
          backgroundColor: AppColors.darkBlue,
        ),
      ),
    );
  }

  Widget buildEntryCard(
    BuildContext context,
    String code,
    String title,
    String subtitle,
    String date,
    String time,
    String status,
    Color avatarColor,
  ) {
    Color statusColor;
    Color textColor;
    switch (status) {
      case "Draft":
        statusColor = AppColors.liteblue;
        textColor = AppColors.darkBlue;
        break;
      case "Submitted":
        statusColor = AppColors.litegreen;
        textColor = AppColors.green;
        break;
      case "Rejected":
        statusColor = AppColors.sandal;
        textColor = AppColors.red;
        break;
      default:
        statusColor = AppColors.grey;
        textColor = Colors.black;
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LogisticDetailScreen()),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: avatarColor,
                radius: 24,
                child: Text(
                  code,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: AppColors.liteyellow,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          date,
                          style: TextStyle(color: AppColors.liteyellow),
                        ),
                        const SizedBox(width: 16),
                        const Icon(
                          Icons.access_time,
                          size: 14,
                          color: AppColors.litecyan,
                        ),
                        const SizedBox(width: 4),
                        Text(time, style: TextStyle(color: AppColors.litecyan)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      height: 1.5,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "SINV-PO-25-26-00217",
                          style: const TextStyle(
                            color: Colors.indigo,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            status,
                            style: TextStyle(fontSize: 12, color: textColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
