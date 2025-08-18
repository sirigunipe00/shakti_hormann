import 'package:shakti_hormann/core/model/pair.dart';
import 'package:shakti_hormann/core/utils/typedefs.dart';
import 'package:shakti_hormann/features/logistic_request/model/logistic_planning_form.dart';
import 'package:shakti_hormann/features/logistic_request/model/sales_order_form.dart';
import 'package:shakti_hormann/features/logistic_request/model/transporter_form.dart';

abstract interface class LogisticPlanningRepo {
  AsyncValueOf<List<LogisticPlanningForm>> fetchLogistics(
    int start,
    int? docStatus,
    String? search,
  );
  AsyncValueOf<List<TransportersForm>> fetchTransporters();
  AsyncValueOf<Pair<String, String>> createLogisticPlanning(
    LogisticPlanningForm form,
  );
  AsyncValueOf<String> updateLogisticPlanning(LogisticPlanningForm form);
  AsyncValueOf<List<SalesOrderForm>> fetchSalesOrder(String name);
}
