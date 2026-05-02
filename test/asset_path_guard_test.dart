import 'package:flutter_confetti_engine/src/asset_path_guard.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('isSafeFlutterAssetKey', () {
    test('accepts normal bundle paths', () {
      expect(
        isSafeFlutterAssetKey('assets/sounds/cheer.mp3'),
        isTrue,
      );
      expect(
        isSafeFlutterAssetKey(
          'packages/flutter_confetti_engine/assets/sounds/burst.mp3',
        ),
        isTrue,
      );
    });

    test('rejects parent-directory segments', () {
      expect(isSafeFlutterAssetKey('assets/../secrets.mp3'), isFalse);
      expect(isSafeFlutterAssetKey('../foo.mp3'), isFalse);
    });

    test('rejects empty and oversized strings', () {
      expect(isSafeFlutterAssetKey(''), isFalse);
      expect(isSafeFlutterAssetKey('a' * 3000), isFalse);
    });

    test('rejects null bytes', () {
      expect(isSafeFlutterAssetKey('assets/a\x00b.mp3'), isFalse);
    });

    test('normalizes backslashes before checking segments', () {
      expect(isSafeFlutterAssetKey(r'assets\..\other.mp3'), isFalse);
    });
  });
}
