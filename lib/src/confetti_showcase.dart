import 'dart:math';

import 'package:flutter/material.dart';

import 'confetti_customization.dart';
import 'particle.dart';
import 'particle_shape.dart';
import 'presets.dart';
import 'tick_confetti_physics.dart';
import 'tick_confetti_spawn_options.dart';

/// Eight curated tick bursts for showcase scenarios (basic cannon, random direction,
/// dualLaunch, starField, emojiPop, school pride, manual launch/kill, bounded emitter).
///
/// All modes use tick-style simulation ([TickConfettiPhysics]). Multi-shot patterns
/// (dualLaunch timer, starField triple-tap, school-pride stream) are represented by **one
/// representative burst** here; repeat via [Timer] in your app for continuous effects.
enum ConfettiShowcase {
  /// `particleCount: 100`, `spread: 70`, origin `y ≈ 0.6`.
  centerPop,

  /// Random angle (55°–125°), spread (50°–70°), count (50–100), `y ≈ 0.6`.
  randomAngle,

  /// One dual-emitter wave like a dual-emitter tick (`spread: 360`, `ticks: 60`).
  /// For the full decreasing-count timer effect, call [Timer.periodic] yourself.
  dualLaunch,

  /// Warm palette, `spread: 360`, `gravity: 0`, `ticks: 50`, star shapes + mixed scalar.
  starField,

  /// Same motion as [starField] with [ParticleShape.emoji] from [emojiPool].
  emojiPop,

  /// Red / white dual cannons from left and right edges (`angle` 60° / 120°).
  dualStream,

  /// Same particles as [centerPop]; pair with [ConfettiController] + [ConfettiController.kill].
  controlledBurst,

  /// Bottom-centered burst (`y ≈ 1`); place [ConfettiWidget] in a [ClipPath] / small stack for UI parity.
  inlineEmitter,
}

/// Builds particle lists for [ConfettiShowcase] using [TickConfettiPhysics].
abstract final class ShowcaseParticleFactory {
  ShowcaseParticleFactory._();

  static const double _nominalGravityPx = 500;
  static const double _fallbackExtent = 400;

  /// Default unicode pool when [emojiPool] is null (see [kDefaultCelebrationEmojis]).
  static List<Particle> createParticles(
    ConfettiShowcase showcase,
    Size size, {
    List<String>? emojiPool,
    ConfettiCustomization? customization,
    Random? random,
  }) {
    final rng = random ?? Random();
    final safe = _safeSize(size);
    final emojis = _emojiPool(emojiPool);

    switch (showcase) {
      case ConfettiShowcase.centerPop:
      case ConfettiShowcase.controlledBurst:
        return _burst(
          safe,
          rng,
          customization,
          count: ConfettiCustomization.effectiveCount(100, customization),
          opts: const TickConfettiSpawnOptions(
            angle: 90,
            spread: 70,
            decay: 0.9,
            gravity: 1,
            scalar: 1,
            ticks: 220,
          ),
          emitter: (s) => Offset(s.width / 2, s.height * 0.6),
          shapes: const [
            ParticleShape.circle,
            ParticleShape.square,
          ],
          colors: _palette(customization),
        );
      case ConfettiShowcase.randomAngle:
        final angle = _randomRange(rng, 55, 125);
        final spread = _randomRange(rng, 50, 70);
        final n = ConfettiCustomization.effectiveCount(
          rng.nextInt(51) + 50,
          customization,
        );
        return _burst(
          safe,
          rng,
          customization,
          count: n,
          opts: TickConfettiSpawnOptions(
            angle: angle,
            spread: spread,
            decay: 0.9,
            gravity: 1,
            scalar: 1,
            ticks: 220,
          ),
          emitter: (s) => Offset(s.width / 2, s.height * 0.6),
          shapes: const [
            ParticleShape.circle,
            ParticleShape.square,
            ParticleShape.triangle,
          ],
          colors: _palette(customization),
        );
      case ConfettiShowcase.dualLaunch:
        final countEach = max(
          8,
          (ConfettiCustomization.effectiveCount(25, customization) / 2).round(),
        );
        const baseOpts = TickConfettiSpawnOptions(
          spread: 360,
          startVelocity: 30,
          ticks: 60,
          decay: 0.92,
          gravity: 0.85,
          scalar: 1,
          angle: 90,
        );
        final left = _burst(
          safe,
          rng,
          customization,
          count: countEach,
          opts: baseOpts,
          emitter: (s) => Offset(
                s.width * rng.nextDouble().clamp(0.1, 0.3),
                s.height * (rng.nextDouble() - 0.2).clamp(0.15, 0.85),
              ),
          shapes: const [ParticleShape.circle, ParticleShape.star],
          colors: _palette(customization),
        );
        final right = _burst(
          safe,
          rng,
          customization,
          count: countEach,
          opts: baseOpts,
          emitter: (s) => Offset(
                s.width * rng.nextDouble().clamp(0.7, 0.9),
                s.height * (rng.nextDouble() - 0.2).clamp(0.15, 0.85),
              ),
          shapes: const [ParticleShape.circle, ParticleShape.star],
          colors: _palette(customization),
        );
        return [...left, ...right];
      case ConfettiShowcase.starField:
        final n = ConfettiCustomization.effectiveCount(50, customization);
        const warm = [
          Color(0xffFFE400),
          Color(0xffFFBD00),
          Color(0xffE89400),
          Color(0xffFFCA6C),
          Color(0xffFDFFB8),
        ];
        final colors = _palette(customization, fallback: warm);
        return _burst(
          safe,
          rng,
          customization,
          count: n,
          opts: const TickConfettiSpawnOptions(
            spread: 360,
            ticks: 50,
            gravity: 0,
            decay: 0.94,
            startVelocity: 30,
            angle: 90,
            scalar: 1,
          ),
          emitter: (s) => Offset(s.width / 2, s.height * 0.55),
          shapes: const [ParticleShape.star],
          colors: colors,
          scalarJitter: true,
        );
      case ConfettiShowcase.emojiPop:
        final n = ConfettiCustomization.effectiveCount(50, customization);
        return _burst(
          safe,
          rng,
          customization,
          count: n,
          opts: const TickConfettiSpawnOptions(
            spread: 360,
            ticks: 50,
            gravity: 0,
            decay: 0.94,
            startVelocity: 30,
            angle: 90,
            scalar: 1,
          ),
          emitter: (s) => Offset(s.width / 2, s.height * 0.55),
          shapes: const [ParticleShape.emoji],
          colors: _palette(customization),
          emojiPool: emojis,
        );
      case ConfettiShowcase.dualStream:
        const prideColors = [
          Color(0xffbb0000),
          Color(0xffffffff),
        ];
        final custom = customization?.colors;
        final colors = custom != null && custom.isNotEmpty
            ? List<Color>.from(custom)
            : prideColors;
        final half = max(
          4,
          ConfettiCustomization.effectiveCount(50, customization) ~/ 2,
        );
        final left = _burst(
          safe,
          rng,
          customization,
          count: half,
          opts: const TickConfettiSpawnOptions(
            angle: 60,
            spread: 55,
            decay: 0.9,
            gravity: 1,
            ticks: 240,
            scalar: 1,
          ),
          emitter: (s) => Offset(12, s.height * 0.45),
          shapes: const [ParticleShape.circle, ParticleShape.square],
          colors: colors,
        );
        final right = _burst(
          safe,
          rng,
          customization,
          count: half,
          opts: const TickConfettiSpawnOptions(
            angle: 120,
            spread: 55,
            decay: 0.9,
            gravity: 1,
            ticks: 240,
            scalar: 1,
          ),
          emitter: (s) => Offset(s.width - 12, s.height * 0.45),
          shapes: const [ParticleShape.circle, ParticleShape.square],
          colors: colors,
        );
        return [...left, ...right];
      case ConfettiShowcase.inlineEmitter:
        return _burst(
          safe,
          rng,
          customization,
          count: ConfettiCustomization.effectiveCount(100, customization),
          opts: const TickConfettiSpawnOptions(
            angle: 90,
            spread: 70,
            decay: 0.9,
            gravity: 1,
            ticks: 200,
            scalar: 1,
          ),
          emitter: (s) => Offset(s.width / 2, s.height - 2),
          shapes: const [
            ParticleShape.circle,
            ParticleShape.square,
          ],
          colors: _palette(customization),
        );
    }
  }

