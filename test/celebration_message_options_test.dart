import 'package:flutter/material.dart';
import 'package:flutter_confetti_engine/flutter_confetti_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CelebrationMessageOptions', () {
    test('shouldPaintText respects showMessage and trimming', () {
      expect(
        const CelebrationMessageOptions(message: ' Hi ').shouldPaintText,
        isTrue,
      );
      expect(
        const CelebrationMessageOptions(message: '   ', showMessage: true)
            .shouldPaintText,
        isFalse,
      );
      expect(
        const CelebrationMessageOptions(message: 'x', showMessage: false)
            .shouldPaintText,
        isFalse,
      );
    });

    test('withDefaults forwards fields', () {
      final o = CelebrationMessageOptions.withDefaults(
        'Congratulations! 🎉',
        durationInSeconds: 3,
        style: const TextStyle(fontSize: 22),
        decoration: BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
      );
      expect(o.effectiveMessage, 'Congratulations! 🎉');
      expect(o.durationInSeconds, 3);
      expect(o.alignment, Alignment.center);
      expect(o.decoration, isNotNull);
    });
  });
}
