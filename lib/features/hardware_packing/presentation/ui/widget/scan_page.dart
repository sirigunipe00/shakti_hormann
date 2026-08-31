import 'dart:io';

import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shakti_hormann/features/hardware_packing/presentation/ui/widget/mes_sticker_validator.dart';

class ScanHardWarePage extends StatefulWidget {
  const ScanHardWarePage({super.key});

  @override
  State<ScanHardWarePage> createState() => _ScanHardWarePageState();
}

enum _Phase { ready, scanning, checking, result }

class _ScanHardWarePageState extends State<ScanHardWarePage> {
  _Phase _phase = _Phase.ready;
  File? _imageFile;
  MesStickerScanResult? _result;
  String? _error;

  Future<void> _startDriveScan() async {
    setState(() {
      _phase = _Phase.scanning;
      _error = null;
      _result = null;
      _imageFile = null;
    });

    try {
      final pictures = await CunningDocumentScanner.getPictures(
        noOfPages: 1,
        scannerSource: ScannerSource.camera,
        androidScannerMode: AndroidScannerMode.base,
        iosScannerOptions: IosScannerOptions(
          imageFormat: IosImageFormat.jpg,
          jpgCompressionQuality: 1.0,
          defaultFilter: IosDocumentFilter.original,
          showFilterBar: false,
        ),
      );

      if (!mounted) return;

      if (pictures == null || pictures.isEmpty) {
        setState(() => _phase = _Phase.ready);
        return;
      }

      final file = File(pictures.first);
      if (!file.existsSync()) {
        setState(() {
          _phase = _Phase.ready;
          _error = 'Scan failed. Please try again.';
        });
        return;
      }

      setState(() {
        _imageFile = file;
        _phase = _Phase.checking;
      });

      final result = await validateMesStickerImage(file.path);
      if (!mounted) return;

      HapticFeedback.mediumImpact();
      setState(() {
        _result = result;
        _phase = _Phase.result;
      });

      if (result.allOk) {
        await Future<void>.delayed(const Duration(milliseconds: 650));
        if (mounted) _accept();
      }
    } on CunningDocumentScannerException catch (e) {
      if (!mounted) return;
      setState(() {
        _phase = _Phase.ready;
        _error =
            e.code == 'permission_denied'
                ? 'Please allow Camera permission and try again.'
                : (e.message.isNotEmpty
                    ? e.message
                    : 'Scanner error. Please try again.');
      });
    } on PlatformException catch (e) {
      if (!mounted) return;
      setState(() {
        _phase = _Phase.ready;
        _error = e.message ?? 'Could not open scanner.';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _phase = _Phase.ready;
        _error = 'Could not open scanner. Please try again.';
      });
    }
  }

  void _accept() {
    final file = _imageFile;
    if (file == null || _result == null || !_result!.allOk) return;
    HapticFeedback.lightImpact();
    Navigator.pop(context, file);
  }

  void _retake() {
    setState(() {
      _phase = _Phase.ready;
      _imageFile = null;
      _result = null;
      _error = null;
    });
    _startDriveScan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1220),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1220),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'MES Sticker Scan',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: switch (_phase) {
            _Phase.ready => _ReadyView(
              key: const ValueKey('ready'),
              error: _error,
              onScan: _startDriveScan,
            ),
            _Phase.scanning => const _BusyView(
              key: ValueKey('scanning'),
              title: 'Opening Drive scanner…',
              subtitle: 'Blue box will find the sticker — hold steady',
            ),
            _Phase.checking => const _BusyView(
              key: ValueKey('checking'),
              title: 'Checking sticker…',
              subtitle: 'Reading OR, MES, PAGE & BOX',
            ),
            _Phase.result => _ResultView(
              key: const ValueKey('result'),
              imageFile: _imageFile!,
              result: _result!,
              onRetake: _retake,
              onAccept: _result!.allOk ? _accept : null,
            ),
          },
        ),
      ),
    );
  }
}

class _ReadyView extends StatelessWidget {
  const _ReadyView({super.key, required this.onScan, this.error});

