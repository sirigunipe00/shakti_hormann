import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/auth/model/logged_in_user.dart';
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

    if (docStatus != null && docStatus != '4') {
      filters
        ..add(['status', '=', docStatus])
        ..add(['docstatus', '!=', 2])
        ..add(['docstatus', '!=', 1]);
    }

    if (serach != null && serach.isNotEmpty) {
      filters.add(['name', 'like', '%$serach%']);
    }
    
     final users = $sl.get<LoggedInUser>();
final hasRole = users.roles!.any((r) => r.role == 'Admin Role-SH');
$logger.devLog('hasRole...$hasRole');
final plantName = user().plantName;
    if (!hasRole && plantName != null && plantName.isNotEmpty) {
      filters.add(['plant_name', '=', plantName]);
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
        'limit_page_length': 'None',
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
    final date = form.arrivalDate;
    String? arrivaldate;

    if (date.isNotNull) {
      final yyyyMmDd = RegExp(r'^\d{4}-\d{2}-\d{2}$');
      if (yyyyMmDd.hasMatch(date!)) {
        // Split the date and rearrange to dd-mm-yyyy
        final parts = date.split('-');
        arrivaldate = '${parts[2]}-${parts[1]}-${parts[0]}';
      } else {
        arrivaldate = date;
      }
    }

    final formattedTime =
        form.arrivalTime != null
            ? DateFormat('HH:mm:ss').format(
              DateFormat('HH:mm:ss').tryParse(form.arrivalTime!) ??
                  DateFormat('HH:mm').parse(form.arrivalTime!),
            )
            : null;

    $logger.devLog('arrtival date repo......${form.arrivalDate}');
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

      final Map<String, dynamic> requestBody = {
        'plant_name': form.plantName,
        'linked_transporter_confirmation': form.linkedTransporterConfirmation,
        'arrival_date': arrivaldate,
        'arrival_time': formattedTime,
        'driver_id_proof':
            driverIdfrontcompressedBytes == null
                ? null
                : base64Encode(driverIdfrontcompressedBytes),
        'vehicle_number': form.vehicleNumber,
        'vehicle_reporting_entry_vre_date': form.vehicleReportingEntryVreDate,
        'driver_contact': form.driverContact,
        'remarks': form.remarks,
      };
      if (form.plantName != null &&
          form.plantName!.trim().isNotEmpty &&
          form.plantName != '') {
        // print('form.plantName....:${form.plantName}');
        requestBody['plant_name'] = form.plantName;
      }
      final config = RequestConfig(
        url: Urls.createVehicleReporting,
        parser: (json) {
          final data =
              json['message']['data']['linked_transporter_confirmation']
                  as String;
          return Pair(data, '');
        },
        body: jsonEncode(requestBody),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );

      $logger.devLog('requestConfig.....$config');

      final response = await post(config);
      $logger.devLog('response.........$response');

      return response.processAsync((r) async {
        return right(r.data!);
      });
    });
  }

  @override
  AsyncValueOf<Pair<String, String>> submitVehicleReporting(
    VehicleReportingForm form,
  ) async {
    final formattedTime =
        form.arrivalTime != null
            ? DateFormat('HH:mm').format(
              DateFormat('HH:mm:ss').tryParse(form.arrivalTime!) ??
                  DateFormat('HH:mm').parse(form.arrivalTime!),
            )
            : null;
    $logger.devLog('arrtival date repo......${form.arrivalDate}');

    return await executeSafely(() async {
      $logger.devLog('repodate........${form.arrivalDate}');

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
      final Map<String, dynamic> requestBody = {
        'plant_name': form.plantName,
        'name': form.name,
        'linked_transporter_confirmation': form.linkedTransporterConfirmation,
        'arrival_date': form.arrivalDate,
        'arrival_time': formattedTime,
        'driver_id_proof':
            driverIdfrontcompressedBytes == null
                ? null
                : base64Encode(driverIdfrontcompressedBytes),
        'vehicle_number': form.vehicleNumber,
        'vehicle_reporting_entry_vre_date': form.vehicleReportingEntryVreDate,
        'driver_contact': form.driverContact,
        'remarks': form.remarks,
        'status': 'Reported',
      };
      if (form.plantName != null &&
          form.plantName!.trim().isNotEmpty &&
          form.plantName != '') {
        // print('form.plantName....:${form.plantName}');
        requestBody['plant_name'] = form.plantName;
      }
      final config = RequestConfig(
        url: Urls.updateVehicleReporting,
        parser: (json) {
          final data = json['message']['data']['name'] as String;
          return Pair(data, '');
        },
        body: jsonEncode(requestBody),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );

      $logger.devLog('requestConfig.....$config');

      final response = await post(config);
      $logger.devLog(response);

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
      $logger.devLog(response);
      return response.process((r) => right(r.data!));
    });
  }

  @override
  AsyncValueOf<List<TransportConfirmationForm>> fetchLogistics(
    String name,
  ) async {
    return await executeSafely(() async {
      final plantName = user().plantName;
      final filters = <List<dynamic>>[];

      if (plantName != null && plantName.isNotEmpty) {
        filters.add(['plant_name', '=', plantName]);
      }
      filters
        ..add(['docstatus', '=', 1])
        ..add(['status', '=', 'Transporter Confirmed'])
        ..add(['vehicle_reported_loaded', '=', 0]);
      final now = DateTime.now();
      final today = DateFormat('yyyy-MM-dd').format(now);
      final yesterday = DateFormat(
        'yyyy-MM-dd',
      ).format(now.subtract(const Duration(days: 1)));

      filters.add([
        'transporter_confirmation_date',
        'between',
        [yesterday, today],
      ]);

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
          'filters': jsonEncode(filters),
          'limit_start': 0,
          'limit_page_length': 'None',
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

  final String url = Urls.filepath(relativePath);

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return response.bodyBytes;
  } else {
    throw Exception('Failed to load file: ${response.statusCode}');
  }
}
