import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/features/gate_exit/data/gate_exit_repo.dart';
import 'package:shakti_hormann/features/gate_exit/model/gate%20_exit_form.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/gate_exit/model/sales_invoice_form.dart';

@LazySingleton(as: GateExitRepo)
class GateExitRepoimpl extends BaseApiRepository implements GateExitRepo {
  const GateExitRepoimpl(super.client);

  @override
  AsyncValueOf<List<GateExitForm>> fetchEntries(
    int start,
    int? docStatus,
    String? serach,
  ) async {
    final requestConfig = RequestConfig(
      url: Urls.getList,
      parser: (json) {
        final data = json['message'];
        final listdata = data as List<dynamic>;
        return listdata.map((e) => GateExitForm.fromJson(e)).toList();
      },
      reqParams: {
        if (!(docStatus == null)) ...{
          'filters': [
            ["docstatus", "=", docStatus],
            if (serach.containsValidValue) ...{
              ["name", "Like", "%$serach"],
            },
          ],
        },
        'limit_start': start,
        'limit': 20,
        'oreder_by': 'create desc',
        'doctype': 'Gate Exit',
        'fields': ["*"],
      },
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    $logger.devLog("requestConfig....$requestConfig");
    final response = await get(requestConfig);
    return response.process((r) => right(r.data!));
  }

  @override
  AsyncValueOf<Pair<String, String>> submitGateExit(GateExitForm form) async {
    return await executeSafely(() async {
      final config = RequestConfig(
        url: Urls.submitGateEntry,
        parser: (json) {
          final data = json['message']['message'] as String;
          return Pair(data, '');
        },
        body: jsonEncode({
          "gate_entry_id": form.name, 
        }),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );

      final response = await post(config);
      return response.processAsync((r) async {
        return right(Pair(r.data!.first, r.data!.second));
      });
    });
  }


  @override
  AsyncValueOf<Pair<String, String>> createGateExit(GateExitForm form) async {
    final formJson = form.toJson();

    $logger.devLog('form....$form');

    formJson['status'] = 'Draft';
    $logger.devLog('formJson.....$formJson');

    final finalMap = {...removeNullValues(form.toJson()), ...formJson};

    final config = RequestConfig(
      url: Urls.createGateEntry,
      parser: (json) {
        final data = json['message']['data']['name'] as String;
        return Pair(data, '');
      },

      body: jsonEncode({
        "plant_name": form.plantName,
        // "po_number":"PUR-ORD-2025-00002",
        "vehicle_number": form.vehicleNo,
        "invoice_date": form.creationDate,
        "entry_date": form.gateEntryDate,
        "vendor_invoice_no": form.salesInvoice,
      }),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    $logger.devLog('requestConfig.....$config');

    final response = await post(config);
    $logger.devLog('response.....$response');
    return response.processAsync((r) async {
      return right(Pair(r.data!.first, r.data!.second));
    });
  }

  @override
  AsyncValueOf<List<SalesInvoiceForm>> fetchSalesInvoice(String name) async {
    return await executeSafely(() async {
      final config = RequestConfig(
        url: Urls.getList,
        parser: (json) {
          final data = json['message'];
          final listdata = data as List<dynamic>;
          return listdata.map((e) => SalesInvoiceForm.fromJson(e)).toList();
        },
        reqParams: {
          'limit': 20,
          'oreder_by': 'create desc',
          'doctype': 'Sales Invoice',
          'fields': ["*"],
        },
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );
      $logger.devLog('salesinvoice.....$config');
      final response = await get(config);
      $logger.devLog('response.....$response');
      return response.processAsync((r) async {
        return right((r.data!));
      });
    });
  }



}
