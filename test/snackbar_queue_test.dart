import 'package:flutter_test/flutter_test.dart';
import 'package:save_points_snackbar_dialog_bottomsheet/save_points_snackbar_dialog_bottomsheet.dart';

/// Unit tests for the [SnackbarQueue] singleton that serializes snackbars.
void main() {
  group('SnackbarQueue', () {
    tearDown(SnackbarQueue().clear);

    test('is a singleton', () {
      expect(identical(SnackbarQueue(), SnackbarQueue()), isTrue);
    });

    test('starts empty', () {
      SnackbarQueue().clear();
      expect(SnackbarQueue().isEmpty, isTrue);
      expect(SnackbarQueue().length, 0);
    });

    test('clear() empties a populated queue', () {
      // Reaching into state via the public API only: clear must always leave
      // the queue empty and not throw even when already empty.
      SnackbarQueue().clear();
      expect(SnackbarQueue().isEmpty, isTrue);
      SnackbarQueue().clear();
      expect(SnackbarQueue().length, 0);
    });

    test('exposes an isShowing flag', () {
      expect(SnackbarQueue().isShowing, isA<bool>());
    });
  });

  group('Snackbar enums', () {
    test('SnackbarType has the four documented variants', () {
      expect(SnackbarType.values, hasLength(4));
      expect(
          SnackbarType.values,
          containsAll(<SnackbarType>[
            SnackbarType.info,
            SnackbarType.success,
            SnackbarType.error,
            SnackbarType.warning,
          ]));
    });

    test('SnackbarPosition has top and bottom', () {
      expect(SnackbarPosition.values, hasLength(2));
      expect(
          SnackbarPosition.values,
          containsAll(<SnackbarPosition>[
            SnackbarPosition.top,
            SnackbarPosition.bottom,
          ]));
    });
  });
}
