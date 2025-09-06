import 'package:shakti_hormann/core/model/pair.dart';
import 'package:shakti_hormann/core/utils/utils.dart';
import 'package:shakti_hormann/features/gate_entry/model/gate_entry_form.dart';
import 'package:shakti_hormann/features/gate_entry/model/gate_number_form.dart';
import 'package:shakti_hormann/features/gate_entry/model/purchase_order.dart';
import 'package:shakti_hormann/features/gate_entry/model/purchase_order_form.dart';

abstract interface class GateEntryRepo {
  AsyncValueOf<List<GateEntryForm>> fetchEntries(
    int start,
    int? docStatus,
    String? search,
  );

  AsyncValueOf<Pair<String, String>> createGateEntry(GateEntryForm form);
  AsyncValueOf<Pair<String, String>> submitGateEntry(GateEntryForm form);
  AsyncValueOf<List<PurchaseOrderForm>> fetchPurchaseOrders(String name);

  AsyncValueOf<List<PurchaseOrder>> fetchPurchase(String name);
  AsyncValueOf<List<GateNumberForm>> fetchGateNumber(String name);
}
