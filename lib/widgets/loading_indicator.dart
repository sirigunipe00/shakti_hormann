import 'package:flutter/material.dart';
import 'package:shakti_hormann/widgets/door_loading_gate.dart';
import 'package:shakti_hormann/widgets/door_loading_loop.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
    this.color = const Color(0xff4c5c92),
    this.compact = false,
    this.isContentReady = false,
    this.child,
  });

  final Color color;

  /// Use for inline areas (buttons, pagination) — keeps a small spinner.
  final bool compact;

  /// When set with [child], waits for a full door cycle before revealing content.
  final bool isContentReady;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.black12,
          color: color,
          strokeWidth: 4,
        ),
      );
    }

    if (child != null) {
      return DoorLoadingGate(
        isContentReady: isContentReady,
        expand: true,
        child: child!,
      );
    }

    return const SizedBox.expand(child: DoorLoadingLoop(expand: true));
  }
}
