import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/gate_entry/data/gate_entry.repo.dart';
import 'package:shakti_hormann/features/gate_entry/model/gate_entry_form.dart';
import 'package:shakti_hormann/features/gate_entry/model/receiver_name_form.dart';

@LazySingleton(as: GateEntryRepo)
class GateEntryRepoimpl extends BaseApiRepository implements GateEntryRepo {
  const GateEntryRepoimpl(super.client);

  @override
  AsyncValueOf<List<GateEntryForm>> fetchEntries(
    int start,
    int? docStatus,
    String? serach,
  ) async {
    final requestConfig = RequestConfig(
      url: Urls.getList,
      parser: (json) {
        final data = json['message'];
        final listdata = data as List<dynamic>;
        return listdata.map((e) => GateEntryForm.fromJson(e)).toList();
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
        'doctype': 'Gate Entry',
        'fields': ["*"],
      },
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    $logger.devLog("requestConfig....$requestConfig");
    final response = await get(requestConfig);
    return response.process((r) => right(r.data!));
  }

  @override
  AsyncValueOf<List<String>> fetchCompanyList() async {
    return await executeSafely(() async {
      final config = RequestConfig(
        url: Urls.companyName,
        reqParams: {
          'fields': ReceiverNameForm.fields,
          'limit_page_length': 'None',
        },
        parser: (p0) {
          final data = p0['data'] as List<dynamic>;
          return data.map((e) => e['name'].toString()).toList();
        },
      );
      final response = await get(config);
      return response.process((r) => right(r.data!));
    });
  }

  @override
  AsyncValueOf<Pair<String, String>> submitGateEntry(GateEntryForm form) async {
    return await executeSafely(() async {
      final config = RequestConfig(
        url: Urls.submitGateEntry,
        parser: (json) {
          final data = json['message']['message'] as String;
          return Pair(data, '');
        },
        body: jsonEncode({
          "gate_entry_id": form.name, // as per your curl
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
  AsyncValueOf<Pair<String, String>> createGateEntry(GateEntryForm form) async {
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
        "invoice_date": form.vendorInvoiceDate,
        "entry_date": form.gateEntryDate,
        "vendor_invoice_no": form.vendorInvoiceNo,
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

  //  @override
  //   AsyncValueOf<String> updateGateEntry(
  //       GateEntryForm form) async {
  //     final formData = form.toJson();
  //     formData
  //       ..remove('name')
  //       ..remove('creation')
  //       ..remove('gate_entry_date')
  //       ..remove('weighment_date');

  //     final requestConfig = RequestConfig(
  //       url: Urls.updateGateEntry,
  //       body: jsonEncode(removeNullValues({
  //         'ge_id': form.name,
  //         'gate_entry_lines': reqMap,
  //         ...formData,
  //       })),
  //       parser: (json) {
  //         final data = json['message']['message'];
  //         return data;
  //       },
  //       headers: {HttpHeaders.contentTypeHeader: 'application/json'},
  //     );
  //     final response = await post(requestConfig);
  //     return response.process((r) => right(r.data!));
  //   }
}
