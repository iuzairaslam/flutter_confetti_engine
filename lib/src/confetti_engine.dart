import 'dart:async';

import 'package:flutter/material.dart';

import 'celebration_feedback.dart';
import 'celebration_message_options.dart';
import 'celebration_scene.dart';
import 'confetti_customization.dart';
import 'confetti_showcase.dart';
import 'confetti_widget.dart';
import 'presets.dart';

/// The primary entry point for flutter_confetti_engine.
///
/// Provides a static one-liner API that inserts a full-screen confetti
/// overlay, plays the animation (with optional haptics and sound), and
/// removes itself automatically when all particles have faded.
///
/// **Minimal usage:**
/// ```dart
/// ConfettiEngine.celebrate(context);
/// ```
///
/// **With options:**
/// ```dart
/// ConfettiEngine.celebrate(
///   context,
///   preset: Preset.nova,
///   enableSound: true,
///   soundAssetPath: 'assets/sounds/cheer.mp3',
/// );
/// ```
///
/// Only one overlay can be active at a time. Calling [celebrate] while an
/// animation is already running will dismiss the previous one first.
///
/// For region-constrained animations or manual lifecycle control, use
/// [ConfettiWidget] and [ConfettiController] directly.
abstract final class ConfettiEngine {
  // Private constructor — static-only class.
  ConfettiEngine._();

  static OverlayEntry? _current;

  /// Shows a full-screen confetti animation above the current route.
  ///
  /// - [context] — any [BuildContext] within the widget tree. Used to obtain
  ///   the nearest [Overlay].
  /// - [preset] — animation style. Defaults to [Preset.nova].
  /// - [enableHaptics] — fires platform haptic feedback at animation start.
  ///   Defaults to `true`.
  /// - [enableSound] — plays the asset at [soundAssetPath] when the animation
  ///   starts. Defaults to `false`. Failures are caught silently.
  /// - [soundAssetPath] — Flutter asset path registered in the consuming app's
  ///   pubspec.yaml (e.g. `'assets/sounds/cheer.mp3'`). Ignored when
  ///   [enableSound] is `false`. Use trusted paths only — do not pass raw
  ///   user-supplied strings without allowlisting.
  /// - [feedback] — optional grouped haptic/audio settings. When non-null,
  ///   **overrides** [enableHaptics], [enableSound], and [soundAssetPath] so
  ///   you can bind one object from app state (e.g. user toggles).
  /// - [emojiPool] — unicode strings for emoji-shaped particles; see
  ///   [ConfettiWidget.emojiPool].
  /// - [scene] — optional [CelebrationScene] (preset + base customization), e.g.
  ///   [CelebrationScene.fromConfettiType], [CelebrationScene.compose], or
  ///   [CelebrationScene.themed]. When non-null,
  ///   [CelebrationScene.preset] overrides [preset], and [CelebrationScene.customization]
  ///   is merged under [customization] (call-site wins per field).
  /// - [customization] — optional count / colors / shapes / physics; see
  ///   [ConfettiCustomization].
  /// - [overlayMessage] — optional banner ([CelebrationMessageOptions]): text,
  ///   alignment, padding, [TextStyle], [BoxDecoration], and/or
  ///   [CelebrationMessageOptions.durationInSeconds] to cap overlay lifetime.
  /// - [showcase] — optional curated tick burst ([ConfettiShowcase]); when
  ///   non-null, drives particles instead of [preset].
  /// - [onComplete] — called once when all particles have faded and the
  ///   overlay has been removed.
  ///
  /// When no [Overlay] ancestor exists (e.g. wrong context), this returns
  /// immediately without showing anything — it does not throw.
  static void celebrate(
    BuildContext context, {
    Preset preset = Preset.nova,
    CelebrationScene? scene,
    ConfettiShowcase? showcase,
    bool enableHaptics = true,
    bool enableSound = false,
    String? soundAssetPath,
    CelebrationFeedback? feedback,
    List<String>? emojiPool,
    ConfettiCustomization? customization,
    CelebrationMessageOptions? overlayMessage,
    VoidCallback? onComplete,
  }) {
    // Dismiss any running animation first.
    dismiss();

    final overlay = Overlay.maybeOf(context);
    if (overlay == null) return;

    final effectivePreset = scene?.preset ?? preset;
    final effectiveCustomization =
        ConfettiCustomization.merge(scene?.customization, customization);

    OverlayEntry? entry;

    void removeEntry() {
      entry?.remove();
      if (_current == entry) _current = null;
      onComplete?.call();
    }

    final msg = overlayMessage;
    final showBanner = msg != null && msg.shouldPaintText;
    final useHost = showBanner || (msg?.durationInSeconds != null);

    if (useHost && msg != null) {
      entry = OverlayEntry(
        builder: (_) => _CelebrationOverlayHost(
          preset: effectivePreset,
          showcase: showcase,
          customization: effectiveCustomization,
          feedback: feedback,
          enableHaptics: enableHaptics,
          enableSound: enableSound,
          soundAssetPath: soundAssetPath,
          emojiPool: emojiPool,
          messageOptions: msg,
          showMessageLayer: showBanner,
          onFinished: removeEntry,
        ),
      );
    } else {
      entry = OverlayEntry(
        builder: (_) => IgnorePointer(
          child: ConfettiWidget(
            preset: effectivePreset,
            showcase: showcase,
            autoPlay: true,
            feedback: feedback,
            enableHaptics: enableHaptics,
            enableSound: enableSound,
            soundAssetPath: soundAssetPath,
            emojiPool: emojiPool,
            customization: effectiveCustomization,
            onComplete: removeEntry,
          ),
        ),
      );
    }

    _current = entry;
    overlay.insert(entry);
  }

