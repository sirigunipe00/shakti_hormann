import 'package:shakti_hormann/core/model/pair.dart';
import 'package:shakti_hormann/core/utils/typedefs.dart';
import 'package:shakti_hormann/features/gate_exit/model/gate%20_exit_form.dart';
import 'package:shakti_hormann/features/gate_exit/model/sales_invoice_form.dart';

abstract interface class GateExitRepo {
  AsyncValueOf<List<GateExitForm>> fetchEntries(
    int start,
    int? docStatus,
    String? search,
  );
  AsyncValueOf<Pair<String,String>> submitGateExit(GateExitForm form);
  AsyncValueOf<Pair<String,String>> createGateExit(GateExitForm form);
  AsyncValueOf<List<SalesInvoiceForm>> fetchSalesInvoice(String name);

 
}