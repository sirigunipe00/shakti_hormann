import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';

/// Single-operation loading progress for the Hörmann door loader.
///
/// Progress is monotonic (never decreases), never reports 100% until
/// [complete] is called, and owns at most one idle trickle timer.
class HormannLoadingController extends ChangeNotifier {
  HormannLoadingController();

  double _progress = 0;
  String _label = 'Fitting the frame';
  var _completing = false;
  var _completed = false;
  Timer? _idleTimer;

  double get progress => _progress;
  String get label => _label;
  bool get isCompleting => _completing;
  bool get isCompleted => _completed;

  static String labelFor(double progress) {
    final pct = progress * 100;
    if (pct < 24) return 'Fitting the frame';
    if (pct < 42) return 'Hanging the door';
    if (pct < 55) return 'Checking the finish';
    if (pct < 66) return 'Opening the door';
    if (pct < 88) return 'Closing up';
    if (pct < 100) return 'Almost ready';
    return 'Ready';
  }

  /// Move forward to [target] (capped below 100% until [complete]).
  void setStage(double target, {String? label}) {
    if (_completing || _completed) return;
    final next = target.clamp(0.0, 0.92);
    var changed = false;
    if (next > _progress) {
      _progress = next;
      changed = true;
    }
    final nextLabel = label ?? labelFor(_progress);
    if (nextLabel != _label) {
      _label = nextLabel;
      changed = true;
    }
    if (changed) notifyListeners();
  }

  /// While waiting on network/page, creep forward slowly without finishing.
  void startIdleCreep({
    double ceiling = 0.90,
    Duration interval = const Duration(milliseconds: 400),
    double step = 0.012,
  }) {
    if (_completing || _completed) return;
    _idleTimer?.cancel();
    _idleTimer = Timer.periodic(interval, (_) {
      if (_completing || _completed) {
        _idleTimer?.cancel();
        return;
      }
      final next = math.min(ceiling, _progress + step);
      if (next <= _progress) return;
      _progress = next;
      _label = labelFor(_progress);
      notifyListeners();
    });
  }

  void stopIdleCreep() {
    _idleTimer?.cancel();
    _idleTimer = null;
  }

  /// Animate to 100% exactly once, then mark finished.
  Future<void> complete({
    String label = 'Ready',
    Duration holdAtFull = const Duration(milliseconds: 420),
  }) async {
    if (_completed) return;
    _completing = true;
    stopIdleCreep();
    _label = label;
    _progress = 1.0;
    notifyListeners();
    await Future<void>.delayed(holdAtFull);
    if (_completed) return;
    _completed = true;
    notifyListeners();
  }

  /// Reset for a new loading operation (e.g. refresh).
  void reset() {
    stopIdleCreep();
    _progress = 0;
    _label = 'Fitting the frame';
    _completing = false;
    _completed = false;
    notifyListeners();
  }

  @override
  void dispose() {
    stopIdleCreep();
    super.dispose();
  }
}
