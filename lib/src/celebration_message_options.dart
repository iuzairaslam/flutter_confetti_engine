import 'package:flutter/material.dart';

/// Text banner layered over full-screen particle celebration.
///
/// Pass to [ConfettiEngine.celebrate] as `overlayMessage`, or build via
/// [CelebrationMessageOptions.withDefaults].
@immutable
class CelebrationMessageOptions {
  /// Creates message styling for the overlay.
  const CelebrationMessageOptions({
    required this.message,
    this.showMessage = true,
    this.alignment = Alignment.bottomCenter,
    this.outerPadding = const EdgeInsets.fromLTRB(24, 0, 24, 56),
    this.textAlign = TextAlign.center,
    this.style,
    this.decoration,
    this.innerPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    this.durationInSeconds,
  });

  /// Copy with common defaults for a celebratory line (like pub examples).
  factory CelebrationMessageOptions.withDefaults(
    String message, {
    bool showMessage = true,
    Alignment alignment = Alignment.bottomCenter,
    EdgeInsets outerPadding = const EdgeInsets.fromLTRB(24, 0, 24, 56),
    TextAlign textAlign = TextAlign.center,
    TextStyle? style,
    BoxDecoration? decoration,
    EdgeInsets innerPadding =
        const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    int? durationInSeconds,
  }) {
    return CelebrationMessageOptions(
      message: message,
      showMessage: showMessage,
      alignment: alignment,
      outerPadding: outerPadding,
      textAlign: textAlign,
      style: style,
      decoration: decoration,
      innerPadding: innerPadding,
      durationInSeconds: durationInSeconds,
    );
  }

  /// Banner text (emojis allowed).
  final String message;

  /// When `false`, no text widget is built (confetti only).
  final bool showMessage;

  /// Where to anchor the padded text block in the overlay [Stack].
  final Alignment alignment;

  /// Space around the text (or decorated container) inside the [alignment] slot.
  final EdgeInsets outerPadding;

  /// Paragraph alignment inside [Text].
  final TextAlign textAlign;

  /// Typographic style; defaults to a white, shadowed title in the engine host.
  final TextStyle? style;

  /// Optional background / border around the label (e.g. rounded frosted bar).
  final BoxDecoration? decoration;

  /// Padding inside [decoration]; ignored when [decoration] is null.
  final EdgeInsets innerPadding;

  /// When non-null, the **entire overlay** (confetti + message) is dismissed
  /// after this many seconds at minimum **1** (clamped to **3600** in the engine).
  /// If particles finish earlier, the overlay still closes then.
  ///
  /// When **null**, dismissal follows particle lifetime only.
  final int? durationInSeconds;

  /// Effective trimmed message — empty means “don’t paint text”.
  String get effectiveMessage => message.trim();

  /// Whether the engine should paint a text layer.
  bool get shouldPaintText =>
      showMessage && effectiveMessage.isNotEmpty;
}
