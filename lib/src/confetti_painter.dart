import 'dart:math';

import 'package:flutter/material.dart';

import 'flutter_confetti_physics.dart';
import 'particle.dart';
import 'particle_shape.dart';
import 'tick_confetti_physics.dart';

/// Matches [PresetFactory] emoji rune cap — belts-and-suspenders at paint time.
const int _kMaxEmojiPaintRunes = 32;

String _truncateEmojiForPaint(String raw) {
  final runes = raw.runes;
  if (runes.length <= _kMaxEmojiPaintRunes) return raw;
  return String.fromCharCodes(runes.take(_kMaxEmojiPaintRunes));
}

/// Renders a list of [Particle] objects onto the canvas each frame.
///
/// This is a pure [CustomPainter] — no widget tree, no layout — which keeps
/// the render cost proportional to particle count rather than widget count.
///
/// Every particle is drawn centered on its (x, y) world position. The canvas
/// is translated to that point, rotated by [Particle.rotation], then the shape
/// is drawn around (0, 0) in the particle's local space.
class ConfettiPainter extends CustomPainter {
  /// The current snapshot of particles for this frame.
  final List<Particle> particles;

  /// When non-null, applied to vector particle draws ([BlendMode.srcOver] if null).
  final BlendMode? particleBlendMode;

  /// Creates a [ConfettiPainter] with the given [particles].
  const ConfettiPainter({
    required this.particles,
    this.particleBlendMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final particle in particles) {
      if (particle.isDead || particle.opacity <= 0.0) continue;
      if (!_isDrawableParticle(particle)) continue;

      try {
        paint
          ..color = particle.color.withValues(
            alpha: particle.opacity.clamp(0.0, 1.0),
          )
          ..blendMode = particleBlendMode ?? BlendMode.srcOver;

        final fc = particle.flutterConfetti;
        final fp = particle.flutterConfettiPath;
        if (fc != null && fp != null) {
          final m = _flutterConfettiPaintMatrix(fc, particle.x, particle.y);
          final transformed = fp.transform(m.storage);
          canvas.drawPath(transformed, paint);
        } else if (particle.tickConfetti != null) {
          _drawTickShape(canvas, paint, particle);
        } else {
          canvas.save();
          canvas.translate(particle.x, particle.y);
          canvas.rotate(particle.rotation);
          _drawShape(canvas, paint, particle);
          canvas.restore();
        }
      } catch (_) {
        // Malformed particle state must not cancel the whole frame.
      }
    }
  }

  static bool _isDrawableParticle(Particle particle) {
    if (!particle.x.isFinite || !particle.y.isFinite) return false;
    final fc = particle.flutterConfetti;
    final tc = particle.tickConfetti;
    if (fc != null) {
      if (!fc.paperWidth.isFinite ||
          !fc.paperHeight.isFinite ||
          fc.paperWidth <= 0 ||
          fc.paperHeight <= 0) {
        return false;
      }
    } else if (tc != null) {
      if (!particle.size.isFinite || particle.size <= 0) return false;
    } else {
      if (!particle.size.isFinite || particle.size <= 0) return false;
      if (!particle.rotation.isFinite) return false;
    }
    if (!particle.opacity.isFinite) return false;
    return true;
  }

  // Always repaint while animation is running. The Ticker is stopped when all
  // particles are dead, so this never fires on a static screen.
  @override
  bool shouldRepaint(ConfettiPainter oldDelegate) => true;

  // ─── Tick-mode visuals (Canvas geometry for star / circle / square / triangle)

  void _drawTickShape(Canvas canvas, Paint paint, Particle particle) {
    final physics = particle.tickConfetti!;
    switch (particle.shape) {
      case ParticleShape.star:
        _drawTickStar(canvas, paint, physics);
      case ParticleShape.circle:
        _drawTickCircle(canvas, paint, physics);
      case ParticleShape.square:
        _drawTickSquare(canvas, paint, physics);
      case ParticleShape.triangle:
        _drawTickTriangle(canvas, paint, physics);
      case ParticleShape.emoji:
        canvas.save();
        canvas.translate(particle.x, particle.y);
        canvas.rotate(pi / 10 * physics.wobble);
        _drawEmoji(canvas, particle.emoji ?? '🎉', particle.size);
        canvas.restore();
      default:
        canvas.save();
        canvas.translate(particle.x, particle.y);
        canvas.rotate(pi / 10 * physics.wobble);
        _drawShape(canvas, paint, particle);
        canvas.restore();
    }
  }

