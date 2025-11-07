import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/logistic_request/model/sales_order.dart';
import 'package:shakti_hormann/features/transport_confirmation/data/transport_confrimation_repo.dart';
import 'package:shakti_hormann/features/transport_confirmation/model/transport_confirmation_form.dart';

@LazySingleton(as: TransportConfrimationRepo)
class TransportCnfrmRepoimpl extends BaseApiRepository
    implements TransportConfrimationRepo {
  const TransportCnfrmRepoimpl(super.client);

  @override
  AsyncValueOf<List<TransportConfirmationForm>> fetchTransports(
    int start,
    String? status,
    String? serach,
  ) async {
    final filters = <List<dynamic>>[];

    if (status != null && status != '4') {
      filters..add(['status', '=', status])
      ..add(['docstatus', '!=', 2]);
    }

    if (serach != null && serach.isNotEmpty) {
      filters.add(['name', 'like', '%$serach%']);
    }
         final plantName = user().plantName;
         final transporter = user().transporter;
  if (plantName != null && plantName.isNotEmpty) {
    filters.add(['plant_name', '=', plantName]); 
   
  }
  if (transporter != null && transporter.isNotEmpty) {
    filters.add(['transporter_name', '=', transporter]); 
   
  }

  
    final requestConfig = RequestConfig(
      url: Urls.getList,
      parser: (json) {
        final data = json['message'];
        final listdata = data as List<dynamic>;
        return listdata
            .map((e) => TransportConfirmationForm.fromJson(e))
            .toList();
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
    $logger.devLog('requestConfig....$requestConfig');
    final response = await get(requestConfig);
    return response.process((r) => right(r.data!));
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
         'filters': 
         [
        [
            'parent',
            '=',
            name
        ],
        
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
      $logger.devLog('reposales........$response');
      return response.processAsync((r) async {
        return right((r.data!));
      });
    });
  }

  @override
  AsyncValueOf<Pair<String, String>> submitTransport(
    TransportConfirmationForm form,
  ) async {
    return await executeSafely(() async {
      // String? estimatedArrival;
      // if (form.estimatedArrival != null && form.!.isNotEmpty) {
      //   try {
      //     final parsedDate = DateFormat(
      //       'dd-MM-yyyy',
      //     ).parse(form.estimatedArrival!);

      //     final now = DateTime.now();

      //     final combinedDateTime = DateTime(
      //       parsedDate.year,
      //       parsedDate.month,
      //       parsedDate.day,
      //       now.hour,
      //       now.minute,
      //       now.second,
      //     );

      //     estimatedArrival = DateFormat(
      //       'dd-MM-yyyy HH:mm:ss',
      //     ).format(combinedDateTime);
      //   } catch (e) {
      //     $logger.devLog('Date parsing error: $e');
      //   }
      // }
       final formattedTime =
          form.estimatedArrivalTime != null
              ? DateFormat('HH:mm:ss').format(
                DateFormat('HH:mm:ss').tryParse(form.estimatedArrivalTime!) ??
                    DateFormat('HH:mm').parse(form.estimatedArrivalTime!),
              )
              : null;

      final config = RequestConfig(
        url: Urls.updateTransport,
        parser: (json) {
          final data = json['message']['data']['logistic_request_id'] as String;
          return Pair(data, '');
        },

        body: jsonEncode({
          'logistic_request_id': form.name,
          'status': 'Transporter Confirmed',
          'transporter_confirmation_date': form.transporterConfirmationDate,
          'driver_name': form.driverName,
          'vehicle_number': form.vehicleNumber,
          'estimated_arrival_date': form.estimatedArrivalDate,
          'estimated_arrival_time': formattedTime,
          'driver_contact': form.driverContact,
          'transporter_remarks': form.transporterRemarks,
        }),
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
  AsyncValueOf<Pair<String, String>> rejectTransport(
    TransportConfirmationForm form,
  ) async {
    return await executeSafely(() async {
      final formData = removeNullValues(form.toJson());
      const keysToRemove = ['name', 'creation', 'modified', 'modified_by'];
      for (String key in keysToRemove) {
        formData.remove(key);
      }

      final requestConfig = RequestConfig(
        url: Urls.updateTransport,
        parser: (json) {
          final message = json['message']['message'] as String;
          return Pair(message, '');
        },
        body: jsonEncode({
          'logistic_request_id': form.name,
          'status': 'Transporter Rejected',
          'reject_reason': form.rejectReason,
        }),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );
      $logger.devLog(requestConfig);

      final response = await post(requestConfig);
      return response.process((r) => right(r.data!));
    });
  }
}
