import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/transport_confirmation/model/transport_confirmation_form.dart';
import 'package:shakti_hormann/features/vehicle_reporting/data/vehicle_reporting_repo.dart';
import 'package:shakti_hormann/features/vehicle_reporting/model/vehicle_reporting_form.dart';

@LazySingleton(as: VehicleReportingRepo)
class VehicleReportingRepoimpl extends BaseApiRepository
    implements VehicleReportingRepo {
  const VehicleReportingRepoimpl(super.client);

  @override
  AsyncValueOf<List<VehicleReportingForm>> fetchVehicles(
    int start,
    String? docStatus,
    String? serach,
  ) async {
    final filters = <List<dynamic>>[];

    print('docstatus in reo.:$docStatus');

    if (docStatus != null && docStatus != '4') {
      filters
        ..add(['status', '=', docStatus])
        ..add(['docstatus', '!=', 2])
        ..add(['docstatus', '!=', 1]);
      ;
    }

    if (serach != null && serach.isNotEmpty) {
      filters.add(['name', 'like', '%$serach%']);
    }
    final requestConfig = RequestConfig(
      url: Urls.getList,
      parser: (json) {
        final data = json['message'];
        final listdata = data as List<dynamic>;
        return listdata.map((e) => VehicleReportingForm.fromJson(e)).toList();
      },
      reqParams: {
        'filters': jsonEncode(filters),
        'limit_start': start,
        'limit': 20,
        'order_by': 'creation desc',
        'doctype': 'Vehicle Reporting and Dispatch Loading',
        'fields': jsonEncode(['*']),
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
    $logger.devLog('arrtival date repo......${form.arrivalDateAndTime}');
    return await executeSafely(() async {
      Uint8List? driverIdfrontcompressedBytes;

      if (form.driverIdPhotoImg != null) {
        final filePath = form.driverIdPhotoImg!.path;
        driverIdfrontcompressedBytes =
            await FlutterImageCompress.compressWithFile(filePath, quality: 50);
      } else if (form.driverIdPhoto != null) {
        driverIdfrontcompressedBytes = await fetchAndConvertToBase64(
          form.driverIdPhoto ?? '',
        );
      }
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
          'arrival_date_and__time': form.arrivalDateAndTime,
          'driver_id_proof':
              driverIdfrontcompressedBytes == null
                  ? null
                  : base64Encode(driverIdfrontcompressedBytes),
          'vehicle_number': form.vehicleNumber,
          'vehicle_reporting_entry_vre_date': form.vehicleReportingEntryVreDate,
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
  AsyncValueOf<Pair<String, String>> submitVehicleReporting(
    VehicleReportingForm form,
  ) async {
    $logger.devLog('arrtival date repo......${form.arrivalDateAndTime}');

    return await executeSafely(() async {
      final date = DFU.formatArrivalDate(form.arrivalDateAndTime);

      Uint8List? driverIdfrontcompressedBytes;

      if (form.driverIdPhotoImg != null) {
        final filePath = form.driverIdPhotoImg!.path;
        driverIdfrontcompressedBytes =
            await FlutterImageCompress.compressWithFile(filePath, quality: 50);
      } else if (form.driverIdPhoto != null) {
        driverIdfrontcompressedBytes = await fetchAndConvertToBase64(
          form.driverIdPhoto ?? '',
        );
      }
      final config = RequestConfig(
        url: Urls.updateVehicleReporting,
        parser: (json) {
          final data = json['message']['data']['name'] as String;
          return Pair(data, '');
        },
        body: jsonEncode({
          'plant_name': form.plantName,
          'name': form.name,
          'linked_transporter_confirmation': form.linkedTransporterConfirmation,
          'arrival_date_and__time': date,

          'driver_id_proof':
              driverIdfrontcompressedBytes == null
                  ? null
                  : base64Encode(driverIdfrontcompressedBytes),
          'status': 'Reported',
          'vehicle_number': form.vehicleNumber,
          'vehicle_reporting_entry_vre_date': form.vehicleReportingEntryVreDate,
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
  AsyncValueOf<Pair<String, String>> rejectVehicleReporting(
    VehicleReportingForm form,
  ) async {
    return await executeSafely(() async {
      final formData = removeNullValues(form.toJson());
      const keysToRemove = ['name', 'creation', 'modified', 'modified_by'];
      for (String key in keysToRemove) {
        formData.remove(key);
      }

      final requestConfig = RequestConfig(
        url: Urls.updateVehicleReporting,
        parser: (json) {
          final message = json['message']['message'] as String;
          return Pair(message, '');
        },
        body: jsonEncode({
          'name': form.name,
          'status': 'Rejected',
          'reject_reason': form.rejectReason,
        }),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );
      $logger.devLog(requestConfig);

      final response = await post(requestConfig);
      return response.process((r) => right(r.data!));
    });
  }

  @override
  AsyncValueOf<List<TransportConfirmationForm>> fetchLogistics(
    String name,
  ) async {
    return await executeSafely(() async {
      final config = RequestConfig(
        url: Urls.getList,

        parser: (json) {
          final data = json['message'];
          final listdata = data as List<dynamic>;
          return listdata
              .map((e) => TransportConfirmationForm.fromJson(e))
              .toList();
        },
        reqParams: {
          'filters': jsonEncode([
            ['docstatus', '=', 1],
            ['status', '=', 'Transporter Confirmed'],
            ['vehicle_reported_loaded', '=', 0],
          ]),
          'limit': 20,
          'order_by': 'creation desc',
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

Future<Uint8List?> fetchAndConvertToBase64(String relativePath) async {
  if (p.extension(relativePath).isEmpty) {
    return null;
  }

  final String url = 'http://65.21.243.18:8000$relativePath';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    Uint8List bytes = response.bodyBytes;

    return bytes;
  } else {
    throw Exception('Failed to load file: ${response.statusCode}');
  }
}
