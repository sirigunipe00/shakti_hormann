import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/hardware_packing/model/hardware_item.dart';
import 'package:shakti_hormann/features/hardware_packing/model/hardware_packing.dart';
import 'package:shakti_hormann/features/hardware_packing/model/hardware_packing_item.dart';

abstract class HardWareRepo{
  AsyncValueOf<List<HardwarePacking>> fetchHardware(
    int start,
    int? docStatus,
    String? search,
  );
  AsyncValueOf<Pair<String,String>> createHardware(HardwarePacking form,List<HardwareItem> lines);
  AsyncValueOf<List<HardwareItem>> fetchItems(String name);
  AsyncValueOf<HardwarePackingItem> fetchHardwareItems(String mesImage);
}