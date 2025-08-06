

import 'package:shakti_hormann/core/cubit/base/base_cubit.dart';
import 'package:shakti_hormann/core/model/page_view_filters.dart';

abstract class FiltersCubit extends AppBaseCubit<PageViewFilters> {
  FiltersCubit(super.initialState);
  void onSearch([String? query]);
  void onChangeStatus(String status);
}
