import 'confetti_customization.dart';
import 'presets.dart';

/// Animation motion profiles for mapped presets.
///
/// Map to [Preset] via [ConfettiAnimationMaps.presetFor]. Use
/// [ConfettiAnimationMaps.extraCustomizationFor] for subtle tweaks (e.g. [drift] drift).
enum AnimationConfetti {
  /// Directional stream ([Preset.crossfire]-style).
  streamSide,

  /// Omnidirectional burst ([Preset.nova]).
  omniBlast,

  /// Heavy top-down shower ([Preset.cascade]).
  heavyRain,

  /// Downward drift ([Preset.cascade]).
  cascade,

  /// Like [cascade] with stronger sideways drift ([Preset.cascade] + speed tweak).
  drift,

  /// Directional sideways stream ([Preset.crossfire]).
  pushLeft,
}

/// Maps [AnimationConfetti] to [Preset] and optional [ConfettiCustomization].
abstract final class ConfettiAnimationMaps {
  ConfettiAnimationMaps._();

  /// Built-in [Preset] for [animation].
  static Preset presetFor(AnimationConfetti animation) {
    switch (animation) {
      case AnimationConfetti.streamSide:
      case AnimationConfetti.pushLeft:
        return Preset.crossfire;
      case AnimationConfetti.omniBlast:
        return Preset.nova;
      case AnimationConfetti.heavyRain:
      case AnimationConfetti.cascade:
      case AnimationConfetti.drift:
        return Preset.cascade;
    }
  }

  /// Extra customization layered on top of the preset (e.g. [drift] drift).
  static ConfettiCustomization? extraCustomizationFor(AnimationConfetti animation) {
    switch (animation) {
      case AnimationConfetti.drift:
        return const ConfettiCustomization(speedMultiplier: 1.28);
      case AnimationConfetti.streamSide:
      case AnimationConfetti.omniBlast:
      case AnimationConfetti.heavyRain:
      case AnimationConfetti.cascade:
      case AnimationConfetti.pushLeft:
        return null;
    }
  }
}
