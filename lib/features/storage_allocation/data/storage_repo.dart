import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/storage_allocation/model/storage.dart';

abstract class StorageRepo{
  AsyncValueOf<List<Storage>> fetchStorage(
    int start,
    int? docStatus,
    String? search,
  );
}