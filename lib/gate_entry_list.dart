import 'package:flutter/material.dart';
import 'package:shakti_hormann/gate_entry_details.dart';

class GateEntryScreen extends StatelessWidget {
  const GateEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text('Gate Entry', style: TextStyle(color: Colors.black)),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Icon(Icons.menu_outlined, color: Colors.orange),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search GI / PO',
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
                  "GI-SHM-0001",
                  "Quantum Logistics | TS11AS9269 | Steel",
                  "2025-07-23",
                  "10:00 AM",
                  "Draft",
                  Colors.deepPurple.shade100,
                ),
                buildEntryCard(
                  context,
                  "AT",
                  "GI-SHM-0002",
                  "Apex Transport | TS14AG9270 | Aluminum",
                  "2025-08-15",
                  "2:30 PM",
                  "Submitted",
                  Colors.orange.shade100,
                ),
                buildEntryCard(
                  context,
                  "NC",
                  "GI-SHM-0003",
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
  switch (status) {
    case "Draft":
      statusColor = Colors.blue.shade100;
      break;
    case "Submitted":
      statusColor = Colors.green.shade100;
      break;
    case "Rejected":
      statusColor = Colors.red.shade100;
      break;
    default:
      statusColor = Colors.grey.shade300;
  }

 return GestureDetector(
  onTap: () {
   Navigator.push(context, MaterialPageRoute(builder: (context)=>
   GateEntryDetailScreen()));
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
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
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
                    const Icon(Icons.calendar_today, size: 14, color: Colors.orange),
                    const SizedBox(width: 4),
                    Text(date),
                    const SizedBox(width: 16),
                    const Icon(Icons.access_time, size: 14, color: Colors.teal),
                    const SizedBox(width: 4),
                    Text(time),
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
                      "SHM-PO-25-26-00217",
                      style: const TextStyle(
                        color: Colors.indigo,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        status,
                        style: const TextStyle(fontSize: 12),
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

