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
    for (final n in focusNodes) {
      n.dispose();
    }
    super.dispose();
  }

  void _snack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formState = context.watch<CreateZoneCubit>().state;
    final isCompleted = formState.view == ZoneView.completed;
    final newform = formState.form;
    final isMoveFlow = formState.isMoveFlow;

    final hasPallet =
        (newform.palletBoxQr?.trim().isNotEmpty ?? false);
    final hasZone = (newform.zoneQr?.trim().isNotEmpty ?? false);
    final hasPhoto = newform.locationPhotoImg != null ||
        (newform.locationPhoto?.trim().isNotEmpty ?? false);
    final hasSo = (newform.salesOrders?.trim().isNotEmpty ?? false);

    return MultiBlocListener(
      listeners: [
        BlocListener<CreateZoneCubit, CreateZoneState>(
          listenWhen: (previous, current) =>
              previous.error != current.error &&
              current.error?.title == 'SAME_ZONE',
          listener: (context, state) {
            final err = state.error;
            if (err == null) return;
            _snack(err.error);
            context.cubit<CreateZoneCubit>().errorHandled();
          },
        ),
      ],
      child: ColoredBox(
        color: const Color(0xFFF7F8FA),
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: ShellInsets.scrollPadding(
            context,
            left: 16,
            right: 16,
            top: 12,
          ),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isCompleted) ...[
                _FlowSteps(
                  hasPallet: hasPallet || isMoveFlow,
                  hasZone: hasZone,
                  hasPhoto: hasPhoto,
                ),
                const SizedBox(height: 12),
                if (!isMoveFlow) ...[
                  _ScanCard(
                    icon: Icons.qr_code_scanner_rounded,
                    label: hasPallet
                        ? 'Pallet scanned'
                        : '1. Scan Pallet / Box QR',
                    hint: hasPallet
                        ? (newform.palletBoxQr ?? '')
                        : 'Fills SO, qty, and last zone',
                    done: hasPallet,
                    onTap: () => _onScanSticker(context, isZoneScan: false),
                  ),
                  const SizedBox(height: 10),
                ] else ...[
                  _InfoBanner(
                    icon: Icons.swap_horiz_rounded,
                    text:
                        'Moving pallet ${newform.palletBoxQr ?? ''}. Scan the new zone, then capture a photo.',
                  ),
                  const SizedBox(height: 10),
                ],
                _ScanCard(
                  icon: Icons.location_on_outlined,
                  label: hasZone ? 'Zone scanned' : '2. Scan Zone QR',
                  hint: hasZone
                      ? (newform.zoneQr ?? '')
                      : (!hasPallet && !isMoveFlow)
                          ? 'Scan the pallet first'
                          : 'Assign storage location',
                  done: hasZone,
                  enabled: hasPallet || isMoveFlow,
                  onTap: () {
                    if (!hasPallet && !isMoveFlow) {
                      _snack('Scan the pallet / box QR first');
                      return;
                    }
                    _onScanSticker(context, isZoneScan: true);
                  },
                ),
                const SizedBox(height: 14),
              ] else ...[
                const SizedBox(height: 4),
              ],

              const SectionHeader(
                title: 'Pallet Details',
                assetIcon: 'assets/images/palleticon.svg',
              ),
              _SoftCard(
                child: SpacedColumn(
                  defaultHeight: 8,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InputField(
                      key: ValueKey('st_pallet_${newform.palletBoxQr}'),
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
                      key: ValueKey('st_so_${newform.salesOrders}'),
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
                      focusNode: focusNodes.elementAt(14),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: InputField(
                            key: ValueKey('st_qty_${newform.totalQty}'),
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
                            focusNode: focusNodes.elementAt(15),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InputField(
                            key: ValueKey('st_count_${newform.palletCount}'),
                            readOnly: true,
                            initialValue: newform.palletCount == null
                                ? ''
                                : newform.palletCount.toString(),
                            title: 'Transfer Count',
                            hintText: 'Auto-filled',
                            isRequired: false,
                            borderColor: AppColors.grey,
                            onChanged: (p0) {
                              context.cubit<CreateZoneCubit>().onValueChanged(
                                palletCount: int.tryParse(p0),
                              );
                            },
                            focusNode: focusNodes.elementAt(16),
                          ),
                        ),
                      ],
                    ),
                    if (!isCompleted && hasPallet && !hasSo)
                      const Text(
                        'Pallet scanned, but Sales Order is missing. Rescan or check the pallet QR.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFFB45309),
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    if (!isCompleted && !hasPallet && !isMoveFlow)
                      const Text(
                        'Scan a pallet / box QR to fill Sales Order, quantity, and last zone.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                          fontFamily: 'Urbanist',
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              const SectionHeader(
                title: 'Zone Details',
                assetIcon: 'assets/images/zone_icon.svg',
              ),
              _SoftCard(
                child: SpacedColumn(
                  defaultHeight: 8,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InputField(
                      key: ValueKey('st_zone_${newform.zoneQr}'),
                      readOnly: true,
                      initialValue: newform.zoneQr,
                      title: 'Zone No',
                      hintText: 'Scan to add details',
                      isRequired: true,
                      borderColor: AppColors.grey,
                      onChanged: (p0) {
                        context.cubit<CreateZoneCubit>().onValueChanged(
                          newzoneQr: p0,
                        );
                      },
                      focusNode: focusNodes.elementAt(17),
                    ),
                    if (newform.oldZone != null &&
                        newform.oldZone!.isNotEmpty) ...[
                      InputField(
                        key: ValueKey('st_old_${newform.oldZone}'),
                        readOnly: true,
                        initialValue: newform.oldZone,
                        title: 'Last Zone No',
                        hintText: 'Previous location',
                        isRequired: false,
                        borderColor: AppColors.grey,
                        onChanged: (p0) {
                          context.cubit<CreateZoneCubit>().onValueChanged(
                            oldzone: p0,
                          );
                        },
                        focusNode: focusNodes.elementAt(18),
                      ),
                    ],
                    Opacity(
                      opacity: hasZone || isCompleted ? 1 : 0.55,
                      child: IgnorePointer(
                        ignoring: !hasZone && !isCompleted,
                        child: DashedBorderBox(
                          borderRadius: 12,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: NewUploadPhotoWidget(
                              fileName: 'zone_icon',
                              imageUrl: newform.locationPhoto,
                              title: '3. Allocated Zone Image',
                              isRequired: true,
                              // Photo is proof of zone — locked until zone QR is scanned.
                              isReadOnly: isCompleted || !hasZone,
                              onFileCapture: (file) {
                                context.cubit<CreateZoneCubit>().onValueChanged(
                                  zonePhoto: file,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (!isCompleted && !hasZone)
                      const Text(
                        'Scan Zone QR first — photo unlocks after the zone is scanned.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                          fontFamily: 'Urbanist',
                        ),
                      )
                    else if (!isCompleted && !hasPhoto)
                      const Text(
                        'Capture a clear photo of the allocated zone before saving.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                          fontFamily: 'Urbanist',
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onScanSticker(
    BuildContext context, {
    required bool isZoneScan,
  }) async {
    if (context.read<CreateZoneCubit>().state.view == ZoneView.completed) {
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

class _FlowSteps extends StatelessWidget {
  const _FlowSteps({
    required this.hasPallet,
    required this.hasZone,
    required this.hasPhoto,
  });

  final bool hasPallet;
  final bool hasZone;
  final bool hasPhoto;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8ECF4)),
      ),
      child: Row(
        children: [
          _StepChip(index: 1, label: 'Pallet', done: hasPallet),
          _StepDivider(active: hasPallet),
          _StepChip(index: 2, label: 'Zone', done: hasZone),
          _StepDivider(active: hasZone),
          _StepChip(index: 3, label: 'Photo', done: hasPhoto),
        ],
      ),
    );
  }
}

class _StepChip extends StatelessWidget {
  const _StepChip({
    required this.index,
    required this.label,
    required this.done,
  });

  final int index;
  final String label;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: done ? const Color(0xFF16A34A) : const Color(0xFF2957A4),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: done
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : Text(
                      '$index',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Urbanist',
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                fontFamily: 'Urbanist',
                color: done
                    ? const Color(0xFF16A34A)
                    : const Color(0xFF0E1446),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepDivider extends StatelessWidget {
  const _StepDivider({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      color: active ? const Color(0xFF16A34A) : const Color(0xFFD0D4DD),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF2563EB), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E3A8A),
                fontFamily: 'Urbanist',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SoftCard extends StatelessWidget {
  const _SoftCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
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
      child: child,
    );
  }
}

class _ScanCard extends StatelessWidget {
  const _ScanCard({
    required this.icon,
    required this.label,
    required this.onTap,
    this.hint,
    this.done = false,
    this.enabled = true,
  });

  final IconData icon;
  final String label;
  final String? hint;
  final VoidCallback onTap;
  final bool done;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final accent = done
        ? const Color(0xFF16A34A)
        : enabled
            ? const Color(0xFF0E2A5C)
            : const Color(0xFF94A3B8);

    return Opacity(
      opacity: enabled || done ? 1 : 0.55,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: DashedBorderBox(
            borderRadius: 16,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
              decoration: BoxDecoration(
                color: done
                    ? const Color(0xFFF0FDF4)
                    : Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: accent,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      done ? Icons.check_rounded : icon,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: done
                          ? const Color(0xFF166534)
                          : const Color(0xFF0E1446),
                      fontFamily: 'Urbanist',
                    ),
                  ),
                  if (hint != null && hint!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      hint!,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                        fontFamily: 'Urbanist',
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
