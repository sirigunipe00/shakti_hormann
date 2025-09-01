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
import 'package:shakti_hormann/features/gate_entry/data/gate_entry.repo.dart';
import 'package:shakti_hormann/features/gate_entry/model/gate_entry_form.dart';
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

    if (docStatus != null && docStatus != 2) {
      filters.add(['docstatus', '=', docStatus]);
    }

    if (search != null && search.isNotEmpty) {
      filters.add(['name', 'like', '%$search%']);
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
        'limit': 20,

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
  AsyncValueOf<List<PurchaseOrderForm>> fetchPurchaseOrders(String name) async {
    return await executeSafely(() async {
      final config = RequestConfig(
        url: Urls.getList,

        parser: (json) {
          final data = json['message'];
          final listdata = data as List<dynamic>;
          return listdata.map((e) => PurchaseOrderForm.fromJson(e)).toList();
        },
        reqParams: {
          'limit': 20,
          'oreder_by': 'creat desc',
          'doctype': 'SAP Purchase Order',
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
      Uint8List? vehiclefrontcompressedBytes;
      Uint8List? vehiclebackcompressedBytes;
      Uint8List? invocecompressedBytes;

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
        vehiclefrontcompressedBytes = await fetchAndConvertToBase64(
          form.vehicleBackPhoto ?? '',
        );
      }

      if (form.invoicePhotoImg != null) {
        final filePath = form.invoicePhotoImg!.path;
        invocecompressedBytes = await FlutterImageCompress.compressWithFile(
          filePath,
          quality: 50,
        );
      } else if (form.invoicePhoto != null) {
        vehiclefrontcompressedBytes = await fetchAndConvertToBase64(
          form.invoicePhoto ?? '',
        );
      }

      final config = RequestConfig(
        url: Urls.submitGateEntry,
        parser: (json) {
          final data = json['message']['message'] as String;
          return Pair(data, '');
        },
        body: jsonEncode({
          'gate_entry_id': form.name,
          'plant_name': form.plantName,
          'purchase_order': form.purchaseOrder,
          'invoice_amount': form.invoiceAmount,
          'vendor_invoice_date':
              form.vendorInvoiceDate != null
                  ? DateFormat('yyyy-MM-dd').format(
                    DateFormat('dd-MM-yyyy').parse(form.vendorInvoiceDate!),
                  )
                  : null,
          'gate_entry_date': form.gateEntryDate != null
                  ? DateFormat('yyyy-MM-dd').format(
                    DateFormat('dd-MM-yyyy').parse(form.gateEntryDate!),
                  )
                  : null,
          'vendor_invoice_no': form.vendorInvoiceNo,
          'vehicle_photo':
              vehiclefrontcompressedBytes == null
                  ? null
                  : base64Encode(vehiclefrontcompressedBytes),
          'vendor_invoice_photo':
              invocecompressedBytes == null
                  ? null
                  : base64Encode(invocecompressedBytes),
          'vehicle_back_photo':
              vehiclebackcompressedBytes == null
                  ? null
                  : base64Encode(vehiclebackcompressedBytes),
          'vehicle_no': form.vehicleNo,
          'vendor_invoice_quantity': form.invoiceQuantity,
          'remarks': form.remarks,
          'scan_irn': form.scanIrn,
        }),
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

    Uint8List? vehiclefrontcompressedBytes;
    Uint8List? vehiclebackcompressedBytes;
    Uint8List? invocecompressedBytes;

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
      vehiclefrontcompressedBytes = await fetchAndConvertToBase64(
        form.vehicleBackPhoto ?? '',
      );
    }

    if (form.invoicePhotoImg != null) {
      final filePath = form.invoicePhotoImg!.path;
      invocecompressedBytes = await FlutterImageCompress.compressWithFile(
        filePath,
        quality: 50,
      );
    } else if (form.invoicePhoto != null) {
      vehiclefrontcompressedBytes = await fetchAndConvertToBase64(
        form.invoicePhoto ?? '',
      );
    }

    final config = RequestConfig(
      url: Urls.createGateEntry,
      parser: (json) {
        final data = json['message']['data']['name'] as String;
        return Pair(data, '');
      },

      body: jsonEncode({
        'plant_name': form.plantName,
        'purchase_order': form.purchaseOrder,
        'invoice_amount': form.invoiceAmount,
        'vendor_invoice_date': form.vendorInvoiceDate,
        'gate_entry_date': form.gateEntryDate,
        'vendor_invoice_no': form.vendorInvoiceNo,
        'vehicle_photo':
            vehiclefrontcompressedBytes == null
                ? null
                : base64Encode(vehiclefrontcompressedBytes),
        'vendor_invoice_photo':
            invocecompressedBytes == null
                ? null
                : base64Encode(invocecompressedBytes),
        'vehicle_back_photo':
            vehiclebackcompressedBytes == null
                ? null
                : base64Encode(vehiclebackcompressedBytes),
        'vehicle_no': form.vehicleNo,
        'vendor_invoice_quantity': form.invoiceQuantity,
        'remarks': form.remarks,
        'scan_irn': form.scanIrn,
      }),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    $logger.devLog('requestConfig.....$config');

    final response = await post(config);
    return response.processAsync((r) async {
      return right(Pair(r.data!.first, r.data!.second));
    });
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
}
