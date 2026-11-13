import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shakti_hormann/widgets/scan/scan_outcome.dart';

/// Floor-operator feedback: haptic + system sound + large on-screen banner.
///
/// Uses only Flutter platform channels (no asset audio) so it works across
/// Android OEM builds without missing sound files.
abstract final class ScanFeedback {
  static Future<void> play(ScanOutcome outcome) async {
    try {
      if (outcome.success) {
        await HapticFeedback.mediumImpact();
        await SystemSound.play(SystemSoundType.click);
      } else {
        await HapticFeedback.heavyImpact();
        await SystemSound.play(SystemSoundType.alert);
        // Extra pulse so fail is obvious even on muted devices.
        await Future<void>.delayed(const Duration(milliseconds: 80));
        await HapticFeedback.vibrate();
      }
    } catch (_) {
      // Some devices / emulators reject vibrate — never block scanning.
    }
  }
}

/// Full-bleed success / fail banner for camera overlays.
class ScanFeedbackBanner extends StatelessWidget {
  const ScanFeedbackBanner({required this.outcome, super.key});

  final ScanOutcome outcome;

  @override
  Widget build(BuildContext context) {
    final ok = outcome.success;
    final color = ok ? const Color(0xFF16A34A) : const Color(0xFFDC2626);

    return IgnorePointer(
      child: ColoredBox(
        color: color.withValues(alpha: 0.88),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    ok ? Icons.check_circle_rounded : Icons.cancel_rounded,
                    color: Colors.white,
                    size: 96,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    ok ? 'SUCCESS' : 'FAILED',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Urbanist',
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    outcome.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Urbanist',
                      height: 1.3,
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
