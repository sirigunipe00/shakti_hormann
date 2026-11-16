import 'package:flutter/material.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/features/auth/model/logged_in_user.dart';
import 'package:shakti_hormann/features/forklift/data/forklift_repo.dart';
import 'package:shakti_hormann/features/forklift/model/forklift_models.dart';
import 'package:shakti_hormann/features/forklift/presentation/ui/create/forklift_scan_flow.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/form_page_loading_stack.dart';

class ForkliftOperatorDetailPage extends StatefulWidget {
  const ForkliftOperatorDetailPage({super.key, required this.session});

  final ForkliftSession session;

  @override
  State<ForkliftOperatorDetailPage> createState() =>
      _ForkliftOperatorDetailPageState();
}

class _ForkliftOperatorDetailPageState extends State<ForkliftOperatorDetailPage> {
  static const _ink = Color(0xFF0E1446);
  static const _muted = Color(0xFF6B7690);
  static const _border = Color(0xFFE6EAF2);
  static const _canvas = Color(0xFFF5F7FB);
  static const _accent = Color(0xFFF2A93B);

  late ForkliftSession _session;
  ForkliftInfo? _forklift;
  var _loading = true;
  var _busy = false;

  @override
  void initState() {
    super.initState();
    _session = widget.session;
    _load();
  }

  Future<void> _load() async {
    final name = _session.name;
    if (name == null || name.isEmpty) {
      setState(() => _loading = false);
      return;
    }
    final result = await $sl.get<ForkliftRepo>().getOperatorLogDetail(name);
    if (!mounted) return;
    result.fold(
      (_) => setState(() => _loading = false),
      (detail) => setState(() {
        _session = detail.log ?? _session;
        _forklift = detail.forklift;
        _loading = false;
      }),
    );
  }

  bool get _isMine {
    if (!$sl.isRegistered<LoggedInUser>()) return false;
    final me = $sl.get<LoggedInUser>().email;
    return me != null &&
        me.isNotEmpty &&
        me.toLowerCase() == (_session.user ?? '').toLowerCase();
  }

  Future<void> _logoutByScan() async {
    setState(() => _busy = true);
    final outcome = await ForkliftScanFlow.open(
      context,
      preferStopForLog: _session.name,
    );
    if (!mounted) return;
    setState(() => _busy = false);
    if (outcome?.loggedOut == true) {
      Navigator.pop(context, true);
    }
  }

  bool _isBlockedLogoutMethod(String method) {
    final m = method.toLowerCase();
    return m.contains('without scan') || m == 'no scan';
  }

  String _fmt(String? date, String? time, {String? datetime}) {
    if (datetime != null && datetime.trim().isNotEmpty) {
      return DFU.ddMMyyyyAmPmFromStr(datetime);
    }
    if (date != null &&
        date.trim().isNotEmpty &&
        time != null &&
        time.trim().isNotEmpty) {
      return DFU.ddMMyyyyAmPmFromStr('$date $time');
    }
    if (date != null && date.trim().isNotEmpty) {
      return DFU.ddMMyyyyAmPmFromStr(date);
    }
    return '—';
  }

