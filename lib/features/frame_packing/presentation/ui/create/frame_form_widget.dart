import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/core/utils/packing_sticker_decoder.dart';
import 'package:shakti_hormann/core/utils/packing_sticker_document_capture.dart';
import 'package:shakti_hormann/features/frame_packing/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/frame_packing/presentation/bloc/create_frame_cubit.dart/create_frame_cubit.dart';
import 'package:shakti_hormann/features/frame_packing/presentation/ui/create/frame_scan_page.dart';
import 'package:shakti_hormann/features/frame_packing/presentation/ui/widget/frame_lines_widget.dart';
import 'package:shakti_hormann/features/logistic_request/model/sales_order_form.dart';
import 'package:shakti_hormann/features/pallet_creation/model/pallet_model.dart';
import 'package:shakti_hormann/features/shutter_packing/model/pallet_code.dart';
import 'package:shakti_hormann/features/shutter_packing/model/pallet_size.dart';
import 'package:shakti_hormann/features/shutter_packing/presentation/ui/widget/border_painter.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/dailogs/app_dialogs.dart';
import 'package:shakti_hormann/widgets/inputs/new_upload_photo_widget.dart';
import 'package:shakti_hormann/widgets/inputs/search_dropdown_widget.dart';
// import 'package:shakti_hormann/widgets/sectionheader.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class FrameFormWidget extends StatefulWidget {
  const FrameFormWidget({
    super.key,
    required this.isDecodingUploadSticker,
  });

  final ValueNotifier<bool> isDecodingUploadSticker;

  @override
  State<FrameFormWidget> createState() => __FrameFormWidgetState();
}

