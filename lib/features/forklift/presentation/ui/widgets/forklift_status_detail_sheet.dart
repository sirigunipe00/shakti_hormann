import 'package:flutter/material.dart';
import 'package:shakti_hormann/core/utils/date_format_util.dart';
import 'package:shakti_hormann/features/forklift/model/forklift_models.dart';

/// Compact light status detail sheet (matches Operator Details summary style).
Future<void> showForkliftStatusDetailSheet({
  required BuildContext context,
  required ForkliftInfo info,
  required ForkliftDetailResult detail,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _ForkliftStatusDetailSheet(info: info, detail: detail),
  );
}

class _ForkliftStatusDetailSheet extends StatelessWidget {
  const _ForkliftStatusDetailSheet({
    required this.info,
    required this.detail,
  });

  final ForkliftInfo info;
  final ForkliftDetailResult detail;

  static const _ink = Color(0xFF0E1446);
  static const _muted = Color(0xFF6B7690);
  static const _border = Color(0xFFE6EAF2);
  static const _canvas = Color(0xFFF5F7FB);

  @override
  Widget build(BuildContext context) {
    final f = detail.forklift ?? info;
    final Color badgeBg;
    final Color badgeFg;
    final Color nbBg;
    final Color nbFg;
    final String badge;
    if (f.isOutOfService ||
        (detail.status ?? '').toLowerCase().contains('out')) {
      badgeBg = const Color(0xFFEEF0F4);
      badgeFg = const Color(0xFF5B6472);
      nbBg = const Color(0xFFEEF0F4);
      nbFg = const Color(0xFF5B6472);
      badge = 'Out of service';
    } else if (f.isOccupied ||
        (detail.status ?? '').toLowerCase().contains('occup')) {
      badgeBg = const Color(0xFFFDE8E9);
      badgeFg = const Color(0xFFE23D45);
      nbBg = const Color(0xFFFDE8E9);
      nbFg = const Color(0xFFE23D45);
      badge = 'Occupied';
    } else {
      badgeBg = const Color(0xFFE3F7EC);
      badgeFg = const Color(0xFF1B9E5A);
      nbBg = const Color(0xFFE3F7EC);
      nbFg = const Color(0xFF1B9E5A);
      badge = 'Free';
    }

    final typeCap = [
      f.forkliftType,
      f.capacity,
    ].whereType<String>().where((e) => e.isNotEmpty).join(' · ');

    final occupiedName = detail.occupiedBy?.displayName ??
        f.occupiedBy?.displayName ??
        '';
    final occupiedUser =
        detail.occupiedBy?.user ?? f.occupiedBy?.user ?? '';
    final sinceRaw = detail.since ?? f.since;
    final since = (sinceRaw == null || sinceRaw.isEmpty)
        ? '—'
        : DFU.ddMMyyyyAmPmFromStr(sinceRaw);
    final used = detail.usedLast8Hours?['duration']?.toString() ?? '—';
    final recent = detail.recentUsers.take(2).toList();
    final bottomPad = MediaQuery.paddingOf(context).bottom;

    final summaryLine = f.isOccupied
        ? [
            if (occupiedName.isNotEmpty) occupiedName,
            if (since != '—') 'Since $since',
          ].join(' · ')
        : f.isOutOfService
            ? (f.outOfServiceReason ?? 'Out of service')
            : (typeCap.isEmpty ? 'Available' : typeCap);

    return Container(
      decoration: const BoxDecoration(
        color: _canvas,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 10 + bottomPad),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFD5DAE5),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Forklift Status Details',
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontWeight: FontWeight.w800,
                        fontSize: 15.5,
                        color: _ink,
                      ),
                    ),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded, color: _muted),
                  ),
                ],
              ),
              // Compact light summary (replaces dark hero)
              Container(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _border),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: nbBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        f.shortNo,
                        style: TextStyle(
                          color: nbFg,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Urbanist',
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  f.displayNo,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: _ink,
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.w800,
                                    fontFamily: 'Urbanist',
                                  ),
                                ),
                              ),
                              _pill(badge, badgeBg, badgeFg),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            typeCap.isEmpty ? '—' : typeCap,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: _muted,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Urbanist',
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            summaryLine.isEmpty ? '—' : summaryLine,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF2957A4),
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Urbanist',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              _sectionTitle(Icons.info_outline_rounded, 'Details'),
              _card([
                _row(
                  'Status',
                  badge,
                  trailing: _pill(badge, badgeBg, badgeFg),
                ),
                if (f.isOccupied) ...[
                  _row(
                    'Occupied by',
                    occupiedName.isEmpty ? '—' : occupiedName,
                  ),
                  if (occupiedUser.isNotEmpty) _row('User', occupiedUser),
                  _row('Since', since),
                ],
                if (f.isOutOfService)
                  _row('Reason', f.outOfServiceReason ?? '—'),
                _row('Used (8h)', used),
                _row('Plant', f.plantName ?? '—'),
              ]),
              if (recent.isNotEmpty) ...[
                const SizedBox(height: 10),
                _sectionTitle(Icons.history_rounded, 'Recent Users'),
                _card([
                  for (var i = 0; i < recent.length; i++) ...[
                    _recentRow(recent[i]),
                    if (i < recent.length - 1)
                      const Divider(height: 1, color: Color(0xFFE3E8F1)),
                  ],
                ]),
              ],
              const SizedBox(height: 12),
              SizedBox(
                height: 46,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _ink,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.w800,
                      fontSize: 14.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _recentRow(ForkliftSession s) {
    final start = DFU.ddMMyyyyAmPmFromStr(
      s.loginDatetime ??
          ((s.loginDate != null && s.loginTime != null)
              ? '${s.loginDate} ${s.loginTime}'
              : s.loginTime),
    );
    final end = s.logoutDatetime == null && s.logoutTime == null
        ? 'now'
        : DFU.ddMMyyyyAmPmFromStr(
            s.logoutDatetime ??
                ((s.logoutDate != null && s.logoutTime != null)
                    ? '${s.logoutDate} ${s.logoutTime}'
                    : s.logoutTime),
          );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              s.operatorLabel,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: _ink,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              '$start → $end',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.w600,
                fontSize: 11.5,
                color: _muted,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pill(String label, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          fontFamily: 'Urbanist',
        ),
      ),
    );
  }

  Widget _sectionTitle(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: const Color(0xFFE1EBFD),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, size: 15, color: const Color(0xFF2957A4)),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: _ink,
              fontFamily: 'Urbanist',
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            children[i],
            if (i < children.length - 1)
              const Divider(height: 1, color: Color(0xFFE3E8F1)),
          ],
        ],
      ),
    );
  }

  Widget _row(String label, String value, {Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                color: _muted,
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                fontFamily: 'Urbanist',
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.centerRight,
              child: trailing ??
                  Text(
                    value,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: _ink,
                      fontFamily: 'Urbanist',
                      height: 1.3,
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
