import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

    // PDF417 stickers encode extra fields; keep only the printed 6-part ID.
    // QR (e.g. pallet) codes are returned as-is.
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

// Future<Map<String, String>?> captureAndDecode() async {
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

  String? extracted;
  for (final path in imagePaths) {
    extracted = await decodePackingStickerCode(path);
    if (extracted != null) break;
  }
  if (extracted == null) return null;

  return {'qr': extracted, 'imagePaths': imagePaths};
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
        title: Text('Upload Frame Images (${_capturedPaths.length})'),
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