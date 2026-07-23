import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/logistic_request/model/sales_order_form.dart';
import 'package:shakti_hormann/features/pallet_creation/model/pallet_model.dart';
import 'package:shakti_hormann/features/shutter_packing/model/pallet_code.dart';
import 'package:shakti_hormann/features/shutter_packing/model/pallet_size.dart';
import 'package:shakti_hormann/features/shutter_packing/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/shutter_packing/presentation/bloc/create_shutter_cubit.dart/create_shutter_cubit.dart';
import 'package:shakti_hormann/features/shutter_packing/presentation/ui/create/scan_shutter_page.dart';
import 'package:shakti_hormann/features/shutter_packing/presentation/ui/widget/border_painter.dart';
import 'package:shakti_hormann/features/shutter_packing/presentation/ui/widget/shutter_lines_widget.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/dailogs/app_dialogs.dart';
import 'package:shakti_hormann/widgets/inputs/new_upload_photo_widget.dart';
import 'package:shakti_hormann/widgets/inputs/search_dropdown_widget.dart';
import 'package:shakti_hormann/widgets/sectionheader.dart';

class ShutterPackingFormWidget extends StatefulWidget {
  const ShutterPackingFormWidget({super.key});

  @override
  State<ShutterPackingFormWidget> createState() =>
      __ShutterPackingFormWidgetState();
}

class __ShutterPackingFormWidgetState extends State<ShutterPackingFormWidget> {
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
    final formState = context.watch<CreateShutterCubit>().state;
    final isCompleted = formState.view == ShutterView.completed;
    final isFrozen = formState.isFrozen;
    final isScanningDisabled = isCompleted || isFrozen;
    final newform = formState.form;
    final status = newform.docStatus;
    $logger.devLog('form......$newform');

    return MultiBlocListener(
      listeners: [
        BlocListener<CreateShutterCubit, CreateShutterState>(
          listenWhen:
              (previous, current) =>
                  previous.error?.status != current.error?.status,
          listener: (_, state) async {},
        ),
        BlocListener<ShutterLinesCubit, ShutterLinesCubitState>(
          listener: (_, state) {
            state.maybeWhen(
              orElse: () {},
              success: context.cubit<CreateShutterCubit>().addAllLines,
            );
          },
        ),
      ],
      child: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              title: 'SO Details',
              assetIcon: 'assets/images/palleticon.svg',
            ),
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
                  BlocBuilder<SalesOrdersCubit, SalesOrderCubitState>(
                    builder: (_, state) {
                      final allData = state.maybeWhen(
                        orElse: () => <PalletModel>[],
                        success: (data) => data,
                      );
                  
                      final names = allData.toList();
                  
                      return SearchDropDownList<PalletModel>(
                        title: 'Sales Order No.',
                        hint: 'Select Sales Order',
                        key: ValueKey(newform.salesOrder),
                        color: AppColors.black,
                        items: names,
                        readOnly: isFrozen || isCompleted,
                        defaultSelection: names.firstWhere(
                          (g) => g.salesOrder == newform.salesOrder,
                          orElse: () => const PalletModel(),
                        ),
                        isloading: state.isLoading,
                        futureRequest: (query) async {
                          if (query.isEmpty) return names;
                          return names.where((item) {
                            final orderNo = item.salesOrder?.toLowerCase() ?? '';
                            final search = query.toLowerCase();
                            return orderNo.contains(search);
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
                            (_, item, __, ___) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Order No: ${item.salesOrder ?? ''}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                        onSelected: (selected) {
                          context.cubit<CreateShutterCubit>().onValueChanged(
                            salesOrder: selected.salesOrder,
                          );
                          context.cubit<CreateShutterCubit>().getPalletCodes(
                            selected.salesOrder!,
                          );
                        },
                        focusNode: FocusNode(),
                      );
                    },
                  ),
                    const SizedBox(height: 12),
            BlocBuilder<CreateShutterCubit, CreateShutterState>(
              builder: (context, state) {
                final palletCodes =
                    state.palletCodes
                        .map((e) => PalletCodeModel(name: e))
                        .toList();

                return SearchDropDownList<PalletCodeModel>(
                  title: 'Pallet Select',
                  hint: 'Search Pallet',
                  key: ValueKey(newform.palletCode),
                  items: palletCodes,
                  readOnly: isFrozen || isCompleted,
                  color: AppColors.black,

                  defaultSelection: palletCodes.firstWhere(
                    (e) =>
                        e.name.trim() == (state.form.palletCode ?? '').trim(),
                    orElse: () => const PalletCodeModel(name: ''),
                  ),

                  futureRequest: (query) async {
                    if (query.isEmpty) return palletCodes;

                    return palletCodes.where((e) {
                      return e.name.toLowerCase().contains(query.toLowerCase());
                    }).toList();
                  },

                  headerBuilder: (_, item, __) => Text(item.name),

                  listItemBuilder: (_, item, __, ___) => Text(item.name),

                  onSelected: (selected) {
                    context.read<CreateShutterCubit>().onValueChanged(
                      palletCode: selected.name,
                    );
                  },
                );
              },
            ),
                ],
              ),
            
            ),
            
