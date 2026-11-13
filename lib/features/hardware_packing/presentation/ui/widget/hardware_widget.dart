import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/hardware_packing/model/hardware_packing.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/styles/app_text_styles.dart';
import 'package:shakti_hormann/widgets/doc_status_widget.dart';

class HardwareWidget extends StatelessWidget {
  const HardwareWidget({
    super.key,
    required this.hardware,
    required this.onTap,
  });

  final HardwarePacking hardware;
  final VoidCallback onTap;

  String get _displayNumber {
    final raw = hardware.name;
    if (raw == null || raw.isEmpty) return '---';

    final digits =
        RegExp(r'\d+').allMatches(raw).map((m) => m.group(0)!).toList();
    if (digits.isEmpty) {
      return raw.substring(0, raw.length.clamp(0, 3)).toUpperCase();
    }

    final last = digits.last;
    return last.length > 4
        ? last.substring(last.length - 4)
        : last.padLeft(3, '0');
  }

  String get _boxLabel {
    final n = hardware.boxCount ?? 0;
    return n == 1 ? '1 Box' : '$n Boxes';
  }

  String get _allocation {
    return (hardware.allocationStatus ?? '').trim();
  }

  bool get _isUnallocated => _allocation.toLowerCase() == 'unallocated';

  bool get _isDispatched => _allocation.toLowerCase() == 'dispatched';

  @override
  Widget build(BuildContext context) {
    final so = hardware.salesOrderNo?.trim() ?? '';
    final date = DFU.ddMMyyyyFromStr(hardware.creation ?? '');

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE8ECF4)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0E1446).withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 9, 10, 8),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2957A4).withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          _displayNumber,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF2957A4),
                            letterSpacing: 0.5,
                            fontFamily: 'Urbanist',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hardware.name ?? '',
                            style: AppTextStyles.titleLarge(context).copyWith(
                              color: AppColors.black,
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                              fontFamily: 'Urbanist',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            so.isNotEmpty ? 'SO: $so' : 'SO: —',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF6B7280),
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              fontFamily: 'Urbanist',
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (date.isNotEmpty) ...[
                      const SizedBox(width: 6),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 11,
                            color: Color(0xFF6B7280),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            date,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Urbanist',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: DottedLine(
                    direction: Axis.horizontal,
                    lineLength: double.infinity,
                    lineThickness: 0.5,
                    dashLength: 6,
                    dashColor: Color(0xFFD0D4DD),
                    dashGapLength: 4,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF4E4),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _boxLabel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFFC97800),
                            fontWeight: FontWeight.w800,
                            fontSize: 11,
                            fontFamily: 'Urbanist',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: _allocation.isEmpty
                            ? const SizedBox.shrink()
                            : _AllocationChip(
                                label: _allocation,
                                isUnallocated: _isUnallocated,
                                isDispatched: _isDispatched,
                              ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    DocStatusWidget(
                      status: StringUtils.docStatus(hardware.docStatus ?? 0),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AllocationChip extends StatelessWidget {
  const _AllocationChip({
    required this.label,
    required this.isUnallocated,
    required this.isDispatched,
  });

  final String label;
  final bool isUnallocated;
  final bool isDispatched;

  @override
  Widget build(BuildContext context) {
    final Color bg;
    final Color border;
    final Color fg;
    final IconData icon;

    if (isUnallocated) {
      bg = const Color(0xFFFFF7E0);
      border = const Color(0xFFFFD166);
      fg = const Color(0xFF9A6700);
      icon = Icons.info_outline_rounded;
    } else if (isDispatched) {
      bg = const Color(0xFFEFFAF3);
      border = const Color(0xFFB7E4C7);
      fg = const Color(0xFF15803D);
      icon = Icons.local_shipping_outlined;
    } else {
      bg = const Color(0xFFF0F5FF);
      border = const Color(0xFFD6E2F5);
      fg = const Color(0xFF2957A4);
      icon = Icons.location_on_outlined;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: fg),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                fontFamily: 'Urbanist',
                color: fg,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
