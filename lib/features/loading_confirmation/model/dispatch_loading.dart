import 'package:shakti_hormann/features/loading_confirmation/model/item_model.dart';

class LoadedRow {
  const LoadedRow({
    this.itemRowName,
    this.scanQr,
    this.unitType,
    this.productType,
    this.packingDoctype,
    this.packingRef,
    this.salesOrder,
    this.parentPalletQr,
    this.loadingStatus,
    this.itemCode,
    this.itemName,
    this.qtyLoaded,
    this.uom,
    this.loadedItemPhoto,
    this.currentZone,
    this.boxNo,
    this.palletSize,
    this.scanTime,
    this.remarks,
  });

  final String? itemRowName;
  final String? scanQr;
  final String? unitType;
  final String? productType;
  final String? packingDoctype;
  final String? packingRef;
  final String? salesOrder;
  final String? parentPalletQr;
  final String? loadingStatus;
  final String? itemCode;
  final String? itemName;
  final num? qtyLoaded;
  final String? uom;
  final String? loadedItemPhoto;
  final String? currentZone;
  final dynamic boxNo;
  final String? palletSize;
  final String? scanTime;
  final String? remarks;

  bool get isPallet =>
      unitType?.toLowerCase() == 'pallet' ||
      (parentPalletQr == null || parentPalletQr!.isEmpty) &&
          (scanQr?.startsWith('FR-') == true ||
              scanQr?.startsWith('SH-') == true ||
              scanQr?.startsWith('CO-') == true);

  bool get isDispatched => loadingStatus?.toLowerCase() == 'dispatched';

  /// Legacy `get_loaded_items` row (Items Loaded child table).
  factory LoadedRow.fromLegacyItemJson(Map<String, dynamic> json) {
    return LoadedRow(
      itemRowName: json['name'] as String? ?? json['item_row_name'] as String?,
      scanQr: json['scan_qr'] as String?,
      unitType: json['unit_type'] as String?,
      productType: json['product_type'] as String?,
      packingDoctype: json['packing_doctype'] as String?,
      packingRef: json['packing_ref'] as String?,
      salesOrder: json['sales_order'] as String?,
      parentPalletQr: json['parent_pallet_qr'] as String?,
      loadingStatus: json['loading_status'] as String?,
      itemCode: json['item_code'] as String?,
      itemName: json['item_name'] as String?,
      qtyLoaded: json['qty_loaded'] as num?,
      uom: json['uom'] as String?,
      loadedItemPhoto: json['loaded_item_photo'] as String?,
      currentZone: json['current_zone'] as String?,
      boxNo: json['box_no'],
      palletSize: json['pallet_size'] as String?,
      scanTime: json['scan_time'] as String?,
      remarks: json['remarks'] as String?,
    );
  }

  factory LoadedRow.fromJson(Map<String, dynamic> json) {
    return LoadedRow(
      itemRowName: json['item_row_name'] as String?,
      scanQr: json['scan_qr'] as String?,
      unitType: json['unit_type'] as String?,
      productType: json['product_type'] as String?,
      packingDoctype: json['packing_doctype'] as String?,
      packingRef: json['packing_ref'] as String?,
      salesOrder: json['sales_order'] as String?,
      parentPalletQr: json['parent_pallet_qr'] as String?,
      loadingStatus: json['loading_status'] as String?,
      itemCode: json['item_code'] as String?,
      itemName: json['item_name'] as String?,
      qtyLoaded: json['qty_loaded'] as num?,
      uom: json['uom'] as String?,
      loadedItemPhoto: json['loaded_item_photo'] as String?,
      currentZone: json['current_zone'] as String?,
      boxNo: json['box_no'],
      palletSize: json['pallet_size'] as String?,
      scanTime: json['scan_time'] as String?,
      remarks: json['remarks'] as String?,
    );
  }
}

class RelatedPackingItem {
  const RelatedPackingItem({
    this.scanQr,
    this.unitType,
    this.allocationStatus,
    this.currentZone,
    this.required,
    this.scannedOnThisVehicle,
    this.loadedOnOtherVehicle,
    this.dispatched,
    this.scanStatus,
    this.boxNo,
    this.packingDoctype,
    this.packingRef,
    this.productType,
    this.photo,
  });

  final String? scanQr;
  final String? unitType;
  final String? allocationStatus;
  final String? currentZone;
  final bool? required;
  final bool? scannedOnThisVehicle;
  final String? loadedOnOtherVehicle;
  final bool? dispatched;
  final String? scanStatus;
  final dynamic boxNo;
  final String? packingDoctype;
  final String? packingRef;
  final String? productType;
  final String? photo;

  bool get isLoaded =>
      scannedOnThisVehicle == true || scanStatus?.toLowerCase() == 'loaded';

