import 'dart:math';

import 'package:flutter/material.dart';

import 'tick_confetti_spawn_options.dart';

/// Step-based particle state for tick-mode simulation — one [update] call per
/// animation frame (one integration step per repaint).
class TickConfettiPhysics {
  TickConfettiPhysics({
    required this.wobble,
    required this.wobbleSpeed,
    required this.velocity,
    required this.angle2D,
    required this.tiltAngle,
    required this.color,
    required this.decay,
    required this.drift,
    required this.random,
    required this.tiltSin,
    required this.wobbleX,
    required this.wobbleY,
    required this.gravity,
    required this.ovalScalar,
    required this.scalar,
    required this.flat,
    required this.tiltCos,
    required this.totalTicks,
  })  : ticket = 0,
        progress = 0;

  double wobble;
  double wobbleSpeed;
  double velocity;
  double angle2D;
  double tiltAngle;
  Color color;
  double decay;
  double drift;
  double ovalScalar;
  double scalar;
  bool flat;

  double random;
  double tiltSin;
  double tiltCos;
  double wobbleX;
  double wobbleY;
  double gravity;

  int totalTicks;
  int ticket;
  double progress;

  double x = 0;
  double y = 0;
  double x1 = 0;
  double x2 = 0;
  double y1 = 0;
  double y2 = 0;

  bool get finished => ticket > totalTicks;

  /// Builds tick state from [TickConfettiSpawnOptions] + emitter position.
  factory TickConfettiPhysics.spawn({
    required double emitterX,
    required double emitterY,
    required TickConfettiSpawnOptions options,
    required Color color,
    Random? random,
  }) {
    final rng = random ?? Random();
    final radAngle = options.angle * (pi / 180);
    final radSpread = options.spread * (pi / 180);

    return TickConfettiPhysics(
      wobble: rng.nextDouble() * 10,
      wobbleSpeed: min(0.11, rng.nextDouble() * 0.1 + 0.05),
      velocity: options.startVelocity * 0.5 +
          rng.nextDouble() * options.startVelocity,
      angle2D: -radAngle + (0.5 * radSpread - rng.nextDouble() * radSpread),
      tiltAngle: (rng.nextDouble() * (0.75 - 0.25) + 0.25) * pi,
      color: color,
      decay: options.decay,
      drift: options.drift,
      random: rng.nextDouble() + 2,
      tiltSin: 0,
      tiltCos: 0,
      wobbleX: 0,
      wobbleY: 0,
      gravity: options.gravity * 3,
      ovalScalar: 0.6,
      scalar: options.scalar,
      flat: options.flat,
      totalTicks: options.ticks,
    )
      ..x = emitterX
      ..y = emitterY;
  }

  /// Advances one tick (call once per frame — aligned with one repaint).
  void update() {
    progress = ticket / totalTicks;
    ticket++;

    x += cos(angle2D) * velocity + drift;
    y += sin(angle2D) * velocity + gravity;

    velocity *= decay;

    if (flat) {
      wobble = 0;
      wobbleX = x + (10 * scalar);
      wobbleY = y + (10 * scalar);

      tiltSin = 0;
      tiltCos = 0;
      random = 1;
    } else {
      wobble += wobbleSpeed;
      wobbleX = x + 10 * scalar * cos(wobble);
      wobbleY = y + 10 * scalar * sin(wobble);

      tiltAngle += 0.1;
      tiltSin = sin(tiltAngle);
      tiltCos = cos(tiltAngle);
      random = Random().nextDouble() + 2;
    }

    x1 = x + random * tiltCos;
    y1 = y + random * tiltSin;
    x2 = wobbleX + random * tiltCos;
    y2 = wobbleY + random * tiltSin;
  }

  void kill() {
    ticket = totalTicks + 1;
  }
}
