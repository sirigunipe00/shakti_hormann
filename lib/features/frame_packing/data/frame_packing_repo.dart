import 'package:shakti_hormann/core/model/pair.dart';
import 'package:shakti_hormann/core/utils/typedefs.dart';
import 'package:shakti_hormann/features/frame_packing/model/frame_items.dart';
import 'package:shakti_hormann/features/frame_packing/model/frame_lines.dart';
import 'package:shakti_hormann/features/frame_packing/model/frame_packing.dart';
import 'package:shakti_hormann/features/gate_entry/model/attachement.dart';
import 'package:shakti_hormann/features/shutter_packing/model/pallet_size.dart';


abstract class FramePackingRepo{
  AsyncValueOf<List<FramePacking>> fetchFramePacking(
    int start,
    int? docStatus,
    String? search,
  );
  AsyncValueOf<List<FrameLines>> fetchFrameLines(
    String itemName,
  );
  AsyncValueOf<Pair<String,String>> createFrame(FramePacking form,List<FrameLines> lines);
  AsyncValueOf<Pair<String,String>> updateFrame(FramePacking form,List<FrameLines> lines);
  AsyncValueOf<Pair<String,String>> submitFrame(FramePacking form);
  AsyncValueOf<List<FrameItems>> fetchItems(String name,String index);
  AsyncValueOf<List<PalletSize>> fetchPalletSize();
  AsyncValueOf<List<String>> getFramePalletCode(String salesOrder);
  AsyncValueOf<String> printFrameSticker(String framePackingId);
  AsyncValueOf<List<AttachementInvoices>> fetchAttachments(String gateEntryId);
}