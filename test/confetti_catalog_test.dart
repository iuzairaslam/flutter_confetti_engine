import 'package:flutter_confetti_engine/flutter_confetti_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Confetti catalog', () {
    test('AnimationConfetti maps to presets', () {
      expect(
        ConfettiAnimationMaps.presetFor(AnimationConfetti.omniBlast),
        Preset.nova,
      );
      expect(
        ConfettiAnimationMaps.presetFor(AnimationConfetti.drift),
        Preset.cascade,
      );
      expect(
        ConfettiAnimationMaps.presetFor(AnimationConfetti.pushLeft),
        Preset.crossfire,
      );
    });

    test('falling adds speed multiplier', () {
      final extra = ConfettiAnimationMaps.extraCustomizationFor(
        AnimationConfetti.drift,
      );
      expect(extra?.speedMultiplier, 1.28);
    });

    test('ConfettiStyle maps to single dominant shapes', () {
      expect(
        ConfettiStyleShapes.shapesFor(ConfettiStyle.circles),
        const [ParticleShape.circle],
      );
      expect(
        ConfettiStyleShapes.shapesFor(ConfettiStyle.squares),
        const [ParticleShape.square],
      );
    });

    test('ConfettiDensity scales preset defaults', () {
      expect(
        ConfettiDensityScale.scaledCount(150, ConfettiDensity.low),
        (150 * 0.65).round(),
      );
      expect(
        ConfettiDensityScale.scaledCount(120, ConfettiDensity.high),
        (120 * 1.35).round(),
      );
    });

    test('CelebrationScene.compose applies animation over confetti type', () {
      final scene = CelebrationScene.compose(
        confettiType: ConfettiType.triumph,
        animation: AnimationConfetti.heavyRain,
      );
      expect(scene.preset, Preset.cascade);
      expect(scene.customization?.colors, isNotNull);
    });

    test('CelebrationScene.compose colorTheme overrides type palette', () {
      final scene = CelebrationScene.compose(
        confettiType: ConfettiType.triumph,
        colorTheme: ConfettiColorTheme.pink,
      );
      expect(
        scene.customization?.colors,
        ConfettiColorThemes.palette(ConfettiColorTheme.pink),
      );
    });

    test('teal and pink palettes are non-empty', () {
      expect(ConfettiColorThemes.palette(ConfettiColorTheme.teal), isNotEmpty);
      expect(ConfettiColorThemes.palette(ConfettiColorTheme.pink), isNotEmpty);
    });
  });
}
