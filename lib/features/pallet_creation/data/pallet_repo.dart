
import 'package:shakti_hormann/core/utils/typedefs.dart';
import 'package:shakti_hormann/features/frame_packing/model/frame_packing.dart';

abstract class PalletRepo{
  AsyncValueOf<List<FramePacking>> fetchPallet(
    int start,
    int? docStatus,
    String? search,
  );
}