  /// Full-screen confetti plus an optional styled banner message.
  ///
  /// Prefer [celebrate] with [CelebrationMessageOptions] for full control.
  /// Touches pass through the overlay (including the label).
  static void celebrateWithMessage(
    BuildContext context, {
    required String message,
    Preset preset = Preset.nova,
    CelebrationScene? scene,
    ConfettiShowcase? showcase,
    bool enableHaptics = true,
    bool enableSound = false,
    String? soundAssetPath,
    CelebrationFeedback? feedback,
    List<String>? emojiPool,
    ConfettiCustomization? customization,
    TextStyle? messageStyle,
    Alignment messageAlignment = Alignment.bottomCenter,
    EdgeInsets messageOuterPadding =
        const EdgeInsets.fromLTRB(24, 0, 24, 56),
    TextAlign messageTextAlign = TextAlign.center,
    BoxDecoration? messageDecoration,
    EdgeInsets messageInnerPadding =
        const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    int? durationInSeconds,
    bool showMessage = true,
    VoidCallback? onComplete,
  }) {
    celebrate(
      context,
      preset: preset,
      scene: scene,
      showcase: showcase,
      enableHaptics: enableHaptics,
      enableSound: enableSound,
      soundAssetPath: soundAssetPath,
      feedback: feedback,
      emojiPool: emojiPool,
      customization: customization,
      overlayMessage: CelebrationMessageOptions(
        message: message,
        showMessage: showMessage,
        alignment: messageAlignment,
        outerPadding: messageOuterPadding,
        textAlign: messageTextAlign,
        style: messageStyle,
        decoration: messageDecoration,
        innerPadding: messageInnerPadding,
        durationInSeconds: durationInSeconds,
      ),
      onComplete: onComplete,
    );
  }

