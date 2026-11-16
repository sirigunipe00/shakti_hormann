import 'package:shakti_hormann/core/model/page_view_filters.dart';
import 'package:shakti_hormann/core/model/page_view_filters_cubit.dart';
import 'package:shakti_hormann/core/utils/utils.dart';

class ForkliftOperatorFilterCubit extends PageViewFiltersCubit {
  ForkliftOperatorFilterCubit()
      : super(const PageViewFilters(status: 'All'));

  @override
  void onChangeStatus(String? status) {
    emitSafeState(
      state.copyWith(
        status: (status != null && status.isNotEmpty) ? status : 'All',
      ),
    );
  }

  @override
  void onSearch([String? query]) {
    if (query.doesNotHaveValue) {
      emitSafeState(PageViewFilters(status: state.status));
    } else {
      emitSafeState(state.copyWith(query: query));
    }
  }
}

class ForkliftStatusFilterCubit extends PageViewFiltersCubit {
  ForkliftStatusFilterCubit() : super(const PageViewFilters(status: 'All'));

  @override
  void onChangeStatus(String? status) {
    emitSafeState(
      state.copyWith(
        status: (status != null && status.isNotEmpty) ? status : 'All',
      ),
    );
  }

  @override
  void onSearch([String? query]) {
    if (query.doesNotHaveValue) {
      emitSafeState(PageViewFilters(status: state.status));
    } else {
      emitSafeState(state.copyWith(query: query));
    }
  }
}
