import 'package:flutter/material.dart';
import 'package:flutter_confetti_engine/flutter_confetti_engine.dart';
import 'package:flutter_confetti_engine/src/confetti_painter.dart';
import 'package:flutter_confetti_engine/src/particle.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('ConfettiPainter paints every ParticleShape without error',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: CustomPaint(
          painter: ConfettiPainter(
            particles: [
              for (final shape in ParticleShape.values)
                Particle(
                  x: 60,
                  y: 60,
                  vx: 0,
                  vy: 0,
                  gravity: 0,
                  rotation: 0,
                  rotationSpeed: 0,
                  color: Colors.red,
                  shape: shape,
                  size: 28,
                  maxLifetime: 99,
                  emoji: shape == ParticleShape.emoji ? '🎉' : null,
                ),
            ],
          ),
        ),
      ),
    );
    expect(find.byType(CustomPaint), findsOneWidget);
  });
}
