import 'package:flutter/material.dart';
import 'package:shakti_hormann/styles/app_color.dart';

class GateEntryDetailScreen extends StatelessWidget {
  const GateEntryDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF0D326E), // Navy Blue
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Row: Back Button, Title, Submit/Reject
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Color(0xFFFFC107),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'GI-SHM-0001',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor:AppColors.grey,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Submit',style: TextStyle(color: AppColors.white),),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.grey,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Reject',style: TextStyle(color: AppColors.white)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'IRN Scan',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          const Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Scan / Enter IRN',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          const Icon(Icons.qr_code, color: Color(0xFF0D326E)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    sectionHeader(Icons.local_shipping, "Gate Entry Details"),
                    entryFormTile("Plant Name", "SHM Medchal"),
                    entryFormTile("Gate Entry Number", "Enter GI No."),
                    entryFormTile(
                      "Gate Entry Date",
                      "Enter Date",
                      trailing: const Icon(Icons.calendar_month),
                    ),
                    entryFormTile("Purchase Order Number", "Enter PO No."),
                    entryFormTile("Vehicle Number", "Enter Vehicle No."),

                    const SizedBox(height: 24),

                    sectionHeader(Icons.list_alt, "Invoice Details"),
                    entryFormTile("Vendor Invoice", "Enter Vendor Invoice No."),
                    entryFormTile(
                      "Date",
                      "Enter Vendor Invoice Date",
                      trailing: const Icon(Icons.calendar_today),
                    ),
                    entryFormTile("Quantity", "Enter Vendor Invoice Quantity"),
                    entryFormTile(
                      "Amount",
                      "Enter Vendor Invoice Amount",
                      trailing: const Icon(Icons.currency_rupee),
                    ),
                    entryFormTile("Vehicle Number", "Enter Vehicle Number"),

                    const SizedBox(height: 24),

                    sectionHeader(Icons.camera_alt, "Photo"),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          photoTile(
                            "Vehicle Front",
                            Icons.directions_bus,
                            Colors.teal.shade100,
                          ),
                          photoTile(
                            "Vehicle Back",
                            Icons.fire_truck,
                            Colors.orange.shade100,
                          ),
                          photoTile(
                            "Vendor Invoice",
                            Icons.receipt_long,
                            Colors.purple.shade100,
                          ),
                        ],
                      ),
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

  Widget sectionHeader(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue.shade100,
            child: Icon(icon, color: Colors.blue.shade900),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget entryFormTile(String title, String hint, {Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F2F6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: hint,
                      border: InputBorder.none,
                    ),
                  ),
                ),
                if (trailing != null) trailing,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget photoTile(String label, IconData icon, Color bgColor) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: bgColor,
          child: Icon(icon, size: 28),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}
