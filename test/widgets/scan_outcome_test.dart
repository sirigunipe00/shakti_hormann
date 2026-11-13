import 'package:flutter_test/flutter_test.dart';
import 'package:shakti_hormann/app/data/app_repo.dart';
import 'package:shakti_hormann/widgets/scan/scan_outcome.dart';

void main() {
  group('ScanOutcome', () {
    test('ok / fail flags', () {
      expect(const ScanOutcome.ok('done').success, isTrue);
      expect(const ScanOutcome.fail('bad').success, isFalse);
      expect(
        const ScanOutcome.ok('photo', shouldStop: true).shouldStop,
        isTrue,
      );
    });
  });

  group('isUpdateRequired', () {
    test('forces update when server is newer', () {
      expect(isUpdateRequired('2.0.0', '2.0.1'), isTrue);
      expect(isUpdateRequired('2.0.0', '2.1.0'), isTrue);
      expect(isUpdateRequired('1.9.9', '2.0.0'), isTrue);
    });

    test('does not force when app is same or newer', () {
      expect(isUpdateRequired('2.0.0', '2.0.0'), isFalse);
      expect(isUpdateRequired('2.1.0', '2.0.5'), isFalse);
    });
  });
}
