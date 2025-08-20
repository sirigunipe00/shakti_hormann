import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/logistic_request/model/logistic_planning_form.dart';
import 'package:shakti_hormann/features/vehicle_reporting/data/vehicle_reporting_repo.dart';
import 'package:shakti_hormann/features/vehicle_reporting/model/vehicle_reporting_form.dart';

@LazySingleton(as: VehicleReportingRepo)
class VehicleReportingRepoimpl extends BaseApiRepository
    implements VehicleReportingRepo {
  const VehicleReportingRepoimpl(super.client);

  @override
  AsyncValueOf<List<VehicleReportingForm>> fetchVehicles(
    int start,
    int? docStatus,
    String? serach,
  ) async {
    final requestConfig = RequestConfig(
      url: Urls.getList,
      parser: (json) {
        final data = json['message'];
        final listdata = data as List<dynamic>;
        return listdata.map((e) => VehicleReportingForm.fromJson(e)).toList();
      },
      reqParams: {
        if (!(docStatus == null)) ...{
          'filters': [
            ['docstatus', '=', docStatus],
            if (serach.containsValidValue) ...{
              ['name', 'Like', '%$serach'],
            },
          ],
        },
        'limit_start': start,
        'limit': 20,
        'order_by': 'creation desc',
        'doctype': 'Vehicle Reporting and Dispatch Loading',
        'fields': ['*'],
      },
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    $logger.devLog('requestConfig....$requestConfig');
    final response = await get(requestConfig);
    return response.process((r) => right(r.data!));
  }

  @override
  AsyncValueOf<Pair<String, String>> createVehicleReporting(
    VehicleReportingForm form,
  ) async {
    return await executeSafely(() async {
      final formattedDate =
          form.vehicleReportingEntryVreDate != null
              ? DateFormat('dd-MM-yyyy').format(
                DateFormat(
                  'dd-MM-yyyy',
                ).parse(form.vehicleReportingEntryVreDate!),
              )
              : null;
      final arrivalDateTimeFormatted =
          (form.arrivalDateAndTime != null &&
                  form.arrivalDateAndTime!.isNotEmpty)
              ? DateFormat('dd-MM-yyyy HH:mm:ss').format(
                DateTime(
                  form.vehicleReportingEntryVreDate != null
                      ? DateFormat(
                        'dd-MM-yyyy',
                      ).parse(form.vehicleReportingEntryVreDate!).year
                      : DateTime.now().year,
                  form.vehicleReportingEntryVreDate != null
                      ? DateFormat(
                        'dd-MM-yyyy',
                      ).parse(form.vehicleReportingEntryVreDate!).month
                      : DateTime.now().month,
                  form.vehicleReportingEntryVreDate != null
                      ? DateFormat(
                        'dd-MM-yyyy',
                      ).parse(form.vehicleReportingEntryVreDate!).day
                      : DateTime.now().day,
                  int.parse(form.arrivalDateAndTime!.split(':')[0]),
                  int.parse(form.arrivalDateAndTime!.split(':')[1]),
                ),
              )
              : null;

      final config = RequestConfig(
        url: Urls.createVehicleReporting,
        parser: (json) {
          final data =
              json['message']['data']['linked_transporter_confirmation']
                  as String;
          return Pair(data, '');
        },
        body: jsonEncode({
          'plant_name': form.plantName,
          'linked_transporter_confirmation': form.linkedTransporterConfirmation,
          'arrival_date_and__time': arrivalDateTimeFormatted,
          'driver_id_proof': form.driverIdPhoto,
          'status': form.status,
          'vehicle_reporting_entry_vre_date': formattedDate,
          'driver_contact': form.driverContact,
          'remarks': form.remarks,
        }),

        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );

      $logger.devLog('requestConfig.....$config');

      final response = await post(config);

      return response.processAsync((r) async {
        return right(r.data!);
      });
    });
  }

  @override
  AsyncValueOf<List<LogisticPlanningForm>> fetchLogistics(String name) async {
    return await executeSafely(() async {
      final config = RequestConfig(
        url: Urls.getList,

        parser: (json) {
          final data = json['message'];
          final listdata = data as List<dynamic>;
          return listdata.map((e) => LogisticPlanningForm.fromJson(e)).toList();
        },
        reqParams: {
          'limit': 20,
          'oreder_by': 'create desc',
          'doctype': 'Logistic Planning and Confirmation',
          'fields': ['*'],
        },
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );
      $logger.devLog('LogisticList.....$config');
      final response = await get(config);
      return response.processAsync((r) async {
        return right((r.data!));
      });
    });
  }
}
