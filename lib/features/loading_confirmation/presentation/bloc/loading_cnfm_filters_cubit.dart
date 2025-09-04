import 'package:shakti_hormann/core/core.dart';

import 'package:shakti_hormann/core/model/page_view_filters.dart';
import 'package:shakti_hormann/core/model/page_view_filters_cubit.dart';

class LoadingCnfmFiltersCubit extends PageViewFiltersCubit {
  LoadingCnfmFiltersCubit() : super(PageViewFilters.initial());

  @override
  void onChangeStatus(String? status) {
    if (status != null && status.isNotEmpty) {
      final newState = state.copyWith(status: status);
      emitSafeState(newState);
    } else {
      final newState = state.copyWith(status: 'Reported');
      emitSafeState(newState);
    }
  }

  @override
  void onSearch([String? query]) {
    if (query.doesNotHaveValue) {
      emitSafeState(PageViewFilters(status: state.status));
    } else {
      final newState = state.copyWith(query: query);
      emitSafeState(newState);
    }
  }
}
