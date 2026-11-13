import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shakti_hormann/core/core.dart';

/// Official Hörmann brand mark (hormann.in) for the home sticky header.
class HormannLogoMark extends StatelessWidget {
  const HormannLogoMark({
    super.key,
    this.height = 28,
  });

  static const assetPath = 'assets/images/hormann_brand_logo.svg';

  final double height;

  @override
  Widget build(BuildContext context) {
    final width = height * (276 / 61.1);
    // Plain brand mark — no plate, border, radius clip, or shadow.
    return SvgPicture.asset(
      assetPath,
      height: height,
      width: width,
      fit: BoxFit.cover,
    );
  }
}

class GreetingHeader extends StatelessWidget {
  const GreetingHeader({
    super.key,
    this.collapseProgress = 0,
    this.onNotificationTap,
  });

  /// 0 = fully expanded, 1 = fully collapsed (greeting hidden).
  final double collapseProgress;
  final VoidCallback? onNotificationTap;

  @override
  Widget build(BuildContext context) {
    final greeting = context.dayOfTimeGreeting();
    final userName = context.user.firstName ?? '';
    final t = collapseProgress.clamp(0.0, 1.0);
    final greetingOpacity = (1.0 - (t / 0.7)).clamp(0.0, 1.0);
    final frosted = t > 0.04;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: frosted ? 14 * t : 0,
          sigmaY: frosted ? 14 * t : 0,
        ),
        child: Container(
          padding: EdgeInsets.fromLTRB(16, 6, 12, lerpDouble(10, 6, t)!),
          decoration: BoxDecoration(
            color: Color.lerp(
              const Color(0xFFF7F8FA).withValues(alpha: 0.0),
              Colors.white.withValues(alpha: 0.92),
              t,
            ),
            border: Border(
              bottom: BorderSide(
                color: Color.lerp(
                  Colors.transparent,
                  const Color(0xFFE8ECF4),
                  t,
                )!,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 44,
                child: Row(
                  children: [
                    HormannLogoMark(height: lerpDouble(28, 24, t)!),
                    const SizedBox(width: 10),
                    Expanded(
                      child: t < 0.5
                          ? const SizedBox.shrink()
                          : Opacity(
                              opacity: ((t - 0.5) / 0.5).clamp(0.0, 1.0),
                              child: Text(
                                userName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0E1446),
                                  fontFamily: 'Urbanist',
                                ),
                              ),
                            ),
                    ),
                    _NotificationButton(onTap: onNotificationTap),
                  ],
                ),
              ),
              if (t < 0.92)
                Expanded(
                  child: Opacity(
                    opacity: greetingOpacity,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(top: lerpDouble(6, 0, t)!),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              greeting,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: lerpDouble(17, 13, t),
                                color: const Color(0xFF5B6178),
                                fontFamily: 'Urbanist',
                                fontWeight: FontWeight.w500,
                                height: 1.1,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              userName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: lerpDouble(22, 15, t),
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF0E1446),
                                fontFamily: 'Urbanist',
                                height: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationButton extends StatelessWidget {
  const _NotificationButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 42,
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE8ECF4)),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/notification.svg',
                height: 20,
                width: 20,
              ),
              Positioned(
                top: -1,
                right: -1,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2A93E),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Pinned home header that collapses the greeting on scroll.
class HomeHeaderDelegate extends SliverPersistentHeaderDelegate {
  HomeHeaderDelegate({
    required this.onNotificationTap,
    this.expandedHeight = 124,
    this.collapsedHeight = 64,
  });

  final VoidCallback onNotificationTap;
  final double expandedHeight;
  final double collapsedHeight;

  @override
  double get minExtent => collapsedHeight;

  @override
  double get maxExtent => expandedHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final range = maxExtent - minExtent;
    final t = range <= 0 ? 0.0 : (shrinkOffset / range).clamp(0.0, 1.0);
    return Material(
      color: Colors.transparent,
      child: SizedBox.expand(
        child: GreetingHeader(
          collapseProgress: t,
          onNotificationTap: onNotificationTap,
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant HomeHeaderDelegate oldDelegate) =>
      oldDelegate.onNotificationTap != onNotificationTap ||
      oldDelegate.expandedHeight != expandedHeight ||
      oldDelegate.collapsedHeight != collapsedHeight;
}

extension on BuildContext {
  String dayOfTimeGreeting() {
    final currHour = DFU.now().hour;
    return switch (currHour) {
      >= 0 && < 12 => 'Good Morning,',
      >= 12 && < 17 => 'Good Afternoon,',
      >= 17 && < 20 => 'Good Evening,',
      _ => 'Good Night,',
    };
  }
}
