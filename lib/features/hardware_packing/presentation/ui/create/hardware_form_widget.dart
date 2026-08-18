import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/hardware_packing/model/hardware_item.dart';
import 'package:shakti_hormann/features/hardware_packing/presentation/bloc/bloc_provider.dart';
import 'package:shakti_hormann/features/hardware_packing/presentation/bloc/create_hardware_cubit/create_hardware_cubit.dart';
import 'package:shakti_hormann/features/hardware_packing/presentation/bloc/create_hardware_cubit/hardware_items_cubit.dart';
import 'package:shakti_hormann/features/hardware_packing/presentation/ui/widget/hardware_item_widget.dart';
import 'package:shakti_hormann/features/hardware_packing/presentation/ui/widget/scan_page.dart';
import 'package:shakti_hormann/features/shutter_packing/presentation/ui/widget/border_painter.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/dailogs/app_dialogs.dart';
import 'package:shakti_hormann/widgets/input_filed.dart';
import 'package:shakti_hormann/widgets/sectionheader.dart';
import 'package:shakti_hormann/widgets/spaced_column.dart';

class HardwareFormWidget extends StatefulWidget {
  const HardwareFormWidget({super.key});

  @override
  State<HardwareFormWidget> createState() => __HardwareFormWidgetState();
}

class __HardwareFormWidgetState extends State<HardwareFormWidget> {
  final ScrollController _scrollController = ScrollController();
  final focusNodes = List.generate(40, (index) => FocusNode());

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = context.watch<CreateHardwareCubit>().state;
    final packingState = context.watch<HardwarePackingItemsCubit>().state;
    final isCompleted = formState.view == HardwareView.completed;
    final isReadOnly = isCompleted || formState.form.docStatus == 1;
    final newform = formState.form;
    final status = newform.docStatus;
    $logger.devLog('newform$newform');

    return MultiBlocListener(
      listeners: [
        BlocListener<CreateHardwareCubit, CreateHardwareState>(
          listenWhen:
              (previous, current) =>
                  previous.error?.status != current.error?.status,
          listener: (_, state) async {},
        ),
        BlocListener<HardwareItemsCubit, HardwareItemsState>(
          listener: (_, state) {
            state.maybeWhen(
              orElse: () {},
              success: context.cubit<CreateHardwareCubit>().addAllLines,
            );
          },
        ),
        BlocListener<HardwarePackingItemsCubit, HardwarePackingItemsState>(
          listener: (context, state) async {
            if (state.error != null) {
              await AppDialog.showErrorDialog(
                context,
                title: state.error?.title ?? 'Sticker Error',
                content: state.error!.error,
                onTapDismiss: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              );

              if (!context.mounted) return;
              context.read<HardwarePackingItemsCubit>().errorHandled();
              return;
            }

            if (!state.isSuccess || state.response == null) return;

            final response = state.response!;
            final cubit = context.read<CreateHardwareCubit>();
            final form = cubit.state.form;

            final existingSalesOrder = form.salesOrderNo;
            final scannedSalesOrder = response.orderNumber;
            if (existingSalesOrder != null &&
                existingSalesOrder.isNotEmpty &&
                scannedSalesOrder != null &&
                scannedSalesOrder.isNotEmpty &&
                existingSalesOrder != scannedSalesOrder) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'This record is for Sales Order $existingSalesOrder. '
                    'Scanned sticker belongs to $scannedSalesOrder — not allowed.',
                  ),
                ),
              );
              return;
            }

            final boxParts = response.box?.split('/');
            final boxCurrent =
                (boxParts != null && boxParts.length == 2)
                    ? int.tryParse(boxParts[0].trim())
                    : null;
            final boxTotal =
                (boxParts != null && boxParts.length == 2)
                    ? int.tryParse(boxParts[1].trim())
                    : null;

            final alreadyScanned = form.scannedBoxNumbers;