  void _drawTickStar(Canvas canvas, Paint paint, TickConfettiPhysics physics) {
    canvas.save();
    final innerRadius = 4 * physics.scalar;
    final outerRadius = 8 * physics.scalar;
    var rot = pi / 2 * 3;
    var sx = physics.x;
    var sy = physics.y;
    var spikes = 5;
    final step = pi / spikes;

    final path = Path()..moveTo(sx, sy);

    while (spikes-- >= 0) {
      sx = physics.x + cos(rot) * outerRadius;
      sy = physics.y + sin(rot) * outerRadius;
      path.lineTo(sx, sy);
      rot += step;

      sx = physics.x + cos(rot) * innerRadius;
      sy = physics.y + sin(rot) * innerRadius;
      path.lineTo(sx, sy);
      rot += step;
    }

    path.close();
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  void _drawTickCircle(
      Canvas canvas, Paint paint, TickConfettiPhysics physics) {
    canvas.save();

    canvas.translate(physics.x, physics.y);
    canvas.rotate(pi / 10 * physics.wobble);
    final sx = ((physics.x2 - physics.x1).abs() * physics.ovalScalar)
        .clamp(0.5, 9999.0);
    final sy = ((physics.y2 - physics.y1).abs() * physics.ovalScalar)
        .clamp(0.5, 9999.0);
    canvas.scale(sx, sy);

    canvas.drawArc(
      Rect.fromCircle(center: Offset.zero, radius: 1),
      0,
      2 * pi,
      true,
      paint,
    );

    canvas.restore();
  }

  void _drawTickSquare(
      Canvas canvas, Paint paint, TickConfettiPhysics physics) {
    canvas.save();

    final path = Path()
      ..moveTo(physics.x.floorToDouble(), physics.y.floorToDouble())
      ..lineTo(physics.wobbleX, physics.y1.floorToDouble())
      ..lineTo(physics.x2.floorToDouble(), physics.y2.floorToDouble())
      ..lineTo(physics.x1.floorToDouble(), physics.wobbleY.floorToDouble())
      ..close();

    canvas.drawPath(path, paint);
    canvas.restore();
  }

  void _drawTickTriangle(
      Canvas canvas, Paint paint, TickConfettiPhysics physics) {
    canvas.save();

    final path = Path()
      ..moveTo(physics.x.floorToDouble(), physics.y.floorToDouble())
      ..lineTo(physics.wobbleX.ceilToDouble(), physics.y1.floorToDouble())
      ..lineTo(physics.x2.floorToDouble(), physics.wobbleY.ceilToDouble())
      ..close();

    canvas.drawPath(path, paint);
    canvas.restore();
  }

  // ─── Shape renderers ───────────────────────────────────────────────────────

  void _drawShape(Canvas canvas, Paint paint, Particle particle) {
    switch (particle.shape) {
      case ParticleShape.paper:
        _drawPaper(canvas, paint, particle.size);
      case ParticleShape.circle:
        _drawCircle(canvas, paint, particle.size);
      case ParticleShape.square:
        _drawSquare(canvas, paint, particle.size);
      case ParticleShape.ribbon:
        _drawRibbon(canvas, paint, particle.size);
      case ParticleShape.triangle:
        _drawTriangle(canvas, paint, particle.size);
      case ParticleShape.star:
        _drawStar(canvas, paint, particle.size);
      case ParticleShape.emoji:
        _drawEmoji(canvas, particle.emoji ?? '🎉', particle.size);
      case ParticleShape.pentagon:
        _drawPolygon(canvas, paint, particle.size, 5);
      case ParticleShape.hexagon:
        _drawPolygon(canvas, paint, particle.size, 6);
      case ParticleShape.ring:
        _drawRing(canvas, paint, particle.size);
      case ParticleShape.lightning:
        _drawLightning(canvas, paint, particle.size);
      case ParticleShape.crescent:
        _drawCrescent(canvas, paint, particle.size);
      case ParticleShape.arrow:
        _drawArrow(canvas, paint, particle.size);
    }
  }

  /// Same footprint as [flutterConfettiPaperPath] but centered draw uses [size]
  /// as max(width,height) for legacy-sized particles.
  void _drawPaper(Canvas canvas, Paint paint, double size) {
    final w = size * 0.85;
    final h = size * 0.45;
    canvas.drawRect(
      Rect.fromCenter(center: Offset.zero, width: w, height: h),
      paint,
    );
  }

  void _drawCircle(Canvas canvas, Paint paint, double size) {
    canvas.drawCircle(Offset.zero, size / 2, paint);
  }

  void _drawSquare(Canvas canvas, Paint paint, double size) {
    canvas.drawRect(
      Rect.fromCenter(center: Offset.zero, width: size, height: size),
      paint,
    );
  }

  /// Wide flat rectangle that tumbles like a paper streamer.
  void _drawRibbon(Canvas canvas, Paint paint, double size) {
    canvas.drawRect(
      Rect.fromCenter(
          center: Offset.zero, width: size * 1.6, height: size * 0.4),
      paint,
    );
  }

  void _drawTriangle(Canvas canvas, Paint paint, double size) {
    final half = size / 2;
    final path = Path()
      ..moveTo(0, -half)
      ..lineTo(half, half)
      ..lineTo(-half, half)
      ..close();
    canvas.drawPath(path, paint);
  }

  /// Five-pointed star with inner radius at 40% of the outer radius.
  void _drawStar(Canvas canvas, Paint paint, double size) {
    const points = 5;
    final outer = size / 2;
    final inner = outer * 0.4;
    final path = Path();

    for (var i = 0; i < points * 2; i++) {
      final radius = i.isEven ? outer : inner;
      // Start at the top (-pi/2) and step by pi/points each vertex.
      final angle = (i * pi / points) - pi / 2;
      final dx = cos(angle) * radius;
      final dy = sin(angle) * radius;
      if (i == 0) {
        path.moveTo(dx, dy);
      } else {
        path.lineTo(dx, dy);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  /// Renders a unicode emoji centered on the particle's local origin.
  void _drawEmoji(Canvas canvas, String emoji, double size) {
    if (!size.isFinite || size <= 0) return;
    try {
      final text = _truncateEmojiForPaint(emoji);
      final tp = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(
            fontSize: size,
            decoration: TextDecoration.none,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      // Offset so the emoji is centered on (0,0).
      tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
    } catch (_) {}
  }

  /// Regular [sides]-gon centered at the origin with circumradius [size] / 2.
  void _drawPolygon(Canvas canvas, Paint paint, double size, int sides) {
    final path = _regularPolygonPath(sides, size / 2);
    canvas.drawPath(path, paint);
  }

  Path _regularPolygonPath(int sides, double radius) {
    final path = Path();
    for (var i = 0; i < sides; i++) {
      final angle = (i * 2 * pi / sides) - pi / 2;
      final dx = cos(angle) * radius;
      final dy = sin(angle) * radius;
      if (i == 0) {
        path.moveTo(dx, dy);
      } else {
        path.lineTo(dx, dy);
      }
    }
    path.close();
    return path;
  }

  /// Stroked ring — hollow circle.
  void _drawRing(Canvas canvas, Paint paint, double size) {
    final ringPaint = Paint()
      ..color = paint.color
      ..blendMode = paint.blendMode
      ..style = PaintingStyle.stroke
      ..strokeWidth = size * 0.14;
    canvas.drawCircle(Offset.zero, size * 0.38, ringPaint);
  }

  /// Compact lightning bolt polygon.
  void _drawLightning(Canvas canvas, Paint paint, double size) {
    final w = size * 0.38;
    final h = size / 2;
    final path = Path()
      ..moveTo(w * 0.35, -h)
      ..lineTo(-w * 0.55, -h * 0.08)
      ..lineTo(w * 0.05, -h * 0.02)
      ..lineTo(-w * 0.4, h)
      ..lineTo(w * 0.5, h * 0.12)
      ..lineTo(-w * 0.08, h * 0.08)
      ..close();
    canvas.drawPath(path, paint);
  }

  /// Crescent via even-odd difference of two circles.
  void _drawCrescent(Canvas canvas, Paint paint, double size) {
    final r = size / 2;
    final path = Path()
      ..fillType = PathFillType.evenOdd
      ..addOval(Rect.fromCircle(center: Offset.zero, radius: r * 0.92))
      ..addOval(Rect.fromCircle(center: Offset(r * 0.42, 0), radius: r * 0.72));
    canvas.drawPath(path, paint);
  }

  /// Fat arrow pointing upward.
  void _drawArrow(Canvas canvas, Paint paint, double size) {
    final h = size / 2;
    final w = size * 0.48;
    final path = Path()
      ..moveTo(0, -h)
      ..lineTo(w * 0.65, -h * 0.12)
      ..lineTo(w * 0.32, -h * 0.12)
      ..lineTo(w * 0.32, h)
      ..lineTo(-w * 0.32, h)
      ..lineTo(-w * 0.32, -h * 0.12)
      ..lineTo(-w * 0.65, -h * 0.12)
      ..close();
    canvas.drawPath(path, paint);
  }
}

/// Paint matrix for integrated preset (matrix-path) particles.
Matrix4 _flutterConfettiPaintMatrix(
  FlutterConfettiPhysics p,
  double dx,
  double dy,
) {
  final cosX = cos(p.angleX);
  final sinX = sin(p.angleX);
  final cosY = cos(p.angleY);
  final sinY = sin(p.angleY);
  final cosZ = p.rotateZ ? cos(p.angleZ) : 1.0;
  final sinZ = p.rotateZ ? sin(p.angleZ) : 0.0;

  return Matrix4(
    cosY * cosZ,
    cosX * sinZ + sinX * sinY * cosZ,
    sinX * sinZ - cosX * sinY * cosZ,
    0.0,
    -cosY * sinZ,
    cosX * cosZ - sinX * sinY * sinZ,
    sinX * cosZ + cosX * sinY * sinZ,
    0.0,
    sinY,
    -sinX * cosY,
    cosX * cosY,
    0.001,
    dx,
    dy,
    0.0,
    1.0,
  );
}
