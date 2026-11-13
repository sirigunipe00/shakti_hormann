import 'package:flutter_test/flutter_test.dart';
import 'package:shakti_hormann/widgets/hormann_loading_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HormannLoadingController', () {
    test('progress never decreases and stays below 100 until complete', () {
      final c = HormannLoadingController();
      expect(c.progress, 0);

      c.setStage(0.4);
      expect(c.progress, 0.4);

      c.setStage(0.2);
      expect(c.progress, 0.4);

      c.setStage(0.99);
      expect(c.progress, lessThan(1.0));
      expect(c.progress, 0.92);
      expect(c.isCompleted, isFalse);
    });

    test('complete reaches 100 exactly once', () async {
      final c = HormannLoadingController()..setStage(0.5);
      await c.complete(holdAtFull: Duration.zero);
      expect(c.progress, 1.0);
      expect(c.isCompleted, isTrue);
      expect(c.label, 'Ready');

      await c.complete(holdAtFull: Duration.zero);
      expect(c.progress, 1.0);
      expect(c.isCompleted, isTrue);
    });

    test('idle creep respects ceiling and stops after complete', () async {
      final c = HormannLoadingController()..setStage(0.1);
      c.startIdleCreep(
        ceiling: 0.3,
        interval: const Duration(milliseconds: 20),
        step: 0.05,
      );
      await Future<void>.delayed(const Duration(milliseconds: 120));
      expect(c.progress, lessThanOrEqualTo(0.3));
      expect(c.progress, greaterThan(0.1));

      await c.complete(holdAtFull: Duration.zero);
      final after = c.progress;
      await Future<void>.delayed(const Duration(milliseconds: 80));
      expect(c.progress, after);
      expect(c.progress, 1.0);
    });

    test('reset starts a fresh loading operation', () async {
      final c = HormannLoadingController()..setStage(0.7);
      await c.complete(holdAtFull: Duration.zero);
      c.reset();
      expect(c.progress, 0);
      expect(c.isCompleted, isFalse);
      expect(c.label, 'Fitting the frame');
    });
  });
}
