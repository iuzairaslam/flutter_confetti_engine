import 'builtin_sound.dart';
import 'presets.dart';

/// Helpers for the 10 audio clips shipped with this package.
///
/// All clips are 100 % original WAV files synthesized in Python, MIT-licensed,
/// zero external dependencies:
///
/// | Clip                         | Duration | Character                          |
/// |------------------------------|----------|------------------------------------|
/// | [BuiltinSound.pop]           | ~0.4 s   | Punchy confetti snap               |
/// | [BuiltinSound.chime]         | ~2.2 s   | C-major bell chord                 |
/// | [BuiltinSound.fanfare]       | ~1.6 s   | Triumphant brass fanfare           |
/// | [BuiltinSound.applause]      | ~2.0 s   | Crowd clapping                     |
/// | [BuiltinSound.whoosh]        | ~0.55 s  | Fast frequency sweep               |
/// | [BuiltinSound.drumroll]      | ~1.6 s   | Snare roll + cymbal crash          |
/// | [BuiltinSound.levelUp]       | ~1.0 s   | 8-bit arpeggio jingle              |
/// | [BuiltinSound.bell]          | ~2.2 s   | Clear resonant bell                |
/// | [BuiltinSound.sparkle]       | ~1.4 s   | Magical high-freq twinkling        |
/// | [BuiltinSound.airhorn]       | ~0.85 s  | Bold air-horn blast                |
///
/// ### Auto-pick by preset
/// ```dart
/// ConfettiEngine.celebrate(
///   context,
///   preset: Preset.nova,
///   feedback: CelebrationFeedback.bundledForPreset(Preset.nova),
/// );
/// ```
///
/// ### Pick any clip directly
/// ```dart
/// ConfettiEngine.celebrate(
///   context,
///   feedback: CelebrationFeedback(
///     enableSound: true,
///     builtinSound: BuiltinSound.fanfare,
///   ),
/// );
/// ```
abstract final class ConfettiBundledSounds {
  ConfettiBundledSounds._();

  // ── Convenience path getters ────────────────────────────────────────────

  /// Asset path for [BuiltinSound.pop].
  static String get pop => BuiltinSound.pop.assetPath;

  /// Asset path for [BuiltinSound.chime].
  static String get chime => BuiltinSound.chime.assetPath;

  /// Asset path for [BuiltinSound.fanfare].
  static String get fanfare => BuiltinSound.fanfare.assetPath;

  /// Asset path for [BuiltinSound.applause].
  static String get applause => BuiltinSound.applause.assetPath;

  /// Asset path for [BuiltinSound.whoosh].
  static String get whoosh => BuiltinSound.whoosh.assetPath;

  /// Asset path for [BuiltinSound.drumroll].
  static String get drumroll => BuiltinSound.drumroll.assetPath;

  /// Asset path for [BuiltinSound.levelUp].
  static String get levelUp => BuiltinSound.levelUp.assetPath;

  /// Asset path for [BuiltinSound.bell].
  static String get bell => BuiltinSound.bell.assetPath;

  /// Asset path for [BuiltinSound.sparkle].
  static String get sparkle => BuiltinSound.sparkle.assetPath;

  /// Asset path for [BuiltinSound.airhorn].
  static String get airhorn => BuiltinSound.airhorn.assetPath;

  // ── Preset mapping ───────────────────────────────────────────────────────

  /// Returns the [BuiltinSound] best matched to [preset].
  static BuiltinSound builtinForPreset(Preset preset) {
    switch (preset) {
      case Preset.nova:
      case Preset.crossfire:
        return BuiltinSound.pop;
      case Preset.cascade:
        return BuiltinSound.fanfare;
      case Preset.flare:
        return BuiltinSound.chime;
    }
  }

  /// Asset path of the clip best matched to [preset].
  ///
  /// Equivalent to `builtinForPreset(preset).assetPath`.
  static String pathForPreset(Preset preset) =>
      builtinForPreset(preset).assetPath;
}
