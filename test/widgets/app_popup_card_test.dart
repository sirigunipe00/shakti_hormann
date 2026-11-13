import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shakti_hormann/widgets/dailogs/app_dialogs.dart';
import 'package:shakti_hormann/widgets/dailogs/app_popup_card.dart';

void main() {
  testWidgets('AppPopupCard close, cancel and confirm fire callbacks',
      (tester) async {
    var closed = false;
    var cancelled = false;
    var confirmed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppPopupCard(
            title: 'Print Stickers?',
            icon: Icons.print_rounded,
            body: const Text('Body'),
            onClose: () => closed = true,
            cancelText: 'Cancel',
            onCancel: () => cancelled = true,
            confirmText: 'Print',
            onConfirm: () => confirmed = true,
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pump();
    expect(closed, isTrue);

    await tester.tap(find.text('Cancel'));
    await tester.pump();
    expect(cancelled, isTrue);

    await tester.tap(find.text('Print'));
    await tester.pump();
    expect(confirmed, isTrue);
  });

  testWidgets('AppPopupCard single-action OK fires confirm', (tester) async {
    var confirmed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppPopupCard(
            title: 'Success',
            icon: Icons.check_rounded,
            body: const Text('Saved'),
            singleAction: true,
            confirmText: 'OK',
            onConfirm: () => confirmed = true,
            onClose: () => confirmed = true,
          ),
        ),
      ),
    );

    await tester.tap(find.text('OK'));
    await tester.pump();
    expect(confirmed, isTrue);
  });

  testWidgets('AppDialog.confirm Cancel and Close return false, Confirm true',
      (tester) async {
    Future<bool?>? result;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: ElevatedButton(
                onPressed: () {
                  result = AppDialog.confirm(
                    context,
                    title: 'Submit Document?',
                    content: 'Are you sure?',
                    confirmText: 'Submit',
                  );
                },
                child: const Text('Open'),
              ),
            );
          },
        ),
      ),
    );

    // Cancel
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.text('Submit Document?'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(await result, isFalse);
    expect(find.text('Submit Document?'), findsNothing);

    // Close X
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();
    expect(await result, isFalse);

    // Confirm
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();
    expect(await result, isTrue);
  });

  testWidgets('AppDialog.confirmPrintStickers Cancel returns false',
      (tester) async {
    Future<bool?>? result;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: ElevatedButton(
                onPressed: () {
                  result = AppDialog.confirmPrintStickers(
                    context,
                    stickerCount: 3,
                    salesOrderNo: '180048939',
                  );
                },
                child: const Text('Open'),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.text('Print Stickers?'), findsOneWidget);
    expect(find.textContaining('180048939'), findsOneWidget);

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(await result, isFalse);

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Print'));
    await tester.pumpAndSettle();
    expect(await result, isTrue);
  });

  testWidgets('AppFormDialogShell close and cancel dismiss', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: ElevatedButton(
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (_) => AppFormDialogShell(
                      title: 'Add Item',
                      subtitle: 'Fill details',
                      cancelText: 'Cancel',
                      confirmText: 'Add',
                      onConfirm: () => Navigator.of(context).pop(),
                      child: const TextField(
                        decoration: InputDecoration(labelText: 'Qty'),
                      ),
                    ),
                  );
                },
                child: const Text('Open'),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.text('Add Item'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Add Item'), findsNothing);

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Add Item'), findsNothing);
  });
}
