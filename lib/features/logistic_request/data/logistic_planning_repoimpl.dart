import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/logistic_request/data/logistic_planning_repo.dart';
import 'package:shakti_hormann/features/logistic_request/model/logistic_planning_form.dart';
import 'package:shakti_hormann/features/logistic_request/model/sales_order_form.dart';
import 'package:shakti_hormann/features/logistic_request/model/transporter_form.dart';

@LazySingleton(as: LogisticPlanningRepo)
class LogisticPlanningRepoimpl extends BaseApiRepository
    implements LogisticPlanningRepo {
  const LogisticPlanningRepoimpl(super.client);

  @override
  AsyncValueOf<List<LogisticPlanningForm>> fetchLogistics(
    int start,
    int? docStatus,
    String? serach,
  ) async {
    final requestConfig = RequestConfig(
      url: Urls.getList,
      parser: (json) {
        final data = json['message'];
        final listdata = data as List<dynamic>;
        return listdata.map((e) => LogisticPlanningForm.fromJson(e)).toList();
      },
      reqParams: {
        if (!(docStatus == null)) ...{
          'filters': [
            ['docstatus', '=', docStatus],
            if (serach.containsValidValue) ...{
              ['name', 'Like', '%$serach'],
            },
          ],
        },
        'limit_start': start,
        'limit': 20,
        'order_by': 'creation desc',
        'doctype': 'Logistic Planning and Confirmation',
        'fields': ['*'],
      },
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    $logger.devLog('requestConfig....$requestConfig');
    final response = await get(requestConfig);
    return response.process((r) => right(r.data!));
  }

  @override
  AsyncValueOf<String> updateLogisticPlanning(LogisticPlanningForm form) async {
    return await executeSafely(() async {
      $logger.devLog(form);
      final formData = removeNullValues(form.toJson());
      const keysToRemove = ['name', 'creation', 'modified', 'modified_by'];
      for (String key in keysToRemove) {
        formData.remove(key);
      }

      final requestConfig = RequestConfig(
        url: Urls.updateLogisticPlanning,
        
        parser: (json) {
          final data = json['message']['message'];
          return data;
        },
        body: jsonEncode({'logistic_request_id': form.name}),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );
      $logger.devLog(requestConfig);

      final response = await post(requestConfig);
      return response.process((r) => right(r.data!));
    });
  }



@override
AsyncValueOf<Pair<String, String>> createLogisticPlanning(
  LogisticPlanningForm form,
) async {
  return await executeSafely(() async {
    final formattedDate = form.requestedDeliveryDate != null
        ? DateFormat('dd-MM-yyyy').format(
            DateFormat('dd-MM-yyyy').parse(form.requestedDeliveryDate!),
          )
        : null;

    $logger.devLog('formatted date.....$formattedDate');

    final formattedTime = form.requestedDeliveryTime != null
        ? DateFormat('HH:mm').format(
            DateFormat('HH:mm').parse(form.requestedDeliveryTime!),
          )
        : null;

    final formattedLogisticsRequestDate = form.logisticsRequestDate != null
        ? DateFormat('dd-MM-yyyy').format(
            DateTime.parse(form.logisticsRequestDate!), 
        )
        : null ;
      

    final config = RequestConfig(
      url: Urls.createLogisticPlanning,
      parser: (json) {
        final data = json['message']['data']['logistic_request_id'] as String;
        return Pair(data, '');
      },
      body: jsonEncode({
        'plant_name': form.plantName,
        'sales_order': form.salesOrder,
        'transporter_name': form.transporterName,
        'preferred_vehicle_type': form.preferredVehicleType,
        'requested_delivery_date': formattedDate,
        'requested_delivery_time': formattedTime,
        'any_special_instructions': form.anySpecialInstructions,
        'delivery_address': form.deliveryAddress,
        'status': form.status,
        'logistics_request_date': formattedLogisticsRequestDate, 
      }),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );

    $logger.devLog('requestConfig.....$config');

    final response = await post(config);
    $logger.devLog('response.....$response');

    return response.processAsync((r) async {
      return right(r.data!);
    });
  });
}


  @override
  AsyncValueOf<List<SalesOrderForm>> fetchSalesOrder(String name) async {
    return await executeSafely(() async {
      final config = RequestConfig(
        url: Urls.getList,

        parser: (json) {
          final data = json['message'];
          final listdata = data as List<dynamic>;
          return listdata.map((e) => SalesOrderForm.fromJson(e)).toList();
        },
        reqParams: {
          'limit': 20,
          'oreder_by': 'create desc',
          'doctype': 'Sales Order',
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

  @override
  AsyncValueOf<List<TransportersForm>> fetchTransporters() async {
    return await executeSafely(() async {
      final config = RequestConfig(
        url: Urls.getList,

        parser: (json) {
          final data = json['message'];
          final listdata = data as List<dynamic>;
          return listdata.map((e) => TransportersForm.fromJson(e)).toList();
        },
        reqParams: {
          'oreder_by': 'create desc',
          'doctype': 'Supplier',
          'filters': jsonEncode({'is_transporter': 1}),
          'fields': jsonEncode(['name']),
        },
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );
      $logger.devLog('transporters.....$config');
      final response = await get(config);
      $logger.devLog('Transportersresponse.....$response');
      return response.processAsync((r) async {
        return right((r.data!));
      });
    });
  }
}