  @override
  Widget build(BuildContext context) {
    final active = _session.active;
    final typeCap = [
      _forklift?.forkliftType ?? _session.forkliftType,
      _forklift?.capacity,
    ].whereType<String>().where((e) => e.isNotEmpty).join(' · ');

    // Session status (matches list cards + ERP log status).
    final sessionLabel = active ? 'Active' : 'Logged out';
    final sessionBg =
        active ? const Color(0xFFE3F7EC) : const Color(0xFFFDE8E9);
    final sessionFg =
        active ? const Color(0xFF1B9E5A) : const Color(0xFFE23D45);

    // Fleet status of the forklift itself.
    final fleetLabel = active ? 'Occupied' : 'Free';
    final fleetBg =
        active ? const Color(0xFFFDE8E9) : const Color(0xFFE3F7EC);
    final fleetFg =
        active ? const Color(0xFFE23D45) : const Color(0xFF1B9E5A);

    final logNo = (_session.name ?? '').trim();

    return Scaffold(
      backgroundColor: _canvas,
      appBar: AppBar(
        backgroundColor: AppColors.darkBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Forklift Operator Details',
              style: TextStyle(
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.w800,
                fontSize: 16.5,
              ),
            ),
            if (logNo.isNotEmpty)
              Text(
                logNo,
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontWeight: FontWeight.w700,
                  fontSize: 12.5,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: _accent),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FormPageLoadingStack(
        isLoading: _loading || _busy,
        message: _busy ? 'Opening scanner...' : 'Loading...',
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            16,
            10,
            16,
            active && _isMine ? 100 : 20,
          ),
          children: [
            _sessionHero(
              active: active,
              typeCap: typeCap,
              logNo: logNo,
              sessionLabel: sessionLabel,
              sessionBg: sessionBg,
              sessionFg: sessionFg,
            ),
            const SizedBox(height: 12),
            _sectionTitle(Icons.forklift, 'Forklift Details'),
            _kvCard([
              _Kv('Forklift No', _session.displayForklift),
              _Kv('Type', typeCap.isEmpty ? '—' : typeCap),
              _Kv(
                'Status',
                fleetLabel,
                valueWidget: _pill(fleetLabel, fleetBg, fleetFg),
              ),
              _Kv(
                'Plant',
                _session.plantName ?? _forklift?.plantName ?? '—',
              ),
            ]),
            const SizedBox(height: 12),
            _sectionTitle(Icons.person_outline_rounded, 'Operator Details'),
            _kvCard([
              _Kv('Operator Name', _session.operatorLabel),
              _Kv('User', _session.user ?? '—'),
              _Kv(
                'Login',
                _fmt(
                  _session.loginDate,
                  _session.loginTime,
                  datetime: _session.loginDatetime,
                ),
              ),
              _Kv(
                'Logout',
                (_session.logoutDatetime == null &&
                        (_session.logoutTime == null ||
                            _session.logoutTime!.isEmpty))
                    ? 'Not yet'
                    : _fmt(
                        _session.logoutDate,
                        _session.logoutTime,
                        datetime: _session.logoutDatetime,
                      ),
              ),
              if ((_session.needsReview ?? 0) == 1)
                const _Kv('Review', 'Needs review'),
              if ((_session.logoutMethod ?? '').trim().isNotEmpty &&
                  !_isBlockedLogoutMethod(_session.logoutMethod!))
                _Kv('Logout Method', _session.logoutMethod!),
            ]),
            if (active && _isMine) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF4E4),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFFFE0A8)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.qr_code_scanner, color: Color(0xFFC27A0A)),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Scan the forklift QR to mark logout.',
                        style: TextStyle(
                          color: Color(0xFF3A2600),
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Urbanist',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: active && _isMine
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE23D45),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    onPressed: _busy ? null : _logoutByScan,
                    icon: const Icon(Icons.qr_code_scanner, size: 22),
                    label: const Text(
                      'Scan to Logout',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Urbanist',
                        fontSize: 15.5,
                      ),
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Widget _sessionHero({
    required bool active,
    required String typeCap,
    required String logNo,
    required String sessionLabel,
    required Color sessionBg,
    required Color sessionFg,
  }) {
    final short = _session.shortNo;
    final nbBg =
        active ? const Color(0xFFFFF0D6) : const Color(0xFFFDE8E9);
    final nbFg =
        active ? const Color(0xFFD4890A) : const Color(0xFFE23D45);

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0E1446).withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
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
              short,
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
                        _session.displayForklift,
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
                    _pill(sessionLabel, sessionBg, sessionFg),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  [
                    if (typeCap.isNotEmpty) typeCap,
                    if (logNo.isNotEmpty) logNo,
                  ].join(' · '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Urbanist',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${active ? 'Running' : 'Used'} ${_session.duration ?? '—'}'
                  ' · ${_session.operatorLabel}',
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
    );
  }

  Widget _pill(String label, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: fg.withValues(alpha: 0.18)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg,
          fontSize: 12,
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
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: const Color(0xFFE1EBFD),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 17, color: const Color(0xFF2957A4)),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w800,
              color: _ink,
              fontFamily: 'Urbanist',
            ),
          ),
        ],
      ),
    );
  }

  Widget _kvCard(List<_Kv> rows) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0E1446).withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 9),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      rows[i].label,
                      style: const TextStyle(
                        color: _muted,
                        fontSize: 13.5,
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
                      child: rows[i].valueWidget ??
                          Text(
                            rows[i].value,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13.5,
                              color: _ink,
                              fontFamily: 'Urbanist',
                              height: 1.35,
                            ),
                          ),
                    ),
                  ),
                ],
              ),
            ),
            if (i < rows.length - 1)
              const Divider(height: 1, color: Color(0xFFE3E8F1)),
          ],
        ],
      ),
    );
  }
}

class _Kv {
  const _Kv(this.label, this.value, {this.valueWidget});

  final String label;
  final String value;
  final Widget? valueWidget;
}

