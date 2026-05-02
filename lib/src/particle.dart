import 'package:flutter/material.dart';

import 'flutter_confetti_physics.dart';
import 'particle_shape.dart';
import 'tick_confetti_physics.dart';

/// A single confetti particle — a lightweight data object updated every frame.
///
/// No Flutter widgets are used. Particles are plain Dart objects iterated by
/// [ConfettiPainter] and updated by [ConfettiWidget]'s Ticker loop via [update].
///
/// When [flutterConfetti] is non-null, motion uses the integrated preset physics
/// (drag, phased startup/wind, gravity ∈ [0,1] scale, 3D angle tumble).
///
/// When [tickConfetti] is non-null, motion uses tick-based integration
/// (decay, wobble, tilt quad corners).
class Particle {
  /// Current horizontal position in logical pixels (screen coordinates).
  double x;

  /// Current vertical position in logical pixels (screen coordinates).
  double y;

  /// Horizontal velocity in pixels per second (legacy integrator only).
  double vx;

  /// Vertical velocity in pixels per second (legacy integrator only).
  double vy;

  /// Downward acceleration in pixels per second squared (legacy integrator),
  /// or a nominal “display” gravity when [flutterConfetti] is set.
  final double gravity;

  /// Current rotation angle in radians (legacy integrator only).
  double rotation;

  /// Angular velocity in radians per second (legacy integrator only).
  final double rotationSpeed;

  /// Fill color of the particle.
  final Color color;

  /// Visual shape. Controls how [ConfettiPainter] draws when no custom path.
  final ParticleShape shape;

  /// Bounding size of the particle in logical pixels (legacy mode).
  ///
  /// For [flutterConfetti] particles, this is `max(paperWidth, paperHeight)`.
  /// For [tickConfetti] particles, this tracks display scale (≈ `scalar * 16`).
  final double size;

  /// Current opacity in [0.0, 1.0].
  double opacity;

  /// Total lifespan of the particle in seconds.
  final double maxLifetime;

  /// Accumulated elapsed time in seconds since this particle was spawned.
  double currentLifetime;

  /// Non-null only when [shape] == [ParticleShape.emoji].
  /// Holds the actual unicode emoji character to render (e.g. '🎉').
  final String? emoji;

  /// Optional integrated preset physics ([FlutterConfettiPhysics]).
  final FlutterConfettiPhysics? flutterConfetti;

  /// Non-null for [flutterConfetti] particles — drawn with the same 3D matrix
  /// transform as [ConfettiPainter].
  final Path? flutterConfettiPath;

  /// Optional tick-based physics ([TickConfettiPhysics]).
  final TickConfettiPhysics? tickConfetti;

  bool _isDead = false;

  /// Creates a new [Particle] with all physics properties set explicitly.
  Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.gravity,
    required this.rotation,
    required this.rotationSpeed,
    required this.color,
    required this.shape,
    required this.size,
    required this.maxLifetime,
    this.emoji,
    this.opacity = 1.0,
    this.currentLifetime = 0.0,
    this.flutterConfetti,
    this.flutterConfettiPath,
    this.tickConfetti,
  });

  /// Whether this particle uses integrated preset physics.
  bool get usesFlutterConfettiPhysics => flutterConfetti != null;

  /// Whether this particle uses tick-based simulation.
  bool get usesTickPhysics => tickConfetti != null;

  /// Whether this particle has exceeded its [maxLifetime] and should be ignored.
  bool get isDead => _isDead;

  /// Advances the particle's physics simulation by [dt] seconds.
  void update(double dt) {
    if (_isDead) return;

    if (!maxLifetime.isFinite || maxLifetime <= 0) {
      _isDead = true;
      opacity = 0.0;
      return;
    }

    if (!dt.isFinite || dt <= 0) return;

    final tick = tickConfetti;
    if (tick != null) {
      tick.update();
      x = tick.x;
      y = tick.y;
      opacity = (1.0 - tick.progress).clamp(0.0, 1.0);
      currentLifetime += dt;
      if (!x.isFinite || !y.isFinite || !opacity.isFinite) {
        _isDead = true;
        opacity = 0.0;
        return;
      }
      if (tick.finished) {
        _isDead = true;
        opacity = 0.0;
      }
      return;
    }

    final fc = flutterConfetti;
    if (fc != null) {
      fc.integrate(dt);
      x = fc.originX + fc.relX;
      y = fc.originY + fc.relY;
    } else {
      vy += gravity * dt;
      x += vx * dt;
      y += vy * dt;
      rotation += rotationSpeed * dt;
    }

    currentLifetime += dt;

    if (!y.isFinite ||
        !x.isFinite ||
        (fc == null && (!vy.isFinite || !vx.isFinite || !rotation.isFinite)) ||
        !currentLifetime.isFinite) {
      _isDead = true;
      opacity = 0.0;
      return;
    }

    final lifeFraction = (currentLifetime / maxLifetime).clamp(0.0, 1.0);
    opacity = (1.0 - lifeFraction).clamp(0.0, 1.0);

    if (currentLifetime >= maxLifetime) {
      _isDead = true;
      opacity = 0.0;
    }
  }
}
