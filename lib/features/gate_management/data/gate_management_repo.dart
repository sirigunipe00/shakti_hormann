import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/gate_management/model/gate_management_form.dart';

abstract interface class GateManagementRepo {
  AsyncValueOf<List<GateManagementForm>> fetchGateManagements(
    int start,
    int? docStatus,
    String? search,
  );
  AsyncValueOf<Pair<String, String>> createGateManagement(GateManagementForm form);
  // AsyncValueOf<Pair<String,String>> updateGateManagement(GateManagementForm form);
  AsyncValueOf<Pair<String,String>> submitGateManagement(GateManagementForm form);
  
}