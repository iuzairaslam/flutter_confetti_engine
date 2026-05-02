import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_confetti_engine/flutter_confetti_engine.dart';

void main() {
  group('ConfettiBundledSounds', () {
    test('pathForPreset returns pop for nova and crossfire', () {
      expect(
        ConfettiBundledSounds.pathForPreset(Preset.nova),
        BuiltinSound.pop.assetPath,
      );
      expect(
        ConfettiBundledSounds.pathForPreset(Preset.crossfire),
        BuiltinSound.pop.assetPath,
      );
    });

    test('pathForPreset returns fanfare for cascade', () {
      expect(
        ConfettiBundledSounds.pathForPreset(Preset.cascade),
        BuiltinSound.fanfare.assetPath,
      );
    });

    test('pathForPreset returns chime for flare', () {
      expect(
        ConfettiBundledSounds.pathForPreset(Preset.flare),
        BuiltinSound.chime.assetPath,
      );
    });

    test('builtinForPreset returns correct BuiltinSound enum value', () {
      expect(ConfettiBundledSounds.builtinForPreset(Preset.nova),
          BuiltinSound.pop);
      expect(ConfettiBundledSounds.builtinForPreset(Preset.crossfire),
          BuiltinSound.pop);
      expect(ConfettiBundledSounds.builtinForPreset(Preset.cascade),
          BuiltinSound.fanfare);
      expect(ConfettiBundledSounds.builtinForPreset(Preset.flare),
          BuiltinSound.chime);
    });

    test('convenience getters match BuiltinSound asset paths', () {
      expect(ConfettiBundledSounds.pop, BuiltinSound.pop.assetPath);
      expect(ConfettiBundledSounds.chime, BuiltinSound.chime.assetPath);
      expect(ConfettiBundledSounds.fanfare, BuiltinSound.fanfare.assetPath);
      expect(ConfettiBundledSounds.applause, BuiltinSound.applause.assetPath);
      expect(ConfettiBundledSounds.whoosh, BuiltinSound.whoosh.assetPath);
      expect(ConfettiBundledSounds.drumroll, BuiltinSound.drumroll.assetPath);
      expect(ConfettiBundledSounds.levelUp, BuiltinSound.levelUp.assetPath);
      expect(ConfettiBundledSounds.bell, BuiltinSound.bell.assetPath);
      expect(ConfettiBundledSounds.sparkle, BuiltinSound.sparkle.assetPath);
      expect(ConfettiBundledSounds.airhorn, BuiltinSound.airhorn.assetPath);
    });

    test('every preset resolves to a packages/ WAV path', () {
      for (final preset in Preset.values) {
        final path = ConfettiBundledSounds.pathForPreset(preset);
        expect(path, startsWith('packages/flutter_confetti_engine/'));
        expect(path, endsWith('.wav'));
      }
    });

    test('BuiltinSound.assetPath has correct prefix and extension', () {
      for (final sound in BuiltinSound.values) {
        expect(
          sound.assetPath,
          startsWith('packages/flutter_confetti_engine/assets/sounds/'),
        );
        expect(sound.assetPath, endsWith('.wav'));
      }
    });
  });
}
