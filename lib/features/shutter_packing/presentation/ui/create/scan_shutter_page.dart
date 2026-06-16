import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart' hide BarcodeFormat;

class ScanShutterPage extends StatefulWidget {
  const ScanShutterPage({super.key});

  @override
  State<ScanShutterPage> createState() => _ScanShutterPageState();
}

class _ScanShutterPageState extends State<ScanShutterPage> {
  final MobileScannerController _controller = MobileScannerController();
  bool _scanned = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_scanned) return;
    final raw = capture.barcodes.firstOrNull?.rawValue;
    if (raw == null || raw.isEmpty) return;

    _scanned = true;
    _controller.stop();
    Navigator.of(context).pop(raw);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A3C6B),
        foregroundColor: Colors.white,
        title: const Text('Scan Shutter Sticker'),
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
                    width: 260,
                    height: 260,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Center(
            child: SizedBox(
              width: 260,
              height: 260,
              child: CustomPaint(painter: _CornerBorderPainter()),
            ),
          ),

          const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 80),
              child: Text(
                'Point camera at the shutter sticker QR code',
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
          ..arcToPoint(Offset(r, 0), radius: const Radius.circular(r))
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

Future<Map<String, String>?> captureAndDecodeShutterQr() async {
  final picker = ImagePicker();

  final picked = await picker.pickImage(
    source: ImageSource.camera,
    imageQuality: 90,
  );

  if (picked == null) return null;

  final inputImage = InputImage.fromFile(File(picked.path));
  final textRecognizer = TextRecognizer();

  try {
    final result = await textRecognizer.processImage(inputImage);
    final fullText = result.text;

    final normalized = fullText.replaceAll(RegExp(r'\s+'), '');

    final match = RegExp(
      r'(\d+\/\d+\/[A-Z]+\/+\d+\/\d+)',
    ).firstMatch(normalized);

    if (match == null) {
      return null;
    }

    final extracted = match.group(0)!;

    return {'qr': extracted, 'imagePath': picked.path};
  } finally {
    await textRecognizer.close();
  }
}
