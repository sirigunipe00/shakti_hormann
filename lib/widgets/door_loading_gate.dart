import 'package:flutter/material.dart';
import 'package:shakti_hormann/widgets/door_loading_loop.dart';
import 'package:shakti_hormann/widgets/hormann_loading_controller.dart';

/// Keeps the door loading graphic visible until [isContentReady] is true,
/// completes progress to 100% once, then reveals [child].
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

  /// Optional custom loader. Receives a no-op for backwards compatibility
  /// with call sites that previously waited on the first animation cycle.
  final Widget Function(VoidCallback onFirstCycleComplete)? loading;

  @override
  State<DoorLoadingGate> createState() => _DoorLoadingGateState();
}

class _DoorLoadingGateState extends State<DoorLoadingGate> {
  late final HormannLoadingController _progress = HormannLoadingController();
  var _showContent = false;
  var _finishing = false;

  @override
  void initState() {
    super.initState();
    _progress.setStage(0.12);
    _progress.startIdleCreep(ceiling: 0.88);
    if (widget.isContentReady) {
      _beginFinish();
    }
  }

  @override
  void didUpdateWidget(covariant DoorLoadingGate oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isContentReady && !oldWidget.isContentReady) {
      _beginFinish();
    } else if (!widget.isContentReady && oldWidget.isContentReady) {
      _showContent = false;
      _finishing = false;
      _progress.reset();
      _progress.setStage(0.12);
      _progress.startIdleCreep(ceiling: 0.88);
    }
  }

  Future<void> _beginFinish() async {
    if (_finishing || _showContent) return;
    _finishing = true;
    await _progress.complete();
    if (!mounted) return;
    setState(() => _showContent = true);
  }

  @override
  void dispose() {
    _progress.dispose();
    super.dispose();
  }

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
                widget.loading?.call(() {}) ??
                DoorLoadingPresentation(
                  width: widget.loadingWidth,
                  expand: widget.expand,
                  progressController: _progress,
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
    this.progressController,
  });

  final VoidCallback? onFirstCycleComplete;
  final double? width;
  final bool expand;
  final HormannLoadingController? progressController;

  @override
  Widget build(BuildContext context) {
    if (expand) {
      return DoorLoadingLoop(
        expand: true,
        onFirstCycleComplete: onFirstCycleComplete,
        progressController: progressController,
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
                progressController: progressController,
              ),
            ),
          ),
        );
      },
    );
  }
}
