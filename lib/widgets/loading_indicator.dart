import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
    this.color = const Color(0xff4c5c92),
    this.compact = true,
    this.isContentReady = false,
    this.child,
  });

  final Color color;

  /// Use for inline areas (buttons, pagination) — keeps a small spinner.
  final bool compact;

  /// Kept for API compatibility; list screens no longer gate on door cycles.
  final bool isContentReady;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    if (child != null && isContentReady) {
      return child!;
    }

    return Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.black12,
        color: color,
        strokeWidth: 4,
      ),
    );
  }
}
