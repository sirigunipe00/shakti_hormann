import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shakti_hormann/core/core.dart';
import 'package:shakti_hormann/core/utils/device_info_mixin.dart';
import 'package:shakti_hormann/features/auth/model/logged_in_user.dart';
import 'package:shakti_hormann/features/forklift/data/forklift_repo.dart';
import 'package:shakti_hormann/features/forklift/model/forklift_models.dart';
import 'package:shakti_hormann/features/forklift/presentation/ui/create/forklift_scan_flow.dart';
import 'package:shakti_hormann/styles/app_color.dart';
import 'package:shakti_hormann/widgets/dailogs/app_dialogs.dart';
import 'package:shakti_hormann/widgets/form_page_loading_stack.dart';

class NewForkliftOperatorPage extends StatefulWidget {
  const NewForkliftOperatorPage({
    super.key,
    required this.qrText,
    required this.forklift,
    this.operator,
  });

  final String qrText;
  final ForkliftInfo forklift;
  final ForkliftPerson? operator;

  @override
  State<NewForkliftOperatorPage> createState() =>
      _NewForkliftOperatorPageState();
}

class _NewForkliftOperatorPageState extends State<NewForkliftOperatorPage>
    with DeviceInfoMixin {
  static const _ink = Color(0xFF0E1446);
  static const _muted = Color(0xFF6B7690);
  static const _border = Color(0xFFE6EAF2);
  static const _canvas = Color(0xFFF5F7FB);
  static const _accent = Color(0xFFF2A93B);

  var _busy = false;

  LoggedInUser get _user => $sl.get<LoggedInUser>();

  Future<void> _markLogin() async {
    setState(() => _busy = true);
    String deviceId = 'flutter-device';
    String appVersion = '1.0.0';
    try {
      final info = await getDeviceInfo();
      deviceId = info.deviceUniqueId;
      final p = await PackageInfo.fromPlatform();
      appVersion = p.version;
    } catch (_) {}

    final result = await $sl.get<ForkliftRepo>().markLogin(
          qrText: widget.qrText,
          idempotencyKey: ForkliftScanFlow.newIdempotencyKey(),
          deviceId: deviceId,
          appVersion: appVersion,
        );
    if (!mounted) return;
    setState(() => _busy = false);

    await result.fold(
      (l) => AppDialog.showErrorDialog(
        context,
        title: 'Login failed',
        content: l.error,
        onTapDismiss: context.exit,
      ),
      (r) async {
        if (r.isMustLogout) {
          await ForkliftScanFlow.openActiveSessionForLogout(
            context,
            message: r.popupMessage ??
                'You are still logged in on another forklift. Open that session and scan to log out first.',
            session: r.activeSessionForLogout,
          );
          return;
        }
        if (r.ok == false) {
          await AppDialog.showErrorDialog(
            context,
            title: 'Login failed',
            content: r.popupMessage ?? 'Could not mark login.',
            onTapDismiss: context.exit,
          );
          return;
        }
        await AppDialog.showSuccessDialog(
          context,
          title: 'Login Marked',
          content: r.popupMessage ??
              'Logged in on ${r.forklift?.displayNo ?? widget.forklift.displayNo}.',
          onTapDismiss: context.exit,
        );
        if (!mounted) return;
        Navigator.pop(context, r.log);
      },
    );
  }

  Future<void> _changeForklift() async {
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateStr =
        '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}';
    final hour12 = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final amPm = now.hour >= 12 ? 'PM' : 'AM';
    final timeStr =
        '${hour12.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} $amPm';
    final name = widget.operator?.fullName?.isNotEmpty == true
        ? widget.operator!.fullName!
        : (_user.fullName ?? _user.name);
    final userId = widget.operator?.user?.isNotEmpty == true
        ? widget.operator!.user!
        : (_user.email ?? _user.username ?? '');

    final typeCap = [
      widget.forklift.forkliftType,
      widget.forklift.capacity,
    ].whereType<String>().where((e) => e.isNotEmpty).join(' · ');

    return Scaffold(
      backgroundColor: _canvas,
      appBar: AppBar(
        backgroundColor: AppColors.darkBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'New Forklift Operator',
          style: TextStyle(
            fontFamily: 'Urbanist',
            fontWeight: FontWeight.w800,
            fontSize: 17,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: _accent),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FormPageLoadingStack(
        isLoading: _busy,
        message: 'Marking login...',
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 100),
          children: [
            // Compact light summary (same style as Operator Details)
            Container(
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
                      color: const Color(0xFFE3F7EC),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      widget.forklift.shortNo,
                      style: const TextStyle(
                        color: Color(0xFF1B9E5A),
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
                                widget.forklift.displayNo,
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
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE3F7EC),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'Free',
                                style: TextStyle(
                                  color: Color(0xFF1B9E5A),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Urbanist',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          typeCap.isEmpty ? 'Ready to mark login' : typeCap,
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
                          'Confirm login · $name',
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
            const SizedBox(height: 12),
            _sectionTitle(Icons.forklift, 'Forklift Details'),
            _card([
              _row('Forklift No', widget.forklift.displayNo),
              _row('Type', typeCap.isEmpty ? '—' : typeCap),
              if ((widget.forklift.plantName ?? '').isNotEmpty)
                _row('Plant', widget.forklift.plantName!),
            ]),
            const SizedBox(height: 12),
            _sectionTitle(Icons.person_outline_rounded, 'Operator Details'),
            _card([
              _row('Operator Name', name),
              _row('User', userId),
              _row('Login Date', dateStr),
              _row('Login Time', timeStr),
            ]),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: _border)),
          ),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B9E5A),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _busy ? null : _markLogin,
                    child: const Text(
                      'Mark Login',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Urbanist',
                        fontSize: 14.5,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _ink,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _busy ? null : _changeForklift,
                    child: const Text(
                      'Change Forklift',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Urbanist',
                        fontSize: 14.5,
                      ),
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

  Widget _card(List<Widget> children) {
    return Container(
      width: double.infinity,
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
          for (var i = 0; i < children.length; i++) ...[
            children[i],
            if (i < children.length - 1)
              const Divider(height: 1, color: Color(0xFFE3E8F1)),
          ],
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                color: _muted,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                fontFamily: 'Urbanist',
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: _ink,
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                fontFamily: 'Urbanist',
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Entry used by list + New: opens camera then navigates into form on start.
class NewForkliftOperatorEntry extends StatefulWidget {
  const NewForkliftOperatorEntry({super.key});

  @override
  State<NewForkliftOperatorEntry> createState() =>
      _NewForkliftOperatorEntryState();
}

class _NewForkliftOperatorEntryState extends State<NewForkliftOperatorEntry> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _start());
  }

  Future<void> _start() async {
    final outcome = await ForkliftScanFlow.open(context);
    if (!mounted) return;
    Navigator.pop(context, outcome?.loggedIn == true);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: CircularProgressIndicator(color: Color(0xFFF2A93B)),
      ),
    );
  }
}
