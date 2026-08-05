import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/storage_allocation/model/storage.dart';


abstract class ZoneRepo{
  AsyncValueOf<List<Storage>> fetchZone(
    int start,
    int? docStatus,
    String? search,
  );
  AsyncValueOf<Pair<String,String>> createZone(Storage form);
  AsyncValueOf<List<Storage>> fetchSales(String palletNo);
}