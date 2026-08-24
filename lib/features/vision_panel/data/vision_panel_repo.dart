import 'package:shakti_hormann/core/model/pair.dart';
import 'package:shakti_hormann/core/utils/typedefs.dart';
import 'package:shakti_hormann/features/vision_panel/model/product_type.dart';
import 'package:shakti_hormann/features/vision_panel/model/vision_items.dart';
import 'package:shakti_hormann/features/vision_panel/model/vision_model.dart';
import 'package:shakti_hormann/features/vision_panel/model/vision_panel_entry_lines.dart';

class VisionPanelSaveResult {
  const VisionPanelSaveResult({
    required this.message,
    required this.name,
    this.items = const [],
    this.entryLines = const [],
    this.pendingBoxes = const [],
    this.nextActions = const [],
  });

  final String message;
  final String name;
  final List<VisionItems> items;
  final List<VisionPanelEntryLines> entryLines;
  final List<String> pendingBoxes;
  final List<String> nextActions;
}

abstract interface class VisionPanelRepo {
  AsyncValueOf<List<VisionModel>> fetchPanels(
    int start,
    int? docStatus,
    String? search,
  );
  AsyncValueOf<VisionPanelSaveResult> createVision(
    VisionModel form,
    List<VisionItems> lines,
  );
  AsyncValueOf<List<VisionItems>> fetchVisionLines(String name);
  AsyncValueOf<List<VisionPanelEntryLines>> fetchVisionEntryLines(String name);
  AsyncValueOf<List<VisionPanelEntryLines>> getVisionPanelBoxSequence({
    required String salesOrderNo,
    required int noOfBoxes,
  });
  AsyncValueOf<VisionPanelSaveResult> updateVision(
    String name, {
    String? productType,
    int? noOfBoxes,
    List<Map<String, String>> images = const [],
  });
  AsyncValueOf<List<ProductType>> fetchProduct();
  AsyncValueOf<Pair<String, String>> submitVision(String name);
  AsyncValueOf<String> printVisionSticker(String id);
}