            if (boxCurrent != null && boxTotal != null) {
              if (alreadyScanned.contains(boxCurrent)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Box $boxCurrent of $boxTotal has already been scanned for this order.',
                    ),
                  ),
                );
                return;
              }

              if (alreadyScanned.length >= boxTotal) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'All $boxTotal boxes for this order are already scanned.',
                    ),
                  ),
                );
                return;
              }
            }

            context.read<CreateHardwareCubit>().onValueChanged(
              mesSystem: response.mesBarCode,
              salesOrderNo: response.orderNumber,
              captueDate: response.printDate,
              boxCount: boxCurrent ?? form.boxCount ?? 0,
              totalBoxCount: boxTotal ?? form.totalBoxCount ?? 0,
              scannedBoxNumbers: boxCurrent != null
                  ? [...alreadyScanned, boxCurrent]
                  : alreadyScanned,
            );

            final items =
                response.items.map((e) {
                  return HardwareItem(
                    slNO: e.slNO?.toString(),
                    materialCode: e.materialCode,
                    productName: e.productName,
                    qtySticker: e.qtySticker,
                    uom: e.uom,
                    mesStickerImage: response.mesStickerImage,
                    box: response.box,
                    page: response.page,
                    boxType: response.boxType,
                  );
                }).toList();

            if (items.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No hardware items were found in this sticker.'),
                ),
              );
              return;
            }

            context.read<CreateHardwareCubit>().addHardwareItems(items);
          },
        ),
      ],
      child: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isReadOnly) ...[
              Row(
                children: [
                  Expanded(
                    child:
                        packingState.isLoading
                            ? const _AIExtractionLoadingCard()
                            : _ScanCard(
                              icon: Icons.camera_alt,
                              label: 'Capture MES Sticker',
                              onTap:
                                  () =>
                                      status == 1
                                          ? null
                                          : _captureSticker(context),
                            ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 20),

            const SectionHeader(
              title: 'QR Details',
              assetIcon: 'assets/images/qr.svg',
            ),
            Container(
              padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: SpacedColumn(
                defaultHeight: 6,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InputField(
                    readOnly: true,
                    initialValue: newform.mesSystem,
                    title: 'MSE System No',
                    hintText: 'Scan to add details',
                    isRequired: true,
                    borderColor: AppColors.grey,
                    onChanged: (p0) {
                      context.cubit<CreateHardwareCubit>().onValueChanged(
                        mesSystem: p0,
                      );
                    },
                    focusNode: focusNodes.elementAt(13),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InputField(
                          readOnly: true,
                          initialValue: newform.salesOrderNo,
                          title: 'Sales Order No',
                          hintText: 'Scan to add details',
                          isRequired: true,
                          borderColor: AppColors.grey,
                          onChanged: (p0) {
                            context.cubit<CreateHardwareCubit>().onValueChanged(
                              salesOrderNo: p0,
                            );
                          },
                          focusNode: focusNodes.elementAt(14),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: InputField(
                          key: UniqueKey(),
                          readOnly: true,
                          initialValue: newform.boxCount?.toString() ?? '0',
                          title: 'Box Count',
                          hintText: 'Scan to add details',
                          isRequired: true,
                          borderColor: AppColors.grey,
                          onChanged: (p0) {
                            context.cubit<CreateHardwareCubit>().onValueChanged(
                              boxCount: int.tryParse(p0) ?? 0,
                            );
                          },
                          focusNode: focusNodes.elementAt(15),
                        ),
                      ),
                    ],
                  ),
                  InputField(
                    key: UniqueKey(),
                    readOnly: true,
                    initialValue:
                        (newform.captueDate != null &&
                                newform.captueDate!.contains('.'))
                            ? newform.captueDate
                            : DFU.ddMMyyyyFromStr(
                              newform.captueDate.toString(),
                            ),
                    title: 'Print Date',
                    hintText: 'Scan to add details',
                    isRequired: true,
                    borderColor: AppColors.grey,
                    onChanged: (p0) {
                      context.cubit<CreateHardwareCubit>().onValueChanged(
                        captueDate: p0,
                      );
                    },
                    focusNode: focusNodes.elementAt(15),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const SectionHeader(
              title: 'Item Loaded',
              assetIcon: 'assets/images/vehicleinvoicicon.svg',
            ),
            HardwareItemWidget(
              items: formState.lines,
              isCompleted: isReadOnly,
              onDelete: (slNo) {
                context.read<CreateHardwareCubit>();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _captureSticker(BuildContext context) async {
    final imageFile = await Navigator.push<File>(
      context,
      MaterialPageRoute(builder: (_) => const ScanHardWarePage()),
    );

    if (imageFile == null) return;
    if (context.mounted) {
      context.read<CreateHardwareCubit>().onValueChanged(mesImage: imageFile);
      context.read<HardwarePackingItemsCubit>().fetchHardwareItems(imageFile);
    }
  }
}

class _AIExtractionLoadingCard extends StatelessWidget {
  const _AIExtractionLoadingCard();

  @override
  Widget build(BuildContext context) {
    return DashedBorderBox(
      borderRadius: 16,
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 52,
              height: 52,
              child: CircularProgressIndicator(
                strokeWidth: 4,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'AI Extraction',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Please wait while data is being extracted...',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScanCard extends StatelessWidget {
  const _ScanCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                decoration: const BoxDecoration(
                  color: Color(0xFF2563EB),
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
    );
  }
}
