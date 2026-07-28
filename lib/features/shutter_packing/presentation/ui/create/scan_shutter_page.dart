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

// Future<Map<String, String>?> captureAndDecodeShutterQr() async {
//   final picker = ImagePicker();

//   final picked = await picker.pickImage(
//     source: ImageSource.camera,
//     imageQuality: 90,
//   );

//   if (picked == null) return null;

//   final inputImage = InputImage.fromFile(File(picked.path));
//   final textRecognizer = TextRecognizer();

//   try {
//     final result = await textRecognizer.processImage(inputImage);
//     final fullText = result.text;

//     final normalized = fullText.replaceAll(RegExp(r'\s+'), '');

//     final match = RegExp(
//       r'(\d+\/\d+\/[A-Z]+\/+\d+\/\d+)',
//     ).firstMatch(normalized);

//     if (match == null) {
//       return null;
//     }

//     final extracted = match.group(0)!;

//     return {'qr': extracted, 'imagePath': picked.path};
//   } finally {
//     await textRecognizer.close();
//   }
// }
Future<Map<String, dynamic>?> captureAndDecodeShutterQrMulti(
  BuildContext context,
) async {
  final imagePaths = await Navigator.of(context).push<List<String>>(
    MaterialPageRoute(builder: (_) => const MultiImageCapturePage()),
  );

  if (imagePaths == null || imagePaths.isEmpty) return null;

  final extracted = await _decodeQrFromImage(imagePaths.first);
  if (extracted == null) return null;

  return {'qr': extracted, 'imagePaths': imagePaths};
}
// Future<String?> _decodeQrFromImage(String imagePath) async {
//   final inputImage = InputImage.fromFile(File(imagePath));
//   final textRecognizer = TextRecognizer();

//   try {
//     final result = await textRecognizer.processImage(inputImage);
//     final fullText = result.text;
//     final normalized = fullText.replaceAll(RegExp(r'\s+'), '');

//     // final match = RegExp(
//     //   r'(\d+\/\d+\/[A-Z]+\/+\d+\/\d+)',
//     // ).firstMatch(normalized);
//     final match = RegExp(
//       r'(\d+\/\d+\/[A-Za-z0-9]+(?:\/\d+){2,}(?:\/[A-Za-z0-9]+)*)',
//     ).firstMatch(normalized);

//     if (match == null) return null;
//     return match.group(0)!;
//   } finally {
//     await textRecognizer.close();
//   }
// }
Future<String?> _decodeQrFromImage(String imagePath) async {
  final inputImage = InputImage.fromFile(File(imagePath));
  final textRecognizer = TextRecognizer();

  final pattern = RegExp(
    r'(\d+\/\d+\/[A-Za-z0-9]+(?:\/\d+){2,}(?:\/[A-Za-z0-9]+)*)',
  );

  try {
    final result = await textRecognizer.processImage(inputImage);

    for (final block in result.blocks) {
      for (final line in block.lines) {
        final lineText = line.text.replaceAll(RegExp(r'\s+'), '');
        final match = pattern.firstMatch(lineText);
        if (match != null) {
          return match.group(0);
        }
      }
    }
    final joinedText = result.blocks
        .expand((b) => b.lines)
        .map((l) => l.text.trim())
        .where((t) => t.isNotEmpty)
        .join('|');
    final fallbackMatch = pattern.firstMatch(
      joinedText.replaceAll(RegExp(r'\s+'), ''),
    );
    if (fallbackMatch != null) {
      return fallbackMatch.group(0);
    }

    return null;
  } finally {
    await textRecognizer.close();
  }
}
class MultiImageCapturePage extends StatefulWidget {
  const MultiImageCapturePage({super.key});

  @override
  State<MultiImageCapturePage> createState() => _MultiImageCapturePageState();
}

class _MultiImageCapturePageState extends State<MultiImageCapturePage> {
  final List<String> _capturedPaths = [];
  bool _isCapturing = false;

  Future<void> _captureOne() async {
    if (_isCapturing) return;
    setState(() => _isCapturing = true);

    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 90,
      );
      if (picked != null) {
        setState(() => _capturedPaths.add(picked.path));
      }
    } finally {
      if (mounted) setState(() => _isCapturing = false);
    }
  }

  void _removeAt(int index) {
    setState(() => _capturedPaths.removeAt(index));
  }

  void _done() {
    Navigator.of(context).pop(_capturedPaths);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A3C6B),
        foregroundColor: Colors.white,
        title: Text('Upload Shutter Images (${_capturedPaths.length})'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _capturedPaths.isEmpty
                ? const Center(
                    child: Text(
                      'No photos yet.\nTap "Capture Photo" to take one.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF64748B)),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: _capturedPaths.length,
                    itemBuilder: (_, index) {
                      final path = _capturedPaths[index];
                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(File(path), fit: BoxFit.cover),
                          ),
                          if (index == 0)
                            Positioned(
                              left: 4,
                              top: 4,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2563EB),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'QR',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          Positioned(
                            right: 2,
                            top: 2,
                            child: GestureDetector(
                              onTap: () => _removeAt(index),
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _isCapturing ? null : _captureOne,
                      icon: const Icon(Icons.camera_alt_outlined),
                      label: Text(
                        _capturedPaths.isEmpty
                            ? 'Capture Photo'
                            : 'Add Another',
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF1A3C6B),
                        side: const BorderSide(color: Color(0xFF1A3C6B)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _capturedPaths.isEmpty ? null : _done,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Done',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}