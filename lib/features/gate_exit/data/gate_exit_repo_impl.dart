import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/features/auth/model/logged_in_user.dart';
import 'package:shakti_hormann/features/gate_exit/data/gate_exit_repo.dart';
import 'package:shakti_hormann/features/gate_exit/model/gate_exit_form.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/gate_exit/model/sales_invoice.dart';
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

 
     final users = $sl.get<LoggedInUser>();
final hasRole = users.roles!.any((r) => r.role == 'Admin Role-SH');

final plantName = user().plantName;
    if (!hasRole && plantName != null && plantName.isNotEmpty) {
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
  AsyncValueOf<List<SalesInvoice>> fetchSales(String name) async {
    return await executeSafely(() async {
      final config = RequestConfig(
        url: Urls.getList,

        parser: (json) {
          final data = json['message'];
          final listdata = data as List<dynamic>;
          return listdata.map((e) => SalesInvoice.fromJson(e)).toList();
        },
        reqParams: {
          'filters': [
            ['parent', '=', name],
          ],
          'limit_start': 0,
          'limit_page_length': 'None',
          'order_by': 'creation desc',
          'doctype': 'Gate Exit Lines',
          'parent': 'Gate Exit',
          'fields': ['*'],
        },

        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );

      final response = await get(config);
      $logger.devLog('response.....$response');
      return response.processAsync((r) async {
        return right((r.data!));
      });
    });
  }

  @override
  AsyncValueOf<Pair<String, String>> submitGateExit(GateExitForm form) async {
    return await executeSafely(() async {
      // Only upload newly picked local files. Existing object-storage URLs are
      // already attached on the Gate Exit doc — re-downloading them often hits
      // 404/403 and masks real validation errors.
      final vehiclefrontcompressedBytes = await _compressLocalOrNull(
        form.vehiclePhotoImg,
      );
      final vehiclebackcompressedBytes = await _compressLocalOrNull(
        form.vehicleBackPhotoImg,
      );

      final Map<String, dynamic> requestBody = {
        'gate_exit_id': form.name,
        'plant_name': form.plantName,
        'sales_invoices': form.salesInvoices,
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
      if (form.plantName != null &&
          form.plantName!.trim().isNotEmpty &&
          form.plantName != '') {
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
    return await executeSafely(() async {
      final vehiclefrontcompressedBytes = await _compressLocalOrNull(
        form.vehiclePhotoImg,
      );
      final vehiclebackcompressedBytes = await _compressLocalOrNull(
        form.vehicleBackPhotoImg,
      );

      final Map<String, dynamic> requestBody = {
        'plant_name': form.plantName,
        'sales_invoices': form.salesInvoices,
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
      if (form.plantName != null &&
          form.plantName!.trim().isNotEmpty &&
          form.plantName != '') {
        requestBody['plant_name'] = form.plantName;
      }

      final config = RequestConfig(
        url: Urls.createGateExit,
        parser: (json) {
          final data = json['message']['message'] as String;
          final name = json['message']['data']['name'] as String;
          return Pair(name, data);
        },
        body: jsonEncode(requestBody),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );

      final response = await post(config);
      $logger.devLog('response.....$config');
      return response.processAsync((r) async {
        return right(Pair(r.data!.first, r.data!.second));
      });
    });
  }

  Future<Uint8List?> _compressLocalOrNull(File? file) async {
    if (file == null) return null;
    if (!await file.exists()) return null;
    return FlutterImageCompress.compressWithFile(file.path, quality: 50);
  }

  @override
  AsyncValueOf<List<SalesInvoiceForm>> fetchSalesInvoice(String name) async {
    return await executeSafely(() async {
     final users = $sl.get<LoggedInUser>();
final hasRole = users.roles!.any((r) => r.role == 'Admin Role-SH');

      final plantName = user().plantName;

      final reqParams = {
        'filters': [
          ['gate_exit_created', '=', '0'],
          if (!hasRole && plantName != null && plantName.isNotEmpty)
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

}
