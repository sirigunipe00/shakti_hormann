import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/storage_allocation/model/storage.dart';
import 'package:shakti_hormann/features/zone_transfer/model/zone_transfer.dart';

abstract class ZoneRepo{
  AsyncValueOf<List<ZoneTransfer>> fetchZone(
    int start,
    int? docStatus,
    String? search,
  );
  AsyncValueOf<Pair<String,String>> createZone(ZoneTransfer form);
  AsyncValueOf<List<Storage>> fetchSales(String palletNo);
}