import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/frame_packing/presentation/bloc/create_frame_cubit.dart/create_frame_cubit.dart';
import 'package:shakti_hormann/features/frame_packing/presentation/ui/create/frame_scan_page.dart';
import 'package:shakti_hormann/features/shutter_packing/presentation/ui/widget/border_painter.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/input_filed.dart';
import 'package:shakti_hormann/widgets/inputs/new_upload_photo_widget.dart';
import 'package:shakti_hormann/widgets/sectionheader.dart';
import 'package:shakti_hormann/widgets/spaced_column.dart';

class StorageFormWidget extends StatefulWidget {
  const StorageFormWidget({super.key});

  @override
  State<StorageFormWidget> createState() => __StorageFormWidgetState();
}

class __StorageFormWidgetState extends State<StorageFormWidget> {
  final ScrollController _scrollController = ScrollController();
  final focusNodes = List.generate(40, (index) => FocusNode());

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formState = context.watch<CreateFrameCubit>().state;
    final isCompleted = formState.view == FrameView.completed;
    final newform = formState.form;

    return MultiBlocListener(
      listeners: [
        BlocListener<CreateFrameCubit, CreateFrameState>(
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
            if(!isCompleted)...[
            Row(
              children: [
                Expanded(
                  child: _ScanCard(
                    icon: Icons.qr_code_scanner,
                    label: 'Scan Pallet / Box Qr',
                    onTap: () => _onScanSticker(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ScanCard(
                    icon: Icons.qr_code_scanner,
                    label: 'Scan Zone Qr',
                    onTap: () => _onScanSticker(context),
                  ),
                ),
              ],
            ),
            ],

            const SizedBox(height: 20),

            const SectionHeader(
              title: 'Allocated Zone Photo',
              assetIcon: 'assets/images/phot.svg',
            ),

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
                   NewUploadPhotoWidget(
                      fileName: 'zone_icon',
                      imageUrl: newform.palletPhoto,
                      title: 'Zone Image',
                      isRequired: true,
                      isReadOnly: isCompleted,
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
                      readOnly: isCompleted,
                      initialValue: newform.palletNo,
                      title: 'Pallet No',
                      hintText: 'Scan to add details',
                      isRequired: false,
                      borderColor: AppColors.grey,
                      onChanged: (p0) {
                        context.cubit<CreateFrameCubit>().onValueChanged(
                          palletNo: p0,
                        );
                      },
                      focusNode: focusNodes.elementAt(13),
                    ),
                     InputField(
                      readOnly: isCompleted,
                      initialValue: newform.palletNo,
                      title: 'No of Frames',
                      hintText: 'Scan to add details',
                      isRequired: false,
                      borderColor: AppColors.grey,
                      onChanged: (p0) {
                        context.cubit<CreateFrameCubit>().onValueChanged(
                          palletNo: p0,
                        );
                      },
                      focusNode: focusNodes.elementAt(13),
                    ),
                     InputField(
                      readOnly: isCompleted,
                      initialValue: newform.palletNo,
                      title: 'Sales Order No',
                      hintText: 'Scan to add details',
                      isRequired: false,
                      borderColor: AppColors.grey,
                      onChanged: (p0) {
                        context.cubit<CreateFrameCubit>().onValueChanged(
                          palletNo: p0,
                        );
                      },
                      focusNode: focusNodes.elementAt(13),
                    ),

                  ],
                ),
              ),
              const SizedBox(height: 20),

            const SectionHeader(
              title: 'Zone Details',
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
                      readOnly: isCompleted,
                      initialValue: newform.palletNo,
                      title: 'Zone No',
                      hintText: 'Scan to add details',
                      isRequired: false,
                      borderColor: AppColors.grey,
                      onChanged: (p0) {
                        context.cubit<CreateFrameCubit>().onValueChanged(
                          palletNo: p0,
                        );
                      },
                      focusNode: focusNodes.elementAt(13),
                    )

                  ],
                ),
              ),

            ],
        ),
      ),
    );
  }

  Future<void> _onScanSticker(BuildContext context) async {
    final raw = await Navigator.of(
      context,
    ).push<String>(MaterialPageRoute(builder: (_) => const ScanFramePage()));

    if (raw == null || !context.mounted) return;
    context.cubit<CreateFrameCubit>().onQrScanned(raw);
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
