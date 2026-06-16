import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/gate_entry/model/gate_entry_form.dart';

abstract class ZoneRepo{
  AsyncValueOf<List<GateEntryForm>> fetchZone(
    int start,
    int? docStatus,
    String? search,
  );
}