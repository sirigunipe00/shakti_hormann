/// Result of validating / applying one scanned code.
class ScanOutcome {
  const ScanOutcome._({
    required this.success,
    required this.message,
    this.shouldStop = false,
  });

  const ScanOutcome.ok(String message, {bool shouldStop = false})
    : this._(success: true, message: message, shouldStop: shouldStop);

  const ScanOutcome.fail(String message, {bool shouldStop = false})
    : this._(success: false, message: message, shouldStop: shouldStop);

  final bool success;
  final String message;

  /// When true, burst scanner should stop accepting codes (e.g. photo required).
  final bool shouldStop;
}
