import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_confetti_engine/src/tick_confetti_physics.dart';
import 'package:flutter_confetti_engine/src/tick_confetti_spawn_options.dart';

void main() {
  test('TickConfettiPhysics.update moves origin each tick step', () {
    final p = TickConfettiPhysics.spawn(
      emitterX: 100,
      emitterY: 200,
      options: const TickConfettiSpawnOptions(
        angle: 90,
        spread: 10,
        startVelocity: 40,
        decay: 0.95,
        gravity: 0.5,
        drift: 0,
        flat: true,
        scalar: 1,
        ticks: 50,
      ),
      color: Colors.red,
    );
    final x0 = p.x;
    final y0 = p.y;
    p.update();
    expect(p.x, isNot(equals(x0)));
    expect(p.y, isNot(equals(y0)));
    expect(p.finished, isFalse);
  });

  test('TickConfettiPhysics.spawn respects tick budget', () {
    final p = TickConfettiPhysics.spawn(
      emitterX: 0,
      emitterY: 0,
      options: const TickConfettiSpawnOptions(ticks: 2),
      color: Colors.blue,
    );
    p.update();
    p.update();
    expect(p.finished, isFalse);
    p.update();
    expect(p.finished, isTrue);
  });
}
