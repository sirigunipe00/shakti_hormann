import 'package:shakti_hormann/core/model/pair.dart';
import 'package:shakti_hormann/core/utils/typedefs.dart';
import 'package:shakti_hormann/features/vision_panel/model/vision_items.dart';
import 'package:shakti_hormann/features/vision_panel/model/vision_model.dart';

abstract interface class VisionPanelRepo {
  AsyncValueOf<List<VisionModel>> fetchPanels(
    int start,
    int? docStatus,
    String? search,
  );
  AsyncValueOf<Pair<String,String>> createVision(VisionModel form,List<VisionItems> lines);
  AsyncValueOf<List<VisionItems>> fetchVisionLines(String name);
}