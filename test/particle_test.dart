import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_confetti_engine/flutter_confetti_engine.dart';

// Access internal Particle directly for unit tests.
import 'package:flutter_confetti_engine/src/particle.dart';

void main() {
  group('Particle', () {
    Particle makeParticle({
      double gravity = 500,
      double lifetime = 2.0,
      double vx = 100,
      double vy = -200,
    }) {
      return Particle(
        x: 0,
        y: 0,
        vx: vx,
        vy: vy,
        gravity: gravity,
        rotation: 0,
        rotationSpeed: 1.0,
        color: Colors.red,
        shape: ParticleShape.circle,
        size: 10,
        maxLifetime: lifetime,
      );
    }

    test('starts alive with opacity 1.0', () {
      final p = makeParticle();
      expect(p.isDead, isFalse);
      expect(p.opacity, equals(1.0));
    });

    test('position updates correctly with dt', () {
      final p = makeParticle(gravity: 0, vx: 100, vy: 50);
      p.update(1.0); // 1 second
      expect(p.x, closeTo(100.0, 0.001));
      expect(p.y, closeTo(50.0, 0.001));
    });

    test('gravity accelerates vy downward', () {
      final p = makeParticle(gravity: 500, vy: 0);
      p.update(0.1);
      expect(p.vy, closeTo(50.0, 0.001)); // 500 * 0.1
    });

    test('opacity interpolates linearly to 0', () {
      final p = makeParticle(lifetime: 2.0);
      p.update(1.0); // 50% lifetime consumed
      expect(p.opacity, closeTo(0.5, 0.01));
    });

    test('isDead becomes true at maxLifetime', () {
      final p = makeParticle(lifetime: 1.0);
      p.update(0.5);
      expect(p.isDead, isFalse);
      p.update(0.5);
      expect(p.isDead, isTrue);
      expect(p.opacity, equals(0.0));
    });

    test('update is no-op after death', () {
      final p = makeParticle(lifetime: 0.1);
      p.update(1.0); // kills particle
      final xAfterDeath = p.x;
      p.update(1.0); // should not change anything
      expect(p.x, equals(xAfterDeath));
    });

    test('rotation advances by rotationSpeed * dt', () {
      final p = makeParticle()..rotation = 0;
      // rotationSpeed = 1.0 from factory
      p.update(0.5);
      expect(p.rotation, closeTo(0.5, 0.01));
    });

    test('ignores non-positive or non-finite dt', () {
      final p = makeParticle(gravity: 0, vx: 0, vy: 0);
      final x0 = p.x;
      p.update(double.nan);
      expect(p.x, x0);
      p.update(-1);
      expect(p.x, x0);
    });

    test('invalid maxLifetime marks dead without advancing physics', () {
      final p = Particle(
        x: 0,
        y: 0,
        vx: 100,
        vy: 0,
        gravity: 500,
        rotation: 0,
        rotationSpeed: 1,
        color: Colors.red,
        shape: ParticleShape.circle,
        size: 10,
        maxLifetime: 0,
      );
      p.update(0);
      expect(p.isDead, isTrue);
      expect(p.x, 0);
    });
  });
}
