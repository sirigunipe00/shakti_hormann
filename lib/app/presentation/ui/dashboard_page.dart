import 'package:flutter/material.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AppDashboardPage extends StatelessWidget {
  const AppDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title:  const Center(child: Text('Dashboard',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: AppColors.darkBlue,fontFamily: 'Urbanist'),)),
    
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Stats Cards ---
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2.2,
              children: const [
                StatCard(
                  title: 'Total Gate Entries',
                  value: '154',
                  percent: '-10%',
                  isUp: true,
                ),
                StatCard(
                  title: 'Total Gate Exits',
                  value: '156',
                  percent: '10%',
                  isUp: true,
                ),
                StatCard(
                  title: 'Scheduled Gate Exits',
                  value: '56',
                  percent: '-10%',
                  isUp: false,
                ),
                StatCard(
                  title: 'Pending Gate Exits',
                  value: '34',
                  percent: '-10%',
                  isUp: false,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // --- Bar Chart ---
            const Text(
              'Gate Analysis',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 250,
              child: SfCartesianChart(
                primaryXAxis: const CategoryAxis(title: AxisTitle(text: 'SI No.')),
                legend:const  Legend(isVisible: true),
                series: <CartesianSeries<_GateData, String>>[
                  // 👈 FIXED HERE
                  ColumnSeries<_GateData, String>(
                    name: 'Entry',
                    color: Colors.blue,
                    dataSource: _getGateData(),
                    xValueMapper:
                        (d, index) => (index + 1).toString(), // Auto SI No
                    yValueMapper: (d, _) => d.entry,
                  ),
                  ColumnSeries<_GateData, String>(
                    name: 'Exit',
                    color: Colors.lightBlue,
                    dataSource: _getGateData(),
                    xValueMapper:
                        (d, index) => (index + 1).toString(), // Auto SI No
                    yValueMapper: (d, _) => d.exit,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // --- Donut Charts ---
            Row(
              children: [
                Expanded(child: _buildDonutChart('PDI')),
                const SizedBox(width: 10),
                Expanded(child: _buildDonutChart('PO')),
              ],
            ),

           
           
          ],
        ),
      ),
    );
  }

  // Donut Chart Builder
  Widget _buildDonutChart(String title) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                const Icon(Icons.more_vert, size: 16),
              ],
            ),
            SizedBox(
              height: 150,
              child: SfCircularChart(
                legend: const Legend(
                  isVisible: true,
                  position: LegendPosition.bottom,
                ),
                series: <CircularSeries>[
                  DoughnutSeries<_SupplierData, String>(
                    dataSource: _getSupplierData(),
                    xValueMapper: (d, _) => d.supplier,
                    yValueMapper: (d, _) => d.value,
                    dataLabelSettings: const DataLabelSettings(
                      isVisible: false,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Models & Dummy Data ---
class _GateData {
  _GateData(this.label, this.entry, this.exit);
  final String label;
  final int entry;
  final int exit;
}

List<_GateData> _getGateData() {
  return [
    _GateData('Day 1', 40, 30),
    _GateData('Day 2', 60, 50),
    _GateData('Day 3', 30, 40),
    _GateData('Day 4', 50, 20),
    _GateData('Day 5', 45, 35),
  ];
}

class _SupplierData {
  _SupplierData(this.supplier, this.value);
  final String supplier;
  final int value;
}

List<_SupplierData> _getSupplierData() {
  return [
    _SupplierData('Supplier 1', 25),
    _SupplierData('Supplier 2', 15),
    _SupplierData('Supplier 3', 20),
    _SupplierData('Supplier 4', 10),
    _SupplierData('Supplier 5', 30),
  ];
}

// --- Reusable Stat Card ---
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String percent;
  final bool isUp;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.percent,
    required this.isUp,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
    
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            // const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            // const SizedBox(height: 8,),
            Row(
              children: [
                Icon(
                  isUp ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 16,
                  color: isUp ? Colors.green : Colors.red,
                ),
                Text(
                  percent,
                  style: TextStyle(color: isUp ? Colors.green : Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';

// class AppDashboardPage extends StatelessWidget {
//   const AppDashboardPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body:Center(child: Text('Welcome to DashBoard'))
//     );
//   }
// }