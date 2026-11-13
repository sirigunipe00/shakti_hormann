import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shakti_hormann/core/utils/shell_insets.dart';

void main() {
  testWidgets('bottom scroll clearance clears floating nav + safe area',
      (tester) async {
    late double clearance;
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(
          padding: EdgeInsets.only(bottom: 20),
          viewPadding: EdgeInsets.only(bottom: 20),
        ),
        child: Builder(
          builder: (context) {
            clearance = ShellInsets.bottomScrollClearance(context);
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(
      clearance,
      ShellInsets.navBarHeight +
          ShellInsets.navOuterPadding +
          ShellInsets.extraBreathingRoom +
          20,
    );
    expect(clearance, greaterThan(110));
  });
}
