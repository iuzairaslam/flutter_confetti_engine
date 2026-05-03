import 'confetti_customization.dart';

/// Particle amount relative to each [Preset]’s default count.
///
/// Use with [CelebrationScene.compose] or [ConfettiDensityScale.scaledCount]
/// to scale the particle count up or down without picking a raw number.
enum ConfettiDensity {
  /// ~65 % of the preset default — light sprinkle, subtle celebration.
  low,

  /// 100 % of the preset default — the standard experience.
  medium,

  /// ~135 % of the preset default — full, rich burst for big moments.
  high,
}

/// Scales default particle counts for [ConfettiDensity].
abstract final class ConfettiDensityScale {
  ConfettiDensityScale._();

  /// Multiplier applied to each preset’s built-in default particle total before rounding.
  static double multiplier(ConfettiDensity density) {
    switch (density) {
      case ConfettiDensity.low:
        return 0.65;
      case ConfettiDensity.medium:
        return 1.0;
      case ConfettiDensity.high:
        return 1.35;
    }
  }

  /// Clamped particle total for [presetDefault] and [density].
  static int scaledCount(int presetDefault, ConfettiDensity density) {
    final n = (presetDefault * multiplier(density)).round();
    return n.clamp(
      ConfettiCustomization.minParticleCount,
      ConfettiCustomization.maxParticleCount,
    );
  }
}
