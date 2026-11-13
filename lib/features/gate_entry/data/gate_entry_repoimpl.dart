import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/auth/model/logged_in_user.dart';
import 'package:shakti_hormann/features/gate_entry/data/gate_entry.repo.dart';
import 'package:shakti_hormann/features/gate_entry/model/attachement.dart';
import 'package:shakti_hormann/features/gate_entry/model/gate_entry_form.dart';
import 'package:shakti_hormann/features/gate_entry/model/gate_number_form.dart';
import 'package:shakti_hormann/features/gate_entry/model/purchase_order.dart';
import 'package:shakti_hormann/features/gate_entry/model/purchase_order_form.dart';

@LazySingleton(as: GateEntryRepo)
class GateEntryRepoimpl extends BaseApiRepository implements GateEntryRepo {
  const GateEntryRepoimpl(super.client);
  @override
  AsyncValueOf<List<GateEntryForm>> fetchEntries(
    int start,
    int? docStatus,
    String? search,
  ) async {
    final filters = <List<dynamic>>[];

    if (docStatus != null) {
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
        final data = json['message'] as List<dynamic>;
        return data.map((e) => GateEntryForm.fromJson(e)).toList();
      },
      reqParams: {
        'filters': jsonEncode(filters),
        'limit_start': start,
        'limit_page_length': 'None',
        'order_by': 'creation desc',
        'doctype': 'Gate Entry',
        'fields': jsonEncode(['*']),
      },
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    $logger.devLog('requestConfig....$requestConfig');

    final response = await get(requestConfig);
    return response.process((r) => right(r.data!));
  }

  @override
  AsyncValueOf<List<AttachementInvoices>> fetchAttachments(
    String gateEntryId,
  ) async {
    return await executeSafely(() async {
      final filters = [
        ['attached_to_doctype', '=', 'Gate Entry'],
        ['attached_to_name', '=', gateEntryId],
        ['attached_to_field', '=', 'vendor_invoice_photo'],
      ];

      final config = RequestConfig(
        url: Urls.getList,
        parser: (json) {
          final data = json['message'] as List<dynamic>;
          return data.map((e) => AttachementInvoices.fromJson(e)).toList();
        },
        reqParams: {
          'doctype': 'File',
          'filters': jsonEncode(filters),
          'fields': jsonEncode([
            'file_url',
            'attached_to_doctype',
            'attached_to_name',
            'attached_to_field',
          ]),
        },
      );

      final response = await get(config);
      $logger.devLog('fetchAttachments response.....$response');
      return response.process((r) => right(r.data!));
    });
  }