            const SizedBox(height: 10),
            if (!isCompleted) ...[
              Row(
                children: [
                  Expanded(
                    child: _ScanCard(
                      icon: Icons.qr_code_scanner,
                      label: 'Scan Shutter\nSticker',
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
                      icon: Icons.camera_alt_outlined,
                      label: 'Upload Shutter\nImage',
                      isDisabled: isScanningDisabled,
                      onTap:
                          isScanningDisabled
                              ? null
                              : () => _onUploadImage(context),
                    ),
                  ),
                ],
              ),
              if (isFrozen) ...[
                const SizedBox(height: 8),
                const Text(
                  'Quantity is frozen. Scanning and image upload are disabled.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF94A3B8),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],

            const SizedBox(height: 20),

            const SectionHeader(
              title: 'Pallet Details',
              assetIcon: 'assets/images/palleticon.svg',
            ),
            // Container(
            //   padding: const EdgeInsets.only(
            //     left: 12,
            //     right: 12,
            //     bottom: 8,
            //     top: 8,
            //   ),
            //   width: MediaQuery.of(context).size.width,
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(12),
            //     border: Border.all(color: Colors.grey.shade300),
            //   ),

            //   child: 
            //   InputField(
            //     readOnly: true,
            //     title: 'Pallet No',
            //     hintText: 'Pallet No',
            //     borderColor: AppColors.grey,
            //     initialValue: newform.palletCode,
            //     onChanged:
            //         (p0) => context.cubit<CreateShutterCubit>().onValueChanged(
            //           palletNo: p0,
            //         ),
            //   ),
            // ),

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
              isReadOnly: newform.palletQrPrinted != 1 || isCompleted,
              onFileCapture: (file) {
                if (newform.palletQrPrinted != 1) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please print the pallet QR before capturing the pallet image.',
                      ),
                    ),
                  );
                  return;
                }
                context.cubit<CreateShutterCubit>().onValueChanged(
                  palletPhoto: file,
                );
              },
            ),
              ],
            ),
            ),
            ),
            const SizedBox(height: 20),

            const SectionHeader(
              title: 'Shutter Details',
              assetIcon: 'assets/images/palleticon.svg',
            ),

            const SizedBox(height: 10),

            const ShutterLinesWidget(),

            const SizedBox(height: 16),
            BlocBuilder<CreateShutterCubit, CreateShutterState>(
              builder: (context, state) {
                if (state.isFrozen) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
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
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _ScanCard(
                              icon: Icons.print,
                              label:
                                  newform.palletQrPrinted == 1
                                      ? 'Sticker Printed'
                                      : 'Print Sticker',
                              isDisabled:
                                  state.isPrinting ||
                                  newform.palletQrPrinted == 1,
                              onTap:
                                  (state.isPrinting ||
                                          newform.palletQrPrinted == 1)
                                      ? null
                                      : () => _onPrintQr(context),
                            ),
                          ),
                          // const SizedBox(width: 12),
                          // Expanded(
                          //   child: NewUploadPhotoWidget(
                          //     fileName: 'camera.png',
                          //     imageUrl: newform.palletPhoto,
                          //     title: 'Pallet Image',
                          //     isRequired: true,
                          //     // Same gating logic as the Pallet Details section:
                          //     // only capturable once the pallet QR has been printed.
                          //     isReadOnly: newform.palletQrPrinted != 1,
                          //     onFileCapture: (file) {
                          //       if (newform.palletQrPrinted != 1) {
                          //         ScaffoldMessenger.of(context).showSnackBar(
                          //           const SnackBar(
                          //             content: Text(
                          //               'Please print the pallet QR before capturing the pallet image.',
                          //             ),
                          //           ),
                          //         );
                          //         return;
                          //       }
                          //       context
                          //           .cubit<CreateShutterCubit>()
                          //           .onValueChanged(palletPhoto: file);
                          //     },
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  );
                }

                final hasLines = state.lines.isNotEmpty;
                final isSubmitted = newform.docStatus == 1;
                final canFreeze = hasLines && !state.isFreezing && !isSubmitted;
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        canFreeze ? () => _onFreezeQuantity(context) : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          hasLines
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
                );
              },
            ),
          ],
        ),
      ),
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

    context.cubit<CreateShutterCubit>().freezeQuantity();

    if (!context.mounted) return;

    await AppDialog.showSuccessDialog(
      context,
      title: 'Quantity Locked',
      content: 'Please Print the Sticker.',
      onTapDismiss: context.exit,
    );
  }

  Future<void> _onPrintQr(BuildContext context) async {
    final cubit = context.cubit<CreateShutterCubit>();
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
        context.exit();
      },
    );

    if (context.mounted) {
      cubit.printHandled();
    }
  }

  Future<void> _onScanSticker(BuildContext context) async {
    final raw = await Navigator.of(
      context,
    ).push<String>(MaterialPageRoute(builder: (_) => const ScanShutterPage()));

    if (raw == null || !context.mounted) return;
    context.cubit<CreateShutterCubit>().onQrScanned(raw);
  }

  Future<void> _onUploadImage(BuildContext context) async {
    final result = await captureAndDecodeShutterQr();

    if (!context.mounted) return;

    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not read sticker. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    context.cubit<CreateShutterCubit>().onQrScanned(
      result['qr']!,
      imagePath: result['imagePath'],
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
    return Opacity(
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
    );
  }
}
