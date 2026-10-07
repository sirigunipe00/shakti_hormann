
// import 'package:flutter/material.dart';

// class FormPageLoadingStack extends StatelessWidget {
//   const FormPageLoadingStack({
//     super.key,
//     required this.isLoading,
//     required this.child,
//     this.message = 'Please wait...',
//     this.statusLabel,
//   });

//   final bool isLoading;
//   final Widget child;
//   final String message;
//   final String? statusLabel;

//   @override
//   Widget build(BuildContext context) {
//     if (!isLoading) return child;

//     return Stack(
//       fit: StackFit.expand,
//       children: [
//         child,
//         Positioned.fill(
//           child: AbsorbPointer(
//             child: ColoredBox(
//               color: Colors.black.withValues(alpha: 0.25),
//               child: Center(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const CircularProgressIndicator(),
//                     const SizedBox(height: 16),
//                     Text(
//                       message,
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 15,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }


// class FormBusyOverlayBinder extends StatelessWidget {
//   const FormBusyOverlayBinder({
//     super.key,
//     required this.isBusy,
//     required this.child,
//     this.message = 'Please wait...',
//     this.statusLabel,
//   });

//   final bool isBusy;
//   final Widget child;
//   final String message;
//   final String? statusLabel;

//   @override
//   Widget build(BuildContext context) {
//     return FormPageLoadingStack(
//       isLoading: isBusy,
//       message: message,
//       statusLabel: statusLabel,
//       child: child,
//     );
//   }
// }

import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

/// Native Flutter recreation of the Hörmann branded door-loading animation.
/// Loops every 2 seconds, mirroring the original CSS keyframe timings:
/// frame assembles -> door drops in -> door swings open -> closes -> fades out.
class DoorLoadingIndicator extends StatefulWidget {
  const DoorLoadingIndicator({
    super.key,
    this.scale = 1.0,
    this.showProgress = true,
  });

  /// Uniform scale applied to the whole graphic (base size is 190x222 + a
  /// 210-wide progress bar below it).
  final double scale;

  /// Whether to show the progress bar / status label under the animation.
  final bool showProgress;

  @override
  State<DoorLoadingIndicator> createState() => _DoorLoadingIndicatorState();
}

