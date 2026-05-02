/// Built-in synthesized audio clips shipped with flutter_confetti_engine.
///
/// All 10 clips are 100 % original, synthesized in Python, and released under
/// the same MIT licence as the package — safe to redistribute. No external
/// assets or `pubspec.yaml` entries needed.
///
/// ```dart
/// // Pick a clip:
/// ConfettiEngine.celebrate(
///   context,
///   feedback: CelebrationFeedback(
///     enableSound: true,
///     builtinSound: BuiltinSound.fanfare,
///   ),
/// );
///
/// // Auto-pick the best clip for a preset:
/// CelebrationFeedback.bundledForPreset(Preset.nova);
///
/// // Raw asset path for use with audioplayers directly:
/// AudioPlayer().play(AssetSource(BuiltinSound.levelUp.assetPath));
/// ```
enum BuiltinSound {
  /// Short, punchy confetti-popper snap (~0.4 s).
  /// Great for quick bursts — [Preset.nova], [Preset.crossfire].
  pop,

  /// Bright C-major bell chord with inharmonic overtones (~2.2 s).
  /// Great for streaming presets — [Preset.cascade], [Preset.flare].
  chime,

  /// Triumphant 4-note ascending brass fanfare (~1.6 s).
  /// Perfect for big achievement moments.
  fanfare,

  /// Crowd clapping and cheering (~2.0 s).
  /// Ideal for task completions, leaderboards, and congrats screens.
  applause,

  /// Fast, sweeping whoosh (~0.55 s).
  /// Great for swipe gestures, quick transitions, or speed rewards.
  whoosh,

  /// Accelerating snare roll ending in a cymbal crash (~1.6 s).
  /// Perfect for countdowns, reveals, or dramatic moments.
  drumroll,

  /// 8-bit style ascending arpeggio with chord tail (~1.0 s).
  /// Classic video game level-up feel — works with any burst preset.
  levelUp,

  /// Clear resonant D5 bell with long inharmonic decay (~2.2 s).
  /// Great for single-note dings, notifications, or gentle wins.
  bell,

  /// Magical high-frequency twinkling sparkle (~1.4 s).
  /// Perfect for emoji/star effects — [ConfettiShowcase.starField], [ConfettiShowcase.emojiPop].
  sparkle,

  /// Short, bold air-horn blast (~0.85 s).
  /// High-energy — great for sports wins, perfect scores, big milestones.
  airhorn;

  static const String _base = 'packages/flutter_confetti_engine/assets/sounds';

  /// Flutter asset path for this clip.
  ///
  /// Already prefixed with `packages/flutter_confetti_engine/…` so you never
  /// need to register the files in your own app's `pubspec.yaml` — Flutter
  /// merges package assets automatically.
  String get assetPath => '$_base/$name.wav';
}
