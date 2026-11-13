import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/core/utils/packing_sticker_decoder.dart';
import 'package:shakti_hormann/core/utils/packing_sticker_document_capture.dart';
import 'package:shakti_hormann/features/frame_packing/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/frame_packing/presentation/bloc/create_frame_cubit.dart/create_frame_cubit.dart';
import 'package:shakti_hormann/features/frame_packing/presentation/ui/widget/frame_lines_widget.dart';
import 'package:shakti_hormann/features/frame_packing/presentation/ui/widget/frame_select_fields.dart';
import 'package:shakti_hormann/features/pallet_creation/model/pallet_model.dart';
import 'package:shakti_hormann/features/shutter_packing/model/pallet_code.dart';
import 'package:shakti_hormann/features/shutter_packing/presentation/ui/widget/border_painter.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/dailogs/app_dialogs.dart';
import 'package:shakti_hormann/widgets/inputs/new_upload_photo_widget.dart';
import 'package:shakti_hormann/widgets/scan/burst_scan_page.dart';
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
        padding: ShellInsets.scrollPadding(
          context,
          left: 16,
          right: 16,
          top: 5,
        ),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE8ECF4)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0E1446).withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
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

                      return FrameSalesOrderSelect(
                        key: ValueKey(
                          'so_${newform.name}_${newform.salesOrder}_'
                          '$isDropdownLocked',
                        ),
                        orders: names,
                        selected: defaultSelection,
                        isLoading: state.isLoading,
                        locked: isDropdownLocked,
                        onSelected: (selected) {
                          final so = selected.salesOrder;
                          if (so == null || so.isEmpty) return;
                          context.cubit<CreateFrameCubit>().onValueChanged(
                            salesOrder: so,
                            palletCode: '',
                          );
                          context.cubit<CreateFrameCubit>().getPalletCodes(so);
                        },
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
                      final PalletCodeModel? selection = palletCodes
                          .where((e) => e.name == storedCode)
                          .firstOrNull;

                      final emptyHint =
                          palletCodes.isEmpty &&
                                  (newform.salesOrder?.isNotEmpty ?? false)
                              ? 'No pallet codes available'
                              : 'Select pallet code';

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: FramePalletCodeSelect(
                              key: ValueKey(
                                'pc_${state.form.name}_${state.form.salesOrder}_'
                                '${state.form.palletCode}_'
                                '${state.palletCodes.length}',
                              ),
                              codes: palletCodes,
                              selected: selection,
                              locked: isDropdownLocked,
                              isLoading: state.isLoadingPalletCodes,
                              emptyHint: emptyHint,
                              onSelected: (selected) {
                                context
                                    .read<CreateFrameCubit>()
                                    .onValueChanged(palletCode: selected.name);
                              },
                            ),
                          ),
                          if (!isDropdownLocked) ...[
                            const SizedBox(width: 8),
                            Padding(
                              padding: const EdgeInsets.only(top: 26),
                              child: Material(
                                color: const Color(0xFF1A3C6B),
                                borderRadius: BorderRadius.circular(12),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () => _scanPalletCode(context),
                                  child: const SizedBox(
                                    width: 48,
                                    height: 48,
                                    child: Icon(
                                      Icons.qr_code_scanner,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
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
                    'Select Sales Order and Pallet Code, then tap Save to proceed',
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
                        label: 'Multi-Scan\nFrame Stickers',
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
                const _StepHint(
                  text:
                      'If sticker is not available, please upload the image',
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
                                      ? AppColors.darkBlue
                                      : const Color(0xFFCBD5E1),
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
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
                                        fontWeight: FontWeight.w800,
                                        fontSize: 15,
                                        fontFamily: 'Urbanist',
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
              const SizedBox(height: 10),
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
    final confirmed = await AppDialog.confirmFreezeQuantity(context);

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

    // Error is already shown via the page BlocListener dialog — no snackbar.
    if (!success) return;

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
    final cubit = context.cubit<CreateFrameCubit>();
    await Navigator.of(context).push<int>(
      MaterialPageRoute(
        builder:
            (_) => BurstScanPage(
              title: 'Multi-Scan Frames',
              hint: 'Keep scanning stickers — tap Stop when done',
              decodePackingSticker: true,
              onValidate: (code) => cubit.processScannedCode(code),
            ),
      ),
    );
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
            child: Text(
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