  /// Safe size for spawn math (matches [PresetFactory] intent).
  static Size _safeSize(Size size) {
    var w = size.width;
    var h = size.height;
    if (!w.isFinite || w <= 0) w = _fallbackExtent;
    if (!h.isFinite || h <= 0) h = _fallbackExtent;
    return Size(w, h);
  }

  static double _randomRange(Random r, double min, double max) {
    return min + r.nextDouble() * (max - min);
  }

  static List<String> _emojiPool(List<String>? pool) {
    if (pool != null && pool.isNotEmpty) return List<String>.from(pool);
    return List<String>.from(kDefaultCelebrationEmojis);
  }

  static List<Color> _palette(
    ConfettiCustomization? c, {
    List<Color>? fallback,
  }) {
    final list = c?.colors;
    if (list != null && list.isNotEmpty) return List<Color>.from(list);
    return fallback ??
        const [
          Color(0xFF26ccff),
          Color(0xFFa25afd),
          Color(0xFFff5e7e),
          Color(0xFFfcff42),
        ];
  }

  static List<Particle> _burst(
    Size safe,
    Random rng,
    ConfettiCustomization? customization, {
    required int count,
    required TickConfettiSpawnOptions opts,
    required Offset Function(Size s) emitter,
    required List<ParticleShape> shapes,
    required List<Color> colors,
    List<String>? emojiPool,
    bool scalarJitter = false,
  }) {
    final lm = ConfettiCustomization.effectiveLifetimeMultiplier(customization);
    final effGrav = ConfettiCustomization.effectiveGravity(
      _nominalGravityPx,
      customization,
    );
    final factor = effGrav / _nominalGravityPx;
    final spawnOpts = opts.copyWith(
      gravity: (opts.gravity * factor).clamp(0.01, 12.0),
    );

    final out = <Particle>[];
    for (var i = 0; i < count; i++) {
      final origin = emitter(safe);
      final color = colors[rng.nextInt(colors.length)];
      final shape = shapes[rng.nextInt(shapes.length)];
      final scalar = scalarJitter
          ? (rng.nextBool() ? 1.2 : 0.75)
          : spawnOpts.scalar;
      final perOpts =
          scalarJitter ? spawnOpts.copyWith(scalar: scalar) : spawnOpts;

      final tc = TickConfettiPhysics.spawn(
        emitterX: origin.dx,
        emitterY: origin.dy,
        options: perOpts,
        color: color,
        random: rng,
      );

      out.add(
        Particle(
          x: origin.dx,
          y: origin.dy,
          vx: 0,
          vy: 0,
          gravity: effGrav,
          rotation: 0,
          rotationSpeed: 0,
          color: color,
          shape: shape,
          size: perOpts.scalar * 16,
          maxLifetime: perOpts.ticks / 60.0 * lm,
          emoji: shape == ParticleShape.emoji
              ? emojiPool![rng.nextInt(emojiPool.length)]
              : null,
          tickConfetti: tc,
        ),
      );
    }
    return out;
  }
}
