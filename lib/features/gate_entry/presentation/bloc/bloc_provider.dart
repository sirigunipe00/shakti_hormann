import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/gate_entry/data/gate_entry.repo.dart';
import 'package:shakti_hormann/features/gate_entry/model/gate_entry_form.dart';

typedef GateEntriesCubit =
    InfiniteListCubit<GateEntryForm, Pair<int?, String?>, Pair<int?, String?>>;
typedef GateEntriesCubitState = InfiniteListState<GateEntryForm>;

mixin CompanyNameList on NetworkRequestCubit<List<String>, None> {}


class StringListCubit extends NetworkRequestCubit<List<String>, None> with CompanyNameList {
  StringListCubit({required super.onRequest});
}

@lazySingleton
class GateEntryBlocProvider {
  const GateEntryBlocProvider(this.repo);

  final GateEntryRepo repo;

  static GateEntryBlocProvider get() => $sl.get<GateEntryBlocProvider>();

  GateEntriesCubit fetchGateEntries() => GateEntriesCubit(
    requestInitial:
        (params, state) => repo.fetchEntries(0, params!.first, params!.second),
    requestMore:
        (params, state) =>
            repo.fetchEntries(state.curLength, params!.first, params!.second),
  );
 CompanyNameList companyNameList() => StringListCubit(
        onRequest: (_, state) => repo.fetchCompanyList(),
      );
}
