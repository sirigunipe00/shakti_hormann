import 'dart:io';

import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

/// Reads shutter/frame packing sticker codes from an uploaded photo.
/// Stickers are often printed on 3 lines, e.g.
/// `180046333/120/` + `LHR/1/56/` + `2504O`, with a PDF417 barcode.
Future<String?> decodePackingStickerCode(String imagePath) async {
  final inputImage = InputImage.fromFile(File(imagePath));

  final fromBarcode = await _decodeFromBarcode(inputImage);
  if (fromBarcode != null) return fromBarcode;

  return _decodeFromOcr(inputImage);
}

Future<String?> _decodeFromBarcode(InputImage inputImage) async {
  final scanner = BarcodeScanner(formats: [BarcodeFormat.all]);
  try {
    final barcodes = await scanner.processImage(inputImage);
    for (final barcode in barcodes) {
      final raw = (barcode.rawValue ?? barcode.displayValue ?? '').trim();
      final extracted = extractPackingStickerCode(raw);
      if (extracted != null) return extracted;
    }
  } catch (_) {
    // Fall through to OCR.
  } finally {
    await scanner.close();
  }
  return null;
}

Future<String?> _decodeFromOcr(InputImage inputImage) async {
  final recognizer = TextRecognizer();
  try {
    final result = await recognizer.processImage(inputImage);
    final lines =
        result.blocks
            .expand((block) => block.lines)
            .map((line) => line.text.replaceAll(RegExp(r'\s+'), '').trim())
            .where((text) => text.isNotEmpty)
            .toList();

    final candidates = <String>[
      result.text,
      lines.join(),
      lines.map(_ensureTrailingSlash).join(),
      lines.join('/'),
    ];

    for (final candidate in candidates) {
      final extracted = extractPackingStickerCode(candidate);
      if (extracted != null) return extracted;
    }
    return null;
  } finally {
    await recognizer.close();
  }
}

String _ensureTrailingSlash(String value) =>
    value.endsWith('/') ? value : '$value/';

/// Extracts the printed packing sticker ID from a raw barcode/OCR string.
///
/// Printed ID is always 6 parts:
/// `SO / qty / product / seq / total / batch`
/// e.g. `180046333/120/LHR/7/56/2504O`
/// PDF417 payloads may append extra fields after that — those are ignored.
String? extractPackingStickerCode(String raw) {
  final compact = raw.replaceAll(RegExp(r'\s+'), '').replaceAll('\\', '/');
  if (compact.isEmpty) return null;

  final match = _stickerPattern.firstMatch(compact);
  return match?.group(0);
}

/// Matches only the printed sticker value (6 slash-separated parts).
final _stickerPattern = RegExp(
  r'\d{6,}/\d+/[A-Za-z0-9]+/\d+/\d+/[A-Za-z0-9]+',
);
