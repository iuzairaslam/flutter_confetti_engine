import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'audio_player_wrapper.dart';
import 'celebration_feedback.dart';
import 'confetti_controller.dart';
import 'confetti_customization.dart';
import 'confetti_painter.dart';
import 'confetti_showcase.dart';
import 'particle.dart';
import 'presets.dart';

/// A widget that renders a confetti animation within its own bounds.
///
/// Place inside a [Stack] to overlay confetti on top of your content, or
/// constrain it to any region you like.
///
/// For a zero-configuration full-screen experience use
/// [ConfettiEngine.celebrate] instead.
///
/// **With autoPlay:**
/// ```dart
/// Stack(children: [
///   YourContent(),
///   ConfettiWidget(preset: Preset.nova),
/// ])
/// ```
///
/// **With a manual controller:**
/// ```dart
/// final _ctrl = ConfettiController();
///
/// ConfettiWidget(
///   preset: Preset.cascade,
///   controller: _ctrl,
///   autoPlay: false,
/// )
///
/// // Later:
/// _ctrl.play();
/// ```
///
/// **Driving haptics and sound from app state:**
/// ```dart
/// ConfettiWidget(
///   preset: Preset.nova,
///   feedback: CelebrationFeedback(
///     enableHaptics: settings.hapticsOn,
///     enableSound: settings.soundOn,
///     soundAssetPath: 'assets/sounds/cheer.mp3',
///   ),
/// )
/// ```
///
/// **Custom emoji pool for unicode particles:**
/// ```dart
/// ConfettiWidget(
///   preset: Preset.nova,
///   emojiPool: const ['🎮', '🏆', '💎'],
/// )
/// ```
class ConfettiWidget extends StatefulWidget {
  /// The animation style to use. Defaults to [Preset.nova].
  final Preset preset;

  /// Optional controller for programmatic play/stop/reset.
  ///
  /// If null, combine with [autoPlay] = true for fire-and-forget behaviour.
  final ConfettiController? controller;

  /// Whether to start the animation immediately after the first layout.
  ///
  /// Defaults to true. Set to false when using a [controller] to start manually.
  final bool autoPlay;

  /// Called once when all particles have faded and the animation is complete.
  final VoidCallback? onComplete;

  /// Whether to fire [HapticFeedback] at animation start. Defaults to true.
  ///
  /// Ignored when [feedback] is non-null (see [CelebrationFeedback]).
  ///
  /// The haptic pattern depends on [preset]:
  /// - burst / fireworks → [HapticFeedback.heavyImpact]
  /// - rain → [HapticFeedback.mediumImpact]
  /// - snow → no haptic
  final bool enableHaptics;

  /// Whether to play audio when the animation starts. Defaults to false.
  ///
  /// Ignored when [feedback] is non-null.
  ///
  /// Requires [soundAssetPath] to be non-null and the asset to be registered
  /// in the consuming app's pubspec.yaml.
  final bool enableSound;

  /// Flutter asset path for the sound file (e.g. `'assets/sounds/cheer.mp3'`).
  ///
  /// Ignored when [feedback] is non-null, or when effective enableSound is false.
  final String? soundAssetPath;

  /// Optional grouped haptic and audio settings.
  ///
  /// When non-null, **overrides** [enableHaptics], [enableSound], and
  /// [soundAssetPath] so you can bind one object (e.g. from [ValueNotifier]
  /// or settings) and update it when user preferences change.
  final CelebrationFeedback? feedback;

  /// Characters to randomly assign to [ParticleShape.emoji] particles.
  ///
  /// When null or empty, [kDefaultCelebrationEmojis] is used.
  ///
  /// Untrusted input is trimmed, length-limited per entry, and the pool size
  /// is capped internally to avoid excessive memory use.
  final List<String>? emojiPool;

  /// Optional overrides for count, colors, shapes, gravity, and scaling.
  final ConfettiCustomization? customization;

  /// When non-null, uses [ShowcaseParticleFactory] tick bursts ([preset] is
  /// ignored for spawn).
  final ConfettiShowcase? showcase;

  /// Creates a [ConfettiWidget].
  const ConfettiWidget({
    super.key,
    this.preset = Preset.nova,
    this.controller,
    this.autoPlay = true,
    this.onComplete,
    this.enableHaptics = true,
    this.enableSound = false,
    this.soundAssetPath,
    this.feedback,
    this.emojiPool,
    this.customization,
    this.showcase,
  });

  @override
  State<ConfettiWidget> createState() => _ConfettiWidgetState();
}

