import 'package:shakti_hormann/core/model/pair.dart';
import 'package:shakti_hormann/core/utils/typedefs.dart';
import 'package:shakti_hormann/features/loading_confirmation/model/dispatch_loading.dart';
import 'package:shakti_hormann/features/loading_confirmation/model/item_model.dart';
import 'package:shakti_hormann/features/loading_confirmation/model/loading_cnfm.dart';
import 'package:shakti_hormann/features/loading_confirmation/model/logistic.dart';

abstract interface class LoadingCnfmRepo {
  AsyncValueOf<List<LoadingCnfmForm>> fetchLoadingList(
    int start,
    String? docStatus,
    String? search,
    String? salesOrder,
  );
  AsyncValueOf<Pair<String,String>> submitLoading(String form);
  AsyncValueOf<Pair<String,String>> createLoadingCnfm(List<ItemModel> form,String name);
  AsyncValueOf<Pair<String,String>> updateLoadingCnfm(List<ItemModel> form,String name);
  AsyncValueOf<List<ItemModel>> fetchItemList(List<LogisticModel> logistic);
  AsyncValueOf<List<ItemModel>> getItems(String name);
  AsyncValueOf<List<LogisticModel>> fetchLogisticList(String name);
  AsyncValueOf<DispatchScanResult> scanUnitForDispatch({
    required String qr,
    required String vrName,
    String? parentPalletQr,
  });
  AsyncValueOf<DispatchLoadedData> getDispatchLoadedItems(String docname);
  AsyncValueOf<DispatchLoadedData> updateScannedItems(
    String vrName,
    List<Map<String, dynamic>> items,
  );
}