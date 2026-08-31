import 'dart:io';
import 'dart:ui' show Rect;

import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:shakti_hormann/features/hardware_packing/presentation/ui/widget/mes_guide_validation.dart';

enum MesGuideField { mesNumber, orNo, page, box }

class MesFieldResult {
  const MesFieldResult({
    required this.field,
    required this.label,
    required this.ok,
    this.value,
  });

  final MesGuideField field;
  final String label;
  final bool ok;
  final String? value;
}

class MesStickerScanResult {
  const MesStickerScanResult({
    required this.fields,
    required this.rawText,
  });

  final List<MesFieldResult> fields;
  final String rawText;

  bool get allOk => fields.every((f) => f.ok);

  int get okCount => fields.where((f) => f.ok).length;
}
Future<MesStickerScanResult> validateMesStickerImage(String imagePath) async {
  final input = InputImage.fromFile(File(imagePath));
  final textRecognizer = TextRecognizer();
  final barcodeScanner = BarcodeScanner(
    formats: [
      BarcodeFormat.qrCode,
      BarcodeFormat.code128,
      BarcodeFormat.code39,
      BarcodeFormat.pdf417,
      BarcodeFormat.dataMatrix,
    ],
  );

  try {
    final recognized = await textRecognizer.processImage(input);
    final barcodes = await barcodeScanner.processImage(input);

    final lines = <_Line>[
      ...recognized.blocks.expand(
        (b) => b.lines.map((l) => _Line(l.text, l.boundingBox)),
      ),
    ];
    final barcodeValues =
        barcodes
            .map((b) => b.rawValue?.trim() ?? '')
            .where((v) => v.isNotEmpty)
            .toList();

    final allText = [
      recognized.text,
      ...lines.map((e) => e.text),
      ...barcodeValues,
    ].join('\n');

    var minX = double.infinity;
    var minY = double.infinity;
    var maxX = -double.infinity;
    var maxY = -double.infinity;
    for (final l in lines) {
      minX = minX < l.box.left ? minX : l.box.left;
      minY = minY < l.box.top ? minY : l.box.top;
      maxX = maxX > l.box.right ? maxX : l.box.right;
      maxY = maxY > l.box.bottom ? maxY : l.box.bottom;
    }
    if (lines.isEmpty) {
      minX = 0;
      minY = 0;
      maxX = 1;
      maxY = 1;
    }
    final hullW = (maxX - minX).clamp(1.0, double.infinity);
    final hullH = (maxY - minY).clamp(1.0, double.infinity);

    String? orValue = MesGuideValidation.extractOr(allText);
    String? pageValue = MesGuideValidation.extractPage(allText);
    String? boxValue = MesGuideValidation.extractBox(allText);
    String? mesValue;

    for (final code in barcodeValues) {
      mesValue = MesGuideValidation.extractMes(code, isBarcode: true);
      if (mesValue != null) break;
    }
    mesValue ??= MesGuideValidation.extractMes(allText);

    for (final line in lines) {
      final relX = ((line.box.center.dx - minX) / hullW).clamp(0.0, 1.0);
      final relY = ((line.box.center.dy - minY) / hullH).clamp(0.0, 1.0);
      final t = line.text;

      if (orValue == null && MesGuideValidation.inOrZone(relX, relY)) {
        orValue = MesGuideValidation.extractOr(t);
      }
      if (mesValue == null &&
          (MesGuideValidation.inMesZone(relX, relY) ||
              MesGuideValidation.matchesMes(t))) {
        mesValue = MesGuideValidation.extractMes(t);
      }
      if (pageValue == null && MesGuideValidation.inPageZone(relX, relY)) {
        pageValue =
            MesGuideValidation.extractPage(t) ??
            MesGuideValidation.extractFraction(t);
      }
      if (boxValue == null && MesGuideValidation.inBoxZone(relX, relY)) {
        boxValue =
            MesGuideValidation.extractBox(t) ??
            MesGuideValidation.extractFraction(t);
      }
    }

    if (pageValue == null || boxValue == null) {
      final bottom =
          lines.where((l) {
            final relY = ((l.box.center.dy - minY) / hullH).clamp(0.0, 1.0);
            return relY > 0.78 && MesGuideValidation.matchesFraction(l.text);
          }).toList()
            ..sort((a, b) => a.box.center.dx.compareTo(b.box.center.dx));

      if (bottom.isNotEmpty) {
        pageValue ??=
            MesGuideValidation.extractPage(bottom.first.text) ??
            MesGuideValidation.extractFraction(bottom.first.text);
      }
      if (bottom.length >= 2) {
        boxValue ??=
            MesGuideValidation.extractBox(bottom.last.text) ??
            MesGuideValidation.extractFraction(bottom.last.text);
      } else if (bottom.length == 1 && boxValue == null) {
        final relX =
            ((bottom.first.box.center.dx - minX) / hullW).clamp(0.0, 1.0);
        if (MesGuideValidation.inBoxZone(relX, 0.95)) {
          boxValue = MesGuideValidation.extractFraction(bottom.first.text);
        }
      }
    }

    return MesStickerScanResult(
      rawText: allText,
      fields: [
        MesFieldResult(
          field: MesGuideField.orNo,
          label: 'OR No',
          ok: orValue != null && orValue.isNotEmpty,
          value: orValue,
        ),
        MesFieldResult(
          field: MesGuideField.mesNumber,
          label: 'MES No',
          ok: mesValue != null && mesValue.isNotEmpty,
          value: mesValue,
        ),
        MesFieldResult(
          field: MesGuideField.page,
          label: 'PAGE',
          ok: pageValue != null && pageValue.isNotEmpty,
          value: pageValue,
        ),
        MesFieldResult(
          field: MesGuideField.box,
          label: 'BOX',
          ok: boxValue != null && boxValue.isNotEmpty,
          value: boxValue,
        ),
      ],
    );
  } finally {
    await textRecognizer.close();
    await barcodeScanner.close();
  }
}

class _Line {
  _Line(this.text, this.box);
  final String text;
  final Rect box;
}
