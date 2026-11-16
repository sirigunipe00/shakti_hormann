import 'package:flutter/material.dart';
import 'package:shakti_hormann/core/utils/date_format_util.dart';
import 'package:shakti_hormann/features/forklift/model/forklift_models.dart';

class ForkliftStatusCard extends StatelessWidget {
  const ForkliftStatusCard({
    super.key,
    required this.info,
    required this.onTap,
  });

  final ForkliftInfo info;
  final VoidCallback onTap;

  static const _ink = Color(0xFF0E1446);
  static const _muted = Color(0xFF6B7690);
  static const _border = Color(0xFFE6EAF2);

  @override
  Widget build(BuildContext context) {
    final Color nbBg;
    final Color nbFg;
    final Color badgeBg;
    final Color badgeFg;
    final String badge;
    if (info.isOutOfService) {
      nbBg = const Color(0xFFEEF0F4);
      nbFg = const Color(0xFF6B7280);
      badgeBg = const Color(0xFFEEF0F4);
      badgeFg = const Color(0xFF5B6472);
      badge = 'Out of service';
    } else if (info.isOccupied) {
      nbBg = const Color(0xFFFDE8E9);
      nbFg = const Color(0xFFE23D45);
      badgeBg = const Color(0xFFFDE8E9);
      badgeFg = const Color(0xFFE23D45);
      badge = 'Occupied';
    } else {
      nbBg = const Color(0xFFE3F7EC);
      nbFg = const Color(0xFF1B9E5A);
      badgeBg = const Color(0xFFE3F7EC);
      badgeFg = const Color(0xFF1B9E5A);
      badge = 'Free';
    }

    final subtitle = info.isOccupied
        ? [
            if ((info.occupiedBy?.displayName ?? '').isNotEmpty)
              info.occupiedBy!.displayName,
            if ((info.occupiedBy?.user ?? '').isNotEmpty)
              info.occupiedBy!.user,
          ].join(' · ')
        : info.isOutOfService
            ? (info.outOfServiceReason ?? 'Out of service')
            : [
                if ((info.forkliftType ?? '').isNotEmpty) info.forkliftType,
                if ((info.capacity ?? '').isNotEmpty) info.capacity,
              ].join(' · ');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _border),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0E1446).withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: nbBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    info.shortNo,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: nbFg,
                      letterSpacing: 0.4,
                      fontFamily: 'Urbanist',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        info.displayNo,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: _ink,
                          fontWeight: FontWeight.w800,
                          fontSize: 15.5,
                          fontFamily: 'Urbanist',
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle.isEmpty ? '—' : subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: _muted,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Urbanist',
                        ),
                      ),
                      if (info.isOccupied &&
                          ((info.since?.isNotEmpty ?? false) ||
                              (info.runningDuration?.isNotEmpty ?? false))) ...[
                        const SizedBox(height: 3),
                        Text(
                          [
                            if ((info.since ?? '').isNotEmpty)
                              'Since ${DFU.ddMMyyyyAmPmFromStr(info.since)}',
                            if ((info.runningDuration ?? '').isNotEmpty)
                              info.runningDuration,
                          ].join(' · '),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11.5,
                            color: _muted,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Urbanist',
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: badgeBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    badge,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: badgeFg,
                      fontFamily: 'Urbanist',
                    ),
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
