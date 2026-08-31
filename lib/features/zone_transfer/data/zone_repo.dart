import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/storage_allocation/model/storage.dart';

class ZonePalletScanResult {
  const ZonePalletScanResult({
    required this.palletQr,
    this.salesOrder,
    this.totalQty,
    this.oldZoneName,
    this.allocationStatus,
    this.isNewPallet = false,
    this.movementCount = 0,
    this.transferCount = 0,
    this.popupMessage,
  });

  final String palletQr;
  final String? salesOrder;
  final int? totalQty;
  final String? oldZoneName;
  final String? allocationStatus;
  final bool isNewPallet;
  final int movementCount;
  final int transferCount;
  final String? popupMessage;
}

abstract class ZoneRepo {
  AsyncValueOf<List<Storage>> fetchZone(
    int start,
    int? docStatus,
    String? search,
  );
  AsyncValueOf<Pair<String, String>> createZone(Storage form);
  AsyncValueOf<ZonePalletScanResult> scanPalletForZoneTransfer(String palletQr);
  AsyncValueOf<int> getPalletTransferCount(String palletQr);
}
