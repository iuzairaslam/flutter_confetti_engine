import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_confetti_engine/flutter_confetti_engine.dart';
import 'package:flutter_confetti_engine/src/presets.dart';

void main() {
  const testSize = Size(400, 800);

  group('PresetFactory', () {
    test('nova produces 120 particles', () {
      final particles = PresetFactory.createParticles(Preset.nova, testSize);
      expect(particles.length, equals(120));
    });

    test('cascade produces 200 particles', () {
      final particles = PresetFactory.createParticles(Preset.cascade, testSize);
      expect(particles.length, equals(200));
    });

    test('flare produces 72 particles', () {
      final particles = PresetFactory.createParticles(Preset.flare, testSize);
      expect(particles.length, equals(72));
    });

    test('crossfire produces 100 particles', () {
      final particles =
          PresetFactory.createParticles(Preset.crossfire, testSize);
      expect(particles.length, equals(100));
    });

    test('all particles start alive', () {
      for (final preset in Preset.values) {
        final particles = PresetFactory.createParticles(preset, testSize);
        expect(
          particles.every((p) => !p.isDead),
          isTrue,
          reason: '${preset.name} had dead particles on creation',
        );
      }
    });

    test('all particles start with opacity 1.0', () {
      for (final preset in Preset.values) {
        final particles = PresetFactory.createParticles(preset, testSize);
        expect(
          particles.every((p) => p.opacity == 1.0),
          isTrue,
          reason: '${preset.name} particles did not start at full opacity',
        );
      }
    });

    test('nova particles originate near screen center', () {
      final particles = PresetFactory.createParticles(Preset.nova, testSize);
      final cx = testSize.width / 2;
      final cy = testSize.height / 2;
      for (final p in particles) {
        expect(p.x, closeTo(cx, 1.0));
        expect(p.y, closeTo(cy, 1.0));
      }
    });

    test('cascade uses strong downward gravity', () {
      final particles = PresetFactory.createParticles(Preset.cascade, testSize);
      for (final p in particles) {
        expect(p.gravity, greaterThan(400.0));
      }
    });

    test('all particles have positive size', () {
      for (final preset in Preset.values) {
        final particles = PresetFactory.createParticles(preset, testSize);
        expect(
          particles.every((p) => p.size > 0),
          isTrue,
        );
      }
    });

    test('all particles have positive maxLifetime', () {
      for (final preset in Preset.values) {
        final particles = PresetFactory.createParticles(preset, testSize);
        expect(
          particles.every((p) => p.maxLifetime > 0),
          isTrue,
        );
      }
    });

    test('customization overrides particle count', () {
      final particles = PresetFactory.createParticles(
        Preset.nova,
        testSize,
        customization: const ConfettiCustomization(particleCount: 17),
      );
      expect(particles.length, 17);
    });

    test('customization applies total particle count for cascade', () {
      final particles = PresetFactory.createParticles(
        Preset.cascade,
        testSize,
        customization: const ConfettiCustomization(particleCount: 100),
      );
      expect(particles.length, 100);
    });

    test('customization shapeMix restricts geometry', () {
      final particles = PresetFactory.createParticles(
        Preset.nova,
        testSize,
        customization: const ConfettiCustomization(
          particleCount: 80,
          shapeMix: [ParticleShape.circle, ParticleShape.square],
        ),
      );
      expect(
        particles.every(
          (p) =>
              p.shape == ParticleShape.circle ||
              p.shape == ParticleShape.square,
        ),
        isTrue,
      );
    });

    test('customization colors replace preset palette', () {
      const palette = [Colors.black, Colors.white];
      final particles = PresetFactory.createParticles(
        Preset.nova,
        testSize,
        customization: const ConfettiCustomization(
          particleCount: 40,
          colors: palette,
        ),
      );
      for (final p in particles) {
        expect(palette.contains(p.color), isTrue);
      }
    });

    test('customization gravity overrides preset value', () {
      final particles = PresetFactory.createParticles(
        Preset.nova,
        testSize,
        customization: const ConfettiCustomization(
          particleCount: 5,
          gravity: 1234,
        ),
      );
      for (final p in particles) {
        expect(p.gravity, 1234);
      }
    });

    test('custom emojiPool restricts emoji particles', () {
      final particles = PresetFactory.createParticles(
        Preset.nova,
        testSize,
        emojiPool: const ['💰', '🎯'],
      );
      for (final p in particles) {
        if (p.shape == ParticleShape.emoji) {
          expect(['💰', '🎯'].contains(p.emoji), isTrue);
        }
      }
    });

    test('emoji particles have non-null emoji string', () {
      var found = false;
      for (var i = 0; i < 20; i++) {
        final particles = PresetFactory.createParticles(Preset.nova, testSize);
        for (final p in particles) {
          if (p.shape == ParticleShape.emoji) {
            expect(p.emoji, isNotNull);
            expect(p.emoji!.isNotEmpty, isTrue);
            found = true;
          }
        }
        if (found) break;
      }
    });

    test('non-finite layout size is sanitized', () {
      final particles = PresetFactory.createParticles(
        Preset.nova,
        const Size(double.infinity, double.nan),
      );
      expect(particles.length, equals(120));
    });

    test('NaN customization multipliers use safe defaults', () {
      final particles = PresetFactory.createParticles(
        Preset.nova,
        testSize,
        customization: const ConfettiCustomization(
          particleCount: 10,
          speedMultiplier: double.nan,
          lifetimeMultiplier: double.nan,
        ),
      );
      expect(particles.length, 10);
      expect(
        particles.every((p) => p.vx.isFinite && p.vy.isFinite),
        isTrue,
      );
    });

    test('NaN customization gravity keeps preset gravity', () {
      final particles = PresetFactory.createParticles(
        Preset.nova,
        testSize,
        customization: const ConfettiCustomization(
          particleCount: 5,
          gravity: double.nan,
        ),
      );
      for (final p in particles) {
        expect(p.gravity, 500);
      }
    });

    test('whitespace-only emojiPool falls back to defaults', () {
      expect(
        () => PresetFactory.createParticles(
          Preset.nova,
          testSize,
          emojiPool: const ['   ', ' \n'],
        ),
        returnsNormally,
      );
    });

    test('ConfettiCustomization.merge blends nullable fields', () {
      const base = ConfettiCustomization(
        colors: [Colors.red],
        particleCount: 120,
      );
      const over = ConfettiCustomization(
        particleCount: 10,
      );
      final m = ConfettiCustomization.merge(base, over);
      expect(m?.particleCount, 10);
      expect(m?.colors, const [Colors.red]);

      const over2 = ConfettiCustomization(colors: [Colors.blue]);
      final m2 = ConfettiCustomization.merge(base, over2);
      expect(m2?.colors, const [Colors.blue]);
    });

    test(
        'ConfettiCustomization.merge preserves particleBlendMode from override',
        () {
      const base = ConfettiCustomization(
        particleBlendMode: BlendMode.srcOver,
      );
      const over = ConfettiCustomization(
        particleBlendMode: BlendMode.plus,
      );
      final m = ConfettiCustomization.merge(base, over);
      expect(m?.particleBlendMode, BlendMode.plus);
    });
  });
}
