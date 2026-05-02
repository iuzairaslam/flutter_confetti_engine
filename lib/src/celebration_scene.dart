import 'package:flutter/material.dart';

import 'confetti_animation.dart';
import 'confetti_color_theme.dart';
import 'confetti_customization.dart';
import 'confetti_density.dart';
import 'confetti_style.dart';
import 'confetti_type.dart';
import 'presets.dart';

/// Bundles a [Preset] with optional defaults — semantic types ([ConfettiType]),
/// color themes ([ConfettiColorTheme]), or your own [ConfettiCustomization].
///
/// Pass to [ConfettiEngine.celebrate] / [ConfettiWidget] as [scene]; explicit
/// `preset` and `customization` arguments are merged (your customization wins
/// on a per-field basis when provided).
@immutable
class CelebrationScene {
  /// Creates a scene with optional base customization.
  const CelebrationScene({
    required this.preset,
    this.customization,
  });

  /// Visual + motion defaults for [ConfettiType] (semantic celebration presets).
  factory CelebrationScene.fromConfettiType(ConfettiType type) {
    switch (type) {
      case ConfettiType.triumph:
        return CelebrationScene(
          preset: Preset.cascade,
          customization: ConfettiCustomization(
            colors: ConfettiColorThemes.palette(ConfettiColorTheme.green),
          ),
        );
      case ConfettiType.dropped:
        return const CelebrationScene(
          preset: Preset.cascade,
          customization: ConfettiCustomization(
            colors: _failurePalette,
          ),
        );
      case ConfettiType.party:
        return CelebrationScene(
          preset: Preset.nova,
          customization: ConfettiCustomization(
            colors: ConfettiColorThemes.palette(ConfettiColorTheme.rainbow),
          ),
        );
      case ConfettiType.milestone:
        return CelebrationScene(
          preset: Preset.nova,
          customization: ConfettiCustomization(
            colors: ConfettiColorThemes.palette(ConfettiColorTheme.gold),
          ),
        );
      case ConfettiType.rankUp:
        return CelebrationScene(
          preset: Preset.nova,
          customization: ConfettiCustomization(
            colors: ConfettiColorThemes.palette(ConfettiColorTheme.neon),
          ),
        );
    }
  }

  /// Composes optional catalog knobs ([ConfettiType], [AnimationConfetti],
  /// [ConfettiColorTheme], [ConfettiStyle], [ConfettiDensity]) into one scene.
  ///
  /// Layers merge in order: base type (or default [Preset.nova]) → animation tweak →
  /// shape style → density → color theme (explicit theme wins over type colors).
  factory CelebrationScene.compose({
    ConfettiType? confettiType,
    AnimationConfetti? animation,
    ConfettiColorTheme? colorTheme,
    ConfettiStyle? style,
    ConfettiDensity? density,
  }) {
    final CelebrationScene base = confettiType != null
        ? CelebrationScene.fromConfettiType(confettiType)
        : const CelebrationScene(preset: Preset.nova);

    var preset = base.preset;
    ConfettiCustomization? cust = base.customization;

    if (animation != null) {
      preset = ConfettiAnimationMaps.presetFor(animation);
      cust = ConfettiCustomization.merge(
        cust,
        ConfettiAnimationMaps.extraCustomizationFor(animation),
      );
    }

    if (style != null) {
      cust = ConfettiCustomization.merge(
        cust,
        ConfettiCustomization(shapeMix: ConfettiStyleShapes.shapesFor(style)),
      );
    }

    if (density != null) {
      final scaled = ConfettiDensityScale.scaledCount(
        preset.defaultParticleCount,
        density,
      );
      cust = ConfettiCustomization.merge(
        cust,
        ConfettiCustomization(particleCount: scaled),
      );
    }

    if (colorTheme != null) {
      cust = ConfettiCustomization.merge(
        cust,
        ConfettiCustomization(colors: ConfettiColorThemes.palette(colorTheme)),
      );
    }

    return CelebrationScene(preset: preset, customization: cust);
  }

  /// Applies a named [ConfettiColorTheme] with an arbitrary [preset].
  factory CelebrationScene.themed(
    ConfettiColorTheme theme, {
    Preset preset = Preset.nova,
  }) {
    return CelebrationScene(
      preset: preset,
      customization: ConfettiCustomization(
        colors: ConfettiColorThemes.palette(theme),
      ),
    );
  }

  /// Which built-in motion profile to run.
  final Preset preset;

  /// Base customization merged under caller-supplied [ConfettiCustomization].
  final ConfettiCustomization? customization;

  static const List<Color> _failurePalette = [
    Color(0xFF8D6E63),
    Color(0xFFB71C1C),
    Color(0xFF5D4037),
    Color(0xFF78909C),
    Color(0xFF455A64),
  ];
}
