import 'package:flutter/material.dart';

import 'particle_shape.dart';
import 'tick_confetti_spawn_options.dart';

/// Optional overrides for particle **count**, **colors**, **shape mix**, **physics**,
/// and directional cone ([burstDirectionDegrees]) for applicable presets.
///
/// Pass to [ConfettiWidget] or [ConfettiEngine.celebrate]. Unspecified fields
/// keep each preset’s factory defaults.
@immutable
class ConfettiCustomization {
  /// Creates customization overrides.
  ///
  /// [speedMultiplier] and [lifetimeMultiplier] default to `1.0` (no change).
  const ConfettiCustomization({
    this.particleCount,
    this.colors,
    this.shapeMix,
    this.gravity,
    this.speedMultiplier = 1.0,
    this.lifetimeMultiplier = 1.0,
    this.burstDirectionDegrees,
    this.burstSpreadDegrees,
    this.useTickBasedPhysics = false,
    this.tickSpawnOptions,
    this.particleBlendMode,
  });

  /// Minimum allowed [particleCount] (inclusive).
  static const int minParticleCount = 1;

  /// Maximum allowed [particleCount] (inclusive).
  static const int maxParticleCount = 2000;

  /// Total particles to spawn for the run. Clamped to
  /// [[minParticleCount], [maxParticleCount]].
  final int? particleCount;

  /// Replaces the preset’s color palette when non-null and non-empty.
  ///
  /// Very long lists are truncated when building particles so memory stays
  /// bounded.
  final List<Color>? colors;

  /// Replaces which [ParticleShape]s are randomly chosen when non-null and
  /// non-empty. Include [ParticleShape.emoji] if you want unicode particles
  /// (still driven by `emojiPool` on the widget / engine).
  ///
  /// Very long lists are truncated when building particles.
  final List<ParticleShape>? shapeMix;

  /// Overrides downward acceleration in pixels per second squared.
  ///
  /// When null, each preset keeps its built-in gravity (e.g. 500 burst).
  final double? gravity;

  /// Scales initial velocity components (`vx`, `vy`) at spawn time.
  ///
  /// Must be positive; values outside `0.05`–`8.0` are clamped.
  final double speedMultiplier;

  /// Scales each particle’s lifespan (`maxLifetime`).
  ///
  /// Must be positive; values outside `0.1`–`8.0` are clamped.
  final double lifetimeMultiplier;

  /// Directional burst / fountain cone — **degrees** where `0` = east (right),
  /// `90` = south (down), `-90` = north (up). When **null**, [Preset.nova]
  /// uses a full 360° spray (typical “up” aim uses `-90`).
  ///
  /// Directional presets ([Preset.cascade], [Preset.flare], [Preset.crossfire]) use fixed aim unless overridden here.
  final double? burstDirectionDegrees;

  /// Half-width of the cone in **degrees** when [burstDirectionDegrees] is set.
  /// Clamped between `5` and `180` when applied. Defaults to `90` if null.
  final double? burstSpreadDegrees;

  /// When true, presets use tick physics and shaped draws (star / oval circle /
  /// skew quad square / triangle).
  ///
  /// Default remains integrated force integration + paper/star paths.
  final bool useTickBasedPhysics;

  /// Overrides preset tick defaults when [useTickBasedPhysics] is true (full option set).
  final TickConfettiSpawnOptions? tickSpawnOptions;

  /// Blend mode for particle fills/strokes (additive / screen effects).
  ///
  /// When null, painting uses the default ([BlendMode.srcOver]). Emoji [TextPainter]
  /// draws may not honor blend modes consistently across platforms.
  final BlendMode? particleBlendMode;

