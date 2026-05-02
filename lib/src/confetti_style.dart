import 'particle_shape.dart';

/// High-level particle appearance presets.
///
/// Maps to [ParticleShape] mixes via [ConfettiStyleShapes.shapesFor].
enum ConfettiStyle {
  /// Simple circles ([ParticleShape.circle]).
  circles,

  /// Star shapes ([ParticleShape.star]).
  stars,

  /// Emoji characters ([ParticleShape.emoji]).
  symbols,

  /// Ribbon strips ([ParticleShape.ribbon]).
  streamers,

  /// Paper squares ([ParticleShape.square]).
  squares,
}

/// Resolves [ConfettiStyle] to [ConfettiCustomization.shapeMix] entries.
abstract final class ConfettiStyleShapes {
  ConfettiStyleShapes._();

  /// Shape list for [style] — safe for [ConfettiCustomization.shapeMix].
  static List<ParticleShape> shapesFor(ConfettiStyle style) {
    switch (style) {
      case ConfettiStyle.circles:
        return const [ParticleShape.circle];
      case ConfettiStyle.stars:
        return const [ParticleShape.star];
      case ConfettiStyle.symbols:
        return const [ParticleShape.emoji];
      case ConfettiStyle.streamers:
        return const [ParticleShape.ribbon];
      case ConfettiStyle.squares:
        return const [ParticleShape.square];
    }
  }
}
