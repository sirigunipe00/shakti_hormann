import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
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
      'limit': 20,
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
      final config = RequestConfig(
        url: Urls.submitGateExit,
        parser: (json) {
          final data = json['message']['message'] as String;
          return Pair(data, '');
        },
        body: jsonEncode({'gate_exit_id': form.name}),
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

    $logger.devLog('form....$form');

    formJson['status'] = 'Draft';
    $logger.devLog('formJson.....$formJson');

    final cleanedJson = removeNullValues(form.toJson());
    cleanedJson['status'] = 'Draft';

   

    final config = RequestConfig(
      url: Urls.createGateExit,
      parser: (json) {
        final data = json['message']['data']['name'] as String;
        return Pair(data, '');
      },

      body: jsonEncode({
        'plant_name': form.plantName,
        'sales_invoice': form.salesInvoice,
        'vehicle_no': form.vehicleNo,
        'vehicle_back_photo': form.vehicleBackPhoto,
        'vehicle_photo': form.vehiclePhoto,
       'gate_entry_date': form.gateEntryDate != null
        ? DateFormat('dd-MM-yyyy').format(DateTime.parse(form.gateEntryDate!))
        : null,
        'remarks': form.remarks,
        'by_mobile_app': 1,
      }),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    

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
          'fields': ['*'],
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
