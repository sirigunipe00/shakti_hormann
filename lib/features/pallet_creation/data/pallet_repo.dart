
import 'package:shakti_hormann/core/model/pair.dart';
import 'package:shakti_hormann/core/utils/typedefs.dart';
import 'package:shakti_hormann/features/logistic_request/model/sales_order_form.dart';
import 'package:shakti_hormann/features/pallet_creation/model/pallet_items.dart';
import 'package:shakti_hormann/features/pallet_creation/model/pallet_model.dart';

abstract class PalletRepo{
  AsyncValueOf<List<PalletModel>> fetchPallet(
    int start,
    int? docStatus,
    String? search,
  );
  AsyncValueOf<Pair<String,String>> createPallet(PalletModel form,List<PalletItems> lines,);
  AsyncValueOf<Pair<String,String>> updatePallet(PalletModel form,List<PalletItems> lines,);
  AsyncValueOf<List<PalletItems>> fetchPalletItems(String name);
  AsyncValueOf<Pair<String,String>> submitPallet(String name);
  AsyncValueOf<List<SalesOrderForm>> salesOrder();
}