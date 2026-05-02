import 'dart:math';
import 'dart:ui' show Path, lerpDouble;

import 'package:flutter/foundation.dart';

import 'flutter_confetti_constants.dart';

/// Mutable integration state for preset matrix-path particles (force accumulation,
/// drag, phased startup + wind).
///
/// World position is [originX] + [relX], [originY] + [relY].
final class FlutterConfettiPhysics {
  FlutterConfettiPhysics({
    required this.originX,
    required this.originY,
    required this.gravity01,
    required this.particleDrag,
    required double startupForceX,
    required double startupForceY,
    required this.mass,
    required this.rotateZ,
    required this.paperWidth,
    required this.paperHeight,
    Random? random,
    double speedMultiplier = 1.0,
  })  : startupFx = startupForceX * speedMultiplier,
        startupFy = startupForceY * speedMultiplier,
        relX = 0,
        relY = 0,
        vx = _randRange(random, -3, 3) * speedMultiplier,
        vy = _randRange(random, -3, 3) * speedMultiplier,
        ax = 0,
        ay = 0,
        gx = 0,
        gy = lerpDouble(0.1, 5, gravity01)!,
        timeAlive = 0,
        aVelX = _randRange(random, -0.1, 0.1),
        aVelY = _randRange(random, -0.1, 0.1),
        aVelZ = _randRange(random, -0.1, 0.1),
        angleX = 0,
        angleY = 0,
        angleZ = 0;

  final double originX;
  final double originY;

  /// `gravity` ∈ [0, 1] mapped to fall strength.
  final double gravity01;

  final double particleDrag;
  final double mass;
  final bool rotateZ;

  double startupFx;
  double startupFy;

  double relX;
  double relY;
  double vx;
  double vy;
  double ax;
  double ay;

  /// Constant gravity vector (0, [gy]) with [gy] = `lerpDouble(0.1, 5, gravity01)`.
  double gx;
  double gy;

  /// Frames simulated (only incremented while applying wind).
  int timeAlive;

  double aVelX;
  double aVelY;
  double aVelZ;
  double angleX;
  double angleY;
  double angleZ;

  final double paperWidth;
  final double paperHeight;

  double get aAcceleration => 0.0001 / mass;

  static double _randRange(Random? r, double min, double max) {
    final rng = r ?? Random();
    return lerpDouble(min, max, rng.nextDouble())!;
  }

  static const windX = 0.0;
  static const windY = -1.0;

  void _applyForce(double fx, double fy, double deltaTimeSpeed) {
    ax += (fx / mass) * deltaTimeSpeed;
    ay += (fy / mass) * deltaTimeSpeed;
  }

  void _drag(double deltaTimeSpeed) {
    final speed = sqrt(vx * vx + vy * vy);
    final dragMagnitude = particleDrag * speed * speed;
    if (speed < 1e-10 || dragMagnitude < 1e-14) {
      return;
    }
    final ndx = -vx / speed;
    final ndy = -vy / speed;
    _applyForce(ndx * dragMagnitude, ndy * dragMagnitude, deltaTimeSpeed);
  }

  /// Integration step order matches [Particle.update] for matrix-path mode.
  void integrate(double deltaTime) {
    final deltaTimeSpeed = deltaTime * kFlutterConfettiDesiredSpeed;

    _drag(deltaTimeSpeed);

    if (timeAlive < 5) {
      _applyForce(startupFx, startupFy, deltaTimeSpeed);
    }
    if (timeAlive < 25) {
      _applyForce(windX, windY, deltaTimeSpeed);
      timeAlive += 1;
    }

    _applyForce(gx, gy, deltaTimeSpeed);

    vx += ax * deltaTimeSpeed;
    vy += ay * deltaTimeSpeed;
    relX += vx * deltaTimeSpeed;
    relY += vy * deltaTimeSpeed;
    ax = 0;
    ay = 0;

    final aa = aAcceleration;
    aVelX += aa;
    angleX += aVelX * deltaTimeSpeed;

    aVelY += aa;
    angleY += aVelY * deltaTimeSpeed;

    if (rotateZ) {
      angleZ += aVelZ * deltaTimeSpeed;
      aVelZ += aa;
    }
  }
}

/// Default rectangular paper path (relative to particle origin) for matrix-path draws.
Path flutterConfettiPaperPath(double width, double height) {
  final path = Path()
    ..moveTo(0, 0)
    ..lineTo(-width, 0)
    ..lineTo(-width, height)
    ..lineTo(0, height)
    ..close();

  if (kIsWeb) {
    path
      ..lineTo(-width, 0)
      ..lineTo(-width, height)
      ..lineTo(0, height)
      ..close();
  }

  return path;
}

/// Five-point star path for matrix-path preset draws.
Path flutterConfettiDemoStarPath(double width, double height) {
  const numberOfPoints = 5;
  final halfWidth = width / 2;
  final externalRadius = halfWidth;
  final internalRadius = halfWidth / 2.5;
  // ignore: prefer_const_declarations — `pi` is not a compile-time constant.
  final degreesPerStep = (360 / numberOfPoints) * (pi / 180);
  final halfDegreesPerStep = degreesPerStep / 2;
  final path = Path();

  path.moveTo(width, halfWidth);

  for (var step = 0.0; step < 2 * pi; step += degreesPerStep) {
    path.lineTo(
      halfWidth + externalRadius * cos(step),
      halfWidth + externalRadius * sin(step),
    );
    path.lineTo(
      halfWidth + internalRadius * cos(step + halfDegreesPerStep),
      halfWidth + internalRadius * sin(step + halfDegreesPerStep),
    );
  }
  path.close();
  return path;
}
