import 'package:shakti_hormann/core/model/pair.dart';
import 'package:shakti_hormann/core/utils/typedefs.dart';
import 'package:shakti_hormann/features/vision_panel/model/product_type.dart';
import 'package:shakti_hormann/features/vision_panel/model/vision_items.dart';
import 'package:shakti_hormann/features/vision_panel/model/vision_model.dart';
import 'package:shakti_hormann/features/vision_panel/model/vision_panel_entry_lines.dart';


abstract interface class VisionPanelRepo {
  AsyncValueOf<List<VisionModel>> fetchPanels(
    int start,
    int? docStatus,
    String? search,
  );
  AsyncValueOf<Pair<String,String>> createVision(VisionModel form,List<VisionItems> lines);
  AsyncValueOf<List<VisionItems>> fetchVisionLines(String name);
  AsyncValueOf<List<VisionPanelEntryLines>> fetchVisionEntryLines(String name);
  AsyncValueOf<String> updateVision(
     String name, {
     String? productType,
     int? noOfBoxes,
     required List<String> images,
   });
  AsyncValueOf<List<ProductType>> fetchProduct();
  AsyncValueOf<Pair<String,String>> submitVision(String name);
  AsyncValueOf<String> printVisionSticker(String id);
}