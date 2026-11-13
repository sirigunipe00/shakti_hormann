import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path/path.dart' as p;
import 'package:shakti_hormann/styles/app_icons.dart';

/// Home-card illustration with performance-safe looping GIF support.
///
/// Guided by ui-ux-pro-max:
/// - respects reduced motion ([MediaQuery.disableAnimations])
/// - decodes only at device-sized cacheWidth/Height
/// - isolates paints with [RepaintBoundary]
/// - never color-filters animated frames (freezes GIFs)
class FeatureCardIcon extends StatelessWidget {
  const FeatureCardIcon({
    super.key,
    required this.icon,
    required this.width,
    required this.height,
  });

  final AppIcon icon;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final dpr = MediaQuery.devicePixelRatioOf(context).clamp(1.0, 2.5);
    // Cap decode size for mid/low Android — GIFs are ~200px source.
    final cacheW = (width * dpr).round().clamp(48, 240);
    final cacheH = (height * dpr).round().clamp(48, 240);

    final pathExt = p.extension(icon.path).toLowerCase();
    final isAnimated = pathExt == '.gif' || pathExt == '.webp';

    Widget child;
    if (pathExt == '.svg') {
      child = SvgPicture.asset(
        icon.path,
        width: width,
        height: height,
        fit: BoxFit.contain,
      );
    } else if (reduceMotion && icon.stillPath != null) {
      child = _StillAsset(
        path: icon.stillPath!,
        width: width,
        height: height,
        cacheW: cacheW,
        cacheH: cacheH,
      );
    } else {
      child = Image.asset(
        icon.path,
        width: width,
        height: height,
        fit: BoxFit.contain,
        alignment: Alignment.center,
        cacheWidth: cacheW,
        cacheHeight: cacheH,
        filterQuality: isAnimated ? FilterQuality.low : FilterQuality.medium,
        gaplessPlayback: true,
        errorBuilder: icon.stillPath == null
            ? null
            : (_, __, ___) => _StillAsset(
                  path: icon.stillPath!,
                  width: width,
                  height: height,
                  cacheW: cacheW,
                  cacheH: cacheH,
                ),
      );
    }

    // Slight vibrance lift for card art (works on GIF frames + stills).
    // FittedBox keeps every asset visually filling the same square slot.
    return RepaintBoundary(
      child: ColorFiltered(
        colorFilter: _vibranceFilter,
        child: SizedBox(
          width: width,
          height: height,
          child: FittedBox(
            fit: BoxFit.contain,
            alignment: Alignment.center,
            child: SizedBox(
              width: width,
              height: height,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

/// Mild saturation boost — keeps whites clean for warehouse illustrations.
const ColorFilter _vibranceFilter = ColorFilter.matrix(<double>[
  1.12, -0.04, -0.04, 0, 2,
  -0.04, 1.12, -0.04, 0, 2,
  -0.04, -0.04, 1.14, 0, 2,
  0, 0, 0, 1, 0,
]);

class _StillAsset extends StatelessWidget {
  const _StillAsset({
    required this.path,
    required this.width,
    required this.height,
    required this.cacheW,
    required this.cacheH,
  });

  final String path;
  final double width;
  final double height;
  final int cacheW;
  final int cacheH;

  @override
  Widget build(BuildContext context) {
    if (p.extension(path).toLowerCase() == '.svg') {
      return SvgPicture.asset(
        path,
        width: width,
        height: height,
        fit: BoxFit.contain,
      );
    }
    return Image.asset(
      path,
      width: width,
      height: height,
      fit: BoxFit.contain,
      cacheWidth: cacheW,
      cacheHeight: cacheH,
      filterQuality: FilterQuality.low,
      gaplessPlayback: true,
    );
  }
}
