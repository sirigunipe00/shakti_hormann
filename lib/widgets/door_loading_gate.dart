import 'package:flutter/material.dart';
import 'package:shakti_hormann/widgets/door_loading_loop.dart';

/// Keeps the door loading graphic visible until one full animation cycle
/// completes and [isContentReady] is true, then reveals [child].
class DoorLoadingGate extends StatefulWidget {
  const DoorLoadingGate({
    super.key,
    required this.isContentReady,
    required this.child,
    this.loadingWidth,
    this.expand = false,
    this.loading,
  });

  final bool isContentReady;
  final Widget child;
  final double? loadingWidth;
  final bool expand;
  final Widget Function(VoidCallback onFirstCycleComplete)? loading;

  @override
  State<DoorLoadingGate> createState() => _DoorLoadingGateState();
}

class _DoorLoadingGateState extends State<DoorLoadingGate> {
  bool _graphicCycleComplete = false;

  @override
  void didUpdateWidget(covariant DoorLoadingGate oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.isContentReady && oldWidget.isContentReady) {
      _graphicCycleComplete = false;
    }
  }

  void _onFirstCycleComplete() {
    if (!mounted || _graphicCycleComplete) return;
    setState(() => _graphicCycleComplete = true);
  }

  bool get _showContent => widget.isContentReady && _graphicCycleComplete;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Offstage(
          offstage: !_showContent,
          child: widget.child,
        ),
        if (!_showContent)
          Positioned.fill(
            child:
                widget.loading?.call(_onFirstCycleComplete) ??
                DoorLoadingPresentation(
                  onFirstCycleComplete: _onFirstCycleComplete,
                  width: widget.loadingWidth,
                  expand: widget.expand,
                ),
          ),
      ],
    );
  }
}

/// Shared door loading layout for lists, forms, and full-screen states.
class DoorLoadingPresentation extends StatelessWidget {
  const DoorLoadingPresentation({
    super.key,
    this.onFirstCycleComplete,
    this.width,
    this.expand = false,
  });

  final VoidCallback? onFirstCycleComplete;
  final double? width;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    if (expand) {
      return DoorLoadingLoop(
        expand: true,
        onFirstCycleComplete: onFirstCycleComplete,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final animationWidth =
            width ?? (constraints.maxWidth * 0.78).clamp(240.0, 300.0);

        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            child: Center(
              child: DoorLoadingLoop(
                width: animationWidth,
                onFirstCycleComplete: onFirstCycleComplete,
              ),
            ),
          ),
        );
      },
    );
  }
}
