import 'package:flutter/material.dart';

/// Breakpoints and layout helpers for phone / tablet scaling.
abstract final class Responsive {
  static const double tabletBreakpoint = 600;
  static const double largeTabletBreakpoint = 900;

  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= tabletBreakpoint;

  static bool isLargeTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= largeTabletBreakpoint;

  /// Home / dashboard tile columns.
  static int gridCrossAxisCount(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= largeTabletBreakpoint) return 4;
    if (width >= tabletBreakpoint) return 3;
    return 2;
  }

  /// Horizontal page padding that grows slightly on larger screens.
  static EdgeInsets pagePadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontal = width >= largeTabletBreakpoint
        ? 32.0
        : width >= tabletBreakpoint
            ? 24.0
            : 16.0;
    return EdgeInsets.symmetric(horizontal: horizontal);
  }

  static double gridCrossAxisSpacing(BuildContext context) =>
      isTablet(context) ? 16.0 : 12.0;

  static double gridMainAxisSpacing(BuildContext context) =>
      isTablet(context) ? 16.0 : 14.0;

  /// Cap for the home tile grid so iPad-class widths don't stretch cards.
  static double homeGridMaxWidth(BuildContext context) {
    if (isLargeTablet(context)) return 980;
    if (isTablet(context)) return 780;
    return MediaQuery.sizeOf(context).width;
  }

  /// Extra left/right inset used to center the home grid on wide screens.
  static double homeGridSideInset(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final maxW = homeGridMaxWidth(context);
    if (width <= maxW) return 0;
    return (width - maxW) / 2;
  }

  /// Max content width for form / detail screens on tablets.
  static double contentMaxWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= largeTabletBreakpoint) return 840;
    if (width >= tabletBreakpoint) return 720;
    return width;
  }

  /// Target width/height for home tiles. Higher = shorter cards.
  static double gridChildAspectRatio(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= largeTabletBreakpoint) return 1.45;
    if (width >= tabletBreakpoint) return 1.50;
    // Compact phones keep a slightly taller tile for 2-line labels.
    if (width < 360) return 1.45;
    return 1.58;
  }

  /// Tile height derived from the real column width so phones + tablets
  /// keep the same visual density (no fixed px that only fits one device).
  static double gridTileHeight(BuildContext context) {
    final cols = gridCrossAxisCount(context);
    final pagePad = pagePadding(context).horizontal;
    final sideInset = homeGridSideInset(context) * 2;
    final spacing = gridCrossAxisSpacing(context) * (cols - 1);
    final usable = MediaQuery.sizeOf(context).width - pagePad - sideInset - spacing;
    final tileWidth = usable / cols;
    final height = tileWidth / gridChildAspectRatio(context);
    // Keep labels readable under large accessibility text scales.
    final textScale = MediaQuery.textScalerOf(context).scale(1.0).clamp(1.0, 1.3);
    return (height * textScale).clamp(100.0, 168.0);
  }

  static double homeSectionTitleSize(BuildContext context) {
    if (isLargeTablet(context)) return 22;
    if (isTablet(context)) return 20;
    return 18;
  }

  static double homeSectionTitleGap(BuildContext context) {
    // Match Dashboard section breaks (~22+) with a bit more room on Home.
    return isTablet(context) ? 28.0 : 24.0;
  }

  static double homeSectionTitleBottomGap(BuildContext context) {
    // Space below the section title before the packaging cards.
    return isTablet(context) ? 14.0 : 12.0;
  }

  static double homeCardTitleSize(BuildContext context) {
    if (isLargeTablet(context)) return 14;
    if (isTablet(context)) return 13.5;
    final width = MediaQuery.sizeOf(context).width;
    return width < 360 ? 11.5 : 12;
  }

  static double homeIconScale(BuildContext context) {
    if (isLargeTablet(context)) return 1.0;
    if (isTablet(context)) return 0.9;
    final width = MediaQuery.sizeOf(context).width;
    return width < 360 ? 0.64 : 0.72;
  }

  /// Uniform square icon slot for every Home feature card (keeps GIFs aligned).
  static double homeCardIconExtent(BuildContext context) {
    if (isLargeTablet(context)) return 118;
    if (isTablet(context)) return 108;
    final width = MediaQuery.sizeOf(context).width;
    return width < 360 ? 86 : 96;
  }

  static double homeHeaderExpanded(BuildContext context) {
    if (isTablet(context)) return 132;
    return 124;
  }

  static double homeHeaderCollapsed(BuildContext context) {
    if (isTablet(context)) return 68;
    return 64;
  }

  static double homeBottomClearance(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return 88 + bottom;
  }

  /// Space occupied by the floating bottom nav (pill 62 + SafeArea inset).
  /// Used when [Scaffold.extendBody] is true so content/FABs aren't covered.
  static double navBarOverlayHeight(BuildContext context) {
    // Pill 62 + system/SafeArea bottom inset + breathing room above the pill.
    return 80 + MediaQuery.paddingOf(context).bottom;
  }

  /// Bottom inset so a filter sheet sits just above the floating nav pill.
  ///
  /// Matches [AppScaffoldWidget] bottom nav: SafeArea(min bottom: 10) + 62
  /// pill, plus a small air gap so Apply/Reset don't sit on the nav.
  static double filterSheetAboveNav(BuildContext context) {
    const pill = 62.0;
    const gap = 12.0;
    const safeMin = 10.0;
    final inset = MediaQuery.viewPaddingOf(context).bottom;
    final navSafeBottom = inset < safeMin ? safeMin : inset;
    return navSafeBottom + pill + gap;
  }

  /// Lift [FloatingActionButton] so it sits just above the floating nav bar.
  ///
  /// [FloatingActionButtonLocation.endFloat] already adds 16px; we add nav
  /// height + a clear air gap so "+ New" is close but not touching the pill.
  static double fabBottomOffset(BuildContext context) {
    const pill = 62.0;
    const gap = 32.0;
    const safeMin = 10.0;
    const scaffoldFabMargin = 16.0;
    final inset = MediaQuery.viewPaddingOf(context).bottom;
    final navSafeBottom = inset < safeMin ? safeMin : inset;
    final offset = navSafeBottom + pill + gap - scaffoldFabMargin;
    return offset < 0 ? 0 : offset;
  }

  /// Extra list padding so the last cards clear nav + FAB.
  static double listBottomClearance(BuildContext context) {
    return fabBottomOffset(context) + 72;
  }
}

/// Centers [child] and constrains it to [Responsive.contentMaxWidth].
class ResponsiveContent extends StatelessWidget {
  const ResponsiveContent({
    super.key,
    required this.child,
    this.alignment = Alignment.topCenter,
  });

  final Widget child;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: Responsive.contentMaxWidth(context),
        ),
        child: child,
      ),
    );
  }
}
