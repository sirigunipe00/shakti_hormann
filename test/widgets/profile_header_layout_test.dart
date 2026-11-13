import 'package:flutter_test/flutter_test.dart';

/// Mirrors the responsive rules in [AppProfilePage] so the Hormann logo
/// stays above the overlapping profile card on common Android sizes.
({double logoHeight, double cardOverlap, double logoBottomGap}) _profileHeaderMetrics(
  double shortestSide,
) {
  final logoHeight = (shortestSide * 0.055).clamp(28.0, 40.0);
  final cardOverlap = (shortestSide * 0.09).clamp(48.0, 72.0);
  final logoBottomGap = cardOverlap + 12;
  return (
    logoHeight: logoHeight,
    cardOverlap: cardOverlap,
    logoBottomGap: logoBottomGap,
  );
}

void main() {
  test('logo bottom gap always clears card overlap on Android sizes', () {
    const sizes = <double>[
      320, // small phone
      360, // common
      392, // Pixel-ish
      411, // large phone
      480, // phablet
      600, // 7" tablet short side
      800, // large tablet
    ];

    for (final shortest in sizes) {
      final m = _profileHeaderMetrics(shortest);
      expect(
        m.logoBottomGap,
        greaterThan(m.cardOverlap),
        reason: 'shortest=$shortest: logo must sit above overlapping card',
      );
      expect(m.logoHeight, inInclusiveRange(28.0, 40.0));
      expect(m.cardOverlap, inInclusiveRange(48.0, 72.0));
    }
  });
}
