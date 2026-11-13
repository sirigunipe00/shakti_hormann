import 'package:shakti_hormann/core/utils/typedefs.dart';
import 'package:shakti_hormann/features/dashboard/model/gate_dashboard_response.dart';
import 'package:shakti_hormann/features/dashboard/model/packing_dashboard_stats.dart';

abstract interface class Dashboardrepo {
  AsyncValueOf<GateDashboardResponse> getDashboard();

  /// Live counts + recent activity for Scanning & Packaging doctypes.
  AsyncValueOf<PackingDashboardStats> getPackingStats();
}
