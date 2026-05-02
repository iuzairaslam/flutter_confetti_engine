import 'package:flutter/material.dart';

/// Default palette for tick mode — cyan / violet / pink / yellow / orange / magenta.
const List<Color> kTickConfettiPackageColors = [
  Color(0xFF26ccff),
  Color(0xFFa25afd),
  Color(0xFFff5e7e),
  Color(0xFFfcff42),
  Color(0xFFffa62d),
  Color(0xFFff36ff),
];

/// Warm accent palette for tick-mode showcases.
const List<Color> kTickConfettiWarmPalette = [
  Color(0xFFFFEE40),
  Color(0xFFFFFB00),
  Color(0xFFFFE894),
  Color(0xFFFFCA6C),
  Color(0xFFFFDFFB),
];

/// Spawn parameters for tick mode —
/// angle / spread cone, velocity decay, gravity, drift, tick lifespan, and scalar.
///
/// Used when [ConfettiCustomization.useTickBasedPhysics] is true.
@immutable
class TickConfettiSpawnOptions {
  /// Creates tick-style options (degrees for [angle] / [spread], pixels for velocity).
  const TickConfettiSpawnOptions({
    this.angle = 90,
    this.spread = 45,
    this.startVelocity = 45,
    this.decay = 0.9,
    this.gravity = 1,
    this.drift = 0,
    this.flat = false,
    this.scalar = 1,
    this.ticks = 200,
  })  : assert(decay >= 0 && decay <= 1),
        assert(ticks > 0);

  /// Launch bearing in degrees (`90` = straight up in package coordinates).
  final double angle;

  /// Cone half-width in degrees (full width is spread).
  final double spread;

  /// Initial speed scale in pixels for tick spawn.
  final double startVelocity;

  /// Per-tick velocity multiplier (`0`–`1`); slows particles over time.
  final double decay;

  /// Downward pull per tick (physics applies a `×3` scale internally).
  final double gravity;

  /// Horizontal drift per tick (negative = left, positive = right).
  final double drift;

  /// When true, disables wobble / tilt (flat confetti).
  final bool flat;

  /// Visual scale for shapes (stars use inner/outer radius ∝ [scalar]).
  final double scalar;

  /// Simulation length in ticks (one tick per animation frame when using this engine).
  final int ticks;

  /// Returns a copy with any non-null field replaced.
  TickConfettiSpawnOptions copyWith({
    double? angle,
    double? spread,
    double? startVelocity,
    double? decay,
    double? gravity,
    double? drift,
    bool? flat,
    double? scalar,
    int? ticks,
  }) {
    return TickConfettiSpawnOptions(
      angle: angle ?? this.angle,
      spread: spread ?? this.spread,
      startVelocity: startVelocity ?? this.startVelocity,
      decay: decay ?? this.decay,
      gravity: gravity ?? this.gravity,
      drift: drift ?? this.drift,
      flat: flat ?? this.flat,
      scalar: scalar ?? this.scalar,
      ticks: ticks ?? this.ticks,
    );
  }
}
