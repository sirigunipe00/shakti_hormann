import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:shakti_hormann/widgets/dailogs/app_snack_bar_widget.dart';
import 'package:shakti_hormann/widgets/input_filed.dart';
import 'package:shakti_hormann/widgets/inputs/date_picker_field.dart';
import 'package:shakti_hormann/widgets/inputs/new_upload_photo_widget.dart';
import 'package:shakti_hormann/widgets/inputs/search_dropdown_widget.dart';
import 'package:shakti_hormann/widgets/inputs/time_picker.dart';
import 'package:shakti_hormann/widgets/loading_indicator.dart';
import 'package:shakti_hormann/widgets/sectionheader.dart';
import 'package:shakti_hormann/widgets/spaced_column.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

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
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.error!.error)));
            }
          },
        ),
      ],
      child: Container(
        color: Colors.purple.shade100.withValues(alpha: 0.15),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: SpacedColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
            margin: const EdgeInsets.all(12.0),
            defaultHeight: 0,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: SectionHeader(
                  title: 'Vehicle Request Details',
                  assetIcon: 'assets/images/gateentryicon.svg',
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,

                margin: const EdgeInsets.all(2),
                child: Stack(
                  children: [
                    Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(
                          color: Color(0xFFE8ECF4),
                          width: 1,
                        ),
                      ),

                      elevation: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.only(
                          top: 15,
                          left: 16,
                          right: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InputField(
                              title: 'Plant Name',
                              hintText: 'Enter Plant Name',
                              readOnly: true,
                              isRequired: true,
                              borderColor: AppColors.grey,
                              initialValue: newform.plantName,
                              onChanged: (p0) {},
                            ),
                            const SizedBox(height: 12),
                            InputField(
                              title: 'Linked Transporter No',
                              hintText: 'Linked Transporter No',
                              readOnly: true,
                              isRequired: true,
                              borderColor: AppColors.grey,
                              initialValue:
                                  newform.linkedTransporterConfirmation,

                              onChanged: (p0) {},
                            ),
                            AppDateField(
                              title: 'Vehicle Reporting Date',
                              hintText: 'Select Date',
                              readOnly: true,
                              startDate: DateTime(2020),
                              endDate: DateTime(2030),
                              initialDate: DFU.ddMMyyyyFromStr(
                                newform.vehicleReportingEntryVreDate ?? '',
                              ),
                              onSelected: (DateTime date) {},
                              fillColor: Colors.grey[200],
                            ),
                            const SizedBox(height: 12),
                            InputField(
                              title: 'Transporter Name',
                              readOnly: true,
                              borderColor: AppColors.grey,
                              initialValue: [
                                    newform.transporterName,
                                    newform.transporterName2,
                                  ]
                                  .where((e) => e != null && e.isNotEmpty)
                                  .join(' - '),
                              onChanged: (p0) => context,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              const Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: SectionHeader(
                  title: 'Sales Orders',
                  assetIcon: 'assets/images/vehicleinvoicicon.svg',
                ),
              ),
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: Color(0xFFE8ECF4), width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BlocBuilder<Logistic, LogisticState>(
                    builder: (context, state) {
                      return state.maybeWhen(
                        loading:
                            () => const Center(
                              child: CircularProgressIndicator(),
                            ),
                        failure: (msg) => Center(child: Text('Error: $msg')),
                        success: (salesOrders) {
                          if (salesOrders.isNotEmpty) {
                            context.cubit<ItemList>().request(salesOrders);
                          }

                          return SalesOrderTables(
                            salesOrders: salesOrders,
                            widthFactor: 1.2,
                          );
                        },
                        orElse: () => const SizedBox(),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 15),
              const Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: SectionHeader(
                  title: 'Vehicle and Driver Details',
                  assetIcon: 'assets/images/vehicleinvoicicon.svg',
                ),
              ),
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: Color(0xFFE8ECF4), width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: AppDateField(
                              title: 'Arrival Date',
                              hintText: 'Select Date',
                              isRequired: true,
                              readOnly: true,
                              key: ValueKey(newform.arrivalDate ?? ''),
                              startDate: DateTime.now(),
                              endDate: DateTime(2030),
                              initialDate: DFU.ddMMyyyyFromStr(
                                newform.arrivalDate ?? '',
                              ),
                              onSelected: (DateTime date) {},
                              fillColor: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 13),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TimePickerField(
                                  title: 'Arrival Time',
                                  readOnly: true,
                                  isRequired: true,
                                  key: UniqueKey(),
                                  hintText: 'Select Time',
                                  initialTime: formatTime(newform.arrivalTime),
                                  onTimeChanged: (selectedTime) {},
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      InputField(
                        title: 'Vehicle Number',
                        hintText: 'Vehicle No',
                        readOnly: true,
                        borderColor: AppColors.grey,
                        initialValue: newform.vehicleNumber,
                        onChanged: (p0) {},
                      ),
                      const SizedBox(height: 12),
                      InputField(
                        title: 'Driver Contact No',
                        hintText: 'Enter Contact Number',
                        readOnly: true,
                        inputType: TextInputType.number,
                        borderColor: AppColors.grey,
                        initialValue: newform.driverContact,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        onChanged: (p0) {},
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: SectionHeader(
                  title: 'Photo',
                  assetIcon: 'assets/images/photoicon.svg',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Color(0xFFE8ECF4), width: 1),
                  ),
                  child: Center(
                    child: NewUploadPhotoWidget(
                      fileName: 'driverid',
                      imageUrl: newform.driverIdPhoto,
                      title: 'Driver ID Proof',
                      isReadOnly: true,
                      onFileCapture: (file) {
                        // context.cubit<CreateLoadingCnfmCubit>().onValueChanged(
                        //   driverIdPhoto: file,
                        // );
                      },
                      focusNode: focusNodes.elementAt(27),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),
              BlocBuilder<GetLoadedList, GetLoadedState>(
                builder: (context, state) {
                  return state.maybeWhen(
                    orElse: () => const SizedBox(),
                    loading: () => const LoadingIndicator(),
                    success: (data) {
                      return ItemLoadedTable(
                        dispatchData: data,
                        docstatus: formState.form.docstatus,
                        vrName: formState.form.name,
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
  });
  final DispatchLoadedData dispatchData;
  final int? docstatus;
  final String? vrName;

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

  bool get _canEdit => widget.docstatus != 1 && !_dispatchData.isDispatched;

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

    if (seedCubit && !_cubitSeeded) {
      _cubitSeeded = true;
      for (final item in manualItems) {
        context.read<CreateLoadingCnfmCubit>().addInitialItem(item);
      }
    }
  }

  void _showSnack(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
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

    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder:
            (_) => const SimpleBarcodeScannerPage(
              appBarTitle: 'Scan Pallet / Box',
              isShowFlashIcon: true,
            ),
      ),
    );
    if (result == null || result == '-1' || !mounted) return;

    final scanned = result.trim();
    if (scanned.isEmpty) return;

    setState(() => _isScanning = true);

    final repo = LoadingCnfmBlocProvider.get().repo;
    final parentPalletQr = isPalletQr(scanned) ? null : _activePalletQr;

    final lookup = await repo.scanUnitForDispatch(
      qr: scanned,
      vrName: vrName,
      parentPalletQr: parentPalletQr,
    );

    if (!mounted) return;

    await lookup.fold(
      (failure) async {
        setState(() => _isScanning = false);
        _showSnack(failure.error, isError: true);
      },
      (scanResult) async {
        if (scanResult.scannedOnThisVehicle) {
          setState(() => _isScanning = false);
          _showSnack(
            scanResult.popupMessage ??
                'This unit is already scanned on this vehicle.',
            isError: true,
          );
          return;
        }

        final item = <String, dynamic>{'scan_qr': scanned};
        if (!isPalletQr(scanned) &&
            parentPalletQr != null &&
            parentPalletQr.isNotEmpty) {
          item['parent_pallet_qr'] = parentPalletQr;
        }

        final addResult = await repo.updateScannedItems(vrName, [item]);
        if (!mounted) return;

        addResult.fold(
          (failure) {
            setState(() => _isScanning = false);
            _showSnack(failure.error, isError: true);
          },
          (data) {
            setState(() => _isScanning = false);
            _applyDispatchData(data);
            _showSnack(
              data.popupMessage ??
                  scanResult.popupMessage ??
                  'Scanned successfully.',
            );
          },
        );
      },
    );
  }

  Future<void> _deleteScannedRow(String itemRowName) async {
    final vrName = widget.vrName;
    if (vrName == null || !_canEdit) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Remove scan?'),
            content: const Text(
              'Remove this scanned item from the vehicle loading?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Remove'),
              ),
            ],
          ),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, right: 4, bottom: 8),
          child: Row(
            children: [
              const Expanded(
                child: SectionHeader(
                  title: 'Item Details',
                  assetIcon: 'assets/images/remarksicon.svg',
                ),
              ),
              if (_canEdit)
                Tooltip(
                  message: 'Scan pallet / box',
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _isScanning ? null : _scanAndAddUnit,
                      borderRadius: BorderRadius.circular(12),
                      child: Ink(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 242, 171, 6),
                              Color.fromARGB(255, 247, 175, 7),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.yellow.withValues(alpha: 0.45),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child:
                            _isScanning
                                ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.darkBlue,
                                  ),
                                )
                                : const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.qr_code_scanner,
                                      color: AppColors.darkBlue,
                                      size: 32,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      'Scan',
                                      style: TextStyle(
                                        color: AppColors.darkBlue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (_isRefreshing)
          const Padding(
            padding: EdgeInsets.all(12),
            child: Center(child: CircularProgressIndicator()),
          ),
        // if (_dispatchData.pendingNotes.isNotEmpty)
        //   Padding(
        //     padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children:
        //           _dispatchData.pendingNotes
        //               .map(
        //                 (note) => Padding(
        //                   padding: const EdgeInsets.only(bottom: 4),
        //                   child: Text(
        //                     note,
        //                     style: TextStyle(
        //                       color: Colors.orange.shade800,
        //                       fontWeight: FontWeight.w600,
        //                       fontSize: 12,
        //                     ),
        //                   ),
        //                 ),
        //               )
        //               .toList(),
        //     ),
        //   ),
        if (scannedRows.isNotEmpty)
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
        if (scannedRows.isEmpty && _canEdit)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Text(
              'Scan a Pallet (FR-/SH-/CO-), then scan Installation (INST-), Accessories (VP-), and Hardware (MES-) against it.',
              style: TextStyle(color: Colors.black54, fontSize: 12),
            ),
          ),
        const SizedBox(height: 12),
        const Padding(
          padding: EdgeInsets.only(left: 8, bottom: 6),
          child: Text(
            'Manual Added Item : ',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 20,
              color: AppColors.darkBlue,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: _ManualItemsTable(
            rows: rows,
            canEdit: widget.docstatus != 1,
            onEdit: (index) => addRow(index: index),
            onCamera: _openCamera,
            buildPhoto: (path) => _buildImage(path, context: context),
          ),
        ),
        const SizedBox(height: 10),
        if (_canEdit) ...[
          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton.icon(
              onPressed: () => addRow(),
              icon: const Icon(Icons.add),
              label: const Text('Add Item'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkBlue,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
        const SizedBox(height: 8),
      ],
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

  @override
  Widget build(BuildContext context) {
    Widget headerCell(String text) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
        softWrap: true,
        textAlign: TextAlign.center,
      ),
    );

    Widget dataText(String text) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 11),
          softWrap: true,
          maxLines: 4,
        ),
      ),
    );

    Widget dataWidget(Widget child) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: child,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        return Table(
          border: TableBorder.all(color: Colors.grey.shade300),
          columnWidths: {
            0: const FixedColumnWidth(28),
            1: const FlexColumnWidth(1.1),
            2: const FlexColumnWidth(2.0),
            3: const FlexColumnWidth(0.7),
            4: const FlexColumnWidth(0.6),
            5: const FlexColumnWidth(0.8),
            if (canEdit) 6: const FlexColumnWidth(0.5),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              decoration: const BoxDecoration(color: AppColors.darkBlue),
              children: [
                headerCell('#'),
                headerCell('Item Code'),
                headerCell('Item Name'),
                headerCell('Qty'),
                headerCell('UOM'),
                headerCell('Photo'),
                if (canEdit) headerCell('Edit'),
              ],
            ),
            ...List.generate(rows.length, (index) {
              final row = rows[index];
              final photo = row['photo'] as String?;
              final hasPhoto = photo != null && photo.isNotEmpty;

              return TableRow(
                children: [
                  dataText('${index + 1}'),
                  dataText(row['itemCode']?.toString() ?? ''),
                  dataText(row['itemName']?.toString() ?? ''),
                  dataText(row['qty']?.toString() ?? ''),
                  dataText(row['uom']?.toString() ?? ''),
                  dataWidget(
                    Center(
                      child:
                          hasPhoto
                              ? buildPhoto(photo)
                              : IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                  minWidth: 36,
                                  minHeight: 36,
                                ),
                                icon: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(
                                    AppColors.darkBlue,
                                  ),
                                ),
                                onPressed: () => onCamera(index),
                              ),
                    ),
                  ),
                  if (canEdit)
                    dataWidget(
                      IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 36,
                          minHeight: 36,
                        ),
                        onPressed: () => onEdit(index),
                        icon: const Icon(Icons.edit, color: Colors.blue),
                      ),
                    ),
                ],
              );
            }),
          ],
        );
      },
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 6),
            child: Text(
              'Scanned Items :',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 20,
                color: AppColors.darkBlue,
              ),
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              Widget headerCell(String text) => Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 3,
                ),
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10.5,
                  ),
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
              );

              Widget dataCell(
                String text, {
                FontWeight fontWeight = FontWeight.normal,
                Color? color,
              }) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 3),
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: fontWeight,
                    color: color,
                  ),
                  softWrap: true,
                  maxLines: 4,
                  textAlign: TextAlign.center,
                ),
              );

              Widget dataWidget(Widget child) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                child: child,
              );

              return Table(
                border: TableBorder.all(color: Colors.grey.shade300),
                columnWidths: const {
                  0: FixedColumnWidth(24),
                  1: FlexColumnWidth(2.2),
                  2: FlexColumnWidth(1.2),
                  3: FlexColumnWidth(1.0),
                  4: FlexColumnWidth(0.7),
                  5: FlexColumnWidth(0.8),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(
                    decoration: const BoxDecoration(color: AppColors.darkBlue),
                    children: [
                      headerCell('#'),
                      headerCell('Scan QR'),
                      headerCell('Product'),
                      headerCell('Size'),
                      headerCell('Qty'),
                      headerCell('Photo'),
                    ],
                  ),
                  ...List.generate(rows.length, (index) {
                    final row = rows[index];
                    final isPallet = row.isPallet;
                    final isActive = isPallet && activePalletQr == row.scanQr;
                    final bgColor =
                        isActive
                            ? AppColors.darkBlue.withValues(alpha: 0.08)
                            : null;
                    final photoPath = _photoPath(row);
                    final hasPhoto =
                        photoPath != null && photoPath.isNotEmpty;
                    final isPhotoUploading =
                        row.itemRowName != null &&
                        row.itemRowName == photoUploadingRowName;

                    return TableRow(
                      decoration:
                          bgColor != null
                              ? BoxDecoration(color: bgColor)
                              : null,
                      children: [
                        GestureDetector(
                          onTap:
                              isPallet && row.scanQr != null
                                  ? () => onSelectPallet(row.scanQr!)
                                  : null,
                          child: dataCell('${index + 1}'),
                        ),
                        GestureDetector(
                          onTap:
                              isPallet && row.scanQr != null
                                  ? () => onSelectPallet(row.scanQr!)
                                  : null,
                          child: dataCell(row.scanQr ?? ''),
                        ),
                        dataCell(row.productType ?? ''),
                        dataCell(row.palletSize ?? '-'),
                        dataCell(row.qtyLoaded?.toString() ?? ''),
                        dataWidget(
                          Center(
                            child:
                                isPhotoUploading
                                    ? const SizedBox(
                                      width: 28,
                                      height: 28,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.darkBlue,
                                      ),
                                    )
                                    : hasPhoto
                                    ? GestureDetector(
                                      onTap:
                                          canEdit && !row.isDispatched
                                              ? () => onCapturePhoto(row)
                                              : null,
                                      child: buildPhoto(photoPath),
                                    )
                                    : canEdit && !row.isDispatched
                                    ? IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(
                                        minWidth: 36,
                                        minHeight: 36,
                                      ),
                                      icon: const Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            WidgetStateProperty.all(
                                          AppColors.darkBlue,
                                        ),
                                      ),
                                      onPressed: () => onCapturePhoto(row),
                                    )
                                    : const SizedBox.shrink(),
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

Widget _buildImage(String path, {BuildContext? context}) {
  final baseUrl = Urls.baseUrl.replaceAll('/api', '');

  Widget imageWidget;

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
      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
    );
  } else if (path.startsWith('http')) {
    imageWidget = Image.network(
      path,
      width: 50,
      height: 50,
      fit: BoxFit.cover,
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add / Edit Item'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            BlocBuilder<ItemList, ItemState>(
              builder: (_, state) {
                final allData = state.maybeWhen(
                  orElse: () => <ItemModel>[],
                  success: (data) => data,
                );

                return SearchDropDownList<ItemModel>(
                  key: UniqueKey(),
                  title: 'Item Code',
                  hint: 'Search Item Code',
                  color: Colors.black,
                  items: allData,
                  isRequired: true,
                  defaultSelection: itemFrom,
                  isloading: state.isLoading,
                  futureRequest: (query) async {
                    if (query.isEmpty) return allData;

                    final lowerQuery = query.toLowerCase();

                    return allData.where((item) {
                      final code = item.name?.toLowerCase() ?? '';
                      final name = item.itemName?.toLowerCase() ?? '';
                      final uom = item.uomValue?.toLowerCase() ?? '';

                      return code.contains(lowerQuery) ||
                          name.contains(lowerQuery) ||
                          uom.contains(lowerQuery);
                    }).toList();
                  },
                  headerBuilder: (_, item, __) => Text(item.itemCode ?? ''),
                  listItemBuilder:
                      (_, item, __, ___) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Item Code: ${item.itemCode ?? ''}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          if (item.itemName != null)
                            Text('Item Name : ${item.itemName}'),
                          Text('Sales UOM: ${item.uomValue ?? ''}'),
                          Text('Quantity: ${item.qty ?? ''}'),
                          const Divider(height: 8),
                        ],
                      ),
                  onSelected: (selected) {
                    setState(() {
                      itemFrom = selected;
                      selectedCode = selected.itemCode;
                      itemNameController.text = selected.itemName ?? '';
                      uomController.text = selected.uomValue ?? '';
                      qtyController.text = selected.qty.toString();
                    });
                  },
                  focusNode: FocusNode(),
                );
              },
            ),

            const SizedBox(height: 10),
            TextFormField(
              readOnly: true,
              controller: itemNameController,
              decoration: InputDecoration(
                label: RichText(
                  text: const TextSpan(
                    text: 'Item Name',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                    children: [
                      TextSpan(
                        text: '*',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),
            TextFormField(
              readOnly: true,
              controller: uomController,
              decoration: const InputDecoration(
                labelText: 'UOM',
                labelStyle: TextStyle(
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Urbanist',
                ),
              ),
            ),

            const SizedBox(height: 10),
            TextFormField(
              readOnly: false,
              controller: qtyController,
              decoration: InputDecoration(
                label: RichText(
                  text: const TextSpan(
                    text: 'Quantity Loaded',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                    children: [
                      TextSpan(
                        text: '*',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),
            Row(
              children: [
                if (photoPath != null)
                  Stack(
                    children: [
                      _buildImage(photoPath!, context: context),
                      Center(
                        child: IconButton(
                          icon: const Icon(Icons.refresh, color: Colors.white),
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                              AppColors.darkBlue,
                            ),
                          ),
                          onPressed: _pickPhoto,
                        ),
                      ),
                    ],
                  )
                else
                  Center(
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt),
                      onPressed: _pickPhoto,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
          ),
          onPressed: () {
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
          },

          child: const Text(
            'Save',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ],
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
