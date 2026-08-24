import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/frame_packing/presentation/ui/create/frame_scan_page.dart';
import 'package:shakti_hormann/features/shutter_packing/presentation/ui/widget/border_painter.dart';
import 'package:shakti_hormann/features/zone_transfer/presentation/bloc/create_zone_cubit/create_zone_cubit.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/input_filed.dart';
import 'package:shakti_hormann/widgets/inputs/new_upload_photo_widget.dart';
import 'package:shakti_hormann/widgets/sectionheader.dart';
import 'package:shakti_hormann/widgets/spaced_column.dart';

class ZoneFormWidget extends StatefulWidget {
  const ZoneFormWidget({super.key});

  @override
  State<ZoneFormWidget> createState() => __ZoneFormWidgetState();
}

class __ZoneFormWidgetState extends State<ZoneFormWidget> {
  final ScrollController _scrollController = ScrollController();
  final focusNodes = List.generate(40, (index) => FocusNode());

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = context.watch<CreateZoneCubit>().state;
    final isCompleted = formState.view == ZoneView.completed;
    final newform = formState.form;

    return MultiBlocListener(
      listeners: [
        BlocListener<CreateZoneCubit, CreateZoneState>(
          listenWhen:
              (previous, current) =>
                  previous.error?.status != current.error?.status,
          listener: (_, state) async {},
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
      if (!formState.isMoveFlow) ...[
        Expanded(
          child: _ScanCard(
            icon: Icons.qr_code_scanner,
            label: 'Scan pallet / Box Qr',
            onTap: () => _onScanSticker(context, isZoneScan: false),
          ),
        ),
        const SizedBox(width: 12),
      ],
      Expanded(
        child: _ScanCard(
          icon: Icons.qr_code_scanner,
          label: 'Scan New Zone Qr',
          onTap: () => _onScanSticker(context, isZoneScan: true),
        ),
      ),
    ],
  ),
],
            // if(!isCompleted)...[
            // Row(
            //   children: [
            //     Expanded(
            //       child: _ScanCard(
            //         icon: Icons.qr_code_scanner,
            //         label: 'Scan pallet / Box Qr',
            //         onTap: () => _onScanSticker(context,isZoneScan: false),
            //       ),
            //     ),
            //     const SizedBox(width: 12),
            //     Expanded(
            //       child: _ScanCard(
            //         icon: Icons.qr_code_scanner,
            //         label: 'Scan New Zone Qr',
            //         onTap: () => _onScanSticker(context,isZoneScan: true),
            //       ),
            //     ),
            //   ],
            // ),
            // ],

            const SizedBox(height: 20),

            

            const SizedBox(height: 20),

            const SectionHeader(
              title: 'Pallet Details',
              assetIcon: 'assets/images/palleticon.svg',
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
                      key: ValueKey('zt_pallet_${newform.palletBoxQr}'),
                      readOnly: true,
                      initialValue: newform.palletBoxQr,
                      title: 'Pallet No',
                      hintText: 'Scan to add details',
                      isRequired: true,
                      borderColor: AppColors.grey,
                      onChanged: (p0) {
                        context.cubit<CreateZoneCubit>().onValueChanged(
                          palletNo: p0,
                        );
                      },
                      focusNode: focusNodes.elementAt(13),
                    ),
                     InputField(
                      key: ValueKey('zt_qty_${newform.totalQty}'),
                      readOnly: true,
                      initialValue: newform.totalQty?.toString() ?? '0',
                      title: 'Total Quantity',
                      hintText: 'Scan to add details',
                      isRequired: true,
                      borderColor: AppColors.grey,
                      onChanged: (p0) {
                        context.cubit<CreateZoneCubit>().onValueChanged(
                          totalQty: int.tryParse(p0),
                        );
                      },
                      focusNode: focusNodes.elementAt(13),
                    ),
                     InputField(
                      key: ValueKey('zt_so_${newform.salesOrders}'),
                      readOnly: true,
                      initialValue: newform.salesOrders,
                      title: 'Sales Order No',
                      hintText: 'Scan to add details',
                      isRequired: true,
                      borderColor: AppColors.grey,
                      onChanged: (p0) {
                        context.cubit<CreateZoneCubit>().onValueChanged(
                          salesOrders: p0,
                        );
                      },
                      focusNode: focusNodes.elementAt(13),
                    ),                     InputField(
                      key: ValueKey('zt_old_${newform.oldZone}'),
                      readOnly: true,
                      initialValue: newform.oldZone,
                      title: 'Old Zone No',
                      hintText: 'Scan to add details',
                      isRequired: false,
                      borderColor: AppColors.grey,
                      onChanged: (p0) {
                        context.cubit<CreateZoneCubit>().onValueChanged(
                          oldzone: p0,
                        );
                      },
                      focusNode: focusNodes.elementAt(13),
                    ),
                    InputField(
                    key: ValueKey('zt_count_${newform.palletCount}'),
                    readOnly: true,
                    initialValue: newform.palletCount == null ? '0' : newform.palletCount.toString(),
                    title: 'Pallet Count',
                    hintText: 'pallet count',
                    isRequired: false,
                    borderColor: AppColors.grey,
                    onChanged: (p0) {
                      context.cubit<CreateZoneCubit>().onValueChanged(
                        palletCount: int.parse(p0),
                      );
                    },
                    focusNode: focusNodes.elementAt(13),
                  ),

                  ],
                ),
              ),
              const SizedBox(height: 20),

            const SectionHeader(
              title: 'New Zone Details',
              assetIcon: 'assets/images/zone_icon.svg',
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
                      key: ValueKey('zt_new_${newform.zoneQr}'),
                      readOnly: true,
                      initialValue: newform.zoneQr,
                      title: 'New Zone No',
                      hintText: 'Scan to add details',
                      isRequired: true,
                      borderColor: AppColors.grey,
                      onChanged: (p0) {
                        context.cubit<CreateZoneCubit>().onValueChanged(
                          newzoneQr: p0,
                        );
                      },
                      focusNode: focusNodes.elementAt(13),
                    ),
            //          const SectionHeader(
            //   title: 'Allocated New Zone Photo',
            //   assetIcon: 'assets/images/phot.svg',
            // ),

            DashedBorderBox(
              borderRadius: 12,
              child: 
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                   NewUploadPhotoWidget(
                      fileName: 'zone_icon',
                      imageUrl: newform.locationPhoto,
                      title: 'New Zone Image',
                      isRequired: true,
                      isReadOnly: isCompleted,
                      onFileCapture: (file) {
                        context.cubit<CreateZoneCubit>().onValueChanged(
                          zonePhoto: file,
                        );
                      },
                    ),
                  ],
                ),
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

  Future<void> _onScanSticker(BuildContext context,
  {required bool isZoneScan,}) async {
    if (context.read<CreateZoneCubit>().state.view ==
        ZoneView.completed) {
      return;
    }
    final raw = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (_) => const ScanFramePage.qr()),
    );

    if (raw == null || !context.mounted) return;

    if (isZoneScan) {
      context.cubit<CreateZoneCubit>().onValueChanged(newzoneQr: raw);
    } else {
      context.cubit<CreateZoneCubit>().onQrScanned(raw);
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
