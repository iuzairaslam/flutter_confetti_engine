import 'confetti_customization.dart';

/// Particle amount relative to each [Preset]’s default count.
enum ConfettiDensity {
  low,
  medium,
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
