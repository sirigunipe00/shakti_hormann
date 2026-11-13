import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/loading_confirmation/model/dispatch_loading.dart';
import 'package:shakti_hormann/features/loading_confirmation/model/item_model.dart';
import 'package:shakti_hormann/features/loading_confirmation/model/loading_cnfm.dart';
import 'package:shakti_hormann/features/loading_confirmation/model/logistic.dart';
import 'package:shakti_hormann/features/loading_confirmation/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/loading_confirmation/presentation/bloc/create_loading_cubit/create_loading_cnfm_cubit.dart';
import 'package:shakti_hormann/features/loading_confirmation/presentation/ui/create/sales_order_table.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/dailogs/app_dialogs.dart';
import 'package:shakti_hormann/widgets/dailogs/app_popup_card.dart';
import 'package:shakti_hormann/widgets/dailogs/app_snack_bar_widget.dart';
import 'package:shakti_hormann/widgets/inputs/new_upload_photo_widget.dart';
import 'package:shakti_hormann/widgets/scan/burst_scan_page.dart';
import 'package:shakti_hormann/widgets/scan/scan_outcome.dart';
import 'package:shakti_hormann/widgets/sectionheader.dart';
import 'package:shakti_hormann/widgets/spaced_column.dart';

class LoadingCnfmFormWidget extends StatefulWidget {
  const LoadingCnfmFormWidget({super.key});

  @override
  State<LoadingCnfmFormWidget> createState() => _LoadingCnfmFormWidget();
}

class _LoadingCnfmFormWidget extends State<LoadingCnfmFormWidget> {
  final ScrollController _scrollController = ScrollController();
  final focusNodes = List.generate(40, (index) => FocusNode());
  LoadingCnfmForm? loadingCnfmForm;
  DateTime? selectedDate;
  bool? isRejectedMode = false;

