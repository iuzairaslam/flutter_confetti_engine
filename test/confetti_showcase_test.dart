import 'package:flutter/material.dart';
import 'package:flutter_confetti_engine/flutter_confetti_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ShowcaseParticleFactory', () {
    const size = Size(400, 800);

    test('each ConfettiShowcase spawns at least one particle', () {
      for (final mode in ConfettiShowcase.values) {
        final list = ShowcaseParticleFactory.createParticles(mode, size);
        expect(list, isNotEmpty, reason: '$mode');
      }
    });

    test('respects particleCount override', () {
      const c = ConfettiCustomization(particleCount: 7);
      final list = ShowcaseParticleFactory.createParticles(
        ConfettiShowcase.centerPop,
        size,
        customization: c,
      );
      expect(list.length, 7);
    });
  });
}
