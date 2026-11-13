import 'package:flutter_test/flutter_test.dart';
import 'package:shakti_hormann/features/auth/model/logged_in_user.dart';

void main() {
  group('roleStatusFromJson packaging flags', () {
    test('parses new Show … in Mobile App keys', () {
      final status = roleStatusFromJson({
        'Show Pallet Creation in Mobile App': 1,
        'Show Shutter Packaging in Mobile App': 1,
        'Show Frame Packaging in Mobile App': 0,
        'Show Storage Allocation in Mobile App': 1,
        'Show Installation Packaging in Mobile App': 0,
        'Show Accessories Packaging in Mobile App': 1,
        'Show Hardware Packaging in Mobile App': 0,
        'Show Where Is My Material in Mobile App': 1,
      });

      expect(status, isNotNull);
      expect(status!.showPallet, 1);
      expect(status.showShutter, 1);
      expect(status.showFrame, 0);
      expect(status.showStorage, 1);
      expect(status.showInstalltion, 0);
      expect(status.showVision, 1);
      expect(status.showHardware, 0);
      expect(status.showWhereIsMyMaterial, 1);
    });

    test('falls back from legacy *-SH keys', () {
      final status = roleStatusFromJson({
        'Pallet Creation-SH': 1,
        'Shutter Packing-SH': 0,
        'Frame Packing-SH': 1,
        'Storage-SH': 0,
        'Installation Packing-SH': 1,
        'Accessories Packing-SH': 0,
        'Hardware Packing-SH': 1,
      });

      expect(status!.showPallet, 1);
      expect(status.showShutter, 0);
      expect(status.showFrame, 1);
      expect(status.showStorage, 0);
      expect(status.showInstalltion, 1);
      expect(status.showVision, 0);
      expect(status.showHardware, 1);
      // legacy: WIMM inferred from any packing flag
      expect(status.showWhereIsMyMaterial, 1);
    });

    test('prefers new keys when both old and new present', () {
      final status = roleStatusFromJson({
        'Show Pallet Creation in Mobile App': 0,
        'Pallet Creation-SH': 1,
        'Show Where Is My Material in Mobile App': 0,
        'Shutter Packing-SH': 1,
      });

      expect(status!.showPallet, 0);
      expect(status.showWhereIsMyMaterial, 0);
      // shutter only on legacy key
      expect(status.showShutter, 1);
    });
  });
}
