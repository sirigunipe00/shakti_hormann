import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

/// Static boxes aligned to a vertical MES sticker in the camera preview.
/// Positions are fractions of the sticker guide (not OCR).
const _kFields = <_StaticMesBox>[
  _StaticMesBox(
    label: 'MES Sticker Number',
    left: 0.68,
    top: 0.045,
    width: 0.09,
    height: 0.18,
  ),
  _StaticMesBox(
    label: 'OR NO',
    left: 0.08,
    top: 0.22,
    width: 0.48,
    height: 0.09,
  ),
  _StaticMesBox(
    label: 'PAGE',
    left: 0.50,
    top: 0.905,
    width: 0.22,
    height: 0.055,
  ),
  _StaticMesBox(
    label: 'BOX',
    left: 0.73,
    top: 0.905,
    width: 0.22,
    height: 0.055,
  ),
];

class _StaticMesBox {
  const _StaticMesBox({
    required this.label,
    required this.left,
    required this.top,
    required this.width,
    required this.height,
  });

  final String label;
  final double left;
  final double top;
  final double width;
  final double height;
}

class ScanHardWarePage extends StatefulWidget {
  const ScanHardWarePage({super.key});

  @override
  State<ScanHardWarePage> createState() => _ScanHardWarePageState();
}

class _ScanHardWarePageState extends State<ScanHardWarePage> {
  CameraController? _controller;
  Future<void>? _initFuture;
  bool _isCapturing = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final backCamera = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );

    _controller = CameraController(
      backCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    _initFuture = _controller!.initialize();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _captureImage() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized || _isCapturing) {
      return;
    }

    setState(() => _isCapturing = true);
    try {
      final file = await controller.takePicture();
      if (mounted) Navigator.pop(context, File(file.path));
    } catch (_) {
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _isCapturing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<void>(
        future: _initFuture,
        builder: (context, snapshot) {
          if (_controller == null ||
              snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          return Stack(
            fit: StackFit.expand,
            children: [
              FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller!.value.previewSize?.height ?? 0,
                  height: _controller!.value.previewSize?.width ?? 0,
                  child: CameraPreview(_controller!),
                ),
              ),
              const Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(painter: _StaticMesOverlayPainter()),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 4),
                      const Expanded(
                        child: Text(
                          'Align sticker within the boxes',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 32,
                child: Center(
                  child: GestureDetector(
                    onTap: _captureImage,
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: Colors.white38, width: 4),
                      ),
                      child:
                          _isCapturing
                              ? const Padding(
                                padding: EdgeInsets.all(20),
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                ),
                              )
                              : const Icon(
                                Icons.camera_alt,
                                color: Colors.black87,
                                size: 32,
                              ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StaticMesOverlayPainter extends CustomPainter {
  const _StaticMesOverlayPainter();

  static const _red = Color(0xFFE53935);

  @override
  void paint(Canvas canvas, Size size) {
    final sticker = _stickerFrame(size);
    final stroke =
        Paint()
          ..color = _red
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.square;
    final brackets =
        Paint()
          ..color = _red
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.5
          ..strokeCap = StrokeCap.square;

    const labelStyle = TextStyle(
      color: Colors.white,
      fontSize: 11,
      fontWeight: FontWeight.w700,
    );

    for (final field in _kFields) {
      final rect = Rect.fromLTWH(
        sticker.left + sticker.width * field.left,
        sticker.top + sticker.height * field.top,
        sticker.width * field.width,
        sticker.height * field.height,
      );
      canvas.drawRect(rect, stroke);
      _drawCornerBrackets(canvas, rect, brackets);
      _drawLabel(canvas, rect, field.label, labelStyle);
    }
  }

  Rect _stickerFrame(Size size) {
    const aspect = 0.58;
    final maxHeight = size.height * 0.72;
    final maxWidth = size.width * 0.92;
    var height = maxHeight;
    var width = height * aspect;
    if (width > maxWidth) {
      width = maxWidth;
      height = width / aspect;
    }
    return Rect.fromLTWH(
      (size.width - width) / 2,
      size.height * 0.10,
      width,
      height,
    );
  }

  void _drawCornerBrackets(Canvas canvas, Rect rect, Paint paint) {
    final len = (rect.shortestSide * 0.35).clamp(10.0, 22.0);
    canvas
      ..drawLine(rect.topLeft, rect.topLeft + Offset(len, 0), paint)
      ..drawLine(rect.topLeft, rect.topLeft + Offset(0, len), paint)
      ..drawLine(rect.topRight, rect.topRight + Offset(-len, 0), paint)
      ..drawLine(rect.topRight, rect.topRight + Offset(0, len), paint)
      ..drawLine(rect.bottomLeft, rect.bottomLeft + Offset(len, 0), paint)
      ..drawLine(rect.bottomLeft, rect.bottomLeft + Offset(0, -len), paint)
      ..drawLine(rect.bottomRight, rect.bottomRight + Offset(-len, 0), paint)
      ..drawLine(rect.bottomRight, rect.bottomRight + Offset(0, -len), paint);
  }

  void _drawLabel(Canvas canvas, Rect rect, String label, TextStyle style) {
    final tp = TextPainter(
      text: TextSpan(text: label, style: style),
      textDirection: TextDirection.ltr,
    )..layout();

    final offset = Offset(
      rect.left,
      (rect.top - tp.height - 6).clamp(0, double.infinity),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          offset.dx - 4,
          offset.dy - 2,
          tp.width + 8,
          tp.height + 4,
        ),
        const Radius.circular(3),
      ),
      Paint()..color = _red,
    );
    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
