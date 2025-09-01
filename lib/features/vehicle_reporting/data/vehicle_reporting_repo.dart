import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/transport_confirmation/model/transport_confirmation_form.dart';
import 'package:shakti_hormann/features/vehicle_reporting/model/vehicle_reporting_form.dart';

abstract interface class VehicleReportingRepo {
  AsyncValueOf<List<VehicleReportingForm>> fetchVehicles(
    int start,
    String? docStatus,
    String? serach
  );
  AsyncValueOf<Pair<String,String>>  createVehicleReporting(VehicleReportingForm form);
  AsyncValueOf<List<TransportConfirmationForm>> fetchLogistics(String name);
  AsyncValueOf<Pair<String,String>> submitVehicleReporting(VehicleReportingForm form);
  AsyncValueOf<Pair<String,String>> rejectVehicleReporting(VehicleReportingForm form);
}