class __FrameFormWidgetState extends State<FrameFormWidget> {
  final ScrollController _scrollController = ScrollController();
  SalesOrderForm? invoiceform;
  PalletSize? palletSize;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.isDecodingUploadSticker,
      builder: (context, isDecodingUploadSticker, _) {
    final formState = context.watch<CreateFrameCubit>().state;
    final isCompleted = formState.view == FrameView.completed;
    final newform = formState.form;
    $logger.devLog('newform$newform');
    final isPalletPrinted = newform.palletQrPrinted == 1;
    final isFrozen = formState.isFrozen || newform.freezeQuantity == 1;
    final isDocCreated = newform.name != null && newform.name!.isNotEmpty;
    final isDropdownLocked = isFrozen || isCompleted || isDocCreated;
    final isScanningDisabled =
        isCompleted ||
        isFrozen ||
        !isDocCreated ||
        formState.isProcessingScan ||
        isDecodingUploadSticker;
    final hasPalletImage =
        newform.palletPhotoImg != null ||
        (newform.palletPhoto != null && newform.palletPhoto!.isNotEmpty);
    final isSubmitted = newform.docStatus == 1;
    final isStickerPrinted = isPalletPrinted || isSubmitted || isCompleted;

    return Stack(
      children: [
        MultiBlocListener(
      listeners: [
        BlocListener<CreateFrameCubit, CreateFrameState>(
          listenWhen:
              (previous, current) =>
                  previous.error?.status != current.error?.status,
          listener: (_, state) async {},
        ),
        BlocListener<FrameLinesCubit, FrameLinesCubitState>(
          listenWhen: (previous, current) => previous != current,
          listener: (_, state) {
            state.maybeWhen(
              orElse: () {},
              success: (lines) {
                context.cubit<CreateFrameCubit>().addAllLines(lines);
              },
            );
          },
        ),
      ],
      child: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Step 1: SO Details ──
            _StepIndicator(
              stepNumber: 1,
              title: 'SO Details',
              isCompleted: isDocCreated,
              isActive: true,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.only(
                left: 12,
                right: 12,
                bottom: 8,
                top: 8,
              ),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  BlocBuilder<FrameSalesOrdersCubit, FrameSalesOrderCubitState>(
                    builder: (_, state) {
                      final allData = state.maybeWhen(
                        orElse: () => <PalletModel>[],
                        success: (data) => data,
                      );
                      final savedSo = newform.salesOrder?.trim();
                      final names = allData.toList();
                      // Reopened doc: keep saved SO visible even if not in picker API.
                      if (savedSo != null &&
                          savedSo.isNotEmpty &&
                          !names.any((e) => e.salesOrder == savedSo)) {
                        names.insert(
                          0,
                          PalletModel(salesOrder: savedSo, name: savedSo),
                        );
                      }
                      final PalletModel? defaultSelection =
                          (savedSo == null || savedSo.isEmpty)
                              ? null
                              : names.firstWhere(
                                (g) => g.salesOrder == savedSo,
                              );
                      return SearchDropDownList<PalletModel>(
                        title: 'Sales Order No.',
                        hint: 'Select Order No',
                        key: ValueKey('${newform.name}_${newform.salesOrder}'),
                        color: AppColors.black,
                        items: names,
                        isRequired: true,
                        readOnly: isDropdownLocked,
                        defaultSelection: defaultSelection,
                        isloading: state.isLoading,
                        futureRequest: (query) async {
                          if (query.isEmpty) return names;
                          return names.where((item) {
                            final orderNo =
                                item.salesOrder?.toLowerCase() ?? '';
                            return orderNo.contains(query.toLowerCase());
                          }).toList();
                        },
                        headerBuilder:
                            (_, item, __) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.salesOrder ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                        listItemBuilder:
                            (_, item, __, ___) => Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 4.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Order No: ${item.salesOrder ?? ''}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if ((item.customerName ?? '').isNotEmpty)
                                    Text('Customer: ${item.customerName}'),
                                  if ((item.orderDate ?? '').isNotEmpty)
                                    Text(
                                      'Order Date: ${DFU.ddMMyyyyFromStr(item.orderDate!)}',
                                    ),
                                ],
                              ),
                            ),
                        onSelected: (selected) {
                          context.cubit<CreateFrameCubit>().onValueChanged(
                            salesOrder: selected.salesOrder,
                            palletCode: '',
                          );
                          context.cubit<CreateFrameCubit>().getPalletCodes(
                            selected.salesOrder!,
                          );
                        },
                        focusNode: FocusNode(),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  BlocBuilder<CreateFrameCubit, CreateFrameState>(
                    builder: (context, state) {
                      final palletCodes =
                          state.palletCodes
                              .map((e) => PalletCodeModel(name: e))
                              .toList();
                      final storedCode = state.form.palletCode;
                      final matchInList = palletCodes.any(
                        (e) => e.name == storedCode,
                      );
                      if (storedCode != null &&
                          storedCode.isNotEmpty &&
                          !matchInList) {
                        palletCodes.insert(
                          0,
                          PalletCodeModel(name: storedCode),
                        );
                      }
                      final PalletCodeModel? selection =
                          palletCodes
                              .where((e) => e.name == storedCode)
                              .firstOrNull;

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: SearchDropDownList<PalletCodeModel>(
                              title: 'Pallet Select',
                              hint:
                                  palletCodes.isEmpty &&
                                          (newform.salesOrder?.isNotEmpty ??
                                              false)
                                      ? 'No pallet codes available'
                                      : 'Search Pallet',
                              items: palletCodes,
                              key: ValueKey(
                                '${state.form.name}_${state.form.salesOrder}_'
                                '${state.form.palletCode}_${state.palletCodes.join()}',
                              ),
                              readOnly: isDropdownLocked,
                              isRequired: true,
                              isloading: state.isLoadingPalletCodes,
                              color: AppColors.black,
                              defaultSelection: selection,
                              futureRequest: (query) async {
                                if (query.isEmpty) return palletCodes;
                                return palletCodes
                                    .where(
                                      (e) => e.name.toLowerCase().contains(
                                        query.toLowerCase(),
                                      ),
                                    )
                                    .toList();
                              },
                              headerBuilder: (_, item, __) => Text(item.name),
                              listItemBuilder:
                                  (_, item, __, ___) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10.0,
                                      horizontal: 4.0,
                                    ),
                                    child: Text(item.name),
                                  ),
                              onSelected: (selected) {
                                context.read<CreateFrameCubit>().onValueChanged(
                                  palletCode: selected.name,
                                );
                              },
                            ),
                          ),
                          if (!isDropdownLocked)
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 4,
                                bottom: 6,
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: () => _scanPalletCode(context),
                                child: Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1A3C6B),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.qr_code_scanner,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            if (!isDocCreated && !isCompleted) ...[
              const SizedBox(height: 12),
              const _StepHint(
                text:
                    '**Select Sales Order and Pallet Code, then tap Save to proceed**',
              ),
            ],

            // ── Step 2: Scan & Items (visible after Save) ──
            if (isDocCreated) ...[
              const SizedBox(height: 10),
              _StepIndicator(
                stepNumber: 2,
                title: 'Scan & Items',
                isCompleted: isFrozen,
                isActive: isDocCreated && !isFrozen,
              ),
              const SizedBox(height: 8),
              if (!isCompleted && !isFrozen) ...[
                Row(
                  children: [
                    Expanded(
                      child: _ScanCard(
                        icon: Icons.qr_code_scanner,
                        label: 'Scan Frame\nSticker',
                        isDisabled: isScanningDisabled,
                        onTap:
                            isScanningDisabled
                                ? null
                                : () => _onScanSticker(context),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ScanCard(
                        icon: Icons.document_scanner_outlined,
                        label: 'Upload Frame\nImage',
                        isDisabled: isScanningDisabled,
                        onTap:
                            isScanningDisabled
                                ? null
                                : () => _onUploadImage(context),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    '**If Sticker is Not available , Please Upload the Image**',
                  ),
                ),
                const SizedBox(height: 10),
              ],

              // const SectionHeader(
              //   title: 'Frame Details',
              //   assetIcon: 'assets/images/palleticon.svg',
              // ),
              const SizedBox(height: 8),
              const FrameLinesWidget(),
              const SizedBox(height: 16),

              if (!isCompleted && !isFrozen)
                BlocBuilder<CreateFrameCubit, CreateFrameState>(
                  builder: (context, state) {
                    final hasLines = state.lines.isNotEmpty;
                    final canFreeze =
                        hasLines && !state.isFreezing && !isSubmitted;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed:
                                canFreeze
                                    ? () => _onFreezeQuantity(this.context)
                                    : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  canFreeze
                                      ? const Color(0xFF2563EB)
                                      : const Color(0xFFCBD5E1),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child:
                                state.isFreezing
                                    ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                    : const Text(
                                      'Freeze Quantity',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                      ),
                                    ),
                          ),
                        ),
                        if (!hasLines && !isSubmitted) ...[
                          const SizedBox(height: 8),
                          const _StepHint(
                            text: 'Add at least one item to freeze quantity.',
                          ),
                        ],
                      ],
                    );
                  },
                ),

              if (isFrozen) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF16A34A),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lock, color: Colors.white, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Quantity Locked',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
            // ── Step 3: Print Sticker (visible after Freeze) ──
            if (isFrozen || isSubmitted || isCompleted) ...[
              const SizedBox(height: 10),
              _StepIndicator(
                stepNumber: 3,
                title: 'Print Sticker',
                isCompleted: isPalletPrinted,
                isActive: isFrozen && !isPalletPrinted,
              ),
              const SizedBox(height: 8),
              if (isStickerPrinted)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFF16A34A).withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Color(0xFF16A34A),
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Sticker Printed',
                        style: TextStyle(
                          color: Color(0xFF16A34A),
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _ScanCard(
                        icon: Icons.print,
                        label:
                            formState.isPrinting
                                ? 'Printing...'
                                : 'Print Sticker',
                        isDisabled: formState.isPrinting,
                        onTap:
                            formState.isPrinting
                                ? null
                                : () => _onPrintQr(context),
                      ),
                    ),
                  ],
                ),
            ],

            // ── Step 4: Pallet Image (visible after Print) ──
            if (isPalletPrinted || isSubmitted || isCompleted) ...[
              const SizedBox(height: 24),
              _StepIndicator(
                stepNumber: 4,
                title: 'Pallet Image',
                isCompleted: hasPalletImage,
                isActive: isPalletPrinted && !hasPalletImage,
              ),
              const SizedBox(height: 8),
              DashedBorderBox(
                borderRadius: 12,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Pallet No.',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Text(
                          newform.palletCode ?? '',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF1E293B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      NewUploadPhotoWidget(
                        fileName: 'camera.png',
                        imageUrl: newform.palletPhoto,
                        title: 'Pallet Image',
                        isRequired: true,
                        isReadOnly: isCompleted || isSubmitted,
                        onFileCapture: (file) {
                          context.cubit<CreateFrameCubit>().onValueChanged(
                            palletPhoto: file,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              if (!hasPalletImage) ...[
                const SizedBox(height: 8),
                const _StepHint(
                  text: 'Capture the pallet image to proceed to submit.',
                ),
              ],
            ],
          ],
        ),
      ),
    ),
      ],
    );
      },
    );
  }

  Future<void> _onFreezeQuantity(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (dialogContext) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCE7E7),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(
                      Icons.priority_high,
                      color: Color(0xFFE53E3E),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Freeze Quantity?',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Note: Once freezed you will not be able to change the inputs',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed:
                              () => Navigator.of(dialogContext).pop(false),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFE53E3E),
                            side: const BorderSide(color: Color(0xFFE53E3E)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed:
                              () => Navigator.of(dialogContext).pop(true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A3C6B),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Freeze',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );

    if (confirmed != true || !context.mounted) return;

    final cubit = context.cubit<CreateFrameCubit>();
    await cubit.freezeFrameQuantity();

    if (!context.mounted) return;
    if (cubit.state.error != null) return;

    await AppDialog.showSuccessDialog(
      context,
      title: 'Quantity Locked',
      content: 'Please Print the Sticker.',
      onTapDismiss: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    if (context.mounted) {
      cubit.freezeHandled();
    }
  }

  Future<void> _onPrintQr(BuildContext context) async {
    final cubit = context.cubit<CreateFrameCubit>();
    final success = await cubit.printSticker();

    if (!context.mounted) return;

    if (!success) {
      final error =
          cubit.state.error?.error ?? 'Could not print QR. Please try again.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
      return;
    }

    final message =
        cubit.state.printSuccessMsg ?? 'Print request sent successfully.';
    await AppDialog.showSuccessDialog(
      context,
      title: 'Success',
      content: message,
      onTapDismiss: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    if (context.mounted) {
      cubit.printHandled();
    }
  }

  Future<void> _onScanSticker(BuildContext context) async {
    final raw = await Navigator.of(
      context,
    ).push<String>(MaterialPageRoute(builder: (_) => const ScanFramePage()));

    if (raw == null || !context.mounted) return;
    context.cubit<CreateFrameCubit>().onQrScanned(raw);
  }

  // Future<void> _scanPalletCode(BuildContext context) async {
  //   final cubit = context.cubit<CreateFrameCubit>();
  //   final salesOrder = cubit.state.form.salesOrder?.trim();

  //   if (salesOrder == null || salesOrder.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Please select a Sales Order first.'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //     return;
  //   }

  //   final result = await Navigator.push<String>(
  //     context,
  //     MaterialPageRoute(
  //       builder:
  //           (_) => const SimpleBarcodeScannerPage(
  //             appBarTitle: 'Scan Pallet Code',
  //             isShowFlashIcon: true,
  //           ),
  //     ),
  //   );
  //   if (result == null || result == '-1' || !context.mounted) return;

  //   final scanned = result.trim();
  //   if (scanned.isEmpty) return;

  //   final match = RegExp(r'^FR-(\d+)-').firstMatch(scanned);

  //   if (match == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('"$scanned" is not a valid pallet code.'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //     return;
  //   }

  //   final scannedSalesOrder = match.group(1)!;

  //   if (scannedSalesOrder != salesOrder) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(
  //           'This pallet belongs to Sales Order "$scannedSalesOrder", '
  //           'not the selected Sales Order "$salesOrder".',
  //         ),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //     return;
  //   }

  //   final validCodes = cubit.state.palletCodes;
  //   final isValid = validCodes.any(
  //     (code) => code.trim().toLowerCase() == scanned.toLowerCase(),
  //   );

  //   if (!isValid) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(
  //           'Pallet "$scanned" is not in the list of available pallet codes for this Sales Order.',
  //         ),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //     return;
  //   }

  //   context.read<CreateFrameCubit>().onValueChanged(palletCode: scanned);
  // }
  Future<void> _scanPalletCode(BuildContext context) async {
    final cubit = context.cubit<CreateFrameCubit>();
    final salesOrder = cubit.state.form.salesOrder?.trim();

    if (salesOrder == null || salesOrder.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 2),
          content: Text('Please select a Sales Order first.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder:
            (_) => const SimpleBarcodeScannerPage(
              appBarTitle: 'Scan Pallet Code',
              isShowFlashIcon: true,
            ),
      ),
    );
    if (result == null || result == '-1' || !context.mounted) return;

    final scanned = result.trim();
    if (scanned.isEmpty) return;

    final validCodes = cubit.state.palletCodes;
    final matchedCode = validCodes.firstWhere(
      (code) => code.trim().toLowerCase() == scanned.toLowerCase(),
      orElse: () => '',
    );

    if (matchedCode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Pallet "$scanned" is not in the list of available pallet codes for this Sales Order.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    context.read<CreateFrameCubit>().onValueChanged(palletCode: matchedCode);
  }

  Future<void> _onUploadImage(BuildContext context) async {
    final imagePaths = await Navigator.of(context).push<List<String>>(
      MaterialPageRoute(
        builder:
            (_) => const PackingStickerDocumentCapturePage(
              title: 'Frame Images',
            ),
      ),
    );

    if (!context.mounted) return;
    if (imagePaths == null || imagePaths.isEmpty) return;

    widget.isDecodingUploadSticker.value = true;
    String? extracted;
    try {
      for (final path in imagePaths) {
        extracted = await decodePackingStickerCode(path);
        if (extracted != null) break;
      }
    } finally {
      widget.isDecodingUploadSticker.value = false;
    }

    if (!context.mounted) return;
    if (extracted == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not read sticker. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await context.cubit<CreateFrameCubit>().onQrScanned(
      extracted,
      imagePath: imagePaths,
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({
    required this.stepNumber,
    required this.title,
    required this.isCompleted,
    required this.isActive,
  });

  final int stepNumber;
  final String title;
  final bool isCompleted;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final Color circleColor =
        isCompleted
            ? const Color(0xFF2563EB)
            : isActive
            ? const Color(0xFF2563EB)
            : const Color(0xFFCBD5E1);

    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(color: circleColor, shape: BoxShape.circle),
          child: Center(
            child:
                isCompleted
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : Text(
                      '$stepNumber',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color:
                isActive || isCompleted
                    ? const Color(0xFF1E293B)
                    : const Color(0xFF94A3B8),
          ),
        ),
      ],
    );
  }
}

class _StepHint extends StatelessWidget {
  const _StepHint({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 15,
        color: AppColors.black,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _ScanCard extends StatelessWidget {
  const _ScanCard({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDisabled = false,
  });
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: isDisabled || onTap == null,
      child: Opacity(
        opacity: isDisabled ? 0.5 : 1,
        child: GestureDetector(
          onTap: onTap,
          child: DashedBorderBox(
            borderRadius: 16,
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color:
                          isDisabled
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF2563EB),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: Colors.white, size: 32),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
