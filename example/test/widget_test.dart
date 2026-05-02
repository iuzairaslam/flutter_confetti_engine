import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_confetti_engine/flutter_confetti_engine.dart';

import 'package:flutter_confetti_engine_example/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('BuiltinSound asset paths', () {
    for (final sound in BuiltinSound.values) {
      test('${sound.name}.wav is loadable from the bundle', () async {
        final data = await rootBundle.load(sound.assetPath);
        expect(data.lengthInBytes, greaterThan(1024));
      });
    }
  });

  group('ConfettiBundledSounds', () {
    test('pop path matches BuiltinSound.pop', () {
      expect(ConfettiBundledSounds.pop, BuiltinSound.pop.assetPath);
    });

    test('chime path matches BuiltinSound.chime', () {
      expect(ConfettiBundledSounds.chime, BuiltinSound.chime.assetPath);
    });

    test('pathForPreset resolves for all presets', () {
      for (final preset in Preset.values) {
        final path = ConfettiBundledSounds.pathForPreset(preset);
        expect(path, isNotEmpty);
        expect(path, startsWith('packages/flutter_confetti_engine/'));
      }
    });
  });

  testWidgets('demo app builds and shows expected text',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ConfettiExampleApp());
    expect(find.textContaining('flutter_confetti_engine'), findsWidgets);
  });
}
