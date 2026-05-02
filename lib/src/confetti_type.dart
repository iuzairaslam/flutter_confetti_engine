/// Semantic party outcome categories.
///
/// Use [CelebrationScene.fromConfettiType] for preset + palette defaults. You can
/// still override via [ConfettiCustomization] when calling [ConfettiEngine.celebrate].
enum ConfettiType {
  /// Positive outcome — cool greens / blues, rain-like calm motion by default.
  triumph,

  /// Negative outcome — muted reds / grays, subdued rain preset by default.
  dropped,

  /// General party moment — fireworks + rainbow palette by default.
  party,

  /// Trophy-style — fireworks + gold tones by default.
  milestone,

  /// Progress milestone — burst + neon palette by default.
  rankUp,
}