  @override
  Widget build(BuildContext context) {
    final formState = context.read<CreateLoadingCnfmCubit>().state;
    final newform = formState.form;
      final isLocked = newform.docstatus == 1 ||
      StringUtils.equalsIgnoreCase(newform.status ?? '', 'Rejected');
    $logger.devLog('.......$newform');

    return MultiBlocListener(
      listeners: [
        BlocListener<CreateLoadingCnfmCubit, CreateLaodingCnfmState>(
          listenWhen: (previous, current) {
            final prevStatus = previous.error?.status;
            final currStatus = current.error?.status;
            return prevStatus != currStatus;
          },
          listener: (context, state) {
            if (state.error != null) {
              // ScaffoldMessenger.of(
              //   context,
              // ).showSnackBar(SnackBar(content: Text(state.error!.error)));
            }
          },
        ),
      ],
      child: ColoredBox(
        color: const Color(0xFFF7F8FA),
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: ShellInsets.scrollPadding(context),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: SpacedColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            margin: const EdgeInsets.all(12.0),
            defaultHeight: 0,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 12.0, top: 4),
                child: SectionHeader(
                  title: 'Trip Summary',
                  assetIcon: 'assets/images/gateentryicon.svg',
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 6, 8, 0),
                child: _DispatchTripSummary(
                  form: newform,
                  arrivalTimeLabel: formatTime(newform.arrivalTime),
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.only(left: 12.0),
                child: SectionHeader(
                  title: 'Sales Orders',
                  assetIcon: 'assets/images/vehicleinvoicicon.svg',
                ),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: BlocBuilder<Logistic, LogisticState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                      loading: () => const Padding(
                        padding: EdgeInsets.all(20),
                        child: Center(
                          child: SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      ),
                      failure: (msg) => Text(
                        'Sales orders unavailable: $msg',
                        style: const TextStyle(
                          color: Color(0xFFC2410C),
                          fontSize: 12,
                          fontFamily: 'Urbanist',
                        ),
                      ),
                      success: (salesOrders) {
                        if (salesOrders.isNotEmpty) {
                          context.cubit<ItemList>().request(salesOrders);
                        }
                        return SalesOrderTables(salesOrders: salesOrders);
                      },
                      orElse: () => const SizedBox.shrink(),
                    );
                  },
                ),
              ),
              if (!isLocked) ...[
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: _DispatchReadinessBanner(
                    hasLoadedVehiclePhoto:
                        newform.loadedVehiclePhotoImg != null ||
                        (newform.loadedVehiclePhoto?.trim().isNotEmpty ??
                            false),
                  ),
                ),
              ],
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.only(left: 12.0),
                child: SectionHeader(
                  title: 'Photo',
                  assetIcon: 'assets/images/photoicon.svg',
                ),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: _DispatchPhotosCards(
                  driverIdUrl: newform.driverIdPhoto,
                  loadedVehicleUrl: newform.loadedVehiclePhoto,
                  loadedVehicleFile: newform.loadedVehiclePhotoImg,
                  isLocked: isLocked,
                  onCaptureLoadedVehicle: (file) {
                    context.cubit<CreateLoadingCnfmCubit>().onValueChanged(
                      loadedVehiclePhoto: file,
                    );
                  },
                ),
              ),

              const SizedBox(height: 12),
              BlocBuilder<GetLoadedList, GetLoadedState>(
                builder: (context, state) {
                  return state.maybeWhen(
                    orElse: () => const SizedBox(),
                    loading:
                        () => const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: CircularProgressIndicator(),
                          ),
                        ),
                    success: (data) {
                      return ItemLoadedTable(
                        dispatchData: data,
                        docstatus: formState.form.docstatus,
                        vrName: formState.form.name,
                        status: formState.form.status,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String? formatTime(String? backendTime) {
  if (backendTime == null || backendTime.isEmpty) return null;

  final parts = backendTime.split(':');
  if (parts.length < 2) return backendTime;

  return '${parts[0]}:${parts[1]}';
}

class ItemLoadedTable extends StatefulWidget {
  const ItemLoadedTable({
    super.key,
    required this.dispatchData,
    required this.docstatus,
    this.vrName,
    this.status,
  });
  final DispatchLoadedData dispatchData;
  final int? docstatus;
  final String? vrName;
  final String? status;

  @override
  State<ItemLoadedTable> createState() => _ItemLoadedTableState();
}

class _ItemLoadedTableState extends State<ItemLoadedTable> {
  final ImagePicker _picker = ImagePicker();
  List<Map<String, dynamic>> rows = [];
  late DispatchLoadedData _dispatchData;
  bool _isScanning = false;
  bool _isRefreshing = false;
  String? _activePalletQr;
  bool _cubitSeeded = false;
  final Map<String, String> _scannedLocalPhotos = {};
  String? _photoUploadingRowName;

bool get _canEdit {
  final result = widget.docstatus != 1 &&
      !_dispatchData.isDispatched &&
      !widget.status.toString().toLowerCase().contains('rejected');
  debugPrint('_canEdit check: docstatus=${widget.docstatus}, status="${widget.status}", isDispatched=${_dispatchData.isDispatched}, result=$result');
  return result;
}

      

  @override
  void initState() {
    super.initState();
    _dispatchData = widget.dispatchData;
    _applyDispatchData(widget.dispatchData, seedCubit: true);
  }

  @override
  void didUpdateWidget(covariant ItemLoadedTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dispatchData != widget.dispatchData) {
      _applyDispatchData(widget.dispatchData);
    }
  }

  void _applyDispatchData(DispatchLoadedData data, {bool seedCubit = false}) {
    final manualItems = data.toManualItems();
    setState(() {
      _dispatchData = data;
      rows =
          manualItems
              .map(
                (item) => {
                  'itemCode': item.itemCode,
                  'itemName': item.itemName,
                  'qty': item.qtyLoaded?.toString() ?? '',
                  'uom': item.uomValue,
                  'photo': item.loadedItemPhoto ?? '',
                },
              )
              .toList();
      _activePalletQr =
          data.lastScannedPallet ??
          (data.palletRows.isNotEmpty
              ? data.palletRows.last.scanQr
              : _activePalletQr);
    });
    context.read<CreateLoadingCnfmCubit>().updateScannedRows(data.scannedRows);

    if (seedCubit && !_cubitSeeded) {
      _cubitSeeded = true;
      for (final item in manualItems) {
        context.read<CreateLoadingCnfmCubit>().addInitialItem(item);
      }
    }
  }

  Future<void> _showSnack(String message, {bool isError = false}) async {
    if (!mounted) return;
    if (isError) {
      await AppDialog.showErrorDialog(
        context,
        title: 'Error',
        content: message,
        onTapDismiss: context.exit,
        buttonText: 'Okay',
      );
    } else {
      await AppDialog.showSuccessDialog(
        context,
        title: 'Success',
        content: message,
        onTapDismiss: context.exit,
        buttonText: 'Okay',
      );
    }
  }

  bool _scannedRowHasPhoto(LoadedRow row) {
    final rowName = row.itemRowName;
    if (rowName != null && _scannedLocalPhotos[rowName] != null) {
      return true;
    }
    final remote = row.loadedItemPhoto;
    return remote != null && remote.isNotEmpty;
  }

  LoadedRow? _scannedRowMissingPhoto() {
    for (final row in _dispatchData.scannedRows) {
      if (row.isDispatched) continue;
      if (!_scannedRowHasPhoto(row)) return row;
    }
    return null;
  }

  Future<void> _scanAndAddUnit() async {
    if (!_canEdit || _isScanning) return;

    final rowNeedingPhoto = _scannedRowMissingPhoto();
    if (rowNeedingPhoto != null) {
      final qr = rowNeedingPhoto.scanQr?.trim();
      _showSnack(
        qr != null && qr.isNotEmpty
            ? 'Please capture a photo for $qr before scanning another item.'
            : 'Please capture a photo for the scanned item before scanning another item.',
        isError: true,
      );
      return;
    }

    final vrName = widget.vrName;
    if (vrName == null || vrName.isEmpty) {
      _showSnack('Vehicle Reporting ID is missing.', isError: true);
      return;
    }

    setState(() => _isScanning = true);
    await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder:
            (_) => BurstScanPage(
              title: 'Multi-Scan Pallet / Box',
              hint: 'Keep scanning units — tap Stop when done',
              onValidate: (code) => _validateAndAddScannedUnit(vrName, code),
            ),
      ),
    );
    if (mounted) setState(() => _isScanning = false);
  }

  Future<ScanOutcome> _validateAndAddScannedUnit(
    String vrName,
    String scannedRaw,
  ) async {
    final scanned = scannedRaw.trim();
    if (scanned.isEmpty) {
      return const ScanOutcome.fail('Empty code');
    }

    final photoGate = _scannedRowMissingPhoto();
    if (photoGate != null) {
      final qr = photoGate.scanQr?.trim();
      return ScanOutcome.fail(
        qr != null && qr.isNotEmpty
            ? 'Capture photo for $qr before next scan'
            : 'Capture photo for last item before next scan',
        shouldStop: true,
      );
    }

    final repo = LoadingCnfmBlocProvider.get().repo;
    final parentPalletQr = isPalletQr(scanned) ? null : _activePalletQr;

    final lookup = await repo.scanUnitForDispatch(
      qr: scanned,
      vrName: vrName,
      parentPalletQr: parentPalletQr,
    );

    return await lookup.fold(
      (failure) async => ScanOutcome.fail(failure.error),
      (scanResult) async {
        if (scanResult.scannedOnThisVehicle) {
          return ScanOutcome.fail(
            scanResult.popupMessage ??
                'This unit is already scanned on this vehicle.',
          );
        }

        final item = <String, dynamic>{'scan_qr': scanned};
        if (!isPalletQr(scanned) &&
            parentPalletQr != null &&
            parentPalletQr.isNotEmpty) {
          item['parent_pallet_qr'] = parentPalletQr;
        }

        final addResult = await repo.updateScannedItems(vrName, [item]);
        return addResult.fold(
          (failure) => ScanOutcome.fail(failure.error),
          (data) {
            if (mounted) _applyDispatchData(data);
            final msg =
                data.popupMessage ??
                scanResult.popupMessage ??
                'Scanned successfully';
            // Loading requires a photo per unit before the next scan.
            final needsPhoto = _scannedRowMissingPhoto() != null;
            return ScanOutcome.ok(
              needsPhoto ? '$msg — capture photo next' : msg,
              shouldStop: needsPhoto,
            );
          },
        );
      },
    );
  }

  Future<void> _deleteScannedRow(String itemRowName) async {
    final vrName = widget.vrName;
    if (vrName == null || !_canEdit) return;

    final confirmed = await AppDialog.confirm(
      context,
      title: 'Remove scan?',
      content: 'Remove this scanned item from the vehicle loading?',
      confirmText: 'Remove',
      icon: Icons.delete_outline_rounded,
      iconBackground: const Color(0xFFFEE2E2),
      iconColor: const Color(0xFFE11D48),
      confirmIcon: Icons.delete_rounded,
      confirmColor: const Color(0xFFE11D48),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _isRefreshing = true);
    final response = await LoadingCnfmBlocProvider.get().repo
        .updateScannedItems(vrName, [
          {'item_row_name': itemRowName, 'action': 'delete'},
        ]);

    if (!mounted) return;
    response.fold(
      (failure) {
        setState(() => _isRefreshing = false);
        _showSnack(failure.error, isError: true);
      },
      (data) {
        setState(() => _isRefreshing = false);
        _applyDispatchData(data);
        _showSnack(data.popupMessage ?? 'Item removed.');
      },
    );
  }

  Future<void> _captureScannedPhoto(LoadedRow row) async {
    final vrName = widget.vrName;
    final rowName = row.itemRowName;
    if (!_canEdit || vrName == null || rowName == null || rowName.isEmpty) {
      return;
    }

    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo == null || !mounted) return;

    setState(() {
      _scannedLocalPhotos[rowName] = photo.path;
      _photoUploadingRowName = rowName;
    });

    String? base64Photo;
    try {
      final compressed = await FlutterImageCompress.compressWithFile(
        photo.path,
        quality: 50,
      );
      if (compressed != null) {
        base64Photo = base64Encode(compressed);
      }
    } catch (_) {
      base64Photo = null;
    }

    if (base64Photo == null) {
      if (!mounted) return;
      setState(() => _photoUploadingRowName = null);
      _showSnack('Could not process photo. Try again.', isError: true);
      return;
    }

    final response = await LoadingCnfmBlocProvider.get().repo
        .updateScannedItems(vrName, [
          {
            'item_row_name': rowName,
            'loaded_item_photo': base64Photo,
          },
        ]);

    if (!mounted) return;
    response.fold(
      (failure) {
        setState(() => _photoUploadingRowName = null);
        _showSnack(failure.error, isError: true);
      },
      (data) {
        setState(() => _photoUploadingRowName = null);
        _applyDispatchData(data);
        _showSnack(data.popupMessage ?? 'Photo saved.');
      },
    );
  }

  Future<void> _openCamera(int index) async {
    if (!_canEdit) return;
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        rows[index]['photo'] = photo.path;
      });

      final cubit = context.read<CreateLoadingCnfmCubit>();

      if (index < cubit.state.listitems.length) {
        final oldItem = cubit.state.listitems[index];

        final newItem = oldItem.copyWith(
          imageFile: File(photo.path),
          loadedItemPhoto: oldItem.loadedItemPhoto,
        );
        cubit.updateItem(index, newItem);
      }
    }
  }

  Future<void> addRow({int? index}) async {
    final initial = index != null ? rows[index] : null;
    final List<LogisticModel> salesorders = context
        .read<Logistic>()
        .state
        .maybeWhen(
          success: (orders) => orders,
          orElse: () => <LogisticModel>[],
        );

    final result = await showDialog(
      context: context,
      builder: (context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create:
                  (_) =>
                      LoadingCnfmBlocProvider.get().itemList()
                        ..request(salesorders),
            ),
            BlocProvider(
              create: (context) => context.read<CreateLoadingCnfmCubit>(),
              child: Container(),
            ),
          ],
          child: ItemDialogWidget(initialRow: initial),
        );
      },
    );

    if (result != null) {
      final row = result['row'] as Map<String, dynamic>;
      final lineItem = result['model'] as ItemModel;

      if (index != null) {
        final cubit = context.read<CreateLoadingCnfmCubit>();
        final oldItem = cubit.state.listitems[index];

        final updatedItem = oldItem.copyWith(
          itemCode: lineItem.itemCode ?? oldItem.itemCode,
          itemName: lineItem.itemName ?? oldItem.itemName,
          uomValue: lineItem.uomValue ?? oldItem.uomValue,
          qtyLoaded: lineItem.qtyLoaded ?? oldItem.qtyLoaded,
          sampleQuantity: lineItem.sampleQuantity ?? oldItem.sampleQuantity,
          loadedItemPhoto: lineItem.loadedItemPhoto ?? oldItem.loadedItemPhoto,
          imageFile: lineItem.imageFile,
        );

        setState(() {
          rows[index] = row;
        });

        cubit.updateItem(index, updatedItem);
      } else {
        setState(() {
          rows.add(row);
        });
        context.read<CreateLoadingCnfmCubit>().addItem(lineItem);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scannedRows = _dispatchData.scannedRows;
    final photoGate = _scannedRowMissingPhoto();
    final scanEnabled =
        _canEdit && photoGate == null && _photoUploadingRowName == null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Item Details',
          assetIcon: 'assets/images/remarksicon.svg',
        ),
        const SizedBox(height: 8),
        if (_canEdit) ...[
          if (photoGate != null)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7ED),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFDBA74)),
              ),
              child: Text(
                'Photo required for ${photoGate.scanQr ?? 'last scanned item'} before the next scan.',
                style: const TextStyle(
                  color: Color(0xFF9A3412),
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Urbanist',
                  fontSize: 13,
                ),
              ),
            ),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: scanEnabled && !_isScanning ? _scanAndAddUnit : null,
              icon:
                  _isScanning
                      ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.darkBlue,
                        ),
                      )
                      : const Icon(Icons.qr_code_scanner_rounded, size: 26),
              label: Text(
                _isScanning ? 'Opening scanner…' : 'Multi-Scan Pallet / Box',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  fontFamily: 'Urbanist',
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF2AB06),
                foregroundColor: AppColors.darkBlue,
                disabledBackgroundColor: Colors.grey.shade300,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Camera stays open. Validation runs before the next scan. Tap Stop when done.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontFamily: 'Urbanist',
            ),
          ),
          const SizedBox(height: 14),
        ],
        if (_isRefreshing)
          const Padding(
            padding: EdgeInsets.all(12),
            child: Center(child: CircularProgressIndicator()),
          ),
        _ScannedItemsTable(
          rows: scannedRows,
          canEdit: _canEdit,
          activePalletQr: _activePalletQr,
          localPhotos: _scannedLocalPhotos,
          photoUploadingRowName: _photoUploadingRowName,
          onSelectPallet: (qr) => setState(() => _activePalletQr = qr),
          onDelete: _deleteScannedRow,
          onCapturePhoto: _captureScannedPhoto,
          buildPhoto: (path) => _buildImage(path, context: context),
        ),
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'Manual Items',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 18,
              color: AppColors.darkBlue,
              fontFamily: 'Urbanist',
            ),
          ),
        ),
        _ManualItemsTable(
          rows: rows,
          canEdit: _canEdit,
          onEdit: (index) => addRow(index: index),
          onCamera: _openCamera,
          buildPhoto: (path) => _buildImage(path, context: context),
        ),
        if (_canEdit && photoGate == null && _photoUploadingRowName == null) ...[
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: Material(
              color: const Color(0xFFF2A93E),
              borderRadius: BorderRadius.circular(28),
              child: InkWell(
                onTap: () => addRow(),
                borderRadius: BorderRadius.circular(28),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, color: AppColors.darkBlue, size: 22),
                      SizedBox(width: 6),
                      Text(
                        'Add Item',
                        style: TextStyle(
                          color: AppColors.darkBlue,
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          fontFamily: 'Urbanist',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
        const SizedBox(height: 8),
      ],
    );
  }
}


