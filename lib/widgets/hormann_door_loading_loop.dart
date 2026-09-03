import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Fast looping Hörmann door-and-frame assembly loader.
///
/// Branding lives only on the small navy nameplate mounted on the door —
/// no page heading or logo above the scene.
class HormannDoorLoadingLoop extends StatefulWidget {
  const HormannDoorLoadingLoop({
    super.key,
    this.width = 240,
    this.expand = false,
    this.fixedStatusLabel,
    this.loopDuration = const Duration(milliseconds: 2000),
    this.onFirstCycleComplete,
  });

  final double width;
  final bool expand;
  final String? fixedStatusLabel;
  final Duration loopDuration;
  final VoidCallback? onFirstCycleComplete;

  @override
  State<HormannDoorLoadingLoop> createState() => _HormannDoorLoadingLoopState();
}

class _HormannDoorLoadingLoopState extends State<HormannDoorLoadingLoop>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _cycleCompleteNotified = false;
  double _previousT = 0;
  bool _progressVisible = false;

  static const _sceneW = 190.0;
  static const _sceneH = 235.0;
  static const _jambW = 13.0;
  static const _headerH = 13.0;
  static const _jambInset = 28.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.loopDuration,
    )..repeat();
    _controller.addListener(_onTick);

    // Progress bar fades in once near start (not tied to the loop reset).
    Future<void>.delayed(const Duration(milliseconds: 180), () {
      if (mounted) setState(() => _progressVisible = true);
    });
  }

  void _onTick() {
    final t = _controller.value;
    final wrapped = _previousT > 0.9 && t < 0.1;
    _previousT = t;
    if (wrapped && !_cycleCompleteNotified) {
      _cycleCompleteNotified = true;
      widget.onFirstCycleComplete?.call();
    }
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onTick)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scale = widget.width / 240;
    final sceneW = _sceneW * scale;
    final sceneH = _sceneH * scale;
    final progressW = 210 * scale;

    final content = AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: sceneW,
              height: sceneH,
              child: _DoorScene(t: t, scale: scale),
            ),
            SizedBox(height: 36 * scale),
            AnimatedOpacity(
              opacity: _progressVisible ? 1 : 0,
              duration: const Duration(milliseconds: 250),
              child: _ProgressBar(
                t: t,
                width: progressW,
                fixedStatusLabel: widget.fixedStatusLabel,
              ),
            ),
          ],
        );
      },
    );

    if (!widget.expand) {
      // Intrinsic size only — must not expand to fill parent (form overlays).
      return content;
    }

    return ColoredBox(
      color: Colors.white,
      child: Center(child: content),
    );
  }
}

class _DoorScene extends StatelessWidget {
  const _DoorScene({required this.t, required this.scale});

  final double t;
  final double scale;

