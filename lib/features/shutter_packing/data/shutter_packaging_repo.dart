import 'package:shakti_hormann/core/model/pair.dart';
import 'package:shakti_hormann/core/utils/typedefs.dart';
import 'package:shakti_hormann/features/shutter_packing/model/items.dart';
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
  AsyncValueOf<Pair<String,String>> submitShutter(ShutterPacking form);
  AsyncValueOf<List<Items>> fetchItems(String name,String index);
}