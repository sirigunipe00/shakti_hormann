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
    final isCompleted = formState.view == HardwareView.completed;
    final newform = formState.form;
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
          listener: (context, state) {
            if (!state.isSuccess || state.response == null) return;

            final response = state.response!;
            final cubit = context.read<CreateHardwareCubit>();
            final form = cubit.state.form;

            final boxParts = response.box?.split('/');
            final boxCurrent =
                (boxParts != null && boxParts.length == 2)
                    ? int.tryParse(boxParts[0].trim())
                    : null;
            final boxTotal =
                (boxParts != null && boxParts.length == 2)
                    ? int.tryParse(boxParts[1].trim())
                    : null;

            if (boxCurrent == null || boxTotal == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Could not read box count from sticker.'),
                ),
              );
              return;
            }

            final alreadyScanned = form.scannedBoxNumbers;
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

            context.read<CreateHardwareCubit>().onValueChanged(
              mesSystem: response.mesBarCode,
              salesOrderNo: response.orderNumber,
              captueDate: response.printDate,
              boxCount: int.tryParse(response.box?.split('/').first ?? '0'),
              totalBoxCount: boxTotal,
              scannedBoxNumbers: [...alreadyScanned, boxCurrent],
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
                  );
                }).toList();

            // context.read<CreateHardwareCubit>().updateHardwareItems(items);
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
            if (!isCompleted) ...[
              Row(
                children: [
                  Expanded(
                    child: _ScanCard(
                      icon: Icons.camera_alt,
                      label: 'Capture MES Sticker',
                      onTap: () => _captureSticker(context),
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
                    readOnly: isCompleted,
                    initialValue: newform.mesSystem,
                    title: 'MSE System No',
                    hintText: 'Scan to add details',
                    isRequired: false,
                    borderColor: AppColors.grey,
                    onChanged: (p0) {
                      context.cubit<CreateHardwareCubit>().onValueChanged(
                        mesSystem: p0,
                      );
                    },
                    focusNode: focusNodes.elementAt(13),
                  ),
                  InputField(
                    readOnly: isCompleted,
                    initialValue: newform.salesOrderNo,
                    title: 'Sales Order No',
                    hintText: 'Scan to add details',
                    isRequired: false,
                    borderColor: AppColors.grey,
                    onChanged: (p0) {
                      context.cubit<CreateHardwareCubit>().onValueChanged(
                        salesOrderNo: p0,
                      );
                    },
                    focusNode: focusNodes.elementAt(14),
                  ),
                  InputField(
                    key: UniqueKey(),
                    readOnly: isCompleted,
                    initialValue:
                        (newform.captueDate != null &&
                                newform.captueDate!.contains('.'))
                            ? newform.captueDate
                            : DFU.ddMMyyyyFromStr(
                              newform.captueDate.toString(),
                            ),
                    title: 'Print Date',
                    hintText: 'Scan to add details',
                    isRequired: false,
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
              isCompleted: isCompleted,
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