  @override
  Widget build(BuildContext context) {
    final sceneW = _HormannDoorLoadingLoopState._sceneW * scale;
    final sceneH = _HormannDoorLoadingLoopState._sceneH * scale;
    final jambW = _HormannDoorLoadingLoopState._jambW * scale;
    final headerH = _HormannDoorLoadingLoopState._headerH * scale;
    final jambInset = _HormannDoorLoadingLoopState._jambInset * scale;

    final openingLeft = jambInset + jambW;
    final openingTop = headerH;
    final openingW = sceneW - openingLeft * 2;
    final openingH = sceneH - headerH;

    final jambX = _jambOffset(t);
    final headerY = _headerOffset(t);
    final frameOpacity = _frameOpacity(t);
    final doorY = _doorY(t, openingH);
    final doorOpacity = _doorOpacity(t);
    final doorAngle = _doorAngle(t);
    final glowOpacity = _glowOpacity(t);
    final groundOpacity = _groundOpacity(t);
    final shine = _shineProgress(t);

    return SizedBox(
      width: sceneW,
      height: sceneH,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Ground shadow
          Positioned(
            left: 20 * scale,
            right: 20 * scale,
            bottom: -14 * scale,
            child: Opacity(
              opacity: groundOpacity,
              child: Container(
                height: 14 * scale,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF1C4587).withValues(alpha: 0.16),
                      const Color(0xFF1C4587).withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Warm orange glow around opening
          if (glowOpacity > 0)
            Positioned(
              left: openingLeft - 40 * scale,
              top: openingTop - 40 * scale,
              child: Opacity(
                opacity: glowOpacity,
                child: ImageFiltered(
                  imageFilter: ui.ImageFilter.blur(
                    sigmaX: 10 * scale,
                    sigmaY: 10 * scale,
                  ),
                  child: Container(
                    width: openingW + 80 * scale,
                    height: openingH + 80 * scale,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFFF2A93E).withValues(alpha: 0.32),
                          const Color(0xFFF2A93E).withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // Left jamb
          Positioned(
            left: jambInset + jambX,
            top: 0,
            child: Opacity(
              opacity: frameOpacity,
              child: _Jamb(width: jambW, height: sceneH),
            ),
          ),

          // Right jamb
          Positioned(
            right: jambInset - jambX,
            top: 0,
            child: Opacity(
              opacity: frameOpacity,
              child: _Jamb(width: jambW, height: sceneH, mirror: true),
            ),
          ),

          // Header
          Positioned(
            left: jambInset,
            right: jambInset,
            top: headerY,
            child: Opacity(
              opacity: frameOpacity,
              child: _Header(height: headerH),
            ),
          ),

          // Opening + door
          Positioned(
            left: openingLeft,
            top: openingTop,
            width: openingW,
            height: openingH,
            child: ColoredBox(
              color: const Color(0xFFF5F3EE),
              child: ClipRect(
                child: Opacity(
                  opacity: doorOpacity,
                  child: Transform(
                    alignment: Alignment.centerLeft,
                    transform:
                        Matrix4.identity()
                          ..translate(0.0, doorY)
                          ..setEntry(3, 2, 0.0015)
                          ..rotateY(doorAngle),
                    child: _DoorPanel(
                      width: openingW,
                      height: openingH,
                      scale: scale,
                      shineProgress: shine,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Left jamb: hidden 0–6%, slides in by 22%, holds to 88%, out by 96%.
  double _jambOffset(double t) {
    if (t <= 0.06) return -120 * scale;
    if (t <= 0.22) {
      return _Anim.map(t, 0.06, 0.22, -120 * scale, 0, curve: Curves.easeOut);
    }
    if (t <= 0.88) return 0;
    if (t <= 0.96) {
      return _Anim.map(t, 0.88, 0.96, 0, -120 * scale, curve: Curves.easeIn);
    }
    return -120 * scale;
  }

  double _headerOffset(double t) {
    if (t <= 0.10) return -85 * scale;
    if (t <= 0.26) {
      return _Anim.map(t, 0.10, 0.26, -85 * scale, 0, curve: Curves.easeOut);
    }
    if (t <= 0.88) return 0;
    if (t <= 0.96) {
      return _Anim.map(t, 0.88, 0.96, 0, -85 * scale, curve: Curves.easeIn);
    }
    return -85 * scale;
  }

  double _frameOpacity(double t) {
    if (t <= 0.06) return 0;
    if (t <= 0.22) {
      return _Anim.map(t, 0.06, 0.22, 0, 1, curve: Curves.easeOut);
    }
    if (t <= 0.88) return 1;
    if (t <= 0.96) {
      return _Anim.map(t, 0.88, 0.96, 1, 0, curve: Curves.easeIn);
    }
    return 0;
  }

  double _doorY(double t, double openingH) {
    final rise = math.min(210 * scale, openingH * 1.05);
    if (t < 0.24) return rise;
    if (t <= 0.40) {
      return _Anim.map(t, 0.24, 0.40, rise, 0, curve: Curves.easeOut);
    }
    if (t < 0.84) return 0;
    if (t <= 0.94) {
      return _Anim.map(t, 0.84, 0.94, 0, rise, curve: Curves.easeIn);
    }
    return rise;
  }

  double _doorOpacity(double t) {
    if (t < 0.24) return 0;
    if (t <= 0.40) {
      return _Anim.map(t, 0.24, 0.40, 0, 1, curve: Curves.easeOut);
    }
    if (t < 0.84) return 1;
    if (t <= 0.94) {
      return _Anim.map(t, 0.84, 0.94, 1, 0, curve: Curves.easeIn);
    }
    return 0;
  }

  double _doorAngle(double t) {
    final open = -56 * math.pi / 180;
    if (t < 0.46) return 0;
    if (t <= 0.58) {
      return _Anim.map(t, 0.46, 0.58, 0, open, curve: Curves.easeInOut);
    }
    if (t <= 0.68) {
      return _Anim.map(t, 0.58, 0.68, open, 0, curve: Curves.easeInOut);
    }
    return 0;
  }

  double _glowOpacity(double t) {
    if (t < 0.40) return 0;
    if (t <= 0.56) {
      return _Anim.map(t, 0.40, 0.56, 0, 1, curve: Curves.easeOut);
    }
    if (t <= 0.68) {
      return _Anim.map(t, 0.56, 0.68, 1, 0, curve: Curves.easeIn);
    }
    return 0;
  }

  double _groundOpacity(double t) {
    if (t < 0.08) return 0;
    if (t <= 0.16) {
      return _Anim.map(t, 0.08, 0.16, 0, 1, curve: Curves.easeOut);
    }
    if (t <= 0.82) return 1;
    if (t <= 0.96) {
      return _Anim.map(t, 0.82, 0.96, 1, 0, curve: Curves.easeIn);
    }
    return 0;
  }

  /// Returns 0–1 shine sweep progress; <0 means hidden.
  double _shineProgress(double t) {
    if (t < 0.46 || t > 0.52) return -1;
    return _Anim.map(t, 0.46, 0.52, 0, 1, curve: Curves.easeInOut);
  }
}

class _Jamb extends StatelessWidget {
  const _Jamb({
    required this.width,
    required this.height,
    this.mirror = false,
  });

  final double width;
  final double height;
  final bool mirror;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: mirror ? Alignment.centerRight : Alignment.centerLeft,
          end: mirror ? Alignment.centerLeft : Alignment.centerRight,
          colors: const [Color(0xFF2C3550), Color(0xFF1B2138)],
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 0.5,
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF333C58), Color(0xFF1B2138)],
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 0.5,
        ),
      ),
    );
  }
}

class _DoorPanel extends StatelessWidget {
  const _DoorPanel({
    required this.width,
    required this.height,
    required this.scale,
    required this.shineProgress,
  });

  final double width;
  final double height;
  final double scale;
  final double shineProgress;

  @override
  Widget build(BuildContext context) {
    final inset = 11 * scale;
    final topPanelH = 73 * scale;
    final bottomTop = 98 * scale;
    final bottomPanelH = 111 * scale;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment(-0.55, -1),
          end: Alignment(0.85, 1),
          colors: [Color(0xFFC99A5F), Color(0xFF9C6D3A), Color(0xFF7D5527)],
          stops: [0.0, 0.45, 1.0],
        ),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.2),
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            offset: Offset(4 * scale, 0),
            blurRadius: 14 * scale,
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          // Top raised panel
          Positioned(
            left: inset,
            right: inset,
            top: 13 * scale,
            height: topPanelH,
            child: const _RaisedPanel(),
          ),
          // Bottom raised panel
          Positioned(
            left: inset,
            right: inset,
            top: bottomTop,
            height: math.min(bottomPanelH, height - bottomTop - 8 * scale),
            child: const _RaisedPanel(),
          ),

          // Brand nameplate ON the door (moves/rotates with door)
          Positioned(
            top: 10 * scale,
            left: 0,
            right: 0,
            child: Center(child: _BrandPlate(scale: scale)),
          ),

          // Brass handle
          Positioned(
            right: 7 * scale,
            top: height / 2 - 3.5 * scale,
            child: Container(
              width: 7 * scale,
              height: 7 * scale,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const RadialGradient(
                  center: Alignment(-0.3, -0.3),
                  colors: [Color(0xFFF4D492), Color(0xFFB8862F)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFF4D492).withValues(alpha: 0.7),
                    blurRadius: 4 * scale,
                  ),
                ],
              ),
            ),
          ),

          // Diagonal shine sweep
          if (shineProgress >= 0)
            _DoorShine(
              width: width,
              height: height,
              progress: shineProgress,
            ),
        ],
      ),
    );
  }
}

