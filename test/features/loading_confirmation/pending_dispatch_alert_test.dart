import 'package:flutter_test/flutter_test.dart';
import 'package:shakti_hormann/features/loading_confirmation/model/dispatch_loading.dart';

void main() {
  group('formatPendingDispatchAlert', () {
    test('returns null when nothing pending', () {
      expect(
        formatPendingDispatchAlert(palletsPending: 0, boxesPending: 0),
        isNull,
      );
    });

    test('formats pallets only', () {
      expect(
        formatPendingDispatchAlert(palletsPending: 21, boxesPending: 0),
        '21 Pallets Pending',
      );
      expect(
        formatPendingDispatchAlert(palletsPending: 1, boxesPending: 0),
        '1 Pallet Pending',
      );
    });

    test('formats boxes only', () {
      expect(
        formatPendingDispatchAlert(palletsPending: 0, boxesPending: 2),
        '2 Boxes Pending',
      );
      expect(
        formatPendingDispatchAlert(palletsPending: 0, boxesPending: 1),
        '1 Box Pending',
      );
    });

    test('formats both', () {
      expect(
        formatPendingDispatchAlert(palletsPending: 1, boxesPending: 2),
        '1 Pallet and 2 Boxes Pending',
      );
    });
  });

  group('DispatchLoadedData pending fields', () {
    test('parses required/pending from summary JSON', () {
      final data = DispatchLoadedData.fromJson({
        'name': 'VRE-SHM-2646',
        'pallets_required': 23,
        'boxes_required': 5,
        'pallets_loaded': 2,
        'related_boxes_loaded': 5,
        'pallets_pending': 21,
        'boxes_pending': 0,
        'is_complete': false,
        'loaded_rows': [],
      });

      expect(data.palletsRequired, 23);
      expect(data.boxesRequired, 5);
      expect(data.palletsLoaded, 2);
      expect(data.relatedBoxesLoaded, 5);
      expect(data.palletsPending, 21);
      expect(data.boxesPending, 0);
      expect(data.hasPendingUnits, isTrue);
      expect(
        formatPendingDispatchAlert(
          palletsPending: data.palletsPending,
          boxesPending: data.boxesPending,
        ),
        '21 Pallets Pending',
      );
    });

    test('derives pending when only required/loaded present', () {
      final data = DispatchLoadedData.fromJson({
        'pallets_required': 5,
        'boxes_required': 10,
        'pallets_loaded': 4,
        'related_boxes_loaded': 8,
        'loaded_rows': [],
      });

      expect(data.palletsPending, 1);
      expect(data.boxesPending, 2);
    });
  });
}
