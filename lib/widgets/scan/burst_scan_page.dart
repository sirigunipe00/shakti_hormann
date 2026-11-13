import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shakti_hormann/core/utils/packing_sticker_decoder.dart';
import 'package:shakti_hormann/core/utils/shell_insets.dart';
import 'package:shakti_hormann/widgets/scan/scan_feedback.dart';
import 'package:shakti_hormann/widgets/scan/scan_outcome.dart';

typedef BurstScanValidator = Future<ScanOutcome> Function(String rawCode);

/// Continuous camera scanner for floor ops.
///
/// - Keeps camera open between scans
/// - Runs [onValidate] before accepting the next code
/// - Shows big success/fail + haptic/sound
/// - User can Stop / Done at any time
class BurstScanPage extends StatefulWidget {
  const BurstScanPage({
    required this.title,
    required this.onValidate,
    this.hint = 'Point camera at the code — keep scanning',
    this.formats = const [BarcodeFormat.qrCode, BarcodeFormat.pdf417],
    this.decodePackingSticker = false,
    super.key,
  });

  final String title;
  final String hint;
  final List<BarcodeFormat> formats;
  final bool decodePackingSticker;
  final BurstScanValidator onValidate;

  @override
  State<BurstScanPage> createState() => _BurstScanPageState();
}

class _BurstScanPageState extends State<BurstScanPage> {
  late final MobileScannerController _controller = MobileScannerController(
    formats: widget.formats,
    detectionSpeed: DetectionSpeed.normal,
  );

  bool _busy = false;
  bool _stopped = false;
  int _successCount = 0;
  int _failCount = 0;
  String? _lastRaw;
  DateTime? _lastRawAt;
  ScanOutcome? _banner;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _stopAndClose() async {
    if (_stopped) return;
    _stopped = true;
    try {
      await _controller.stop();
    } catch (_) {}
    if (!mounted) return;
    Navigator.of(context).pop(_successCount);
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_busy || _stopped) return;

    final raw = capture.barcodes.firstOrNull?.rawValue?.trim();
    if (raw == null || raw.isEmpty) return;

    // Debounce identical codes while the operator still holds the sticker.
    final now = DateTime.now();
    if (_lastRaw == raw &&
        _lastRawAt != null &&
        now.difference(_lastRawAt!) < const Duration(seconds: 2)) {
      return;
    }

    _busy = true;
    _lastRaw = raw;
    _lastRawAt = now;

    try {
      await _controller.stop();
    } catch (_) {}

    final value =
        widget.decodePackingSticker
            ? (extractPackingStickerCode(raw) ?? raw)
            : raw;

    if (!mounted) return;
    setState(() => _banner = null);

    ScanOutcome outcome;
    try {
      outcome = await widget.onValidate(value);
    } catch (e) {
      outcome = ScanOutcome.fail(e.toString());
    }

    if (!mounted) return;

    if (outcome.success) {
      _successCount += 1;
    } else {
      _failCount += 1;
    }

    setState(() => _banner = outcome);
    await ScanFeedback.play(outcome);

    final hold = outcome.success
        ? const Duration(milliseconds: 900)
        : const Duration(milliseconds: 1400);
    await Future<void>.delayed(hold);

    if (!mounted) return;
    setState(() => _banner = null);

    if (outcome.shouldStop || _stopped) {
      await _stopAndClose();
      return;
    }

    _busy = false;
    try {
      await _controller.start();
    } catch (_) {
      // If camera cannot restart, close so the operator is not stuck.
      await _stopAndClose();
    }
  }

  @override
  Widget build(BuildContext context) {
    const scanW = 280.0;
    const scanH = 180.0;
    final bottomClearance = ShellInsets.overlayAboveNav(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        await _stopAndClose();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: const Color(0xFF1A3C6B),
          foregroundColor: Colors.white,
          title: Text(widget.title),
          leading: IconButton(
            icon: const Icon(Icons.close),
            tooltip: 'Stop',
            onPressed: _stopAndClose,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.flash_on),
              onPressed: _controller.toggleTorch,
            ),
          ],
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            MobileScanner(controller: _controller, onDetect: _onDetect),
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withValues(alpha: 0.55),
                BlendMode.srcOut,
              ),
              child: Stack(
                children: [
                  Container(color: Colors.transparent),
                  Center(
                    child: Container(
                      width: scanW,
                      height: scanH,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: SizedBox(
                width: scanW,
                height: scanH,
                child: CustomPaint(painter: _CornerBorderPainter()),
              ),
            ),
            if (_busy && _banner == null)
              const ColoredBox(
                color: Color(0x66000000),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: Colors.white),
                      SizedBox(height: 14),
                      Text(
                        'Checking…',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Urbanist',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (_banner != null) ScanFeedbackBanner(outcome: _banner!),
            Positioned(
              left: 16,
              right: 16,
              bottom: bottomClearance,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_banner == null) ...[
                    Text(
                      _busy ? 'Validating scan…' : widget.hint,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Urbanist',
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'OK $_successCount   ·   Fail $_failCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                              fontFamily: 'Urbanist',
                            ),
                          ),
                        ),
                        FilledButton.icon(
                          onPressed: _busy && _banner == null
                              ? null
                              : _stopAndClose,
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFFDC2626),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          icon: const Icon(Icons.stop_circle_outlined),
                          label: const Text(
                            'Stop',
                            style: TextStyle(fontWeight: FontWeight.w900),
                          ),
                        ),
                      ],
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
}

class _CornerBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2563EB)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const len = 28.0;
    const r = 10.0;

    canvas
      ..drawPath(
        Path()
          ..moveTo(0, r + len)
          ..lineTo(0, r)
          ..arcToPoint(const Offset(r, 0), radius: const Radius.circular(r))
          ..lineTo(r + len, 0),
        paint,
      )
      ..drawPath(
        Path()
          ..moveTo(size.width - r - len, 0)
          ..lineTo(size.width - r, 0)
          ..arcToPoint(Offset(size.width, r), radius: const Radius.circular(r))
          ..lineTo(size.width, r + len),
        paint,
      )
      ..drawPath(
        Path()
          ..moveTo(0, size.height - r - len)
          ..lineTo(0, size.height - r)
          ..arcToPoint(
            Offset(r, size.height),
            radius: const Radius.circular(r),
            clockwise: false,
          )
          ..lineTo(r + len, size.height),
        paint,
      )
      ..drawPath(
        Path()
          ..moveTo(size.width - r - len, size.height)
          ..lineTo(size.width - r, size.height)
          ..arcToPoint(
            Offset(size.width, size.height - r),
            radius: const Radius.circular(r),
            clockwise: false,
          )
          ..lineTo(size.width, size.height - r - len),
        paint,
      );
  }

  @override
  bool shouldRepaint(_) => false;
}