  final VoidCallback onScan;
  final String? error;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1D4ED8), Color(0xFF1E3A8A)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.document_scanner, color: Colors.white, size: 28),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Drive-style scanner',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                _Step(n: '1', text: 'Place sticker flat on the box'),
                _Step(
                  n: '2',
                  text: 'Fit the FULL sticker in the blue frame',
                ),
                _Step(
                  n: '3',
                  text: 'OR, MES (QR), PAGE & BOX must all be visible',
                ),
                _Step(n: '4', text: 'Hold steady — auto capture / tap shutter'),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                children: [
                  Text(
                    'Must see all 4 before capture',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: CustomPaint(
                      painter: _LayoutPreviewPainter(),
                      child: SizedBox.expand(),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Half sticker = scan rejected. Retake until all green.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFB45309),
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (error != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF7F1D1D),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                error!,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
          const SizedBox(height: 14),
          SizedBox(
            height: 56,
            child: ElevatedButton.icon(
              onPressed: onScan,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              icon: const Icon(Icons.document_scanner, size: 26),
              label: const Text(
                'Open Drive Scanner',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.n, required this.text});
  final String n;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 11,
            backgroundColor: Colors.white,
            child: Text(
              n,
              style: const TextStyle(
                color: Color(0xFF1D4ED8),
                fontWeight: FontWeight.w900,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BusyView extends StatelessWidget {
  const _BusyView({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 56,
              height: 56,
              child: CircularProgressIndicator(
                strokeWidth: 5,
                color: Color(0xFF60A5FA),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF94A3B8),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultView extends StatelessWidget {
  const _ResultView({
    super.key,
    required this.imageFile,
    required this.result,
    required this.onRetake,
    required this.onAccept,
  });

  final File imageFile;
  final MesStickerScanResult result;
  final VoidCallback onRetake;
  final VoidCallback? onAccept;

  @override
  Widget build(BuildContext context) {
    final allOk = result.allOk;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: allOk ? const Color(0xFF166534) : const Color(0xFF9A3412),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Icon(
                  allOk ? Icons.check_circle : Icons.warning_amber_rounded,
                  color: Colors.white,
                  size: 28,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    allOk
                        ? 'All 4 fields found — saving photo…'
                        : 'Found ${result.okCount}/4. Retake with FULL sticker in the blue frame.\n(AI locked until OR, MES, PAGE & BOX are green)',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.file(
                imageFile,
                fit: BoxFit.contain,
                width: double.infinity,
              ),
            ),
          ),
          const SizedBox(height: 12),
          ...result.fields.map((f) => _FieldRow(field: f)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onRetake,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white54),
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.refresh),
                  label: const Text(
                    'Retake',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: onAccept,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        allOk
                            ? const Color(0xFF16A34A)
                            : const Color(0xFF334155),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: const Color(0xFF334155),
                    disabledForegroundColor: Colors.white38,
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: Icon(allOk ? Icons.check : Icons.lock),
                  label: Text(
                    allOk ? 'Use photo' : 'Locked — need all 4',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FieldRow extends StatelessWidget {
  const _FieldRow({required this.field});
  final MesFieldResult field;

  @override
  Widget build(BuildContext context) {
    final ok = field.ok;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: ok ? const Color(0xFF14532D) : const Color(0xFF7F1D1D),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ok ? const Color(0xFF4ADE80) : const Color(0xFFF87171),
        ),
      ),
      child: Row(
        children: [
          Icon(
            ok ? Icons.check_circle : Icons.cancel,
            color: Colors.white,
            size: 22,
          ),
          const SizedBox(width: 10),
          Text(
            field.label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 14,
            ),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              ok ? (field.value ?? 'OK') : 'Not found — retake',
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: ok ? const Color(0xFFBBF7D0) : const Color(0xFFFECACA),
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Preview only — reminds operators what must be inside the blue frame.
class _LayoutPreviewPainter extends CustomPainter {
  const _LayoutPreviewPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final sticker = Rect.fromLTWH(
      size.width * 0.08,
      size.height * 0.02,
      size.width * 0.84,
      size.height * 0.96,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(sticker, const Radius.circular(8)),
      Paint()
        ..color = const Color(0xFF2563EB)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    void box(Rect r, String label, Color c) {
      canvas.drawRect(
        r,
        Paint()
          ..color = c
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
      final tp = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(
            color: c,
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(r.left + 4, r.top + 3));
    }

    box(
      Rect.fromLTWH(
        sticker.left + sticker.width * 0.06,
        sticker.top + sticker.height * 0.15,
        sticker.width * 0.5,
        sticker.height * 0.1,
      ),
      'OR No',
      const Color(0xFFDC2626),
    );
    box(
      Rect.fromLTWH(
        sticker.left + sticker.width * 0.70,
        sticker.top + sticker.height * 0.03,
        sticker.width * 0.24,
        sticker.height * 0.16,
      ),
      'MES / QR',
      const Color(0xFFDC2626),
    );
    box(
      Rect.fromLTWH(
        sticker.left + sticker.width * 0.50,
        sticker.top + sticker.height * 0.88,
        sticker.width * 0.22,
        sticker.height * 0.08,
      ),
      'PAGE',
      const Color(0xFFDC2626),
    );
    box(
      Rect.fromLTWH(
        sticker.left + sticker.width * 0.74,
        sticker.top + sticker.height * 0.88,
        sticker.width * 0.22,
        sticker.height * 0.08,
      ),
      'BOX',
      const Color(0xFFDC2626),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
