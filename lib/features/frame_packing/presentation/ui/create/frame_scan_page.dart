import 'package:flutter/material.dart';
import 'package:shakti_hormann/core/utils/packing_sticker_decoder.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanFramePage extends StatefulWidget {
  const ScanFramePage({
    super.key,
    this.formats = const [BarcodeFormat.pdf417],
    this.title = 'Scan Barcode',
    this.hint = 'Point camera at the sticker barcode',
  });

  const ScanFramePage.qr({
    super.key,
    this.title = 'Scan QR',
    this.hint = 'Point camera at the QR code',
  }) : formats = const [BarcodeFormat.qrCode];

  final List<BarcodeFormat> formats;
  final String title;
  final String hint;

  @override
  State<ScanFramePage> createState() => _ScanFramePageState();
}

class _ScanFramePageState extends State<ScanFramePage> {
  late final MobileScannerController _controller = MobileScannerController(
    formats: widget.formats,
  );
  bool _scanned = false;

  bool get _isQrScan =>
      widget.formats.length == 1 && widget.formats.first == BarcodeFormat.qrCode;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_scanned) return;
    final raw = capture.barcodes.firstOrNull?.rawValue;
    if (raw == null || raw.isEmpty) return;
    final value =
        _isQrScan ? raw : (extractPackingStickerCode(raw) ?? raw);

    _scanned = true;
    _controller.stop();
    Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    final scanWidth = _isQrScan ? 260.0 : 300.0;
    final scanHeight = _isQrScan ? 260.0 : 140.0;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A3C6B),
        foregroundColor: Colors.white,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: _controller.toggleTorch,
          ),
        ],
      ),
      body: Stack(
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
                    width: scanWidth,
                    height: scanHeight,
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
              width: scanWidth,
              height: scanHeight,
              child: CustomPaint(painter: _CornerBorderPainter()),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: Text(
                widget.hint,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CornerBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
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
