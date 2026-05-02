import 'package:flutter/foundation.dart';

import 'builtin_sound.dart';
import 'bundled_sounds.dart';
import 'presets.dart';

/// Groups haptic and audio settings for [ConfettiWidget] and [ConfettiEngine].
///
/// **Sound** — three approaches, pick one per celebration:
///
/// 1. **Built-in clip** — set [builtinSound] to [BuiltinSound.pop] or
///    [BuiltinSound.chime].  No extra `pubspec.yaml` setup required.
/// 2. **Preset-matched clip** — use the [bundledForPreset] factory and the
///    package chooses the right built-in automatically.
/// 3. **Your own file** — register an asset in your app's `pubspec.yaml` and
///    pass its path via [soundAssetPath] or the [customAsset] factory.
///
/// When both [builtinSound] and [soundAssetPath] are set, [soundAssetPath]
/// takes priority.  Only one should be set at a time.
///
/// **Toggles** — [enableSound] and [enableHaptics] are independent.
/// When [enableSound] is false, all sound fields are ignored.
///
/// Use this object to drive feedback from app state or user preferences without
/// threading multiple booleans through every call site.
@immutable
class CelebrationFeedback {
  /// Creates feedback settings.
  ///
  /// Provide at most one of [builtinSound] or [soundAssetPath].
  /// Both are ignored when [enableSound] is `false`.
  const CelebrationFeedback({
    this.enableHaptics = true,
    this.enableSound = false,
    this.builtinSound,
    this.soundAssetPath,
  });

  /// No platform haptics and no audio.
  const CelebrationFeedback.none()
      : enableHaptics = false,
        enableSound = false,
        builtinSound = null,
        soundAssetPath = null;

  /// Preset-specific haptics only; no audio.
  const CelebrationFeedback.hapticsOnly()
      : enableHaptics = true,
        enableSound = false,
        builtinSound = null,
        soundAssetPath = null;

  /// Plays the [BuiltinSound] best matched to [preset].
  ///
  /// No asset registration needed — clips are bundled with the package.
  factory CelebrationFeedback.bundledForPreset(
    Preset preset, {
    bool enableHaptics = true,
    bool enableSound = true,
  }) {
    return CelebrationFeedback(
      enableHaptics: enableHaptics,
      enableSound: enableSound,
      builtinSound: ConfettiBundledSounds.builtinForPreset(preset),
    );
  }

  /// Your own audio file (path from your app's `flutter: assets:` list).
  factory CelebrationFeedback.customAsset(
    String soundAssetPath, {
    bool enableHaptics = true,
    bool enableSound = true,
  }) {
    return CelebrationFeedback(
      enableHaptics: enableHaptics,
      enableSound: enableSound,
      soundAssetPath: soundAssetPath,
    );
  }

  /// Whether to fire [HapticFeedback] at animation start.
  final bool enableHaptics;

  /// Whether to play audio when the animation starts.
  final bool enableSound;

  /// A built-in synthesized clip shipped with the package.
  ///
  /// Ignored when [soundAssetPath] is also set (custom path wins).
  /// Ignored when [enableSound] is `false`.
  final BuiltinSound? builtinSound;

  /// Flutter asset path for a custom sound (e.g. `'assets/sounds/cheer.mp3'`).
  ///
  /// Takes priority over [builtinSound] when both are set.
  /// Ignored when [enableSound] is `false`.
  final String? soundAssetPath;

  /// The asset path that will actually be played.
  ///
  /// Returns [soundAssetPath] if set, otherwise [builtinSound]'s path,
  /// otherwise `null` (silent).
  String? get resolvedSoundPath => soundAssetPath ?? builtinSound?.assetPath;

  /// Returns a copy with the given fields replaced.
  CelebrationFeedback copyWith({
    bool? enableHaptics,
    bool? enableSound,
    BuiltinSound? builtinSound,
    String? soundAssetPath,
  }) {
    return CelebrationFeedback(
      enableHaptics: enableHaptics ?? this.enableHaptics,
      enableSound: enableSound ?? this.enableSound,
      builtinSound: builtinSound ?? this.builtinSound,
      soundAssetPath: soundAssetPath ?? this.soundAssetPath,
    );
  }
}
