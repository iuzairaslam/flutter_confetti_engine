/// The visual shape rendered for each confetti particle.
///
/// Presets pick a shape mix; the painter maps each value to a canvas primitive.
///
/// All shapes are drawn centered on (0, 0) in the particle's local coordinate
/// space — the canvas is translated to the particle's world position before
/// drawing.
enum ParticleShape {
  /// Five-pointed star drawn with alternating outer/inner radius vertices.
  star,

  /// Axis-aligned rectangle for default “paper” strips (matrix-path preset draws).
  paper,

  /// Wide, flat rectangle that tumbles like a paper streamer.
  ribbon,

  /// A single unicode emoji character (e.g. 🎉).
  /// The emoji string is stored on the simulation particle when this shape is used.
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