  factory RelatedPackingItem.fromJson(Map<String, dynamic> json) {
    return RelatedPackingItem(
      scanQr: json['scan_qr'] as String?,
      unitType: json['unit_type'] as String?,
      allocationStatus: json['allocation_status'] as String?,
      currentZone: json['current_zone'] as String?,
      required: json['required'] as bool?,
      scannedOnThisVehicle: json['scanned_on_this_vehicle'] as bool?,
      loadedOnOtherVehicle: json['loaded_on_other_vehicle'] as String?,
      dispatched: json['dispatched'] as bool?,
      scanStatus: json['scan_status'] as String?,
      boxNo: json['box_no'],
      packingDoctype: json['packing_doctype'] as String?,
      packingRef: json['packing_ref'] as String?,
      productType: json['product_type'] as String?,
      photo: json['photo'] as String?,
    );
  }
}

class RelatedPacking {
  const RelatedPacking({
    this.installation = const [],
    this.accessories = const [],
    this.hardware = const [],
  });

  final List<RelatedPackingItem> installation;
  final List<RelatedPackingItem> accessories;
  final List<RelatedPackingItem> hardware;

  List<RelatedPackingItem> get all => [
    ...installation,
    ...accessories,
    ...hardware,
  ];

  factory RelatedPacking.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const RelatedPacking();
    List<RelatedPackingItem> parseList(String key) {
      final raw = json[key];
      if (raw is! List) return [];
      return raw
          .whereType<Map<String, dynamic>>()
          .map(RelatedPackingItem.fromJson)
          .toList();
    }

    return RelatedPacking(
      installation: parseList('installation'),
      accessories: parseList('accessories'),
      hardware: parseList('hardware'),
    );
  }
}

class DispatchCompleteness {
  const DispatchCompleteness({
    this.installationTotal = 0,
    this.installationPending = 0,
    this.installationComplete = false,
    this.accessoriesTotal = 0,
    this.accessoriesPending = 0,
    this.accessoriesComplete = false,
    this.hardwareTotal = 0,
    this.hardwarePending = 0,
    this.hardwareComplete = false,
    this.allRelatedComplete = false,
  });

  final int installationTotal;
  final int installationPending;
  final bool installationComplete;
  final int accessoriesTotal;
  final int accessoriesPending;
  final bool accessoriesComplete;
  final int hardwareTotal;
  final int hardwarePending;
  final bool hardwareComplete;
  final bool allRelatedComplete;

  factory DispatchCompleteness.fromJson(Map<String, dynamic>? json) {
    if (json == null || json.isEmpty) return const DispatchCompleteness();
    return DispatchCompleteness(
      installationTotal: (json['installation_total'] as num?)?.toInt() ?? 0,
      installationPending: (json['installation_pending'] as num?)?.toInt() ?? 0,
      installationComplete: json['installation_complete'] == true,
      accessoriesTotal: (json['accessories_total'] as num?)?.toInt() ?? 0,
      accessoriesPending: (json['accessories_pending'] as num?)?.toInt() ?? 0,
      accessoriesComplete: json['accessories_complete'] == true,
      hardwareTotal: (json['hardware_total'] as num?)?.toInt() ?? 0,
      hardwarePending: (json['hardware_pending'] as num?)?.toInt() ?? 0,
      hardwareComplete: json['hardware_complete'] == true,
      allRelatedComplete: json['all_related_complete'] == true,
    );
  }
}

class DispatchScanResult {
  const DispatchScanResult({
    this.scannedQr,
    this.scanQr,
    this.unitType,
    this.productType,
    this.packingDoctype,
    this.packingRef,
    this.salesOrder,
    this.qty,
    this.palletCode,
    this.palletSize,
    this.currentZone,
    this.allocationStatus,
    this.packUnitStatus,
    this.isPallet = false,
    this.scannedOnThisVehicle = false,
    this.relatedPacking = const RelatedPacking(),
    this.completeness = const DispatchCompleteness(),
    this.popupMessage,
    this.items = const [],
  });

  final String? scannedQr;
  final String? scanQr;
  final String? unitType;
  final String? productType;
  final String? packingDoctype;
  final String? packingRef;
  final String? salesOrder;
  final num? qty;
  final String? palletCode;
  final String? palletSize;
  final String? currentZone;
  final String? allocationStatus;
  final String? packUnitStatus;
  final bool isPallet;
  final bool scannedOnThisVehicle;
  final RelatedPacking relatedPacking;
  final DispatchCompleteness completeness;
  final String? popupMessage;
  final List<Map<String, dynamic>> items;

  factory DispatchScanResult.fromJson(Map<String, dynamic> json) {
    final itemsRaw = json['items'];
    return DispatchScanResult(
      scannedQr: json['scanned_qr'] as String?,
      scanQr: json['scan_qr'] as String?,
      unitType: json['unit_type'] as String?,
      productType: json['product_type'] as String?,
      packingDoctype: json['packing_doctype'] as String?,
      packingRef: json['packing_ref'] as String?,
      salesOrder: json['sales_order'] as String?,
      qty: json['qty'] as num?,
      palletCode: json['pallet_code'] as String?,
      palletSize: json['pallet_size'] as String?,
      currentZone: json['current_zone'] as String?,
      allocationStatus: json['allocation_status'] as String?,
      packUnitStatus: json['pack_unit_status'] as String?,
      isPallet: json['is_pallet'] == true,
      scannedOnThisVehicle: json['scanned_on_this_vehicle'] == true,
      relatedPacking: RelatedPacking.fromJson(
        json['related_packing'] as Map<String, dynamic>?,
      ),
      completeness: DispatchCompleteness.fromJson(
        json['completeness'] as Map<String, dynamic>?,
      ),
      popupMessage: json['popup_message'] as String?,
      items:
          itemsRaw is List
              ? itemsRaw.whereType<Map<String, dynamic>>().toList()
              : const [],
    );
  }
}

