import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/logistic_request/model/logistic_planning_form.dart';
import 'package:shakti_hormann/features/vehicle_reporting/model/vehicle_reporting_form.dart';

abstract interface class VehicleReportingRepo {
  AsyncValueOf<List<VehicleReportingForm>> fetchVehicles(
    int start,
    int? docStatus,
    String? serach
  );
  AsyncValueOf<Pair<String,String>>  createVehicleReporting(VehicleReportingForm form);
  AsyncValueOf<List<LogisticPlanningForm>> fetchLogistics(String name);
}