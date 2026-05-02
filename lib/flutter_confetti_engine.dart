/// flutter_confetti_engine
///
/// A celebration package that combines confetti particle animation, haptic
/// feedback, and optional sound in a single API call.
///
/// **Quick start:**
/// ```dart
/// import 'package:flutter_confetti_engine/flutter_confetti_engine.dart';
///
/// // One-liner — full-screen burst with haptics:
/// ConfettiEngine.celebrate(context);
///
/// // With a preset:
/// ConfettiEngine.celebrate(context, preset: Preset.nova);
///
/// // Stock clip for the preset you pass to celebrate():
/// ConfettiEngine.celebrate(
///   context,
///   preset: Preset.cascade,
///   feedback: CelebrationFeedback.bundledForPreset(Preset.cascade),
/// );
///
/// // Your own asset + toggle haptics/sound:
/// ConfettiEngine.celebrate(
///   context,
///   feedback: CelebrationFeedback.customAsset(
///     'assets/party.mp3',
///     enableHaptics: true,
///     enableSound: true,
///   ),
/// );
///
/// // Message banner + max duration (overlay closes at 3s or when particles end):
/// ConfettiEngine.celebrate(
///   context,
///   overlayMessage: CelebrationMessageOptions.withDefaults(
///     'Congratulations! 🎉',
///     durationInSeconds: 3,
///     alignment: Alignment.center,
///     decoration: BoxDecoration(
///       color: Color(0x88000000),
///       borderRadius: BorderRadius.all(Radius.circular(16)),
///     ),
///   ),
/// );
///
/// // Manual control:
/// final controller = ConfettiController();
/// ConfettiWidget(preset: Preset.flare, controller: controller, autoPlay: false)
/// controller.play();
/// ```
library;

export 'src/builtin_sound.dart' show BuiltinSound;
export 'src/bundled_sounds.dart' show ConfettiBundledSounds;
export 'src/celebration_feedback.dart' show CelebrationFeedback;
export 'src/celebration_message_options.dart' show CelebrationMessageOptions;
export 'src/celebration_scene.dart' show CelebrationScene;
export 'src/confetti_animation.dart'
    show AnimationConfetti, ConfettiAnimationMaps;
export 'src/confetti_color_theme.dart'
    show ConfettiColorTheme, ConfettiColorThemes;
export 'src/confetti_density.dart' show ConfettiDensity, ConfettiDensityScale;
export 'src/confetti_style.dart' show ConfettiStyle, ConfettiStyleShapes;
export 'src/confetti_type.dart' show ConfettiType;
export 'src/confetti_customization.dart' show ConfettiCustomization;
export 'src/tick_confetti_spawn_options.dart'
    show
        TickConfettiSpawnOptions,
        kTickConfettiPackageColors,
        kTickConfettiWarmPalette;
export 'src/confetti_controller.dart' show ConfettiController, ControllerState;
export 'src/confetti_engine.dart' show ConfettiEngine;
export 'src/confetti_showcase.dart'
    show ConfettiShowcase, ShowcaseParticleFactory;
export 'src/confetti_widget.dart' show ConfettiWidget;
export 'src/presets.dart' show Preset, kDefaultCelebrationEmojis;
export 'src/particle_shape.dart' show ParticleShape;

// Internal classes (Particle, PresetFactory, ConfettiPainter, AudioPlayerWrapper)
// are intentionally NOT exported — they are implementation details.
