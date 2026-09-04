import 'package:flutter/material.dart';
import 'package:shakti_hormann/widgets/hormann_door_loading_loop.dart';

/// Backwards-compatible alias for [HormannDoorLoadingLoop].
class DoorLoadingLoop extends StatelessWidget {
  const DoorLoadingLoop({
    super.key,
    this.width = 240,
    this.expand = false,
    this.fixedStatusLabel,
    this.loopDuration = const Duration(milliseconds: 2000),
    this.onFirstCycleComplete,
    this.holdCompleteAssembly = false,
  });

  final double width;
  final bool expand;
  final String? fixedStatusLabel;
  final Duration loopDuration;
  final VoidCallback? onFirstCycleComplete;
  final bool holdCompleteAssembly;

  @override
  Widget build(BuildContext context) {
    return HormannDoorLoadingLoop(
      width: width,
      expand: expand,
      fixedStatusLabel: fixedStatusLabel,
      loopDuration: loopDuration,
      onFirstCycleComplete: onFirstCycleComplete,
      holdCompleteAssembly: holdCompleteAssembly,
    );
  }
}
