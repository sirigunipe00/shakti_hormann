import 'package:shakti_hormann/core/utils/typedefs.dart';
import 'package:shakti_hormann/features/dashboard/model/gate_dashboard_response.dart';

abstract interface class Dashboardrepo {
  AsyncValueOf<GateDashboardResponse> getDashboard();
    // AsyncValueOf<bool> isAppUpdateAvailable();
}