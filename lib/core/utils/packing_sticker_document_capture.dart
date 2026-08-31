import 'dart:io';

import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shakti_hormann/core/utils/packing_sticker_decoder.dart';
import 'package:shakti_hormann/widgets/packing_sticker_image_preview.dart';

Future<Map<String, dynamic>?> captureAndDecodePackingStickerMulti(
  BuildContext context, {
  required String pageTitle,
}) async {
  final imagePaths = await Navigator.of(context).push<List<String>>(
    MaterialPageRoute(
      builder:
          (_) => PackingStickerDocumentCapturePage(title: pageTitle),
    ),
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

class PackingStickerDocumentCapturePage extends StatefulWidget {
  const PackingStickerDocumentCapturePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<PackingStickerDocumentCapturePage> createState() =>
      _PackingStickerDocumentCapturePageState();
}

class _PackingStickerDocumentCapturePageState
    extends State<PackingStickerDocumentCapturePage> {
  final List<String> _capturedPaths = [];
  bool _isScanning = false;

  Future<void> _scanOne() async {
    if (_isScanning) return;
    setState(() => _isScanning = true);

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

      if (pictures == null || pictures.isEmpty) return;

      final file = File(pictures.first);
      if (!file.existsSync()) {
        _showError('Scan failed. Please try again.');
        return;
      }

      setState(() => _capturedPaths.add(file.path));
    } on CunningDocumentScannerException catch (e) {
      if (!mounted) return;
      _showError(
        e.code == 'permission_denied'
            ? 'Please allow Camera permission and try again.'
            : (e.message.isNotEmpty
                ? e.message
                : 'Scanner error. Please try again.'),
      );
    } on PlatformException catch (e) {
      if (!mounted) return;
      _showError(e.message ?? 'Could not open scanner.');
    } catch (_) {
      if (!mounted) return;
      _showError('Could not open scanner. Please try again.');
    } finally {
      if (mounted) setState(() => _isScanning = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
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
        title: Text('${widget.title} (${_capturedPaths.length})'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child:
                    _capturedPaths.isEmpty
                        ? const Center(
                          child: Text(
                            'No scans yet.\nTap "Scan Document" to capture the sticker.',
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
                                  child: PackingStickerPreviewImage(
                                    path: path,
                                    fit: BoxFit.cover,
                                  ),
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
                          onPressed: _isScanning ? null : _scanOne,
                          icon: const Icon(Icons.document_scanner_outlined),
                          label: Text(
                            _capturedPaths.isEmpty
                                ? 'Scan Document'
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
                          onPressed:
                              _capturedPaths.isEmpty || _isScanning
                                  ? null
                                  : _done,
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
          if (_isScanning)
            Container(
              color: Colors.black.withValues(alpha: 0.35),
              child: const Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Opening document scanner...'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