class _DoorLoadingIndicatorState extends State<DoorLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const _phases = <_Phase>[
    _Phase(0.00, 'Fitting the frame'),
    _Phase(0.24, 'Hanging the door'),
    _Phase(0.42, 'Checking the finish'),
    _Phase(0.55, 'Opening the door'),
    _Phase(0.66, 'Closing up'),
    _Phase(0.88, 'Almost ready'),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Piecewise-linear interpolation between (stop, value) keyframe pairs,
  /// equivalent to the CSS @keyframes percentage stops in the original file.
  static double _kf(double t, List<double> stops, List<double> values) {
    if (t <= stops.first) return values.first;
    if (t >= stops.last) return values.last;
    for (var i = 0; i < stops.length - 1; i++) {
      if (t >= stops[i] && t <= stops[i + 1]) {
        final span = stops[i + 1] - stops[i];
        final localT = span == 0 ? 0.0 : (t - stops[i]) / span;
        return values[i] + (values[i + 1] - values[i]) * localT;
      }
    }
    return values.last;
  }

  String _labelFor(double t) {
    var current = _phases.first.text;
    for (final p in _phases) {
      if (t >= p.at) current = p.text;
    }
    return current;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;

        final lightOpacity =
            _kf(t, [0, 0.40, 0.56, 0.68, 1], [0, 0, 1, 0, 0]);
        final jambX = _kf(
            t, [0, 0.06, 0.22, 0.88, 0.96, 1], [120, 120, 0, 0, 120, 120]);
        final jambOpacity =
            _kf(t, [0, 0.06, 0.22, 0.88, 0.96, 1], [0, 0, 1, 1, 0, 0]);
        final headerY = _kf(
            t, [0, 0.10, 0.26, 0.88, 0.96, 1], [-85, -85, 0, 0, -85, -85]);
        final headerOpacity =
            _kf(t, [0, 0.10, 0.26, 0.88, 0.96, 1], [0, 0, 1, 1, 0, 0]);
        final doorY = _kf(t, [0, 0.24, 0.40, 0.94, 1], [210, 210, 0, 0, 210]);
        final doorOpacity = _kf(t, [0, 0.24, 0.40, 0.94, 1], [0, 0, 1, 1, 0]);
        final doorRotY =
            _kf(t, [0.40, 0.46, 0.58, 0.68, 0.84], [0, 0, -56, 0, 0]);
        final shineX =
            _kf(t, [0, 0.42, 0.46, 0.52, 1], [-60, -60, 130, 130, 130]);
        final shineOpacity =
            _kf(t, [0, 0.42, 0.46, 0.52, 1], [0, 0, 0.9, 0, 0]);
        final label = _labelFor(t);
        const sceneHeight = 235.0;
        final scale = widget.scale;
        return Column(
          mainAxisSize: MainAxisSize.min,
          // Center everything (the frame graphic and the progress bar /
          // label beneath it) on the same vertical axis.
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 190 * scale,
              height: sceneHeight * scale,
              child: Transform.scale(
                scale: scale,
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: 190,
                  height: sceneHeight,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Ambient glow
                      Positioned.fill(
                        child: IgnorePointer(
                          child: Opacity(
                            opacity: lightOpacity,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    const Color(0xFFF2A93E)
                                        .withValues(alpha: 0.32),
                                    const Color(0xFFF2A93E)
                                        .withValues(alpha: 0.0),
                                  ],
                                  stops: const [0.0, 0.7],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Left jamb — spans exactly the door/opening height,
                      // nothing extra below it.
                      Positioned(
                        left: 28 + jambX,
                        top: 13,
                        width: 13,
                        height: sceneHeight - 13,
                        child: Opacity(
                          opacity: jambOpacity,
                          child: const _JambBox(),
                        ),
                      ),
                      // Right jamb
                      Positioned(
                        right: 28 + jambX,
                        top: 13,
                        width: 13,
                        height: sceneHeight - 13,
                        child: Opacity(
                          opacity: jambOpacity,
                          child: const _JambBox(),
                        ),
                      ),
                      // Header
                      Positioned(
                        left: 28,
                        right: 28,
                        top: headerY,
                        height: 13,
                        child: Opacity(
                          opacity: headerOpacity,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.08),
                              ),
                              gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xFF333C58),
                                  Color(0xFF1B2138)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Opening + door — same height as the jambs, so the
                      // door's bottom edge lines up with the jamb's bottom.
                      // left/right offsets are symmetric (41/41 in a 190pt
                      // wide scene), so the door is horizontally centered.
                      Positioned(
                        left: 41,
                        right: 41,
                        top: 13,
                        height: sceneHeight - 13,
                        child: ClipRect(
                          child: ColoredBox(
                            color: const Color(0xFFF5F3EE),
                            child: Opacity(
                              opacity: doorOpacity,
                              child: Transform(
                                alignment: Alignment.bottomLeft,
                                transform: Matrix4.identity()
                                  ..setEntry(3, 2, 0.0015)
                                  ..translate(0.0, doorY)
                                  ..rotateY(doorRotY * math.pi / 180),
                                child: _Door(
                                  shineX: shineX,
                                  shineOpacity: shineOpacity,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (widget.showProgress) ...[
              SizedBox(height: 20 * scale),
              SizedBox(
                width: 210 * scale,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: SizedBox(
                        height: 3,
                        child: Stack(
                          children: [
                            Container(
                              color: const Color(0xFF1C4587)
                                  .withValues(alpha: 0.1),
                            ),
                            FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: t,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFC9862B),
                                      Color(0xFFF2A93E)
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFF2A93E)
                                          .withValues(alpha: 0.5),
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Status label, centered under the door graphic (was
                    // previously left-aligned due to a single-child Row
                    // with MainAxisAlignment.spaceBetween).
                    Center(
                      child: Text(
                        label,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 11.5,
                          letterSpacing: 0.4,
                          color: Color(0xFF8A8D9A),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _Phase {
  const _Phase(this.at, this.text);
  final double at;
  final String text;
}

class _JambBox extends StatelessWidget {
  const _JambBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        gradient: const LinearGradient(
          colors: [Color(0xFF2C3550), Color(0xFF1B2138)],
        ),
      ),
    );
  }
}

class _Door extends StatelessWidget {
  const _Door({required this.shineX, required this.shineOpacity});

  final double shineX;
  final double shineOpacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black.withValues(alpha: 0.2)),
        gradient: const LinearGradient(
          begin: Alignment(-0.7, -0.7),
          end: Alignment(0.7, 0.7),
          colors: [
            Color(0xFFC99A5F),
            Color(0xFF9C6D3A),
            Color(0xFF7D5527),
          ],
          stops: [0.0, 0.45, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            offset: const Offset(4, 0),
            blurRadius: 14,
          ),
        ],
      ),
      child: ClipRect(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final h = constraints.maxHeight;
            return Stack(
              children: [
                const Positioned(
                  left: 11,
                  right: 11,
                  top: 13,
                  height: 73,
                  child: _Panel(),
                ),
                const Positioned(
                  left: 11,
                  right: 11,
                  top: 98,
                  height: 111,
                  child: _Panel(),
                ),
                const Positioned(
                  top: 10,
                  left: 0,
                  right: 0,
                  child: Center(child: _Plate()),
                ),
                const Positioned(
                  right: 7,
                  top: 117,
                  child: _Handle(),
                ),
                Positioned(
                  top: -h * 0.2,
                  left: w * (shineX / 100),
                  width: w * 0.4,
                  height: h * 1.4,
                  child: Opacity(
                    opacity: shineOpacity.clamp(0.0, 1.0),
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.skewX(-18 * math.pi / 180),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withValues(alpha: 0.0),
                              Colors.white.withValues(alpha: 0.55),
                              Colors.white.withValues(alpha: 0.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        gradient: LinearGradient(
          begin: const Alignment(-0.7, -0.7),
          end: const Alignment(0.7, 0.7),
          colors: [
            const Color(0xFFB88950).withValues(alpha: 0.57),
            const Color(0xFF8A5C2E),
          ],
        ),
      ),
    );
  }
}

class _Plate extends StatelessWidget {
  const _Plate();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 3, 8, 3),
      decoration: BoxDecoration(
        color: const Color(0xFF1C4587),
        borderRadius: BorderRadius.circular(2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: const Text(
        'HÖRMANN',
        // NOTE: uses the default font family here. If you have Montserrat
        // registered in pubspec.yaml, swap this for fontFamily: 'Montserrat'.
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 8,
          letterSpacing: 0.4,
          color: Color(0xFFF2A93E),
        ),
      ),
    );
  }
}

class _Handle extends StatelessWidget {
  const _Handle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 7,
      height: 7,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          center: Alignment(-0.3, -0.3),
          colors: [Color(0xFFF4D492), Color(0xFFB8862F)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFF4D492).withValues(alpha: 0.7),
            blurRadius: 4,
          ),
        ],
      ),
    );
  }
}


// class FormPageLoadingStack extends StatelessWidget {
//   const FormPageLoadingStack({
//     super.key,
//     required this.isLoading,
//     required this.child,
//     this.message,
//     this.statusLabel,
//   });

//   final bool isLoading;
//   final Widget child;

//   final String? message;
//   final String? statusLabel;

//   static const double _cardRadius = 24.0;

//   @override
//   Widget build(BuildContext context) {
//     if (!isLoading) return child;

//     return Stack(
//       fit: StackFit.expand,
//       children: [
//         child,
//         Positioned.fill(
//           child: AbsorbPointer(
//             child: ColoredBox(
//               // A very light overall scrim so the frosted card reads
//               // clearly against busy backgrounds, without fully hiding
//               // the page underneath.
//               color: Colors.black.withValues(alpha: 0.22),
//               child: Center(
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(_cardRadius),
//                   child: BackdropFilter(
//                     // Frosted-glass blur of whatever sits behind the card
//                     // (the dimmed page content).
//                     filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 28,
//                         horizontal: 34,
//                       ),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(_cardRadius),
//                         // A subtle multi-stop tint (rather than a flat
//                         // color) so the glass looks like it's catching
//                         // light unevenly, the way real frosted glass does.
//                         gradient: LinearGradient(
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                           colors: [
//                             Colors.white.withValues(alpha: 0.34),
//                             Colors.white.withValues(alpha: 0.12),
//                             Colors.white.withValues(alpha: 0.20),
//                           ],
//                           stops: const [0.0, 0.55, 1.0],
//                         ),
//                         // Bright outer rim = the "edge" of the glass
//                         // catching light.
//                         border: Border.all(
//                           color: Colors.white.withValues(alpha: 0.55),
//                           width: 1.2,
//                         ),
//                         boxShadow: [
//                           // Soft, wide ambient shadow lifts the card off
//                           // the page.
//                           BoxShadow(
//                             color: Colors.black.withValues(alpha: 0.20),
//                             blurRadius: 36,
//                             offset: const Offset(0, 18),
//                           ),
//                           // Tighter contact shadow for grounding.
//                           BoxShadow(
//                             color: Colors.black.withValues(alpha: 0.12),
//                             blurRadius: 8,
//                             offset: const Offset(0, 3),
//                           ),
//                         ],
//                       ),
//                       // Painted on top of the content: a faint diagonal
//                       // sheen fading from the top-left corner, plus a
//                       // hairline dark inner edge — together they read as
//                       // light glancing off a curved glass surface.
//                       foregroundDecoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(_cardRadius),
//                         border: Border.all(
//                           color: Colors.black.withValues(alpha: 0.05),
//                           width: 0.6,
//                         ),
//                         gradient: LinearGradient(
//                           begin: const Alignment(-1, -1),
//                           end: const Alignment(0.3, 0.5),
//                           colors: [
//                             Colors.white.withValues(alpha: 0.35),
//                             Colors.white.withValues(alpha: 0.0),
//                           ],
//                           stops: const [0.0, 0.65],
//                         ),
//                       ),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           // Door graphic is the focal point of the card,
//                           // centered both horizontally and as the first
//                           // (and largest) element vertically.
//                           const DoorLoadingIndicator(scale: 0.95),
//                           if (message != null) ...[
//                             const SizedBox(height: 14),
//                             Text(
//                               message!,
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 color: const Color(0xFF1C4587),
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w600,
//                                 shadows: [
//                                   Shadow(
//                                     color: Colors.white.withValues(alpha: 0.6),
//                                     blurRadius: 4,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
class FormPageLoadingStack extends StatefulWidget {
  const FormPageLoadingStack({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
    this.statusLabel,
  });

  final bool isLoading;
  final Widget child;
  final String? message;
  final String? statusLabel;

  @override
  State<FormPageLoadingStack> createState() => _FormPageLoadingStackState();
}

class _FormPageLoadingStackState extends State<FormPageLoadingStack> {
  static const _minVisible = Duration(milliseconds: 2000);

  bool _showOverlay = false;
  DateTime? _shownAt;

  @override
  void initState() {
    super.initState();
    _showOverlay = widget.isLoading;
    if (_showOverlay) _shownAt = DateTime.now();
  }

  @override
  void didUpdateWidget(covariant FormPageLoadingStack oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isLoading && !_showOverlay) {
      setState(() {
        _showOverlay = true;
        _shownAt = DateTime.now();
      });
    } else if (!widget.isLoading && _showOverlay) {
      final elapsed = DateTime.now().difference(_shownAt ?? DateTime.now());
      final remaining = _minVisible - elapsed;

      if (remaining <= Duration.zero) {
        setState(() => _showOverlay = false);
      } else {
        Future.delayed(remaining, () {
          if (!mounted) return;
          if (!widget.isLoading) {
            setState(() => _showOverlay = false);
          }
        });
      }
    }
  }

  static const double _cardRadius = 24.0;

  @override
  Widget build(BuildContext context) {
    if (!_showOverlay) return widget.child;

    return Stack(
      fit: StackFit.expand,
      children: [
        widget.child,
        Positioned.fill(
          child: AbsorbPointer(
            child: ColoredBox(
              color: Colors.black.withValues(alpha: 0.22),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(_cardRadius),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 28,
                        horizontal: 34,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(_cardRadius),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withValues(alpha: 0.34),
                            Colors.white.withValues(alpha: 0.12),
                            Colors.white.withValues(alpha: 0.20),
                          ],
                          stops: const [0.0, 0.55, 1.0],
                        ),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.55),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.20),
                            blurRadius: 36,
                            offset: const Offset(0, 18),
                          ),
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      foregroundDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(_cardRadius),
                        border: Border.all(
                          color: Colors.black.withValues(alpha: 0.05),
                          width: 0.6,
                        ),
                        gradient: LinearGradient(
                          begin: const Alignment(-1, -1),
                          end: const Alignment(0.3, 0.5),
                          colors: [
                            Colors.white.withValues(alpha: 0.35),
                            Colors.white.withValues(alpha: 0.0),
                          ],
                          stops: const [0.0, 0.65],
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const DoorLoadingIndicator(scale: 0.95),
                          if (widget.message != null) ...[
                            const SizedBox(height: 14),
                            Text(
                              widget.message!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: const Color(0xFF1C4587),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                shadows: [
                                  Shadow(
                                    color: Colors.white.withValues(alpha: 0.6),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class FormBusyOverlayBinder extends StatelessWidget {
  const FormBusyOverlayBinder({
    super.key,
    required this.isBusy,
    required this.child,
    this.message,
    this.statusLabel,
  });

  final bool isBusy;
  final Widget child;
  final String? message;
  final String? statusLabel;

  @override
  Widget build(BuildContext context) {
    return FormPageLoadingStack(
      isLoading: isBusy,
      message: message,
      statusLabel: statusLabel,
      child: child,
    );
  }
}