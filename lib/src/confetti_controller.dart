import 'package:flutter/foundation.dart';

/// The state of a [ConfettiController].
enum ControllerState {
  /// No animation has been started yet (initial state after construction or [ConfettiController.reset]).
  idle,

  /// The animation is currently running.
  playing,

  /// The animation was stopped before completing naturally.
  stopped,
}

/// Drives a [ConfettiWidget] manually.
///
/// Use when you need to start, stop, or reset confetti from outside the widget
/// tree — for example, from a button press handler.
///
/// ```dart
/// final controller = ConfettiController();
///
/// // In your widget tree:
/// ConfettiWidget(controller: controller, autoPlay: false, preset: Preset.nova)
///
/// // Triggered by a button:
/// controller.play();
///
/// // Always dispose:
/// @override
/// void dispose() {
///   controller.dispose();
///   super.dispose();
/// }
/// ```
///
/// [ConfettiController] extends [ChangeNotifier]. [ConfettiWidget] listens
/// internally — you don't need to call `addListener` yourself.
class ConfettiController extends ChangeNotifier {
  ControllerState _state = ControllerState.idle;

  /// The current lifecycle state of the animation.
  ControllerState get state => _state;

  /// Convenience getter — true while the animation is running.
  bool get isPlaying => _state == ControllerState.playing;

  /// Starts or restarts the confetti animation.
  ///
  /// If the animation is already playing this is a no-op; call [ConfettiController.reset] first
  /// if you want to replay from the beginning.
  void play() {
    if (_state == ControllerState.playing) return;
    _state = ControllerState.playing;
    notifyListeners();
  }

  /// Halts the animation mid-flight. Particles freeze in place.
  ///
  /// Call [ConfettiController.reset] to also clear the frozen particles from the canvas.
  void stop() {
    if (_state == ControllerState.stopped) return;
    _state = ControllerState.stopped;
    notifyListeners();
  }

  /// Stops the animation and clears all particles, returning to [ControllerState.idle].
  void reset() {
    _state = ControllerState.idle;
    notifyListeners();
  }

  /// Clears the burst immediately (manual stop).
  void kill() => reset();
}
