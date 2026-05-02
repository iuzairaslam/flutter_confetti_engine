import 'package:flutter_confetti_engine/flutter_confetti_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CelebrationFeedback', () {
    test('copyWith updates selected fields, preserves others', () {
      const base = CelebrationFeedback(
        enableHaptics: true,
        enableSound: false,
        soundAssetPath: 'a.mp3',
      );
      final next = base.copyWith(enableSound: true);
      expect(next.enableHaptics, true);
      expect(next.enableSound, true);
      expect(next.soundAssetPath, 'a.mp3');
    });

    test('named constructors set correct defaults', () {
      const none = CelebrationFeedback.none();
      expect(none.enableHaptics, false);
      expect(none.enableSound, false);
      expect(none.soundAssetPath, isNull);
      expect(none.builtinSound, isNull);

      const hOnly = CelebrationFeedback.hapticsOnly();
      expect(hOnly.enableHaptics, true);
      expect(hOnly.enableSound, false);
      expect(hOnly.soundAssetPath, isNull);
      expect(hOnly.builtinSound, isNull);
    });

    test('bundledForPreset sets builtinSound, not soundAssetPath', () {
      final bundled = CelebrationFeedback.bundledForPreset(Preset.nova);
      expect(bundled.enableSound, true);
      expect(bundled.builtinSound, BuiltinSound.pop);
      expect(bundled.soundAssetPath, isNull);
    });

    test('customAsset sets soundAssetPath', () {
      final custom = CelebrationFeedback.customAsset('assets/party.mp3');
      expect(custom.soundAssetPath, 'assets/party.mp3');
      expect(custom.builtinSound, isNull);
      expect(custom.enableSound, true);
    });

    test('resolvedSoundPath prefers soundAssetPath over builtinSound', () {
      const feedback = CelebrationFeedback(
        enableSound: true,
        soundAssetPath: 'assets/custom.mp3',
        builtinSound: BuiltinSound.chime,
      );
      expect(feedback.resolvedSoundPath, 'assets/custom.mp3');
    });

    test('resolvedSoundPath falls back to builtinSound when no custom path',
        () {
      const feedback = CelebrationFeedback(
        enableSound: true,
        builtinSound: BuiltinSound.pop,
      );
      expect(feedback.resolvedSoundPath, BuiltinSound.pop.assetPath);
    });

    test('resolvedSoundPath is null when neither is set', () {
      const feedback = CelebrationFeedback(enableSound: true);
      expect(feedback.resolvedSoundPath, isNull);
    });

    test('bundledForPreset uses correct BuiltinSound per preset', () {
      expect(
        CelebrationFeedback.bundledForPreset(Preset.nova).builtinSound,
        BuiltinSound.pop,
      );
      expect(
        CelebrationFeedback.bundledForPreset(Preset.crossfire).builtinSound,
        BuiltinSound.pop,
      );
      expect(
        CelebrationFeedback.bundledForPreset(Preset.cascade).builtinSound,
        BuiltinSound.fanfare,
      );
      expect(
        CelebrationFeedback.bundledForPreset(Preset.flare).builtinSound,
        BuiltinSound.chime,
      );
    });
  });
}
