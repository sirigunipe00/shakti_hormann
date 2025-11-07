import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/features/dashboard/model/gate_dashboard_response.dart';
import 'package:shakti_hormann/features/dashboard/presentation/bloc_provider.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AppDashboardPage extends StatefulWidget {
  const AppDashboardPage({super.key});

  @override
  State<AppDashboardPage> createState() => _AppDashboardPageState();
}

class _AppDashboardPageState extends State<AppDashboardPage> {
  late final DashBoardList dashboardCubit;

  @override
  void initState() {
    super.initState();
    dashboardCubit = DashBoardBlocProvider.get().getDash();
    dashboardCubit.request(null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FBFF),
      appBar: AppBar(
        centerTitle: true,
        shadowColor: Colors.black45,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.dashboard, color: AppColors.darkBlue),
            SizedBox(width: 8),
            Text(
              'Dashboard',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: AppColors.darkBlue,
                fontFamily: 'Urbanist',
              ),
            ),
          ],
        ),
      ),

      body: BlocBuilder<DashBoardList, DashBoardState>(
        bloc: dashboardCubit,
        builder: (context, state) {
          return state.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            failure: (err) => Center(child: Text('Error: $err')),
            success: (data) {
              final jaipur =
                  data.message.data['Shakti Hormann Private Limited Jaipur'] ??
                  PlantDashboardExtension.empty();
              final medchal =
                  data.message.data['Shakti Hormann Private Limited Medchal'] ??
                  PlantDashboardExtension.empty();

              return _buildDashboardUI(jaipur, medchal);
            },
            initial: () => const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}

Widget _buildDashboardUI(PlantDashboard jaipur, PlantDashboard medchal) {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Gate Entry & Exit Summary',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Urbanist',
            color: AppColors.darkBlue,
          ),
        ),
        const SizedBox(height: 16),

        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            StatCard(
              title: 'Jaipur - Entries',
              value: '${jaipur.gateEntries}',
              icon: Icons.login,
              color: Colors.green,
            ),
            StatCard(
              title: 'Jaipur - Exits',
              value: '${jaipur.gateExits}',
              icon: Icons.logout,
              color: Colors.red,
            ),
            StatCard(
              title: 'Medchal - Entries',
              value: '${medchal.gateEntries}',
              icon: Icons.login,
              color: Colors.green,
            ),
            StatCard(
              title: 'Medchal - Exits',
              value: '${medchal.gateExits}',
              icon: Icons.logout,
              color: Colors.red,
            ),
          ],
        ),

        const SizedBox(height: 24),

        _buildSectionTitle('Jaipur - Gate Analysis'),
        _buildChartCard(
          data: jaipur.daywise,
          entriesColor: Colors.blue,
          exitsColor: const Color(0xFF8DC2FF),
        ),

        const SizedBox(height: 24),

        _buildSectionTitle('Medchal - Gate Analysis'),
        _buildChartCard(
          data: medchal.daywise,
          entriesColor: Colors.green,
          exitsColor: Colors.orange,
        ),
      ],
    ),
  );
}

Widget _buildSectionTitle(String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        fontFamily: 'Urbanist',
        color: AppColors.darkBlue,
      ),
    ),
  );
}

Widget _buildChartCard({
  required List<Daywise> data,
  required Color entriesColor,
  required Color exitsColor,
}) {
  double getMaxY() {
    if (data.isEmpty) return 5;
    final maxEntry = data.map((e) => e.entries).reduce((a, b) => a > b ? a : b);
    final maxExit = data.map((e) => e.exits).reduce((a, b) => a > b ? a : b);
    final maxValue = maxEntry > maxExit ? maxEntry : maxExit;
    if (maxValue == 0) return 5;
    return maxValue + (maxValue * 0.2);
  }

  double getInterval(double maxY) {
    if (maxY <= 5) return 1;
    return (maxY / 5).ceilToDouble();
  }

  final maxY = getMaxY();
  final interval = getInterval(maxY);

  return SizedBox(
    height: 260,
    child: Card(
      elevation: 3,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: SfCartesianChart(
          primaryXAxis: const CategoryAxis(title: AxisTitle(text: 'Day')),
          primaryYAxis: NumericAxis(
            majorGridLines: const MajorGridLines(width: 0.3),
            axisLine: const AxisLine(width: 0),
            minimum: 0,
            maximum: maxY,
            interval: interval,
          ),
          legend: const Legend(isVisible: true),
          series: <CartesianSeries>[
            ColumnSeries<Daywise, String>(
              name: 'Entries',
              color: entriesColor,
              borderRadius: const BorderRadius.all(Radius.circular(6)),
              width: 0.35,
              spacing: 0.2,
              dataSource: data,
              xValueMapper: (d, _) =>
                  d.day.length >= 8 ? d.day.substring(8) : d.day,
              yValueMapper: (d, _) => d.entries,
            ),
            ColumnSeries<Daywise, String>(
              name: 'Exits',
              color: exitsColor,
              borderRadius: const BorderRadius.all(Radius.circular(6)),
              width: 0.35,
              spacing: 0.2,
              dataSource: data,
              xValueMapper: (d, _) =>
                  d.day.length >= 8 ? d.day.substring(8) : d.day,
              yValueMapper: (d, _) => d.exits,
            ),
          ],
        ),
      ),
    ),
  );
}

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2 - 24,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Urbanist',
                  color: Color(0xFF565656),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Urbanist',
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
