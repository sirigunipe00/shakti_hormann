import 'package:flutter_test/flutter_test.dart';
import 'package:shakti_hormann/features/hardware_packing/presentation/ui/widget/mes_guide_validation.dart';

void main() {
  group('MesGuideValidation', () {
    test('OR NO from sticker samples', () {
      expect(MesGuideValidation.extractOr('OR. 180048715'), '180048715');
      expect(MesGuideValidation.matchesOrNo('180048715'), isTrue);
      expect(MesGuideValidation.matchesOrNo('5000000069682'), isFalse);
    });

    test('MES number / barcode / QR payload', () {
      expect(MesGuideValidation.extractMes('5000000069682'), '5000000069682');
      expect(
        MesGuideValidation.extractMes('xx5000000069682yy'),
        '5000000069682',
      );
      expect(
        MesGuideValidation.matchesMes('QRDATA5000000069682', isBarcode: true),
        isTrue,
      );
    });

    test('Page and Box labels with spaces', () {
      expect(MesGuideValidation.extractPage('Page: 1/2'), '1/2');
      expect(MesGuideValidation.extractPage('Page 1 / 2'), '1/2');
      expect(MesGuideValidation.extractBox('Box: 3/13'), '3/13');
      expect(MesGuideValidation.extractBox('Box 1 / 4'), '1/4');
      expect(MesGuideValidation.matchesPage('Box: 2/13'), isFalse);
    });
  });
}