const _ink = Color(0xFF0E1446);
const _muted = Color(0xFF6B7280);
const _lineColor = Color(0xFFE6EAF2);
const _headerBlue = Color(0xFF0E2A5C);

class _DispatchTripSummary extends StatelessWidget {
  const _DispatchTripSummary({
    required this.form,
    required this.arrivalTimeLabel,
  });

  final LoadingCnfmForm form;
  final String? arrivalTimeLabel;

  String get _transporter => [
        form.transporterName,
        form.transporterName2,
      ].where((e) => e != null && e.trim().isNotEmpty).join(' - ');

  String get _vreDate =>
      DFU.ddMMyyyyFromStr(form.vehicleReportingEntryVreDate ?? '');

  String get _arrivalDate => DFU.ddMMyyyyFromStr(form.arrivalDate ?? '');

  @override
  Widget build(BuildContext context) {
    final vehicle = form.vehicleNumber?.trim().isNotEmpty == true
        ? form.vehicleNumber!.trim()
        : '—';
    final lr = form.linkedTransporterConfirmation?.trim().isNotEmpty == true
        ? form.linkedTransporterConfirmation!.trim()
        : '—';

    return Card(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE8ECF4)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: false,
          tilePadding: const EdgeInsets.fromLTRB(14, 4, 10, 4),
          childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
          leading: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF4FB),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.local_shipping_outlined,
              size: 18,
              color: Color(0xFF2957A4),
            ),
          ),
          title: Text(
            '$vehicle  ·  $lr',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _ink,
              fontSize: 14,
              fontWeight: FontWeight.w800,
              fontFamily: 'Urbanist',
            ),
          ),
          subtitle: Text(
            [
              if (_vreDate.isNotEmpty) _vreDate,
              'Tap to view trip details',
            ].join('  ·  '),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _muted,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              fontFamily: 'Urbanist',
            ),
          ),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.lock_outline, size: 13, color: _muted),
                    SizedBox(width: 4),
                    Text(
                      'Read-only from Vehicle Reporting',
                      style: TextStyle(
                        color: _muted,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Urbanist',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            _infoTile(
              icon: Icons.factory_outlined,
              label: 'Plant',
              value: form.plantName,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _infoTile(
                    icon: Icons.local_shipping_outlined,
                    label: 'LR No',
                    value: form.linkedTransporterConfirmation,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _infoTile(
                    icon: Icons.calendar_month_outlined,
                    label: 'VRE Date',
                    value: _vreDate,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _infoTile(
              icon: Icons.business_outlined,
              label: 'Transporter',
              value: _transporter.isEmpty ? null : _transporter,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _infoTile(
                    icon: Icons.directions_car_outlined,
                    label: 'Vehicle',
                    value: form.vehicleNumber,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _infoTile(
                    icon: Icons.call_outlined,
                    label: 'Driver contact',
                    value: form.driverContact,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _infoTile(
                    icon: Icons.event_available_outlined,
                    label: 'Arrival date',
                    value: _arrivalDate,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _infoTile(
                    icon: Icons.schedule_outlined,
                    label: 'Arrival time',
                    value: arrivalTimeLabel,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile({
    required IconData icon,
    required String label,
    required String? value,
  }) {
    final display = (value == null || value.trim().isEmpty) ? '—' : value.trim();
    return Semantics(
      label: '$label: $display',
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFD),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE8ECF4)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 16, color: const Color(0xFF2957A4)),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: _muted,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Urbanist',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    display,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: _ink,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Urbanist',
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DispatchReadinessBanner extends StatelessWidget {
  const _DispatchReadinessBanner({
    required this.hasLoadedVehiclePhoto,
  });

  final bool hasLoadedVehiclePhoto;

  @override
  Widget build(BuildContext context) {
    if (hasLoadedVehiclePhoto) {
      return Semantics(
        liveRegion: true,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFECFDF3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFBBF7D0)),
          ),
          child: const Row(
            children: [
              Icon(Icons.check_circle_outline, size: 18, color: Color(0xFF15803D)),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Loaded vehicle photo ready. Scan items, then Submit.',
                  style: TextStyle(
                    color: Color(0xFF166534),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Urbanist',
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Semantics(
      liveRegion: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF7ED),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFFED7AA)),
        ),
        child: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, size: 18, color: Color(0xFFC2410C)),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Required: capture Loaded Vehicle Photo before Submit. Item photos are required after each scan.',
                style: TextStyle(
                  color: Color(0xFF9A3412),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Urbanist',
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DispatchPhotosCards extends StatelessWidget {
  const _DispatchPhotosCards({
    required this.driverIdUrl,
    required this.loadedVehicleUrl,
    required this.loadedVehicleFile,
    required this.isLocked,
    required this.onCaptureLoadedVehicle,
  });

  final String? driverIdUrl;
  final String? loadedVehicleUrl;
  final File? loadedVehicleFile;
  final bool isLocked;
  final ValueChanged<File> onCaptureLoadedVehicle;

  bool get _hasDriverId =>
      driverIdUrl != null && driverIdUrl!.trim().isNotEmpty;

  bool get _hasLoadedVehicle =>
      loadedVehicleFile != null ||
      (loadedVehicleUrl != null && loadedVehicleUrl!.trim().isNotEmpty);

  String _fullUrl(String? url) {
    if (url == null || url.isEmpty) return '';
    if (url.startsWith('http://') || url.startsWith('https://')) return url;
    final base = Urls.baseUrl.replaceAll('/api', '');
    return '$base$url';
  }

  Future<void> _openPreview(
    BuildContext context, {
    required String title,
    String? imageUrl,
    File? image,
    required bool readOnly,
    Future<void> Function()? onRetake,
  }) async {
    await context.goToPage(
      ImagePreviewPage(
        title: title,
        imageUrl: imageUrl,
        image: image,
        isReadOnly: readOnly,
        onRetake: () async {
          Navigator.pop(context);
          if (onRetake != null) await onRetake();
        },
        onDone: () => Navigator.pop(context),
      ),
    );
  }

  Future<void> _captureVehicle(BuildContext context) async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 45,
      );
      if (picked == null) return;
      onCaptureLoadedVehicle(File(picked.path));
    } catch (e) {
      debugPrint('Loaded vehicle capture failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8ECF4)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0E1446).withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _photoCard(
              context: context,
              title: 'Driver ID Proof',
              subtitle: 'From Vehicle Reporting',
              required: false,
              locked: true,
              hasPhoto: _hasDriverId,
              accent: const Color(0xFF3681F2),
              soft: const Color(0xFFE8F0FE),
              icon: Icons.badge_outlined,
              onTap: _hasDriverId
                  ? () => _openPreview(
                        context,
                        title: 'Driver ID Proof',
                        imageUrl: driverIdUrl,
                        readOnly: true,
                      )
                  : null,
              thumb: _hasDriverId ? _networkThumb(driverIdUrl!) : null,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _photoCard(
              context: context,
              title: 'Loaded Vehicle',
              subtitle: isLocked
                  ? 'Locked after submit'
                  : 'Required before submit',
              required: true,
              locked: isLocked,
              hasPhoto: _hasLoadedVehicle,
              accent: const Color(0xFF0D9488),
              soft: const Color(0xFFE6F7F5),
              icon: Icons.local_shipping_outlined,
              onTap: _hasLoadedVehicle
                  ? () => _openPreview(
                        context,
                        title: 'Loaded Vehicle Photo',
                        imageUrl:
                            loadedVehicleFile == null ? loadedVehicleUrl : null,
                        image: loadedVehicleFile,
                        readOnly: isLocked,
                        onRetake:
                            isLocked ? null : () => _captureVehicle(context),
                      )
                  : (isLocked ? null : () => _captureVehicle(context)),
              thumb: _hasLoadedVehicle
                  ? (loadedVehicleFile != null
                      ? Image.file(loadedVehicleFile!, fit: BoxFit.cover)
                      : _networkThumb(loadedVehicleUrl!))
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _photoCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required bool required,
    required bool locked,
    required bool hasPhoto,
    required Color accent,
    required Color soft,
    required IconData icon,
    required VoidCallback? onTap,
    required Widget? thumb,
  }) {
    final status = hasPhoto
        ? 'Captured'
        : (required ? 'Required' : 'Missing');
    final statusColor = hasPhoto
        ? const Color(0xFF15803D)
        : (required ? const Color(0xFFC2410C) : _muted);

    return Material(
      color: soft,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: !hasPhoto && required
                  ? const Color(0xFFFDBA74)
                  : soft,
            ),
          ),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: accent.withValues(alpha: 0.25)),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: thumb ??
                        Icon(icon, size: 22, color: accent),
                  ),
                  if (locked)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.lock_outline,
                          size: 10,
                          color: _muted,
                        ),
                      ),
                    )
                  else if (!hasPhoto)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: accent,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          size: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: title,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Urbanist',
                  ),
                  children: [
                    if (required)
                      const TextSpan(
                        text: ' *',
                        style: TextStyle(
                          color: Color(0xFFD64545),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 1),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _muted,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Urbanist',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Urbanist',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _networkThumb(String url) {
    return Image.network(
      _fullUrl(url),
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return const Center(
          child: SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },
      errorBuilder: (_, __, ___) => Icon(
        Icons.broken_image_outlined,
        size: 28,
        color: Colors.grey.shade400,
      ),
    );
  }
}

class _DispatchActionIcon extends StatelessWidget {
  const _DispatchActionIcon({
    required this.icon,
    required this.color,
    required this.background,
    required this.tooltip,
    this.onPressed,
  });

  final IconData icon;
  final Color color;
  final Color background;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(icon, color: color, size: 18),
          ),
        ),
      ),
    );
  }
}

