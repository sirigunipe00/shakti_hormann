import 'package:shakti_hormann/core/model/pair.dart';
import 'package:shakti_hormann/core/utils/typedefs.dart';
import 'package:shakti_hormann/features/gate_entry/model/attachement.dart';
import 'package:shakti_hormann/features/pallet_creation/model/pallet_model.dart';
import 'package:shakti_hormann/features/shutter_packing/model/items.dart';
import 'package:shakti_hormann/features/shutter_packing/model/pallet_size.dart';
import 'package:shakti_hormann/features/shutter_packing/model/shutter_lines.dart';
import 'package:shakti_hormann/features/shutter_packing/model/shutter_packing.dart';

abstract class ShutterPackingRepo{
  AsyncValueOf<List<ShutterPacking>> fetchShutterPacking(
    int start,
    int? docStatus,
    String? search,
  );
  AsyncValueOf<List<ShutterLines>> fetchShutterLines(
    String itemName,
  );
  AsyncValueOf<Pair<String,String>> createShutter(ShutterPacking form,List<ShutterLines> lines);
  AsyncValueOf<Pair<String,String>> updateShutter(ShutterPacking form,List<ShutterLines> lines);
  AsyncValueOf<Pair<String,String>> freezeShutter(String shutterPackingId);
  AsyncValueOf<Pair<String,String>> submitShutter(ShutterPacking form);
  AsyncValueOf<List<Items>> fetchItems(String name,String index);
  AsyncValueOf<List<PalletSize>> getPalletSize();
  AsyncValueOf<List<PalletModel>> getSales();
  AsyncValueOf<String> printShutterSticker(String shutterPackingId);
  AsyncValueOf<List<String>> getShutterPalletCode(String salesOrder);
  AsyncValueOf<List<AttachementInvoices>> fetchAttachments(String gateEntryId);
}