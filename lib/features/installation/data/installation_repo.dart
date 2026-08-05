import 'package:shakti_hormann/core/model/pair.dart';
import 'package:shakti_hormann/core/utils/typedefs.dart';
import 'package:shakti_hormann/features/installation/model/installation_line_items.dart';
import 'package:shakti_hormann/features/installation/model/installation_model.dart';

abstract interface class InstallationRepo {
  AsyncValueOf<List<InstallationModel>> fetchInstallation(
    int start,
    int? docStatus,
    String? search,
  );
  AsyncValueOf<Pair<String,String>> createInstallation(InstallationModel form);
  AsyncValueOf<List<InstallationLineItems>> fetchInstallationLines(String name);
  AsyncValueOf<Pair<String,String>> updateInstallation(String name, List<String> images);
  AsyncValueOf<Pair<String,String>> submitInstallation(String name);
  AsyncValueOf<String> printinstallationSticker(String id);
}