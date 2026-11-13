import 'package:flutter/material.dart';

/// Clearance for content that sits under [ScaffoldWithNavigationBar]
/// (`extendBody: true` + floating pill nav ~62px + safe area).
///
/// Without this, long forms/tables can fill the full body height (including
/// the area under the nav) so [SingleChildScrollView] has no overflow and
/// the last rows stay unreachable under the bar.
abstract final class ShellInsets {
  static const double navBarHeight = 62;
  static const double navOuterPadding = 10;
  /// Extra space so the last table rows clear the floating nav comfortably.
  static const double extraBreathingRoom = 48;

  /// Bottom padding so the last form/table row can scroll above the nav.
  static double bottomScrollClearance(BuildContext context) {
    final safeBottom = MediaQuery.viewPaddingOf(context).bottom;
    return navBarHeight + navOuterPadding + extraBreathingRoom + safeBottom;
  }

  /// Bottom inset for fixed overlays (camera hint text, scan CTAs) that sit
  /// above the floating pill when pushed inside the shell navigator.
  ///
  /// Matches [AppScaffoldWidget] SafeArea(min bottom: 10) + 62 pill + [gap].
  static double overlayAboveNav(BuildContext context, {double gap = 20}) {
    const safeMin = navOuterPadding;
    final inset = MediaQuery.viewPaddingOf(context).bottom;
    final navSafeBottom = inset < safeMin ? safeMin : inset;
    return navSafeBottom + navBarHeight + gap;
  }

  static EdgeInsets scrollPadding(
    BuildContext context, {
    double top = 0,
    double left = 0,
    double right = 0,
    double extraBottom = 0,
  }) {
    return EdgeInsets.fromLTRB(
      left,
      top,
      right,
      bottomScrollClearance(context) + extraBottom,
    );
  }
}