class _ConfettiWidgetState extends State<ConfettiWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animCtrl;
  List<Particle> _particles = [];
  Size? _size;
  double _lastTime = 0.0;
  AudioPlayerWrapper? _audio;

  /// Ensures [onComplete] runs at most once per animation cycle.
  bool _completionDispatched = false;

  bool get _effectiveHaptics =>
      widget.feedback?.enableHaptics ?? widget.enableHaptics;

  bool get _effectiveSound =>
      widget.feedback?.enableSound ?? widget.enableSound;

  String? get _effectiveSoundPath =>
      widget.feedback?.resolvedSoundPath ?? widget.soundAssetPath;

  // ─── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 6,
      ), // Safety ceiling — early-stop fires sooner.
    )
      ..addListener(_onTick)
      ..addStatusListener(_onStatus);

    widget.controller?.addListener(_onControllerChange);

    if (widget.autoPlay) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _start());
    }
  }

  @override
  void didUpdateWidget(ConfettiWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_onControllerChange);
      widget.controller?.addListener(_onControllerChange);
    }

    final oldSoundOn = oldWidget.feedback?.enableSound ?? oldWidget.enableSound;
    final newSoundOn = _effectiveSound;
    if (oldSoundOn && !newSoundOn) {
      _disposeAudio();
    }
  }

  @override
  void dispose() {
    _animCtrl
      ..removeListener(_onTick)
      ..removeStatusListener(_onStatus)
      ..dispose();
    widget.controller?.removeListener(_onControllerChange);
    _disposeAudio();
    super.dispose();
  }

  void _disposeAudio() {
    final wrapper = _audio;
    _audio = null;
    wrapper?.dispose();
  }

  // ─── Controller observer ───────────────────────────────────────────────────

  void _onControllerChange() {
    switch (widget.controller?.state) {
      case ControllerState.playing:
        _start();
      case ControllerState.stopped:
        _animCtrl.stop();
      case ControllerState.idle:
        _animCtrl.stop();
        setState(() => _particles = []);
      case null:
        break;
    }
  }

  // ─── Animation ─────────────────────────────────────────────────────────────

  void _start() {
    if (_size == null) return;
    _completionDispatched = false;

    List<Particle> built;
    try {
      if (widget.showcase != null) {
        built = ShowcaseParticleFactory.createParticles(
          widget.showcase!,
          _size!,
          emojiPool: widget.emojiPool,
          customization: widget.customization,
        );
      } else {
        built = PresetFactory.createParticles(
          widget.preset,
          _size!,
          emojiPool: widget.emojiPool,
          customization: widget.customization,
        );
      }
    } catch (_) {
      built = [];
    }

    setState(() {
      _particles = built;
      _lastTime = 0.0;
    });

    if (_particles.isEmpty) {
      _animCtrl.stop();
      _dispatchComplete();
      return;
    }

    _animCtrl.forward(from: 0);
    _fireHaptic();
    _fireSound();
  }

  void _onTick() {
    final t = _animCtrl.value * (_animCtrl.duration!.inMilliseconds / 1000.0);
    final dt = (t - _lastTime).clamp(0.0, 0.1);
    _lastTime = t;
    if (dt <= 0) return;

    var anyAlive = false;
    for (final p in _particles) {
      p.update(dt);
      if (!p.isDead) anyAlive = true;
    }

    setState(() {});

    if (!anyAlive && _particles.isNotEmpty) {
      _animCtrl.stop();
      _dispatchComplete();
    }
  }

  void _onStatus(AnimationStatus status) {
    // Do not use [AnimationStatus.dismissed] here — stop() uses dismissed too,
    // which would incorrectly fire [onComplete] on manual Stop.
    if (status == AnimationStatus.completed) {
      _dispatchComplete();
    }
  }

  void _dispatchComplete() {
    if (_completionDispatched) return;
    _completionDispatched = true;
    widget.onComplete?.call();
  }

  // ─── Haptics ───────────────────────────────────────────────────────────────

  void _fireHaptic() {
    if (!_effectiveHaptics) return;
    try {
      final showcase = widget.showcase;
      if (showcase != null) {
        switch (showcase) {
          case ConfettiShowcase.randomAngle:
            HapticFeedback.mediumImpact();
          case ConfettiShowcase.centerPop:
          case ConfettiShowcase.dualLaunch:
          case ConfettiShowcase.starField:
          case ConfettiShowcase.emojiPop:
          case ConfettiShowcase.dualStream:
          case ConfettiShowcase.controlledBurst:
          case ConfettiShowcase.inlineEmitter:
            HapticFeedback.heavyImpact();
        }
        return;
      }
      switch (widget.preset) {
        case Preset.nova:
        case Preset.cascade:
          HapticFeedback.heavyImpact();
        case Preset.flare:
        case Preset.crossfire:
          HapticFeedback.mediumImpact();
      }
    } catch (_) {
      // Haptics must never surface platform errors to the app.
    }
  }

  // ─── Sound ─────────────────────────────────────────────────────────────────

  void _fireSound() {
    if (!_effectiveSound) return;
    final path = _effectiveSoundPath;
    if (path == null) return;
    _audio ??= AudioPlayerWrapper();
    _audio!.play(path);
  }

  // ─── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final newSize = _layoutSizeFromConstraints(constraints, context);
        if (_size != newSize) {
          _size = newSize;
          if (widget.autoPlay &&
              widget.controller == null &&
              _particles.isEmpty &&
              !_animCtrl.isAnimating) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) _start();
            });
          }
        }
        return CustomPaint(
          painter: ConfettiPainter(
            particles: _particles,
            particleBlendMode: ConfettiCustomization.effectiveParticleBlendMode(
              widget.customization,
            ),
          ),
          // Finite size even when [LayoutBuilder] has unbounded max height
          // (e.g. inside [SingleChildScrollView]) — avoids infinite layout.
          child: SizedBox(
            width: newSize.width,
            height: newSize.height,
          ),
        );
      },
    );
  }

  /// [LayoutBuilder] can report infinite or zero max extents; confetti spawn
  /// needs a finite box, so we fall back to [MediaQuery] or a safe default.
  static Size _layoutSizeFromConstraints(
    BoxConstraints constraints,
    BuildContext context,
  ) {
    const fallback = 400.0;
    var w = constraints.maxWidth;
    var h = constraints.maxHeight;
    if (!w.isFinite || w <= 0) {
      w = MediaQuery.maybeOf(context)?.size.width ?? fallback;
    }
    if (!h.isFinite || h <= 0) {
      h = MediaQuery.maybeOf(context)?.size.height ?? fallback;
    }
    if (!w.isFinite || w <= 0) w = fallback;
    if (!h.isFinite || h <= 0) h = fallback;
    return Size(w, h);
  }
}