class _ManualItemsTable extends StatelessWidget {
  const _ManualItemsTable({
    required this.rows,
    required this.canEdit,
    required this.onEdit,
    required this.onCamera,
    required this.buildPhoto,
  });

  final List<Map<String, dynamic>> rows;
  final bool canEdit;
  final void Function(int index) onEdit;
  final void Function(int index) onCamera;
  final Widget Function(String path) buildPhoto;

  /// #, Code, Name, Qty, UOM, Photo, Edit?
  static const _flexEdit = [2, 3, 5, 2, 2, 2, 2];
  static const _flexView = [2, 4, 6, 2, 2, 2];

  List<int> get _flexes => canEdit ? _flexEdit : _flexView;

  @override
  Widget build(BuildContext context) {
    final headers = [
      'Item\nCode',
      'Item Name',
      'Qty',
      'UOM',
      'Photo',
      if (canEdit) 'Edit',
    ];

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE8ECF4)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0E1446).withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _headerRow(headers),
          if (rows.isEmpty)
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 28, 20, 28),
              child: Column(
                children: [
                  Icon(Icons.inventory_2_outlined, size: 32, color: Color(0xFF6B849F)),
                  SizedBox(height: 10),
                  Text(
                    'No manual items yet',
                    style: TextStyle(
                      color: _ink,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Urbanist',
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Use Add Item when a unit cannot be scanned.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _muted,
                      fontSize: 13,
                      fontFamily: 'Urbanist',
                    ),
                  ),
                ],
              ),
            )
          else
            for (var i = 0; i < rows.length; i++)
              _dataRow(
                index: i,
                isLast: i == rows.length - 1,
                isAlt: i.isOdd,
              ),
        ],
      ),
    );
  }

  Widget _headerRow(List<String> headers) {
    return _rowShell(
      isHeader: true,
      isLast: false,
      isAlt: false,
      children: [
        _serialCell(null, isHeader: true),
        for (var col = 0; col < headers.length; col++) ...[
          _vDivider(isHeader: true),
          Expanded(
            flex: _flexes[col + 1],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
              child: Center(
                child: Text(
                  headers[col],
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    fontFamily: 'Urbanist',
                    height: 1.2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _dataRow({
    required int index,
    required bool isLast,
    required bool isAlt,
  }) {
    final row = rows[index];
    final photo = row['photo'] as String?;
    final hasPhoto = photo != null && photo.isNotEmpty;

    Widget photoCell() {
      if (hasPhoto) {
        return Center(child: buildPhoto(photo));
      }
      if (canEdit) {
        return Center(
          child: _DispatchActionIcon(
            tooltip: 'Capture photo',
            icon: Icons.camera_alt_outlined,
            color: const Color(0xFF2957A4),
            background: const Color(0xFFE8F0FB),
            onPressed: () => onCamera(index),
          ),
        );
      }
      return const Center(
        child: Text('N/A', style: TextStyle(fontSize: 12, color: _muted)),
      );
    }

    return _rowShell(
      isHeader: false,
      isLast: isLast,
      isAlt: isAlt,
      children: [
        _serialCell(index + 1, isHeader: false),
        _vDivider(isHeader: false),
        _textCell(row['itemCode']?.toString() ?? '-', _flexes[1]),
        _vDivider(isHeader: false),
        _textCell(row['itemName']?.toString() ?? '-', _flexes[2], maxLines: 2),
        _vDivider(isHeader: false),
        _textCell(row['qty']?.toString() ?? '-', _flexes[3]),
        _vDivider(isHeader: false),
        _textCell(row['uom']?.toString() ?? '-', _flexes[4]),
        _vDivider(isHeader: false),
        Expanded(flex: _flexes[5], child: photoCell()),
        if (canEdit) ...[
          _vDivider(isHeader: false),
          Expanded(
            flex: _flexes[6],
            child: Center(
              child: _DispatchActionIcon(
                tooltip: 'Edit item',
                icon: Icons.edit_outlined,
                color: const Color(0xFF2957A4),
                background: const Color(0xFFE8F0FB),
                onPressed: () => onEdit(index),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _serialCell(int? n, {required bool isHeader}) {
    return Expanded(
      flex: _flexes.first,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
        child: Center(
          child: isHeader
              ? const Text(
                  '#',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    fontFamily: 'Urbanist',
                  ),
                )
              : Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF4FB),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    n!.toString().padLeft(2, '0'),
                    style: const TextStyle(
                      color: Color(0xFF2957A4),
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Urbanist',
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _textCell(String text, int flex, {int maxLines = 1}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _ink,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: 'Urbanist',
            ),
          ),
        ),
      ),
    );
  }

  Widget _vDivider({required bool isHeader}) {
    return Container(
      width: 1,
      color: isHeader ? Colors.white.withValues(alpha: 0.18) : _lineColor,
    );
  }

  Widget _rowShell({
    required bool isHeader,
    required bool isLast,
    required bool isAlt,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isHeader
            ? _headerBlue
            : (isAlt ? const Color(0xFFF8FAFD) : Colors.white),
        border: isLast || isHeader
            ? null
            : const Border(bottom: BorderSide(color: _lineColor)),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    );
  }
}

class _ScannedItemsTable extends StatelessWidget {
  const _ScannedItemsTable({
    required this.rows,
    required this.canEdit,
    required this.activePalletQr,
    required this.localPhotos,
    this.photoUploadingRowName,
    required this.onSelectPallet,
    required this.onDelete,
    required this.onCapturePhoto,
    required this.buildPhoto,
  });

  final List<LoadedRow> rows;
  final bool canEdit;
  final String? activePalletQr;
  final Map<String, String> localPhotos;
  final String? photoUploadingRowName;
  final void Function(String qr) onSelectPallet;
  final void Function(String itemRowName) onDelete;
  final void Function(LoadedRow row) onCapturePhoto;
  final Widget Function(String path) buildPhoto;

  /// #, QR, Product, Size, Qty, Photo, Del?
  static const _flexEdit = [2, 5, 3, 2, 2, 2, 2];
  static const _flexView = [2, 5, 3, 3, 2, 2];

  List<int> get _flexes => canEdit ? _flexEdit : _flexView;

  String? _photoPath(LoadedRow row) {
    final rowName = row.itemRowName;
    if (rowName != null && localPhotos[rowName] != null) {
      return localPhotos[rowName];
    }
    final remote = row.loadedItemPhoto;
    if (remote != null && remote.isNotEmpty) return remote;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final headers = [
      'Scan QR',
      'Product',
      'Size',
      'Qty',
      'Photo',
      if (canEdit) 'Del',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            'Scanned Items (${rows.length})',
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 18,
              color: AppColors.darkBlue,
              fontFamily: 'Urbanist',
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            border: Border.all(color: const Color(0xFFE8ECF4)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0E1446).withValues(alpha: 0.05),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _headerRow(headers),
              if (rows.isEmpty)
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 28, 20, 28),
                  child: Column(
                    children: [
                      Icon(Icons.qr_code_scanner_rounded, size: 32, color: Color(0xFF6B849F)),
                      SizedBox(height: 10),
                      Text(
                        'No scanned items yet',
                        style: TextStyle(
                          color: _ink,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Urbanist',
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Tap Multi-Scan Pallet / Box to load units.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _muted,
                          fontSize: 13,
                          fontFamily: 'Urbanist',
                        ),
                      ),
                    ],
                  ),
                )
              else
                for (var i = 0; i < rows.length; i++)
                  _dataRow(
                    index: i,
                    isLast: i == rows.length - 1,
                    isAlt: i.isOdd,
                  ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _headerRow(List<String> headers) {
    return _rowShell(
      isHeader: true,
      isLast: false,
      isAlt: false,
      highlight: false,
      children: [
        _serialCell(null, isHeader: true),
        for (var col = 0; col < headers.length; col++) ...[
          _vDivider(isHeader: true),
          Expanded(
            flex: _flexes[col + 1],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
              child: Center(
                child: Text(
                  headers[col],
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    fontFamily: 'Urbanist',
                    height: 1.2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _dataRow({
    required int index,
    required bool isLast,
    required bool isAlt,
  }) {
    final row = rows[index];
    final isPallet = row.isPallet;
    final isActive = isPallet && activePalletQr == row.scanQr;
    final photoPath = _photoPath(row);
    final hasPhoto = photoPath != null && photoPath.isNotEmpty;
    final needsPhoto = canEdit && !row.isDispatched && !hasPhoto;
    final isPhotoUploading =
        row.itemRowName != null && row.itemRowName == photoUploadingRowName;

    Widget photoCell() {
      if (isPhotoUploading) {
        return const Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      }
      if (hasPhoto) {
        return Center(
          child: GestureDetector(
            onTap: canEdit && !row.isDispatched
                ? () => onCapturePhoto(row)
                : null,
            child: buildPhoto(photoPath),
          ),
        );
      }
      if (canEdit && !row.isDispatched) {
        return Center(
          child: _DispatchActionIcon(
            tooltip: needsPhoto ? 'Photo required' : 'Capture photo',
            icon: Icons.camera_alt_outlined,
            color: needsPhoto ? const Color(0xFFC2410C) : const Color(0xFF2957A4),
            background: needsPhoto
                ? const Color(0xFFFFF1E6)
                : const Color(0xFFE8F0FB),
            onPressed: () => onCapturePhoto(row),
          ),
        );
      }
      return const Center(
        child: Text('N/A', style: TextStyle(fontSize: 12, color: _muted)),
      );
    }

    return GestureDetector(
      onTap: isPallet && row.scanQr != null
          ? () => onSelectPallet(row.scanQr!)
          : null,
      child: _rowShell(
        isHeader: false,
        isLast: isLast,
        isAlt: isAlt,
        highlight: isActive || needsPhoto,
        highlightColor: needsPhoto
            ? const Color(0xFFFFF7ED)
            : AppColors.darkBlue.withValues(alpha: 0.06),
        children: [
          _serialCell(index + 1, isHeader: false, pallet: isPallet),
          _vDivider(isHeader: false),
          _textCell(row.scanQr ?? '-', _flexes[1], maxLines: 2),
          _vDivider(isHeader: false),
          _textCell(row.productType ?? '-', _flexes[2]),
          _vDivider(isHeader: false),
          _textCell(
            (row.palletSize == null || row.palletSize == '-')
                ? '-'
                : row.palletSize!,
            _flexes[3],
          ),
          _vDivider(isHeader: false),
          _textCell(row.qtyLoaded?.toString() ?? '-', _flexes[4]),
          _vDivider(isHeader: false),
          Expanded(flex: _flexes[5], child: photoCell()),
          if (canEdit) ...[
            _vDivider(isHeader: false),
            Expanded(
              flex: _flexes[6],
              child: Center(
                child: (row.itemRowName ?? '').isNotEmpty && !row.isDispatched
                    ? _DispatchActionIcon(
                        tooltip: 'Remove',
                        icon: Icons.delete_outline_rounded,
                        color: const Color(0xFFD64545),
                        background: const Color(0xFFFDECEC),
                        onPressed: () => onDelete(row.itemRowName!),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _serialCell(int? n, {required bool isHeader, bool pallet = false}) {
    return Expanded(
      flex: _flexes.first,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
        child: Center(
          child: isHeader
              ? const Text(
                  '#',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    fontFamily: 'Urbanist',
                  ),
                )
              : Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: pallet
                        ? AppColors.darkBlue
                        : const Color(0xFFEFF4FB),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    n!.toString().padLeft(2, '0'),
                    style: TextStyle(
                      color: pallet ? Colors.white : const Color(0xFF2957A4),
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Urbanist',
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _textCell(String text, int flex, {int maxLines = 1}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _ink,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              fontFamily: 'Urbanist',
            ),
          ),
        ),
      ),
    );
  }

  Widget _vDivider({required bool isHeader}) {
    return Container(
      width: 1,
      color: isHeader ? Colors.white.withValues(alpha: 0.18) : _lineColor,
    );
  }

  Widget _rowShell({
    required bool isHeader,
    required bool isLast,
    required bool isAlt,
    required bool highlight,
    Color? highlightColor,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isHeader
            ? _headerBlue
            : highlight
                ? (highlightColor ?? const Color(0xFFF8FAFD))
                : (isAlt ? const Color(0xFFF8FAFD) : Colors.white),
        border: isLast || isHeader
            ? null
            : const Border(bottom: BorderSide(color: _lineColor)),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    );
  }
}

Widget _buildImage(String path, {BuildContext? context}) {
  final baseUrl = Urls.baseUrl.replaceAll('/api', '');

  Widget imageWidget;
  Widget photoLoadingPlaceholder() => const SizedBox(
    width: 50,
    height: 50,
    child: Center(
      child: SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    ),
  );


  if (File(path).existsSync()) {
    imageWidget = Image.file(
      File(path),
      width: 50,
      height: 50,
      fit: BoxFit.cover,
    );
  } else if (path.startsWith('/files/')) {
    imageWidget = Image.network(
      '$baseUrl$path',
      width: 50,
      height: 50,
      fit: BoxFit.cover,
       loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return photoLoadingPlaceholder();
      },
      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
    );
  } else if (path.startsWith('http')) {
    imageWidget = Image.network(
      path,
      width: 50,
      height: 50,
      fit: BoxFit.cover,
       loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return photoLoadingPlaceholder();
      },
      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
    );
  } else {
    imageWidget = const Icon(Icons.broken_image);
  }

  return GestureDetector(
    onTap:
        context == null
            ? null
            : () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ImageViewScreen(imagePath: path),
                ),
              );
            },
    child: ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: imageWidget,
    ),
  );
}

class _ItemCodeSelectField extends StatefulWidget {
  const _ItemCodeSelectField({
    required this.items,
    required this.isLoading,
    required this.selected,
    required this.onSelected,
  });

  final List<ItemModel> items;
  final bool isLoading;
  final ItemModel? selected;
  final ValueChanged<ItemModel> onSelected;

  @override
  State<_ItemCodeSelectField> createState() => _ItemCodeSelectFieldState();
}

class _ItemCodeSelectFieldState extends State<_ItemCodeSelectField> {
  bool _expanded = false;
  late final TextEditingController _search;
  late List<ItemModel> _filtered;

  @override
  void initState() {
    super.initState();
    _search = TextEditingController();
    _filtered = widget.items;
  }

  @override
  void didUpdateWidget(covariant _ItemCodeSelectField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items) {
      _applyFilter(_search.text);
    }
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _applyFilter(String query) {
    final q = query.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        _filtered = widget.items;
      } else {
        _filtered = widget.items.where((item) {
          final code = (item.itemCode ?? item.name ?? '').toLowerCase();
          final name = (item.itemName ?? '').toLowerCase();
          final uom = (item.uomValue ?? '').toLowerCase();
          return code.contains(q) || name.contains(q) || uom.contains(q);
        }).toList();
      }
    });
  }

  void _toggle() {
    setState(() {
      _expanded = !_expanded;
      if (!_expanded) {
        _search.clear();
        _filtered = widget.items;
      }
    });
  }

  void _select(ItemModel item) {
    widget.onSelected(item);
    setState(() {
      _expanded = false;
      _search.clear();
      _filtered = widget.items;
    });
  }

  String get _selectedCode =>
      widget.selected?.itemCode ?? widget.selected?.name ?? '';

  @override
  Widget build(BuildContext context) {
    final hasValue = _selectedCode.isNotEmpty;
    final borderColor = _expanded
        ? const Color(0xFF2957A4)
        : const Color(0xFFE2E8F0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: const TextSpan(
            text: 'Item Code',
            style: TextStyle(
              color: _ink,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              fontFamily: 'Urbanist',
            ),
            children: [
              TextSpan(
                text: ' *',
                style: TextStyle(
                  color: Color(0xFFD64545),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor, width: 1.2),
            boxShadow: _expanded
                ? [
                    BoxShadow(
                      color: const Color(0xFF0E1446).withValues(alpha: 0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Column(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: widget.isLoading ? null : _toggle,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF4FB),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            hasValue
                                ? Icons.qr_code_2_rounded
                                : Icons.search_rounded,
                            size: 18,
                            color: const Color(0xFF2957A4),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: widget.isLoading
                              ? const Text(
                                  'Loading items…',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: _muted,
                                    fontFamily: 'Urbanist',
                                  ),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      hasValue
                                          ? _selectedCode
                                          : 'Search & select item code',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: hasValue
                                            ? FontWeight.w800
                                            : FontWeight.w500,
                                        color: hasValue ? _ink : _muted,
                                        fontFamily: 'Urbanist',
                                      ),
                                    ),
                                    if (hasValue &&
                                        (widget.selected?.itemName ?? '')
                                            .isNotEmpty) ...[
                                      const SizedBox(height: 2),
                                      Text(
                                        widget.selected!.itemName!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: _muted,
                                          fontFamily: 'Urbanist',
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                        ),
                        if (widget.isLoading)
                          const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        else
                          AnimatedRotation(
                            turns: _expanded ? 0.5 : 0,
                            duration: const Duration(milliseconds: 180),
                            child: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: _muted,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              if (_expanded) ...[
                const Divider(height: 1, color: Color(0xFFE8ECF4)),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 6),
                  child: TextField(
                    controller: _search,
                    autofocus: true,
                    onChanged: _applyFilter,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Type code or name…',
                      hintStyle: const TextStyle(
                        color: _muted,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Urbanist',
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        size: 18,
                        color: _muted,
                      ),
                      suffixIcon: _search.text.isEmpty
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.close_rounded, size: 18),
                              color: _muted,
                              onPressed: () {
                                _search.clear();
                                _applyFilter('');
                              },
                            ),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFD),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Builder(
                  builder: (context) {
                    final keyboard = MediaQuery.viewInsetsOf(context).bottom;
                    final maxListHeight = keyboard > 0 ? 120.0 : 180.0;
                    return ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: maxListHeight),
                  child: _filtered.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
                          child: Text(
                            'No matching items',
                            style: TextStyle(
                              color: _muted,
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
                          itemCount: _filtered.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 4),
                          itemBuilder: (context, index) {
                            final item = _filtered[index];
                            final code = item.itemCode ?? item.name ?? '—';
                            final selected = code == _selectedCode;
                            return Material(
                              color: selected
                                  ? const Color(0xFFFFF4E4)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () => _select(item),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 10,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 34,
                                        height: 34,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: selected
                                              ? const Color(0xFFF2A93E)
                                              : const Color(0xFFEFF4FB),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          code.length <= 2
                                              ? code
                                              : code.substring(
                                                  code.length - 2,
                                                ),
                                          style: TextStyle(
                                            color: selected
                                                ? Colors.white
                                                : const Color(0xFF2957A4),
                                            fontSize: 11,
                                            fontWeight: FontWeight.w800,
                                            fontFamily: 'Urbanist',
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              code,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w800,
                                                color: _ink,
                                                fontFamily: 'Urbanist',
                                              ),
                                            ),
                                            if ((item.itemName ?? '')
                                                .isNotEmpty) ...[
                                              const SizedBox(height: 2),
                                              Text(
                                                item.itemName!,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  color: _muted,
                                                  fontFamily: 'Urbanist',
                                                ),
                                              ),
                                            ],
                                            const SizedBox(height: 2),
                                            Text(
                                              'UOM ${item.uomValue ?? '—'}  ·  Qty ${item.qty ?? '—'}',
                                              style: const TextStyle(
                                                fontSize: 10,
                                                color: _muted,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'Urbanist',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (selected)
                                        const Icon(
                                          Icons.check_circle_rounded,
                                          size: 18,
                                          color: Color(0xFFF2A93E),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class ItemDialogWidget extends StatefulWidget {
  const ItemDialogWidget({super.key, this.initialRow});
  final Map<String, dynamic>? initialRow;

  @override
  State<ItemDialogWidget> createState() => _ItemDialogWidgetState();
}

class _ItemDialogWidgetState extends State<ItemDialogWidget> {
  final ImagePicker _picker = ImagePicker();

  ItemModel? itemFrom;
  File? photoFile;

  late TextEditingController itemNameController;
  late TextEditingController uomController;
  late TextEditingController qtyController;

  String? selectedCode;
  String? photoPath;

  @override
  void initState() {
    super.initState();

    selectedCode = widget.initialRow?['itemCode'];
    itemNameController = TextEditingController(
      text: widget.initialRow?['itemName'] ?? '',
    );
    uomController = TextEditingController(
      text: widget.initialRow?['uom'] ?? '',
    );
    qtyController = TextEditingController(
      text: widget.initialRow?['qty'] ?? '',
    );
    photoPath = widget.initialRow?['photo'];

    if (selectedCode != null) {
      itemFrom = ItemModel(
        itemCode: selectedCode,
        itemName: widget.initialRow?['itemName'],
        uomValue: widget.initialRow?['uom'],
        qty: int.tryParse(widget.initialRow?['qty'] ?? '0'),
      );
    }
  }

  @override
  void dispose() {
    itemNameController.dispose();
    uomController.dispose();
    qtyController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        photoPath = photo.path;
        photoFile = File(photo.path);
      });
    }
  }

  InputDecoration _fieldDecoration({
    required String label,
    bool required = false,
    String? hint,
    Widget? prefix,
    Widget? suffix,
  }) {
    return InputDecoration(
      label: RichText(
        text: TextSpan(
          text: label,
          style: const TextStyle(
            color: _ink,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            fontFamily: 'Urbanist',
          ),
          children: [
            if (required)
              const TextSpan(
                text: ' *',
                style: TextStyle(
                  color: Color(0xFFD64545),
                  fontWeight: FontWeight.w900,
                ),
              ),
          ],
        ),
      ),
      hintText: hint,
      hintStyle: const TextStyle(
        color: _muted,
        fontSize: 13,
        fontFamily: 'Urbanist',
      ),
      filled: true,
      fillColor: const Color(0xFFF8FAFD),
      prefixIcon: prefix,
      suffixIcon: suffix,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF2957A4), width: 1.4),
      ),
    );
  }

  void _onSave() {
    if (selectedCode == null || selectedCode!.trim().isEmpty) {
      context.showSnackbar(
        'Please select an Item Code',
        AppSnackBarType.error,
      );
      return;
    }

    final qtyText = qtyController.text.trim();
    final qtyValue = double.tryParse(qtyText);

    if (qtyValue == null || qtyValue <= 0) {
      context.showSnackbar(
        'Quantity Loaded must be greater than 0',
        AppSnackBarType.error,
      );
      return;
    }

    final row = {
      'itemCode': selectedCode,
      'itemName': itemNameController.text,
      'uom': uomController.text,
      'qty': qtyValue.toString(),
      'photo': photoFile != null ? photoFile!.path : photoPath,
    };

    final lineItem = ItemModel(
      itemCode: selectedCode,
      itemName: itemNameController.text,
      uomValue: uomController.text,
      sampleQuantity: qtyValue.toInt(),
      stockUom: uomController.text,
      imageFile: photoFile,
      loadedItemPhoto: photoFile != null ? null : photoPath,
    );

    Navigator.pop(context, {'row': row, 'model': lineItem});
  }

  @override
  Widget build(BuildContext context) {
    final hasPhoto = photoPath != null && photoPath!.trim().isNotEmpty;

    return AppFormDialogShell(
      title: 'Add / Edit Item',
      subtitle: 'Search item code, confirm quantity, then save.',
      icon: Icons.inventory_2_outlined,
      iconBackground: const Color(0xFFE8F0FE),
      iconColor: AppColors.darkBlue,
      maxWidth: 360,
      onClose: () => Navigator.pop(context),
      cancelText: 'Cancel',
      cancelIsDestructive: false,
      onCancel: () => Navigator.pop(context),
      confirmText: 'Save Item',
      confirmIcon: Icons.check_rounded,
      confirmColor: AppColors.darkBlue,
      onConfirm: _onSave,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BlocBuilder<ItemList, ItemState>(
            builder: (_, state) {
              final allData = state.maybeWhen(
                orElse: () => <ItemModel>[],
                success: (data) => data,
              );

              return _ItemCodeSelectField(
                items: allData,
                isLoading: state.isLoading,
                selected: itemFrom,
                onSelected: (selected) {
                  setState(() {
                    itemFrom = selected;
                    selectedCode = selected.itemCode ?? selected.name;
                    itemNameController.text = selected.itemName ?? '';
                    uomController.text = selected.uomValue ?? '';
                    qtyController.text = (selected.qty ?? 0).toString();
                  });
                },
              );
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            readOnly: true,
            controller: itemNameController,
            style: const TextStyle(
              fontFamily: 'Urbanist',
              fontWeight: FontWeight.w600,
              color: _ink,
            ),
            decoration: _fieldDecoration(
              label: 'Item Name',
              required: true,
              hint: 'Auto-filled from item code',
              prefix: const Icon(Icons.label_outline, size: 18, color: _muted),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  readOnly: true,
                  controller: uomController,
                  style: const TextStyle(
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w600,
                    color: _ink,
                  ),
                  decoration: _fieldDecoration(
                    label: 'UOM',
                    hint: 'Unit',
                    prefix: const Icon(
                      Icons.straighten_outlined,
                      size: 18,
                      color: _muted,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: qtyController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  style: const TextStyle(
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w700,
                    color: _ink,
                  ),
                  decoration: _fieldDecoration(
                    label: 'Qty Loaded',
                    required: true,
                    hint: '0',
                    prefix: const Icon(
                      Icons.numbers_rounded,
                      size: 18,
                      color: _muted,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Material(
            color: hasPhoto
                ? const Color(0xFFECFDF3)
                : const Color(0xFFF8FAFD),
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              onTap: _pickPhoto,
              borderRadius: BorderRadius.circular(14),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: hasPhoto
                        ? const Color(0xFFBBF7D0)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Row(
                  children: [
                    if (hasPhoto)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          width: 56,
                          height: 56,
                          child: _buildImage(photoPath!, context: context),
                        ),
                      )
                    else
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F0FE),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.camera_alt_outlined,
                          color: Color(0xFF2957A4),
                        ),
                      ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hasPhoto ? 'Photo attached' : 'Add item photo',
                            style: const TextStyle(
                              color: _ink,
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              fontFamily: 'Urbanist',
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            hasPhoto
                                ? 'Tap to retake from camera'
                                : 'Optional — capture now or later from the list',
                            style: const TextStyle(
                              color: _muted,
                              fontSize: 11,
                              fontFamily: 'Urbanist',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      hasPhoto
                          ? Icons.refresh_rounded
                          : Icons.chevron_right_rounded,
                      color: const Color(0xFF2957A4),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ImageViewScreen extends StatefulWidget {
  const ImageViewScreen({super.key, required this.imagePath});
  final String imagePath;

  @override
  State<ImageViewScreen> createState() => _ImageViewScreenState();
}

class _ImageViewScreenState extends State<ImageViewScreen> {
  double rotationAngle = 0.0;

  void _rotateImage() {
    setState(() {
      rotationAngle += 90 * 3.1415926535 / 180;
    });
  }

  @override
  Widget build(BuildContext context) {
    final baseUrl = Urls.baseUrl.replaceAll('/api', '');

    Widget imageWidget;

    if (File(widget.imagePath).existsSync()) {
      imageWidget = Image.file(File(widget.imagePath), fit: BoxFit.contain);
    } else if (widget.imagePath.startsWith('/files/')) {
      imageWidget = Image.network(
        '$baseUrl${widget.imagePath}',
        fit: BoxFit.contain,
      );
    } else if (widget.imagePath.startsWith('http')) {
      imageWidget = Image.network(widget.imagePath, fit: BoxFit.contain);
    } else {
      imageWidget = const Icon(Icons.broken_image, size: 100);
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Image Preview',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 0.1,
              maxScale: 5.0,
              clipBehavior: Clip.none,
              boundaryMargin: const EdgeInsets.all(100),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SizedBox(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Transform.rotate(
                        angle: rotationAngle,
                        child: imageWidget,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: _rotateImage,
              child: const Icon(Icons.rotate_right, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
