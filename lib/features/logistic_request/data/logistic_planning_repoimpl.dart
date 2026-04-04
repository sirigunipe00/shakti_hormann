import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/auth/model/logged_in_user.dart';
import 'package:shakti_hormann/features/logistic_request/data/logistic_planning_repo.dart';
import 'package:shakti_hormann/features/logistic_request/model/logistic_planning_form.dart';
import 'package:shakti_hormann/features/logistic_request/model/sales_order.dart';
import 'package:shakti_hormann/features/logistic_request/model/sales_order_form.dart';
import 'package:shakti_hormann/features/logistic_request/model/transporter_form.dart';
import 'package:shakti_hormann/features/logistic_request/model/vehicle_type_form.dart';

@LazySingleton(as: LogisticPlanningRepo)
class LogisticPlanningRepoimpl extends BaseApiRepository
    implements LogisticPlanningRepo {
  const LogisticPlanningRepoimpl(super.client);

  @override
  AsyncValueOf<List<LogisticPlanningForm>> fetchLogistics(
    int start,
    String? status,
    String? serach,
  ) async {
    final filters = <List<dynamic>>[];

    if (status != null && status != '4') {
      filters
        ..add(['status', '=', status])
        ..add(['docstatus', '!=', 2]);
    }
 final users = $sl.get<LoggedInUser>();
final hasRole = users.roles!.any((r) => r.role == 'Admin Role-SH');

final plantName = user().plantName;

    if (serach != null && serach.isNotEmpty) {
      filters.add(['name', 'like', '%$serach%']);
    }

    if (!hasRole && plantName != null && plantName.isNotEmpty) {
  filters.add(['plant_name', '=', plantName]);
}
$logger.devLog('hasRole...$hasRole...filters...$filters');
    final requestConfig = RequestConfig(
      url: Urls.getList,
      parser: (json) {
        final data = json['message'];
        final listdata = data as List<dynamic>;
        return listdata.map((e) => LogisticPlanningForm.fromJson(e)).toList();
      },
      reqParams: {
        'filters': jsonEncode(filters),
        'limit_start': start,
        'limit_page_length': 'None',
        'order_by': 'creation desc',
        'doctype': 'Logistic Planning and Confirmation',
        'fields': ['*'],
      },
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    $logger.devLog('requestConfig....sdfergrgrhrtghth$requestConfig');
    final response = await get(requestConfig);
    return response.process((r) => right(r.data!));
  }

  @override
  AsyncValueOf<String> updateLogisticPlanning(LogisticPlanningForm form) async {
    return await executeSafely(() async {
      String? formattedRequestedDeliveryDate;
      final formData = removeNullValues(form.toJson());
      const keysToRemove = ['name', 'creation', 'modified', 'modified_by'];
      for (String key in keysToRemove) {
        formData.remove(key);
      }


      final formattedTime =
          form.requestedDeliveryTime != null
              ? DateFormat('HH:mm').format(
                DateFormat('HH:mm:ss').tryParse(form.requestedDeliveryTime!) ??
                    DateFormat('HH:mm').parse(form.requestedDeliveryTime!),
              )
              : null;

      final formattedLogisticsRequestDate =
          form.logisticsRequestDate != null
              ? DateFormat(
                'dd-MM-yyyy',
              ).format(DateTime.parse(form.logisticsRequestDate!))
              : null;

      final ddMMyyyyRegex = RegExp(r'^\d{2}-\d{2}-\d{4}$');

      if (ddMMyyyyRegex.hasMatch(form.requestedDeliveryDate!)) {
        formattedRequestedDeliveryDate = form.requestedDeliveryDate!;
      } else {
        final inputFormat = DateFormat('yyyy-MM-dd');
        final outputFormat = DateFormat('dd-MM-yyyy');
        final date = inputFormat.parse(form.requestedDeliveryDate!);
        formattedRequestedDeliveryDate = outputFormat.format(date);
      }

        final Map<String, dynamic> requestBody = {
          'logistic_request_id': form.name,
          'sales_orders': form.salesOrder,
          'plant_name': form.plantName,
          'transporter_name': form.transporterName,
          'preferred_vehicle_type': form.preferredVehicleType,
          'requested_delivery_date': formattedRequestedDeliveryDate,
          'requested_delivery_time': formattedTime,
          'any_special_instructions': form.anySpecialInstructions,
          'delivery_address': form.deliveryAddress,
          'transport_type': form.transporterType,
          'dispatch_type': form.dispatchType,
          'status': form.status,
          'logistics_request_date': formattedLogisticsRequestDate,
          'delivery_address_1': form.shippingAddress1,
          'delivery_address_2': form.shippingAddress2,
          'shipping_country': form.country,
          'shipping_state': form.city,
          'shipping_city': form.city,
          'shipping_pin_code': form.pincode,

        };
      if (form.plantName != null && form.plantName!.trim().isNotEmpty && form.plantName != '') {

      requestBody['plant_name'] = form.plantName;
    }

      final requestConfig = RequestConfig(
        url: Urls.updateLogisticPlanning,

        parser: (json) {
          final data = json['message']['message'] as String;
          return data;
        },
        body: jsonEncode(requestBody),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );
      $logger.devLog('UpdateConfig.....$requestConfig');

      final response = await post(requestConfig);
      $logger.devLog('...............$response')
;
      return response.process((r) => right(r.data!));
    });
  }

  @override
  AsyncValueOf<Pair<String, String>> createLogisticPlanning(
    LogisticPlanningForm form,
  ) async {
    return await executeSafely(() async {
      $logger.devLog('updatedate......${form.requestedDeliveryDate}');


      final formattedTime =
          form.requestedDeliveryTime != null
              ? DateFormat('HH:mm').format(
                DateFormat('HH:mm:ss').tryParse(form.requestedDeliveryTime!) ??
                    DateFormat('HH:mm').parse(form.requestedDeliveryTime!),
              )
              : null;

      final formattedLogisticsRequestDate =
          form.logisticsRequestDate != null
              ? DateFormat(
                'dd-MM-yyyy',
              ).format(DateTime.parse(form.logisticsRequestDate!))
              : null;



        final Map<String, dynamic> requestBody = {
           'plant_name': form.plantName,
          'sales_orders': form.salesOrder,
          'transporter_name': form.transporterName,
          'preferred_vehicle_type': form.preferredVehicleType,
          'requested_delivery_date': form.requestedDeliveryDate,
          'requested_delivery_time': formattedTime,
          'any_special_instructions': form.anySpecialInstructions,
          'delivery_address': form.deliveryAddress,
          'transport_type': form.transporterType,
          'dispatch_type': form.dispatchType,
          'status': form.status,
          'logistics_request_date': formattedLogisticsRequestDate,
          'delivery_address_1': form.shippingAddress1,
          'delivery_address_2': form.shippingAddress2,
          'shipping_country': form.country,
          'shipping_state': form.city,
          'shipping_city': form.city,
          'shipping_pin_code': form.pincode,

        };

      if (form.plantName != null && form.plantName!.trim().isNotEmpty && form.plantName != '') {

      requestBody['plant_name'] = form.plantName;
    }

      final config = RequestConfig(
        url: Urls.createLogisticPlanning,
        parser: (json) {
          final data = json['message']['data']['logistic_request_id'] as String;
          return Pair(data, '');
        },
        body: jsonEncode(requestBody),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );

      $logger.devLog('requestConfig.....$config');

      final response = await post(config);

      return response.processAsync((r) async {
        return right(r.data!);
      });
    });
  }

  @override
  AsyncValueOf<List<VehicleTypeForm>> fetchVehicle() async {
    return await executeSafely(() async {
      final config = RequestConfig(
        url: Urls.getList,

        parser: (json) {
          final data = json['message'];
          final listdata = data as List<dynamic>;
          return listdata.map((e) => VehicleTypeForm.fromJson(e)).toList();
        },
        reqParams: {
          'limit_start': 0,
          'limit_page_length': 'None',
          'order_by': 'creation desc',
          'doctype': 'Vehicle Type',
          'fields': ['*'],
        },
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );
      $logger.devLog('VehicleType.....$config');
      final response = await get(config);
      return response.processAsync((r) async {
        return right((r.data!));
      });
    });
  }

  @override
  AsyncValueOf<List<SalesOrder>> fetchSales(String name) async {
    return await executeSafely(() async {
      final config = RequestConfig(
        url: Urls.getList,

        parser: (json) {
          $logger.devLog('repojson...----$json');

          final data = json['message'];
          final listdata = data as List<dynamic>;
          return listdata.map((e) => SalesOrder.fromJson(e)).toList();
        },
        reqParams: {
          'filters': [
            ['parent', '=', name],
          ],
          'limit_start': 0,
          'limit_page_length': 'None',
          'order_by': 'creation desc',
          'doctype': 'Logistic Planning and Confirmation Lines',
          'parent': 'Logistic Planning and Confirmation',
          'fields': ['*'],
        },
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );
      final response = await get(config);
      $logger.devLog('reposales config........$response');
      return response.processAsync((r) async {
        return right((r.data!));
      });
    });
  }

  @override
  AsyncValueOf<List<SalesOrderForm>> fetchSalesOrder(String name) async {
    return await executeSafely(() async {
      final filters = <List<dynamic>>[];

      final users = $sl.get<LoggedInUser>();
      final hasRole = users.roles!.any((r) => r.role == 'Admin Role-SH');
      final plantName = user().plantName;
      if (!hasRole && plantName != null && plantName.isNotEmpty) {
        filters.add(['company', '=', plantName]);
      }

      final reqParams = {
        'limit_start': 0,
        'limit_page_length': 'None',
        'order_by': 'creation desc',
        'doctype': 'SAP Sales Order',
        'fields': ['*'],
        'filters': jsonEncode(filters),
      };

      final config = RequestConfig(
        url: Urls.getList,

        parser: (json) {
          final data = json['message'];
          final listdata = data as List<dynamic>;
          return listdata.map((e) => SalesOrderForm.fromJson(e)).toList();
        },
        reqParams: reqParams,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );
      $logger.devLog('salesinvoice.....$config');
      final response = await get(config);
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
          'limit_start': 0,
          'limit_page_length': 'None',
          'order_by': 'creation desc',
          'doctype': 'Supplier',
          'filters': jsonEncode({'is_transporter': 1}),
          'fields': jsonEncode(['name','supplier_name']),
        },
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );
      $logger.devLog('transporters.....$config');
      final response = await get(config);
      return response.processAsync((r) async {
        return right((r.data!));
      });
    });
  }
}