  /// Celebrates inside a transparent, edge-to-edge [Dialog] (modal full-screen
  /// celebration overlay).
  ///
  /// Returns a [Future] that completes when the dialog route is popped: either
  /// after particles finish, when [CelebrationMessageOptions.durationInSeconds]
  /// elapses, or when the user dismisses the barrier (if [barrierDismissible]
  /// is true). [onComplete] runs immediately before the route is popped from a
  /// **successful** finish (particles or timer), not when the barrier dismisses
  /// the dialog.
  ///
  /// Does nothing when [Navigator.maybeOf] is null.
  static Future<void> celebrateInDialog(
    BuildContext context, {
    Preset preset = Preset.nova,
    CelebrationScene? scene,
    ConfettiShowcase? showcase,
    bool enableHaptics = true,
    bool enableSound = false,
    String? soundAssetPath,
    CelebrationFeedback? feedback,
    List<String>? emojiPool,
    ConfettiCustomization? customization,
    CelebrationMessageOptions? overlayMessage,
    VoidCallback? onComplete,
    bool barrierDismissible = false,
    Color? barrierColor,
    bool useSafeArea = true,
  }) async {
    final navigator = Navigator.maybeOf(context);
    if (navigator == null) return;

    final effectivePreset = scene?.preset ?? preset;
    final effectiveCustomization =
        ConfettiCustomization.merge(scene?.customization, customization);

    final msg = overlayMessage;
    final messageOptions =
        msg ?? const CelebrationMessageOptions(message: '');
    final showBanner = msg != null && msg.shouldPaintText;

    return showDialog<void>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor ?? const Color(0x80000000),
      useSafeArea: useSafeArea,
      builder: (dialogContext) {
        return _CelebrationDialogHost(
          preset: effectivePreset,
          showcase: showcase,
          customization: effectiveCustomization,
          feedback: feedback,
          enableHaptics: enableHaptics,
          enableSound: enableSound,
          soundAssetPath: soundAssetPath,
          emojiPool: emojiPool,
          messageOptions: messageOptions,
          showMessageLayer: showBanner,
          onFinished: () {
            onComplete?.call();
            if (dialogContext.mounted) {
              Navigator.of(dialogContext).pop();
            }
          },
        );
      },
    );
  }

  /// Immediately removes any active confetti overlay.
  ///
  /// Safe to call even when no animation is running.
  static void dismiss() {
    _current?.remove();
    _current = null;
  }
}

/// Caps lifetime via [CelebrationMessageOptions.durationInSeconds] and paints
/// optional text; finishes when particles complete **or** timer fires.
class _CelebrationOverlayHost extends StatefulWidget {
  const _CelebrationOverlayHost({
    required this.preset,
    this.showcase,
    required this.customization,
    required this.feedback,
    required this.enableHaptics,
    required this.enableSound,
    required this.soundAssetPath,
    required this.emojiPool,
    required this.messageOptions,
    required this.showMessageLayer,
    required this.onFinished,
  });

  final Preset preset;
  final ConfettiShowcase? showcase;
  final ConfettiCustomization? customization;
  final CelebrationFeedback? feedback;
  final bool enableHaptics;
  final bool enableSound;
  final String? soundAssetPath;
  final List<String>? emojiPool;
  final CelebrationMessageOptions messageOptions;
  final bool showMessageLayer;
  final VoidCallback onFinished;

  @override
  State<_CelebrationOverlayHost> createState() =>
      _CelebrationOverlayHostState();
}

