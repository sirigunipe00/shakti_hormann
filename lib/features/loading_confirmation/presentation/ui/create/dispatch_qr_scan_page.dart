import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class DispatchQrScanPage extends StatefulWidget {
  const DispatchQrScanPage({super.key});

  @override
  State<DispatchQrScanPage> createState() => _DispatchQrScanPageState();
}

class _DispatchQrScanPageState extends State<DispatchQrScanPage> {
  final MobileScannerController _controller = MobileScannerController(
    formats: [BarcodeFormat.qrCode, BarcodeFormat.pdf417],
    detectionSpeed: DetectionSpeed.unrestricted,
    returnImage: false,
  );
  bool _scanned = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_scanned) return;
    final raw = capture.barcodes.firstOrNull?.rawValue?.trim();
    if (raw == null || raw.isEmpty) return;

    _scanned = true;
    _controller.stop();
    HapticFeedback.mediumImpact();
    Navigator.of(context).pop(raw);
  }

  @override
  Widget build(BuildContext context) {
    const scanSize = 260.0;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A3C6B),
        foregroundColor: Colors.white,
        title: const Text('Scan QR Code'),
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
                    width: scanSize,
                    height: scanSize,
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
              width: scanSize,
              height: scanSize,
              child: CustomPaint(painter: _CornerBorderPainter()),
            ),
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 80),
              child: Text(
                'Point camera at the QR code',
                style: TextStyle(
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