class _RaisedPanel extends StatelessWidget {
  const _RaisedPanel();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        gradient: const LinearGradient(
          begin: Alignment(-0.55, -1),
          end: Alignment(0.85, 1),
          colors: [Color(0x91B88950), Color(0xFF8A5C2E)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x47FFFFFF),
            offset: Offset(1, 1),
            blurRadius: 2,
          ),
          BoxShadow(
            color: Color(0x47000000),
            offset: Offset(-2, -2),
            blurRadius: 4,
          ),
        ],
      ),
    );
  }
}

/// Small Hörmann navy nameplate mounted on the door surface.
class _BrandPlate extends StatelessWidget {
  const _BrandPlate({required this.scale});

  final double scale;

  @override
  Widget build(BuildContext context) {
    final fontSize = 8 * scale;
    final hPad = 8 * scale;
    final vPad = 3 * scale;

    return Container(
      padding: EdgeInsets.fromLTRB(20 * scale, vPad, hPad, vPad),
      decoration: BoxDecoration(
        color: const Color(0xFF1C4587),
        borderRadius: BorderRadius.circular(2 * scale),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            offset: Offset(0, 1 * scale),
            blurRadius: 3 * scale,
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Text(
            'HÖRMANN',
            style: GoogleFonts.montserrat(
              fontSize: fontSize,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.4 * scale,
              color: const Color(0xFFF2A93E),
              height: 1,
            ),
          ),
          // Tiny umlaut-style dot above the Ö
          Positioned(
            top: -3.5 * scale,
            left: 9.5 * scale,
            child: Container(
              width: 1.6 * scale,
              height: 1.6 * scale,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFF2A93E),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DoorShine extends StatelessWidget {
  const _DoorShine({
    required this.width,
    required this.height,
    required this.progress,
  });

  final double width;
  final double height;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final barW = width * 0.4;
    final x = -width * 0.6 + (width * 1.9) * progress;
    final opacity = progress < 0.15
        ? progress / 0.15 * 0.9
        : progress > 0.85
            ? (1 - progress) / 0.15 * 0.9
            : 0.9;

    return Positioned.fill(
      child: ClipRect(
        child: Opacity(
          opacity: opacity.clamp(0.0, 0.9),
          child: Transform(
            transform:
                Matrix4.identity()
                  ..translate(x, -height * 0.2)
                  ..rotateZ(-0.32),
            child: Container(
              width: barW,
              height: height * 1.4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0),
                    Colors.white.withValues(alpha: 0.55),
                    Colors.white.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({
    required this.t,
    required this.width,
    this.fixedStatusLabel,
  });

  final double t;
  final double width;
  final String? fixedStatusLabel;

  String get _statusLabel {
    if (fixedStatusLabel != null && fixedStatusLabel!.isNotEmpty) {
      return fixedStatusLabel!;
    }
    final pct = t * 100;
    if (pct < 24) return 'Fitting the frame';
    if (pct < 42) return 'Hanging the door';
    if (pct < 55) return 'Checking the finish';
    if (pct < 66) return 'Opening the door';
    if (pct < 88) return 'Closing up';
    return 'Almost ready';
  }

  @override
  Widget build(BuildContext context) {
    final percent = (t * 100).round();

    return SizedBox(
      width: width,
      child: Column(
        children: [
          Container(
            height: 3,
            decoration: BoxDecoration(
              color: const Color(0xFF1C4587).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(99),
            ),
            clipBehavior: Clip.hardEdge,
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: t.clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(99),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFC9862B), Color(0xFFF2A93E)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFF2A93E).withValues(alpha: 0.5),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  _statusLabel,
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    color: const Color(0xFF8A8D9A),
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              Text(
                '$percent%',
                style: GoogleFonts.inter(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1C4587),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Anim {
  static double map(
    double t,
    double start,
    double end,
    double from,
    double to, {
    Curve curve = Curves.linear,
  }) {
    if (t <= start) return from;
    if (t >= end) return to;
    final p = curve.transform(((t - start) / (end - start)).clamp(0.0, 1.0));
    return from + (to - from) * p;
  }
}
