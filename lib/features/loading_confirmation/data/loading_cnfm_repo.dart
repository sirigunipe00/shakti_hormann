import 'package:shakti_hormann/core/model/pair.dart';
import 'package:shakti_hormann/core/utils/typedefs.dart';
import 'package:shakti_hormann/features/loading_confirmation/model/item_model.dart';
import 'package:shakti_hormann/features/loading_confirmation/model/loading_cnfm.dart';

abstract interface class LoadingCnfmRepo {
  AsyncValueOf<List<LoadingCnfmForm>> fetchLoadingList(
    int start,
    String? docStatus,
    String? search,
  );
  // AsyncValueOf<Pair<String,String>> submitGateExit(LoadingCnfmForm form);
  AsyncValueOf<Pair<String,String>> createLoadingCnfm(LoadingCnfmForm form);
  AsyncValueOf<List<ItemModel>> fetchItemList(String name);

 
}