class _CelebrationOverlayHostState extends State<_CelebrationOverlayHost> {
  Timer? _timer;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    final raw = widget.messageOptions.durationInSeconds;
    if (raw != null && raw > 0) {
      var secs = raw;
      if (secs < 1) secs = 1;
      if (secs > 3600) secs = 3600;
      _timer = Timer(Duration(seconds: secs), _finishOnce);
    }
  }

  void _finishOnce() {
    if (_finished) return;
    _finished = true;
    _timer?.cancel();
    widget.onFinished();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  static const TextStyle _defaultMessageStyle = TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    decoration: TextDecoration.none,
    decorationThickness: 0,
    shadows: [
      Shadow(blurRadius: 10, color: Colors.black54),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: ConfettiWidget(
              preset: widget.preset,
              showcase: widget.showcase,
              autoPlay: true,
              feedback: widget.feedback,
              enableHaptics: widget.enableHaptics,
              enableSound: widget.enableSound,
              soundAssetPath: widget.soundAssetPath,
              emojiPool: widget.emojiPool,
              customization: widget.customization,
              onComplete: _finishOnce,
            ),
          ),
        ),
        if (widget.showMessageLayer)
          IgnorePointer(
            child: Align(
              alignment: widget.messageOptions.alignment,
              child: Padding(
                padding: widget.messageOptions.outerPadding,
                child: _buildMessageChild(),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMessageChild() {
    final o = widget.messageOptions;
    final baseStyle = o.style ?? _defaultMessageStyle;
    final resolvedStyle = baseStyle.merge(
      const TextStyle(decoration: TextDecoration.none, decorationThickness: 0),
    );
    Widget text = Text(
      o.effectiveMessage,
      textAlign: o.textAlign,
      style: resolvedStyle,
    );
    if (o.decoration != null) {
      text = Container(
        decoration: o.decoration,
        padding: o.innerPadding,
        child: text,
      );
    }
    return text;
  }
}

/// [Dialog]-hosted celebration (see [ConfettiEngine.celebrateInDialog]).
class _CelebrationDialogHost extends StatefulWidget {
  const _CelebrationDialogHost({
    required this.preset,
    this.showcase,
    required this.customization,
    required this.feedback,
    required this.enableHaptics,
    required this.enableSound,
    required this.soundAssetPath,
    required this.emojiPool,
    required this.messageOptions,
    required this.showMessageLayer,
    required this.onFinished,
  });

  final Preset preset;
  final ConfettiShowcase? showcase;
  final ConfettiCustomization? customization;
  final CelebrationFeedback? feedback;
  final bool enableHaptics;
  final bool enableSound;
  final String? soundAssetPath;
  final List<String>? emojiPool;
  final CelebrationMessageOptions messageOptions;
  final bool showMessageLayer;
  final VoidCallback onFinished;

  @override
  State<_CelebrationDialogHost> createState() => _CelebrationDialogHostState();
}

class _CelebrationDialogHostState extends State<_CelebrationDialogHost> {
  Timer? _timer;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    final raw = widget.messageOptions.durationInSeconds;
    if (raw != null && raw > 0) {
      var secs = raw;
      if (secs < 1) secs = 1;
      if (secs > 3600) secs = 3600;
      _timer = Timer(Duration(seconds: secs), _finishOnce);
    }
  }

  void _finishOnce() {
    if (_finished) return;
    _finished = true;
    _timer?.cancel();
    widget.onFinished();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  static const TextStyle _defaultMessageStyle = TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    decoration: TextDecoration.none,
    decorationThickness: 0,
    shadows: [
      Shadow(blurRadius: 10, color: Colors.black54),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: ConfettiWidget(
                  preset: widget.preset,
                  showcase: widget.showcase,
                  autoPlay: true,
                  feedback: widget.feedback,
                  enableHaptics: widget.enableHaptics,
                  enableSound: widget.enableSound,
                  soundAssetPath: widget.soundAssetPath,
                  emojiPool: widget.emojiPool,
                  customization: widget.customization,
                  onComplete: _finishOnce,
                ),
              ),
            ),
            if (widget.showMessageLayer)
              IgnorePointer(
                child: Align(
                  alignment: widget.messageOptions.alignment,
                  child: Padding(
                    padding: widget.messageOptions.outerPadding,
                    child: _buildMessageChild(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageChild() {
    final o = widget.messageOptions;
    final baseStyle = o.style ?? _defaultMessageStyle;
    final resolvedStyle = baseStyle.merge(
      const TextStyle(decoration: TextDecoration.none, decorationThickness: 0),
    );
    Widget text = Text(
      o.effectiveMessage,
      textAlign: o.textAlign,
      style: resolvedStyle,
    );
    if (o.decoration != null) {
      text = Container(
        decoration: o.decoration,
        padding: o.innerPadding,
        child: text,
      );
    }
    return text;
  }
}
