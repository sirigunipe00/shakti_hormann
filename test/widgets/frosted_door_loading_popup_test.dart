import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shakti_hormann/widgets/form_page_loading_stack.dart';
import 'package:shakti_hormann/widgets/frosted_door_loading_popup.dart';
import 'package:shakti_hormann/widgets/hormann_loading_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpAtSize(
    WidgetTester tester, {
    required Size size,
  }) async {
    final progress = HormannLoadingController()..setStage(0.2);

    await tester.pumpWidget(
      MediaQuery(
        data: MediaQueryData(size: size),
        child: MaterialApp(
          home: Scaffold(
            body: FrostedDoorLoadingPopup(
              progress: progress,
              message: 'Saving document...',
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.textContaining('Saving document'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    progress.dispose();
    await tester.pump();
  }

  testWidgets('renders on compact phone without overflow', (tester) async {
    await pumpAtSize(tester, size: const Size(320, 640));
  });

  testWidgets('renders on large phone without overflow', (tester) async {
    await pumpAtSize(tester, size: const Size(430, 932));
  });

  testWidgets('renders on tablet without overflow', (tester) async {
    await pumpAtSize(tester, size: const Size(800, 1280));
  });

  testWidgets('FormPageLoadingStack shows action message', (tester) async {
    await tester.pumpWidget(
      const MediaQuery(
        data: MediaQueryData(size: Size(390, 844)),
        child: MaterialApp(
          home: Scaffold(
            body: FormPageLoadingStack(
              isLoading: true,
              message: 'Saving document...',
              child: Center(child: Text('Form')),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('Saving document...'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 3));
  });
}
