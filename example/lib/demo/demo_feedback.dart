import 'package:flutter_confetti_engine/flutter_confetti_engine.dart';

/// Default feedback used by dialogs, banners, and showcase tiles.
/// Plays [BuiltinSound.pop] — no extra asset setup needed.
CelebrationFeedback demoCelebrationFeedback() {
  return const CelebrationFeedback(
    enableHaptics: true,
    enableSound: true,
    builtinSound: BuiltinSound.pop,
  );
}

/// Feedback for a specific preset — auto-picks the matching built-in clip:
/// - [Preset.nova] / [Preset.crossfire] → [BuiltinSound.pop]
/// - [Preset.cascade]   / [Preset.flare]   → [BuiltinSound.chime]
CelebrationFeedback demoFeedbackForPreset(Preset preset) {
  return CelebrationFeedback.bundledForPreset(preset);
}
