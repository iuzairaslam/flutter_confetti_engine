import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_confetti_engine/flutter_confetti_engine.dart';

void main() {
  group('ConfettiController', () {
    late ConfettiController controller;

    setUp(() => controller = ConfettiController());
    tearDown(() => controller.dispose());

    test('starts in idle state', () {
      expect(controller.state, equals(ControllerState.idle));
      expect(controller.isPlaying, isFalse);
    });

    test('play() transitions to playing', () {
      controller.play();
      expect(controller.state, equals(ControllerState.playing));
      expect(controller.isPlaying, isTrue);
    });

    test('stop() transitions to stopped', () {
      controller.play();
      controller.stop();
      expect(controller.state, equals(ControllerState.stopped));
      expect(controller.isPlaying, isFalse);
    });

    test('reset() returns to idle', () {
      controller.play();
      controller.stop();
      controller.reset();
      expect(controller.state, equals(ControllerState.idle));
    });

    test('play() is no-op when already playing', () {
      controller.play();
      var notifyCount = 0;
      controller.addListener(() => notifyCount++);
      controller.play(); // should not notify again
      expect(notifyCount, equals(0));
    });

    test('stop() is no-op when already stopped', () {
      controller.play();
      controller.stop();
      var notifyCount = 0;
      controller.addListener(() => notifyCount++);
      controller.stop(); // should not notify again
      expect(notifyCount, equals(0));
    });

    test('notifies listeners on state change', () {
      final states = <ControllerState>[];
      controller.addListener(() => states.add(controller.state));

      controller.play();
      controller.stop();
      controller.reset();

      expect(states, [
        ControllerState.playing,
        ControllerState.stopped,
        ControllerState.idle,
      ]);
    });
  });
}
