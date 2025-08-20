import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
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
        // 'limit_page_length': limit,
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
          'doctype': 'Purchase Order',
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
      String? formatDateToDDMMYYYY(String? date) {
        final parsedDate = DateTime.parse(date!);
        final day = parsedDate.day.toString().padLeft(2, '0');
        final month = parsedDate.month.toString().padLeft(2, '0');
        final year = parsedDate.year.toString();
        return '$day-$month-$year';
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
          'vendor_invoice_date': formatDateToDDMMYYYY(form.vendorInvoiceDate),
          'gate_entry_date': formatDateToDDMMYYYY(form.gateEntryDate),
          'vendor_invoice_no': form.vendorInvoiceNo,
          'vehicle_photo': form.vehiclePhoto,
          'vendor_invoice_photo': form.invoicePhoto,
          'vehicle_back_photo': form.vehicleBackPhoto,
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

    String? formatDateToDDMMYYYY(String? date) {
      final parsedDate = DateTime.parse(date!);
      final day = parsedDate.day.toString().padLeft(2, '0');
      final month = parsedDate.month.toString().padLeft(2, '0');
      final year = parsedDate.year.toString();
      return '$day-$month-$year';
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
        'vendor_invoice_date': formatDateToDDMMYYYY(form.vendorInvoiceDate),
        'gate_entry_date': formatDateToDDMMYYYY(form.gateEntryDate),
        'vendor_invoice_no': form.vendorInvoiceNo,
        'vehicle_photo': form.vehiclePhoto,
        'vendor_invoice_photo': form.invoicePhoto,
        'vehicle_back_photo': form.vehicleBackPhoto,
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
}