  @override
  AsyncValueOf<List<PurchaseOrder>> fetchPurchase(String name) async {
    return await executeSafely(() async {
      final config = RequestConfig(
        url: Urls.getList,

        parser: (json) {
          final data = json['message'];
          final listdata = data as List<dynamic>;
          return listdata.map((e) => PurchaseOrder.fromJson(e)).toList();
        },
        reqParams: {
          'filters': [
            ['parent', '=', name],
          ],
          'limit_start': 0,
          'limit_page_length': 'None',
          'oreder_by': 'creat desc',
          'doctype': 'Gate Entry Lines',
          'parent': 'Gate Entry',
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
  AsyncValueOf<List<PurchaseOrderForm>> fetchPurchaseOrders(String name) async {
    return await executeSafely(() async {
      final plantName = user().plantName;
      final filters = <List<dynamic>>[];

      final users = $sl.get<LoggedInUser>();
      final hasRole = users.roles!.any((r) => r.role == 'Admin Role-SH');

      if (!hasRole && plantName != null && plantName.isNotEmpty) {
        filters.add(['company', '=', plantName]);
      }

      final reqParams = {
        'limit_start': 0,
        'limit_page_length': 'None',
        'order_by': 'creation desc',
        'doctype': 'SAP Purchase Order',
        'fields': jsonEncode(['*']),
        'filters': jsonEncode(filters),
      };

      final config = RequestConfig(
        url: Urls.getList,

        parser: (json) {
          final data = json['message'];
          final listdata = data as List<dynamic>;
          return listdata.map((e) => PurchaseOrderForm.fromJson(e)).toList();
        },

        reqParams: reqParams,

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
  AsyncValueOf<List<GateNumberForm>> fetchGateNumber(String name) async {
    return await executeSafely(() async {
      final config = RequestConfig(
        url: Urls.getList,

        parser: (json) {
          final data = json['message'];
          final listdata = data as List<dynamic>;
          return listdata.map((e) => GateNumberForm.fromJson(e)).toList();
        },
        reqParams: {
          'limit_start': 0,
          'limit_page_length': 'None',
          'order_by': 'creation desc',
          'doctype': 'Gate Unloading Points',
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
  AsyncValueOf<Pair<String, String>> submitGateEntry(GateEntryForm form) async {
    return await executeSafely(() async {
      // Only upload newly picked local files. Existing object-storage URLs are
      // already attached on the Gate Entry doc — re-downloading them often hits
      // 403 and is unnecessary for submit.
      final vehiclefrontcompressedBytes = await _compressLocalOrNull(
        form.vehiclePhotoImg,
      );
      final vehiclebackcompressedBytes = await _compressLocalOrNull(
        form.vehicleBackPhotoImg,
      );
      final vendorInvoiceBase64List = await _compressLocalInvoices(
        form.invoicePhotoImg,
      );

      final Map<String, dynamic> requestBody = {
        'gate_entry_id': form.name,
        'plant_name': form.plantName,
        'purchase_orders': form.purchaseOrder,
        'invoice_amount': form.invoiceAmount,

        'vendor_invoice_date': form.vendorInvoiceDate,

        'gate_entry_date': form.gateEntryDate,
        'vendor_invoice_no': form.vendorInvoiceNo,
        'vehicle_photo':
            vehiclefrontcompressedBytes == null
                ? null
                : base64Encode(vehiclefrontcompressedBytes),
        // null = keep existing attachments; only send new local uploads.
        'vendor_invoice_photo':
            vendorInvoiceBase64List.isEmpty ? null : vendorInvoiceBase64List,

        'vehicle_back_photo':
            vehiclebackcompressedBytes == null
                ? null
                : base64Encode(vehiclebackcompressedBytes),
        'vehicle_no': form.vehicleNo,
        'vendor_invoice_quantity': form.invoiceQuantity,
        'remarks': form.remarks,
        'scan_irn': form.scanIrn,
        'gate_number': form.gateNumber,
      };
      if (form.plantName != null &&
          form.plantName!.trim().isNotEmpty &&
          form.plantName != '') {
        requestBody['plant_name'] = form.plantName;
      }

      final config = RequestConfig(
        url: Urls.submitGateEntry,
        parser: (json) {
          final data = json['message']['message'] as String;
          return Pair(data, '');
        },
        body: jsonEncode(requestBody),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );

      final response = await post(config);
      $logger.devLog('updateresponse.....$config');
      return response.processAsync((r) async {
        return right(Pair(r.data!.first, r.data!.second));
      });
    });
  }

  @override
  AsyncValueOf<Pair<String, String>> createGateEntry(GateEntryForm form) async {
    final formJson = form.toJson();

    formJson['status'] = 'Draft';

    $logger.info('form.....:$form');

    final vehiclefrontcompressedBytes = await _compressLocalOrNull(
      form.vehiclePhotoImg,
    );
    final vehiclebackcompressedBytes = await _compressLocalOrNull(
      form.vehicleBackPhotoImg,
    );
    final vendorInvoiceBase64List = await _compressLocalInvoices(
      form.invoicePhotoImg,
    );

    final Map<String, dynamic> requestBody = {
      'plant_name': form.plantName,
      'purchase_orders': form.purchaseOrder,
      'invoice_amount': form.invoiceAmount,
      'vendor_invoice_date': form.vendorInvoiceDate,
      'gate_entry_date': form.gateEntryDate,
      'vendor_invoice_no': form.vendorInvoiceNo,
      'vehicle_photo':
          vehiclefrontcompressedBytes == null
              ? null
              : base64Encode(vehiclefrontcompressedBytes),
      'vendor_invoice_photo':
          vendorInvoiceBase64List.isEmpty ? null : vendorInvoiceBase64List,

      'vehicle_back_photo':
          vehiclebackcompressedBytes == null
              ? null
              : base64Encode(vehiclebackcompressedBytes),
      'vehicle_no': form.vehicleNo,
      'vendor_invoice_quantity': form.invoiceQuantity,
      'remarks': form.remarks,
      'scan_irn': form.scanIrn,
      'gate_number': form.gateNumber,
    };

    if (form.plantName != null &&
        form.plantName!.trim().isNotEmpty &&
        form.plantName != '') {
      requestBody['plant_name'] = form.plantName;
    }

    // if (form.plantName != null && form.plantName!.trim().isNotEmpty) {
    //   requestBody['plant_name'] = form.plantName;
    // }

    final config = RequestConfig(
      url: Urls.createGateEntry,
      parser: (json) {
        final msg = json['message']['message'] as String;
        final data = json['message']['data']['name'] as String;
        return Pair(msg, data);
      },

      body: jsonEncode(requestBody),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    $logger.devLog('requestConfig.....$config');

    final response = await post(config);
    return response.processAsync((r) async {
      return right(Pair(r.data!.first, r.data!.second));
    });
  }

  Future<Uint8List?> _compressLocalOrNull(File? file) async {
    if (file == null) return null;
    if (!await file.exists()) return null;
    return FlutterImageCompress.compressWithFile(file.path, quality: 50);
  }

  Future<List<String>> _compressLocalInvoices(List<File>? files) async {
    if (files == null || files.isEmpty) return [];
    final out = <String>[];
    for (final file in files) {
      if (!await file.exists()) continue;
      final compressed = await FlutterImageCompress.compressWithFile(
        file.path,
        quality: 50,
      );
      if (compressed != null) {
        out.add(base64Encode(compressed));
      }
    }
    return out;
  }

  Future<Uint8List?> fetchAndConvertToBase64(String relativePath) async {
    if (relativePath.trim().isEmpty) return null;
    if (p.extension(relativePath).isEmpty) {
      return null;
    }

    final String url = Urls.filepath(relativePath);
    $logger.devLog('fetchAndConvertToBase64 url=$url');

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception(
        'Failed to load file: ${response.statusCode} ($url)',
      );
    }
  }
}

Future<Uint8List?> safeCompress(File file) async {
  if (!file.existsSync()) {
    $logger.error('❌ Image missing before compression: ${file.path}');
    return null;
  }

  return await FlutterImageCompress.compressWithFile(file.path, quality: 50);
}
