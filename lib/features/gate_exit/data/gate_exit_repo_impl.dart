import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:shakti_hormann/features/gate_exit/data/gate_exit_repo.dart';
import 'package:shakti_hormann/features/gate_exit/model/gate_exit_form.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/gate_exit/model/sales_invoice_form.dart';

@LazySingleton(as: GateExitRepo)
class GateExitRepoimpl extends BaseApiRepository implements GateExitRepo {
  const GateExitRepoimpl(super.client);
  @override
  AsyncValueOf<List<GateExitForm>> fetchEntries(
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
        final data = json['message'];
        final listData = data as List<dynamic>;
        return listData.map((e) => GateExitForm.fromJson(e)).toList();
      },
      reqParams: {
        'filters': jsonEncode(filters),
        'limit_start': start,
        'limit_page_length': 'None',
        'order_by': 'creation desc',
        'doctype': 'Gate Exit',
        'fields': jsonEncode(['*']),
      },
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    $logger.devLog('requestConfig....$requestConfig');

    final response = await get(requestConfig);
    return response.process((r) => right(r.data!));
  }

  @override
  AsyncValueOf<Pair<String, String>> submitGateExit(GateExitForm form) async {
    return await executeSafely(() async {
      Uint8List? vehiclefrontcompressedBytes;
      Uint8List? vehiclebackcompressedBytes;

      if (form.vehiclePhotoImg != null) {
        final filePath = form.vehiclePhotoImg!.path;
        vehiclefrontcompressedBytes =
            await FlutterImageCompress.compressWithFile(filePath, quality: 50);
      } else if (form.vehiclePhoto != null) {
        vehiclefrontcompressedBytes = await fetchAndConvertToBase64(
          form.vehiclePhoto ?? '',
        );
      }

      if (form.vehicleBackPhotoImg != null) {
        final filePath = form.vehicleBackPhotoImg!.path;
        vehiclebackcompressedBytes =
            await FlutterImageCompress.compressWithFile(filePath, quality: 50);
      } else if (form.vehicleBackPhoto != null) {
        vehiclebackcompressedBytes = await fetchAndConvertToBase64(
          form.vehicleBackPhoto ?? '',
        );
      }

         final cleanedJson = removeNullValues(form.toJson());
    cleanedJson['status'] = 'Draft';
     final Map<String, dynamic> requestBody = {
         'gate_exit_id': form.name,
         'plant_name': form.plantName,
        
        'sales_invoice': form.salesInvoice,
        'vehicle_no': form.vehicleNo,
        'vehicle_back_photo':
            vehiclebackcompressedBytes == null
                ? null
                : base64Encode(vehiclebackcompressedBytes),
        'vehicle_photo':
            vehiclefrontcompressedBytes == null
                ? null
                : base64Encode(vehiclefrontcompressedBytes),
        'gate_entry_date': form.gateEntryDate,
        'remarks': form.remarks,
        'by_mobile_app': 1,
        
      };
        if (form.plantName != null && form.plantName!.trim().isNotEmpty && form.plantName != '') {
      print('form.plantName....:${form.plantName}');
      requestBody['plant_name'] = form.plantName;
    }

      final config = RequestConfig(
        url: Urls.submitGateExit,
        parser: (json) {
          final data = json['message']['message'] as String;
          return Pair(data, '');
        },

        body: jsonEncode(requestBody),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );
      $logger.devLog('submit .....$config');
      final response = await post(config);
      return response.processAsync((r) async {
        return right(Pair(r.data!.first, r.data!.second));
      });
    });
  }

  @override
  AsyncValueOf<Pair<String, String>> createGateExit(GateExitForm form) async {
    final formJson = form.toJson();

    formJson['status'] = 'Draft';
    Uint8List? vehiclefrontcompressedBytes;
    Uint8List? vehiclebackcompressedBytes;

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

    if (form.vehicleBackPhotoImg != null) {
      final filePath = form.vehicleBackPhotoImg!.path;
      vehiclebackcompressedBytes = await FlutterImageCompress.compressWithFile(
        filePath,
        quality: 50,
      );
    } else if (form.vehicleBackPhoto != null) {
      vehiclebackcompressedBytes = await fetchAndConvertToBase64(
        form.vehicleBackPhoto ?? '',
      );
    }

    final cleanedJson = removeNullValues(form.toJson());
    cleanedJson['status'] = 'Draft';
     final Map<String, dynamic> requestBody = {
         'plant_name': form.plantName,
        'sales_invoice': form.salesInvoice,
        'vehicle_no': form.vehicleNo,
        'vehicle_back_photo':
            vehiclebackcompressedBytes == null
                ? null
                : base64Encode(vehiclebackcompressedBytes),
        'vehicle_photo':
            vehiclefrontcompressedBytes == null
                ? null
                : base64Encode(vehiclefrontcompressedBytes),
        'gate_entry_date': form.gateEntryDate,
        'remarks': form.remarks,
        'by_mobile_app': 1,
        
      };
        if (form.plantName != null && form.plantName!.trim().isNotEmpty && form.plantName != '') {
      print('form.plantName....:${form.plantName}');
      requestBody['plant_name'] = form.plantName;
    }

    final config = RequestConfig(
      url: Urls.createGateExit,
      parser: (json) {
        final data = json['message']['data']['name'] as String;
        return Pair(data, '');
      },
     

      body: jsonEncode(requestBody),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    final response = await post(config);
    $logger.devLog('response.....$config');
    return response.processAsync((r) async {
      return right(Pair(r.data!.first, r.data!.second));
    });
  }

  @override
  AsyncValueOf<List<SalesInvoiceForm>> fetchSalesInvoice(String name) async {
    return await executeSafely(() async {
      final plantName = user().plantName;

      final reqParams = {
        'filters': [
          ['gate_exit_created', '=', '0'],
          if (plantName != null && plantName.isNotEmpty)
            ['company', '=', plantName],
        ],
        'limit_page_length': 'None',
        'order_by': 'creation desc',
        'doctype': 'SAP Sales Invoice',
        'fields': ['*'],
      };

      final config = RequestConfig(
        url: Urls.getList,

        parser: (json) {
          final data = json['message'];
          final listdata = data as List<dynamic>;
          return listdata.map((e) => SalesInvoiceForm.fromJson(e)).toList();
        },
        reqParams: reqParams,

        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );
      $logger.devLog('..............$config');
      final response = await get(config);
  
      return response.processAsync((r) async {
        return right((r.data!));
      });
    });
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
}