class DispatchLoadedData {
  const DispatchLoadedData({
    this.name,
    this.docstatus,
    this.vehicleStatus,
    this.dispatchLoadingStatus,
    this.lastScannedPallet,
    this.palletsLoaded = 0,
    this.relatedBoxesLoaded = 0,
    this.isComplete = false,
    this.pendingNotes = const [],
    this.loadedRows = const [],
    this.relatedPackingBySo = const {},
    this.popupMessage,
  });

  final String? name;
  final int? docstatus;
  final String? vehicleStatus;
  final String? dispatchLoadingStatus;
  final String? lastScannedPallet;
  final int palletsLoaded;
  final int relatedBoxesLoaded;
  final bool isComplete;
  final List<String> pendingNotes;
  final List<LoadedRow> loadedRows;
  final Map<String, RelatedPacking> relatedPackingBySo;
  final String? popupMessage;

  bool get isSubmitted => docstatus == 1;
  bool get isDispatched =>
      dispatchLoadingStatus?.toLowerCase() == 'dispatched' || isSubmitted;

  List<LoadedRow> get palletRows =>
      loadedRows.where((r) => r.isPallet).toList();

  List<LoadedRow> childrenOf(String palletQr) =>
      loadedRows
          .where((r) => r.parentPalletQr == palletQr && !r.isPallet)
          .toList();

  List<LoadedRow> get scannedRows =>
      loadedRows
          .where((r) => r.scanQr != null && r.scanQr!.trim().isNotEmpty)
          .toList();

  List<LoadedRow> get manualRows =>
      loadedRows
          .where((r) => r.scanQr == null || r.scanQr!.trim().isEmpty)
          .toList();

  List<ItemModel> toManualItems() {
    return manualRows
        .map(
          (r) => ItemModel(
            itemCode: r.itemCode,
            itemName: r.itemName,
            uomValue: r.uom,
            qtyLoaded: r.qtyLoaded?.toDouble(),
            loadedItemPhoto: r.loadedItemPhoto,
            name: r.itemRowName,
            itemrowName: r.itemRowName,
          ),
        )
        .toList();
  }

  factory DispatchLoadedData.fromJson(Map<String, dynamic> json) {
    final rowsRaw = json['loaded_rows'];
    final pendingRaw = json['pending_notes'];
    final relatedRaw = json['related_packing_by_so'];

    final relatedBySo = <String, RelatedPacking>{};
    if (relatedRaw is Map<String, dynamic>) {
      relatedRaw.forEach((key, value) {
        if (value is Map<String, dynamic>) {
          relatedBySo[key] = RelatedPacking.fromJson(value);
        }
      });
    }

    return DispatchLoadedData(
      name: json['name'] as String?,
      docstatus: (json['docstatus'] as num?)?.toInt(),
      vehicleStatus: json['vehicle_status'] as String?,
      dispatchLoadingStatus: json['dispatch_loading_status'] as String?,
      lastScannedPallet: json['last_scanned_pallet'] as String?,
      palletsLoaded: (json['pallets_loaded'] as num?)?.toInt() ?? 0,
      relatedBoxesLoaded: (json['related_boxes_loaded'] as num?)?.toInt() ?? 0,
      isComplete: json['is_complete'] == true,
      pendingNotes:
          pendingRaw is List
              ? pendingRaw.map((e) => e.toString()).toList()
              : const [],
      loadedRows:
          rowsRaw is List
              ? rowsRaw
                  .whereType<Map<String, dynamic>>()
                  .map(LoadedRow.fromJson)
                  .toList()
              : const [],
      relatedPackingBySo: relatedBySo,
      popupMessage: json['popup_message'] as String?,
    );
  }

  factory DispatchLoadedData.empty() => const DispatchLoadedData();

  /// Older UAT records return `message.data` as a flat list of Items Loaded rows.
  factory DispatchLoadedData.fromLegacyList(List<dynamic> items) {
    final loadedRows =
        items
            .whereType<Map<String, dynamic>>()
            .map(LoadedRow.fromLegacyItemJson)
            .toList();
    return DispatchLoadedData(loadedRows: loadedRows);
  }
}

String dispatchPopupMessage(Map<String, dynamic> envelope) {
  final data = envelope['data'];
  if (data is Map<String, dynamic>) {
    final popup = data['popup_message'] as String?;
    if (popup != null && popup.isNotEmpty) return popup;
  }
  return envelope['message'] as String? ?? 'Request failed';
}

bool isPalletQr(String qr) {
  final t = qr.trim().toUpperCase();
  return t.startsWith('FR-') || t.startsWith('SH-') || t.startsWith('CO-');
}
