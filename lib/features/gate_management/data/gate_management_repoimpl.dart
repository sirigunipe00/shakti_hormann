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
import 'package:shakti_hormann/features/gate_management/data/gate_management_repo.dart';
import 'package:shakti_hormann/features/gate_management/model/gate_management_form.dart';

@LazySingleton(as: GateManagementRepo)
class GateManagementRepoimpl extends BaseApiRepository
    implements GateManagementRepo {
  const GateManagementRepoimpl(super.client);
  @override
  AsyncValueOf<List<GateManagementForm>> fetchGateManagements(
    int start,
    int? docStatus,
    String? search,
  ) async {
    final filters = <List<dynamic>>[];

    if (docStatus != null && docStatus != 2) {
      filters.add(['docstatus', '=', docStatus]);
    }

    if (search != null && search.isNotEmpty) {
      filters.add(['name', 'like', '%$search%']);
    }
    final plantName = user().plantName;

    if (plantName != null && plantName.isNotEmpty) {
      filters.add(['plant_name', '=', plantName]);
    }
    final requestConfig = RequestConfig(
      url: Urls.getList,
      parser: (json) {
        final data = json['message'] as List<dynamic>;
        return data.map((e) => GateManagementForm.fromJson(e)).toList();
      },
      reqParams: {
        'filters': jsonEncode(filters),
        'limit_start': start,
        'limit_page_length': 'None',
        'order_by': 'creation desc',
        'doctype': 'Gate Management',
        'fields': jsonEncode(['*']),
      },
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    $logger.devLog('requestConfig....$requestConfig');

    final response = await get(requestConfig);
    return response.process((r) => right(r.data!));
  }

  @override
  AsyncValueOf<Pair<String, String>> createGateManagement(
    GateManagementForm form,
  ) async {
    final today = DateFormat('dd-MM-yyyy').format(DateTime.now());
    final time = DateTime.now();

    final formJson = form.toJson();

    formJson['status'] = 'Draft';

    Uint8List? vehiclefrontcompressedBytes;
    Uint8List? vehiclebackcompressedBytes;
    Uint8List? documentcompressedBytes;

    $logger.info('form.....:$form');

    if (form.vehiclePhotoImg != null) {
      final filePath = form.vehiclePhotoImg!.path;
      vehiclefrontcompressedBytes = await FlutterImageCompress.compressWithFile(
        filePath,
        quality: 50,
      );
    } else if (form.vehiclePhoto != null) {
      vehiclefrontcompressedBytes = await fetchAndConvertToBase64(
        form.vehiclePhoto ?? '',
      );
    }

    if (form.backPhotoImg != null) {
      final filePath = form.backPhotoImg!.path;
      vehiclebackcompressedBytes = await FlutterImageCompress.compressWithFile(
        filePath,
        quality: 50,
      );
    } else if (form.backPhoto != null) {
      vehiclebackcompressedBytes = await fetchAndConvertToBase64(
        form.backPhoto ?? '',
      );
    }

    if (form.documentPhotoImg != null) {
      final filePath = form.documentPhotoImg!.path;
      documentcompressedBytes = await FlutterImageCompress.compressWithFile(
        filePath,
        quality: 50,
      );
    } else if (form.documentPhoto != null) {
      documentcompressedBytes = await fetchAndConvertToBase64(
        form.documentPhoto ?? '',
      );
    }

    final Map<String, dynamic> requestBody = {
      'plant_name': user().plantName,
      'request_type': form.requestType,
      'purpose_remarks': form.remarks,
      'gate_entry_date': 
    (form.gateeEntrydate != null && form.gateeEntrydate!.trim().isNotEmpty) 
        ? form.gateeEntrydate 
        : today,
      'gate_entry_time': (form.gateEntryTime != null && form.gateEntryTime!.trim().isNotEmpty) 
      ? form.gateEntryTime : time,
      // 'gate_exit_date': form.gateExitdate,
    // (form.gateExitdate != null && form.gateExitdate!.trim().isNotEmpty) 
    //     ? form.gateExitdate 
    //     : today,
      // 'gate_exit_time': form.gateExitTime,
      'vehicle_no': form.vehicleNo,
      'vehicle_type': form.vehicleType,
      'vendor_invoice_no': form.vendorInvoiceNo,
      'driver_name': form.driverName,
      'driver_mobile': form.driverMobileNo,
      'company_vendor_name': form.vendorName,

      'vehicle_photo':
          vehiclefrontcompressedBytes == null
              ? null
              : base64Encode(vehiclefrontcompressedBytes),
      'document_photos':
          documentcompressedBytes == null
              ? null
              : base64Encode(documentcompressedBytes),
      'vehicle_back_photo':
          vehiclebackcompressedBytes == null
              ? null
              : base64Encode(vehiclebackcompressedBytes),
      'security_remarks': form.securityRemarks,
    };

    if (form.plantName != null &&
        form.plantName!.trim().isNotEmpty &&
        form.plantName != '') {
      print('form.plantName....:${form.plantName}');
      requestBody['plant_name'] = form.plantName;
    }

    // if (form.plantName != null && form.plantName!.trim().isNotEmpty) {
    //   requestBody['plant_name'] = form.plantName;
    // }

    final config = RequestConfig(
      url: Urls.creategateManagement,
      parser: (json) {
        final data = json['message']['data']['name'] as String;
        return Pair(data, '');
      },

      body: jsonEncode(requestBody),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    $logger.devLog('requestConfig.....$config');

    final response = await post(config);
    $logger.devLog('response..........$response');
    return response.processAsync((r) async {
      return right(Pair(r.data!.first, r.data!.second));
    });
  }

  @override
  AsyncValueOf<Pair<String, String>> submitGateManagement(
    GateManagementForm form,
  ) async {
    final today = DateFormat('dd-MM-yyyy').format(DateTime.now());
    final time = DateTime.now();
    final formJson = form.toJson();

    formJson['status'] = 'Draft';

    Uint8List? vehiclefrontcompressedBytes;
    Uint8List? vehiclebackcompressedBytes;
    Uint8List? documentcompressedBytes;

    $logger.info('form.....:$form');

    if (form.vehiclePhotoImg != null) {
      final filePath = form.vehiclePhotoImg!.path;
      vehiclefrontcompressedBytes = await FlutterImageCompress.compressWithFile(
        filePath,
        quality: 50,
      );
    } else if (form.vehiclePhoto != null) {
      vehiclefrontcompressedBytes = await fetchAndConvertToBase64(
        form.vehiclePhoto ?? '',
      );
    }

    if (form.backPhotoImg != null) {
      final filePath = form.backPhotoImg!.path;
      vehiclebackcompressedBytes = await FlutterImageCompress.compressWithFile(
        filePath,
        quality: 50,
      );
    } else if (form.backPhoto != null) {
      vehiclebackcompressedBytes = await fetchAndConvertToBase64(
        form.backPhoto ?? '',
      );
    }

    if (form.documentPhotoImg != null) {
      final filePath = form.documentPhotoImg!.path;
      documentcompressedBytes = await FlutterImageCompress.compressWithFile(
        filePath,
        quality: 50,
      );
    } else if (form.documentPhoto != null) {
      documentcompressedBytes = await fetchAndConvertToBase64(
        form.documentPhoto ?? '',
      );
    }
      String? formattedgateentryDate;
      String? gateExitFormatedate;
     

       final ddMMyyyyRegex = RegExp(r'^\d{2}-\d{2}-\d{4}$');

      if (ddMMyyyyRegex.hasMatch(form.gateeEntrydate!)) {
        formattedgateentryDate = form.gateeEntrydate!;
      } else {
        final inputFormat = DateFormat('yyyy-MM-dd');
        final outputFormat = DateFormat('dd-MM-yyyy');
        final date = inputFormat.parse(form.gateeEntrydate!);
        formattedgateentryDate = outputFormat.format(date);
      }
        //  final gateexitddMMyyyyRegex = RegExp(r'^\d{2}-\d{2}-\d{4}$');

      // if (gateexitddMMyyyyRegex.hasMatch(form.gateExitdate!)) {
      //   gateExitFormatedate = form.gateExitdate!;
      // } else {
      //   final inputFormat = DateFormat('yyyy-MM-dd');
      //   final outputFormat = DateFormat('dd-MM-yyyy');
      //   final date = inputFormat.parse(form.gateExitdate!);
      //   gateExitFormatedate = outputFormat.format(date);
      // }
      if (form.gateExitdate != null && form.gateExitdate!.trim().isNotEmpty) {
  final ddMMyyyyRegex = RegExp(r'^\d{2}-\d{2}-\d{4}$');

  if (ddMMyyyyRegex.hasMatch(form.gateExitdate!)) {
    gateExitFormatedate = form.gateExitdate!;
  } else {
    final inputFormat = DateFormat('yyyy-MM-dd');
    final outputFormat = DateFormat('dd-MM-yyyy');
    final date = inputFormat.parse(form.gateExitdate!);
    gateExitFormatedate = outputFormat.format(date);
  }
}


    final Map<String, dynamic> requestBody = {
      'plant_name': user().plantName,
      'gate_mgmt_id': form.name,
      'request_type': form.requestType,
      'purpose_remarks': form.remarks,
      'gate_entry_date': formattedgateentryDate,
      'gate_entry_time': form.gateEntryTime,
      'gate_exit_date':   
      (form.gateExitdate != null && form.gateExitdate!.trim().isNotEmpty) 
        ? form.gateExitdate 
        : today,
      'gate_exit_time': form.gateExitTime,
      'vehicle_no': form.vehicleNo,
      'vehicle_type': form.vehicleType,
      'vendor_invoice_no': form.vendorInvoiceNo,
      'driver_name': form.driverName,
      'driver_mobile': form.driverMobileNo,
      'company_vendor_name': form.vendorName,

      'vehicle_photo':
          vehiclefrontcompressedBytes == null
              ? null
              : base64Encode(vehiclefrontcompressedBytes),
      'document_photos':
          documentcompressedBytes == null
              ? null
              : base64Encode(documentcompressedBytes),
      'vehicle_back_photo':
          vehiclebackcompressedBytes == null
              ? null
              : base64Encode(vehiclebackcompressedBytes),
      'security_remarks': form.securityRemarks,
    };

    if (form.plantName != null &&
        form.plantName!.trim().isNotEmpty &&
        form.plantName != '') {
      print('form.plantName....:${form.plantName}');
      requestBody['plant_name'] = form.plantName;
    }

    // if (form.plantName != null && form.plantName!.trim().isNotEmpty) {
    //   requestBody['plant_name'] = form.plantName;
    // }

    final config = RequestConfig(
      url: Urls.submitGateManagement,
      parser: (json) {
        final data = json['message']['message'] as String;
        return Pair(data, '');
      },

      body: jsonEncode(requestBody),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    $logger.devLog('requestConfig.....$config');

    final response = await post(config);
    $logger.devLog('response..........$response');
    return response.processAsync((r) async {
      return right(Pair(r.data!.first, r.data!.second));
    });
  }
  //   @override
  // AsyncValueOf<Pair<String, String>> submitGateManagement(
  //   GateManagementForm form,
  // ) async {
  //   final formJson = form.toJson();

  //   formJson['status'] = 'Draft';

  //   Uint8List? vehiclefrontcompressedBytes;
  //   Uint8List? vehiclebackcompressedBytes;
  //   Uint8List? documentcompressedBytes;

  //   $logger.info('form.....:$form');

  //   if (form.vehiclePhotoImg != null) {
  //     final filePath = form.vehiclePhotoImg!.path;
  //     vehiclefrontcompressedBytes = await FlutterImageCompress.compressWithFile(
  //       filePath,
  //       quality: 50,
  //     );
  //   } else if (form.vehiclePhoto != null) {
  //     vehiclefrontcompressedBytes = await fetchAndConvertToBase64(
  //       form.vehiclePhoto ?? '',
  //     );
  //   }

  //   if (form.backPhotoImg != null) {
  //     final filePath = form.backPhotoImg!.path;
  //     vehiclebackcompressedBytes = await FlutterImageCompress.compressWithFile(
  //       filePath,
  //       quality: 50,
  //     );
  //   } else if (form.backPhoto != null) {
  //     vehiclebackcompressedBytes = await fetchAndConvertToBase64(
  //       form.backPhoto ?? '',
  //     );
  //   }

  //   if (form.documentPhotoImg != null) {
  //     final filePath = form.documentPhotoImg!.path;
  //     documentcompressedBytes = await FlutterImageCompress.compressWithFile(
  //       filePath,
  //       quality: 50,
  //     );
  //   } else if (form.documentPhoto != null) {
  //     documentcompressedBytes = await fetchAndConvertToBase64(
  //       form.documentPhoto ?? '',
  //     );
  //   }

  //   final Map<String, dynamic> requestBody = {
  //     'plant_name': user().plantName,
  //     'gate_mgmt_id': form.name,
  //     'request_type': form.requestType,
  //     'purpose_remarks': form.remarks,
  //     'gate_entry_date': form.gateeEntrydate,
  //     'gate_entry_time': form.gateEntryTime,
  //     'gate_exit_date': form.gateExitdate,
  //     'gate_exit_time': form.gateExitTime,
  //     'vehicle_no': form.vehicleNo,
  //     'vehicle_type': form.vehicleType,
  //     'vendor_invoice_no': form.vendorInvoiceNo,
  //     'driver_name': form.driverName,
  //     'driver_mobile': form.driverMobileNo,
  //     'company_vendor_name': form.vendorName,

  //     'vehicle_photo':
  //         vehiclefrontcompressedBytes == null
  //             ? null
  //             : base64Encode(vehiclefrontcompressedBytes),
  //     'document_photos':
  //         documentcompressedBytes == null
  //             ? null
  //             : base64Encode(documentcompressedBytes),
  //     'vehicle_back_photo':
  //         vehiclebackcompressedBytes == null
  //             ? null
  //             : base64Encode(vehiclebackcompressedBytes),
  //     'security_remarks': form.securityRemarks,
  //   };

  //   if (form.plantName != null &&
  //       form.plantName!.trim().isNotEmpty &&
  //       form.plantName != '') {
  //     print('form.plantName....:${form.plantName}');
  //     requestBody['plant_name'] = form.plantName;
  //   }

  //   // if (form.plantName != null && form.plantName!.trim().isNotEmpty) {
  //   //   requestBody['plant_name'] = form.plantName;
  //   // }

  //   final config = RequestConfig(
  //     url: Urls.submitGateManagement,
  //     parser: (json) {
  //       final data = json['message']['message'] as String;
  //       return Pair(data, '');
  //     },

  //     body: jsonEncode(requestBody),
  //     headers: {HttpHeaders.contentTypeHeader: 'application/json'},
  //   );

  //   $logger.devLog('requestConfig.....$config');

  //   final response = await post(config);
  //   $logger.devLog('response..........$response');
  //   return response.processAsync((r) async {
  //     return right(Pair(r.data!.first, r.data!.second));
  //   });
  // }

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
}
