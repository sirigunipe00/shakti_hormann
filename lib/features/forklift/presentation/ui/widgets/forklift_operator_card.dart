import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:shakti_hormann/core/utils/date_format_util.dart';
import 'package:shakti_hormann/features/forklift/model/forklift_models.dart';

class ForkliftOperatorCard extends StatelessWidget {
  const ForkliftOperatorCard({
    super.key,
    required this.session,
    required this.onTap,
  });

  final ForkliftSession session;
  final VoidCallback onTap;

  static const _ink = Color(0xFF0E1446);
  static const _muted = Color(0xFF6B7690);
  static const _accent = Color(0xFFF2A93B);
  static const _border = Color(0xFFE6EAF2);

  @override
  Widget build(BuildContext context) {
    final active = session.active;
    final badgeBg =
        active ? const Color(0xFFE3F7EC) : const Color(0xFFFDE8E9);
    final badgeFg =
        active ? const Color(0xFF1B9E5A) : const Color(0xFFE23D45);
    final nbBg =
        active ? const Color(0xFFFFF0D6) : const Color(0xFFFCE4EF);
    final nbFg =
        active ? const Color(0xFFD4890A) : const Color(0xFFD6479B);

    final loginDateRaw = session.loginDatetime ??
        (session.loginDate != null
            ? (session.loginTime == null
                ? session.loginDate!
                : '${session.loginDate} ${session.loginTime}')
            : '');
    // List cards stay compact: date only (DD-MM-YYYY). Full AM/PM is on details.
    final loginDate = loginDateRaw.isEmpty
        ? ''
        : DFU.ddMMyyyyFromStr(loginDateRaw);

    final logNo = (session.name ?? '').trim();
    final operatorLine = [
      if ((session.user ?? '').trim().isNotEmpty) session.user!.trim(),
      if (session.operatorLabel.trim().isNotEmpty) session.operatorLabel.trim(),
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
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 11),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                        session.shortNo,
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
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  session.displayForklift,
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
                              ),
                              if (loginDate.isNotEmpty) ...[
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.calendar_month_rounded,
                                  size: 14,
                                  color: Color(0xFF2957A4),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  loginDate,
                                  style: const TextStyle(
                                    color: Color(0xFF2957A4),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Urbanist',
                                  ),
                                ),
                              ],
                            ],
                          ),
                          if (logNo.isNotEmpty) ...[
                            const SizedBox(height: 3),
                            Text(
                              logNo,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12.5,
                                color: Color(0xFF2957A4),
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Urbanist',
                                height: 1.2,
                              ),
                            ),
                          ],
                          const SizedBox(height: 3),
                          Text(
                            operatorLine.isEmpty ? '—' : operatorLine,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: _muted,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Urbanist',
                              height: 1.25,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: DottedLine(
                    dashLength: 5,
                    dashGapLength: 4,
                    lineThickness: 0.8,
                    dashColor: Color(0xFFD5DAE5),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        active
                            ? 'Running: ${session.duration ?? '—'}'
                            : 'Used: ${session.duration ?? '—'}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: _accent,
                          fontFamily: 'Urbanist',
                        ),
                      ),
                    ),
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
                        active ? 'Active' : 'Logged out',
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
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }
}
