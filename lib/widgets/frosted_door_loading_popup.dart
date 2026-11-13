import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shakti_hormann/app/presentation/widgets/greeting_widget.dart';
import 'package:shakti_hormann/widgets/door_loading_loop.dart';
import 'package:shakti_hormann/widgets/hormann_loading_controller.dart';

/// Warm frosted popup used by form save/submit overlays.
/// Matches the approved preview: dim scrim + centered glass card + splash door.
class FrostedDoorLoadingPopup extends StatelessWidget {
  const FrostedDoorLoadingPopup({
    super.key,
    required this.progress,
    this.message,
  });

  final HormannLoadingController progress;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final shortest = size.shortestSide;
    final isTablet = shortest >= 600;
    final isCompact = size.height < 700 || size.width < 360;

    final maxCardW = isTablet
        ? 380.0
        : (size.width * 0.86).clamp(260.0, 320.0);
    final horizontalPad = isTablet ? 40.0 : (isCompact ? 20.0 : 28.0);
    final logoH = isTablet ? 32.0 : (isCompact ? 24.0 : 28.0);
    final doorW = isTablet ? 200.0 : (isCompact ? 160.0 : 188.0);
    final doorAreaH = isTablet
        ? 290.0
        : (isCompact ? 220.0 : 255.0);
    final cardPad = isCompact
        ? const EdgeInsets.fromLTRB(16, 16, 16, 12)
        : isTablet
            ? const EdgeInsets.fromLTRB(24, 26, 24, 18)
            : const EdgeInsets.fromLTRB(20, 20, 20, 14);
    final maxCardH = size.height * 0.82;

    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(color: Colors.black.withValues(alpha: 0.28)),
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPad),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: maxCardW,
                maxHeight: maxCardH,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
                  child: Container(
                    width: double.infinity,
                    padding: cardPad,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      color: const Color(0xFFFFFFF8).withValues(alpha: 0.82),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.95),
                        width: 1.6,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.22),
                          blurRadius: 36,
                          offset: const Offset(0, 16),
                        ),
                      ],
                    ),
                    foregroundDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withValues(alpha: 0.55),
                          Colors.white.withValues(alpha: 0.0),
                        ],
                        stops: const [0.0, 0.45],
                      ),
                    ),
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            HormannLogoMark.assetPath,
                            height: logoH,
                            width: logoH * (276 / 61.1),
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: isCompact ? 6 : 10),
                          // Natural height (no expand) avoids nested overflow in the card.
                          ConstrainedBox(
                            constraints: BoxConstraints(maxHeight: doorAreaH),
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: DoorLoadingLoop(
                                width: doorW,
                                progressController: progress,
                              ),
                            ),
                          ),
                          if (message != null &&
                              message!.trim().isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              message!,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: const Color(0xFF1C4587)
                                    .withValues(alpha: 0.78),
                                fontSize: isTablet
                                    ? 13.5
                                    : (isCompact ? 12.0 : 12.5),
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Urbanist',
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
