/// Content checks for Hardware MES packing stickers (fixed layout).
class MesGuideValidation {
  MesGuideValidation._();

  static final _orPattern = RegExp(
    r'(?:OR\.?\s*)(\d{6,10})',
    caseSensitive: false,
  );
  static final _orOnly = RegExp(r'^\d{6,10}$');
  static final _mesDigits = RegExp(r'^\d{11,16}$');
  static final _mesLoose = RegExp(r'^[A-Za-z0-9\-_/]{8,}$');

  /// Matches "Page: 1/2", "Page 1 / 2", "PAGE 1/2"
  static final _pageLabeled = RegExp(
    r'page\s*:?\s*(\d+\s*/\s*\d+)',
    caseSensitive: false,
  );

  /// Matches "Box: 3/13", "Box 1 / 4"
  static final _boxLabeled = RegExp(
    r'box\s*:?\s*(\d+\s*/\s*\d+)',
    caseSensitive: false,
  );

  static final _fraction = RegExp(r'\d+\s*/\s*\d+');

  static String? extractOr(String text) {
    final m = _orPattern.firstMatch(text);
    if (m != null) return m.group(1);
    final only = text.replaceAll(RegExp(r'\s+'), '').trim();
    if (_orOnly.hasMatch(only)) return only;
    return null;
  }

  static String? extractPage(String text) {
    final m = _pageLabeled.firstMatch(text);
    return m?.group(1)?.replaceAll(RegExp(r'\s+'), '');
  }

  static String? extractBox(String text) {
    final m = _boxLabeled.firstMatch(text);
    return m?.group(1)?.replaceAll(RegExp(r'\s+'), '');
  }

  static String? extractFraction(String text) {
    final m = _fraction.firstMatch(text);
    return m?.group(0)?.replaceAll(RegExp(r'\s+'), '');
  }

  static bool matchesOrNo(String text) => extractOr(text) != null;

  static bool matchesMes(String text, {bool isBarcode = false}) {
    final t = text.replaceAll(RegExp(r'\s+'), '').trim();
    if (t.isEmpty) return false;
    if (isBarcode && t.length >= 6) return true;
    if (_mesDigits.hasMatch(t)) return true;
    // QR payloads often embed MES digits.
    final embedded = RegExp(r'(\d{11,16})').firstMatch(t);
    if (embedded != null) return true;
    return _mesLoose.hasMatch(t) && t.length >= 8;
  }

  static String? extractMes(String text, {bool isBarcode = false}) {
    final t = text.replaceAll(RegExp(r'\s+'), '').trim();
    if (t.isEmpty) return null;
    if (_mesDigits.hasMatch(t)) return t;
    final embedded = RegExp(r'(\d{11,16})').firstMatch(t);
    if (embedded != null) return embedded.group(1);
    if (isBarcode && t.length >= 6) return t;
    if (_mesLoose.hasMatch(t) && t.length >= 8) return t;
    return null;
  }

  static bool matchesPage(String text) => extractPage(text) != null;

  static bool matchesBox(String text) => extractBox(text) != null;

  static bool matchesFraction(String text) => _fraction.hasMatch(text);

  static bool inOrZone(double x, double y) =>
      x >= 0.02 && x <= 0.65 && y >= 0.08 && y <= 0.38;

  static bool inMesZone(double x, double y) =>
      x >= 0.55 && x <= 1.0 && y >= 0.00 && y <= 0.32;

  static bool inPageZone(double x, double y) =>
      x >= 0.40 && x <= 0.80 && y >= 0.82 && y <= 1.0;

  static bool inBoxZone(double x, double y) =>
      x >= 0.68 && x <= 1.0 && y >= 0.82 && y <= 1.0;
}