  /// Returns a copy with the given fields replaced.
  ConfettiCustomization copyWith({
    int? particleCount,
    List<Color>? colors,
    List<ParticleShape>? shapeMix,
    double? gravity,
    double? speedMultiplier,
    double? lifetimeMultiplier,
    double? burstDirectionDegrees,
    double? burstSpreadDegrees,
    bool? useTickBasedPhysics,
    TickConfettiSpawnOptions? tickSpawnOptions,
    BlendMode? particleBlendMode,
  }) {
    return ConfettiCustomization(
      particleCount: particleCount ?? this.particleCount,
      colors: colors ?? this.colors,
      shapeMix: shapeMix ?? this.shapeMix,
      gravity: gravity ?? this.gravity,
      speedMultiplier: speedMultiplier ?? this.speedMultiplier,
      lifetimeMultiplier: lifetimeMultiplier ?? this.lifetimeMultiplier,
      burstDirectionDegrees:
          burstDirectionDegrees ?? this.burstDirectionDegrees,
      burstSpreadDegrees: burstSpreadDegrees ?? this.burstSpreadDegrees,
      useTickBasedPhysics: useTickBasedPhysics ?? this.useTickBasedPhysics,
      tickSpawnOptions: tickSpawnOptions ?? this.tickSpawnOptions,
      particleBlendMode: particleBlendMode ?? this.particleBlendMode,
    );
  }

  /// Merges [base] with [override]; non-null fields on [override] win.
  static ConfettiCustomization? merge(
    ConfettiCustomization? base,
    ConfettiCustomization? override,
  ) {
    if (base == null) return override;
    if (override == null) return base;
    return ConfettiCustomization(
      particleCount: override.particleCount ?? base.particleCount,
      colors: override.colors ?? base.colors,
      shapeMix: override.shapeMix ?? base.shapeMix,
      gravity: override.gravity ?? base.gravity,
      speedMultiplier: override.speedMultiplier != 1.0
          ? override.speedMultiplier
          : base.speedMultiplier,
      lifetimeMultiplier: override.lifetimeMultiplier != 1.0
          ? override.lifetimeMultiplier
          : base.lifetimeMultiplier,
      burstDirectionDegrees:
          override.burstDirectionDegrees ?? base.burstDirectionDegrees,
      burstSpreadDegrees:
          override.burstSpreadDegrees ?? base.burstSpreadDegrees,
      useTickBasedPhysics:
          override.useTickBasedPhysics || base.useTickBasedPhysics,
      tickSpawnOptions: override.tickSpawnOptions ?? base.tickSpawnOptions,
      particleBlendMode: override.particleBlendMode ?? base.particleBlendMode,
    );
  }

  /// Effective speed multiplier after clamping.
  ///
  /// Non-finite values (NaN, infinity) fall back to `1.0` — [double.clamp]
  /// does not normalize NaN.
  static double effectiveSpeedMultiplier(ConfettiCustomization? c) {
    if (c == null) return 1.0;
    final v = c.speedMultiplier;
    if (!v.isFinite) return 1.0;
    return v.clamp(0.05, 8.0);
  }

  /// Effective lifetime multiplier after clamping.
  ///
  /// Non-finite values fall back to `1.0`.
  static double effectiveLifetimeMultiplier(ConfettiCustomization? c) {
    if (c == null) return 1.0;
    final v = c.lifetimeMultiplier;
    if (!v.isFinite) return 1.0;
    return v.clamp(0.1, 8.0);
  }

  /// Effective gravity: optional customization overrides the preset when finite.
  ///
  /// Non-finite gravity falls back to [presetGravity].
  static double effectiveGravity(
      double presetGravity, ConfettiCustomization? c) {
    final g = c?.gravity;
    if (g == null) return presetGravity;
    if (!g.isFinite) return presetGravity;
    return g;
  }

  /// Effective particle count for a preset default when [particleCount] is set.
  static int effectiveCount(int presetDefault, ConfettiCustomization? c) {
    final n = c?.particleCount ?? presetDefault;
    return n.clamp(minParticleCount, maxParticleCount);
  }

  /// Effective blend mode for vector particle draws; null means default compositing.
  static BlendMode? effectiveParticleBlendMode(ConfettiCustomization? c) =>
      c?.particleBlendMode;
}
