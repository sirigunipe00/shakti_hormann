import 'package:shakti_hormann/core/model/pair.dart';
import 'package:shakti_hormann/core/utils/utils.dart';
import 'package:shakti_hormann/features/gate_entry/model/gate_entry_form.dart';

abstract interface class GateEntryRepo {
  AsyncValueOf<List<GateEntryForm>> fetchEntries(
    int start,
    int? docStatus,
    String? search,
  );


  AsyncValueOf<List<String>> fetchCompanyList();

  AsyncValueOf<Pair<String,String>> createGateEntry(GateEntryForm form);
  AsyncValueOf<Pair<String,String>> submitGateEntry(GateEntryForm form);
}
