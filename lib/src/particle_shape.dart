/// The visual shape rendered for each confetti particle.
///
/// Used by [PresetFactory] to configure particles and by [ConfettiPainter]
/// to decide which canvas primitive to draw.
///
/// All shapes are drawn centered on (0, 0) in the particle's local coordinate
/// space — the canvas is translated to the particle's world position before
/// [ConfettiPainter] draws anything.
enum ParticleShape {
  /// Five-pointed star drawn with alternating outer/inner radius vertices.
  star,

  /// Axis-aligned rectangle for default “paper” strips (matrix-path preset draws).
  paper,

  /// Wide, flat rectangle that tumbles like a paper streamer.
  ribbon,

  /// A single unicode emoji character (e.g. 🎉).
  /// The emoji string is stored on the [Particle] via its [Particle.emoji] field.
  emoji,

  /// Filled circle / disc. The fastest shape to render.
  circle,

  /// Filled square. Tumbles like a confetti square.
  square,

  /// Filled equilateral triangle pointing upward.
  triangle,

  /// Regular pentagon inscribed in the particle’s bounding circle.
  pentagon,

  /// Regular hexagon inscribed in the particle’s bounding circle.
  hexagon,

  /// Ring / hollow disc — stroked circle with transparent interior.
  ring,

  /// Zigzag lightning bolt silhouette.
  lightning,

  /// Crescent moon (two overlapping circles, even-odd fill).
  crescent,

  /// Upward-pointing arrowhead with stem.
  arrow,
}
