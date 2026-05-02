import 'package:flutter/material.dart';
import 'package:flutter_confetti_engine/flutter_confetti_engine.dart';

import '../pages/sample_detail_page.dart';
import 'demo_feedback.dart';
import 'demo_prefs.dart';
import 'demo_theme.dart';

// ── Entry point ───────────────────────────────────────────────────────────────

class DemoHome extends StatelessWidget {
  const DemoHome({super.key});

  static ConfettiCustomization? _tickExtra(BuildContext context) {
    return DemoPrefsScope.of(context).useTickPhysics
        ? const ConfettiCustomization(useTickBasedPhysics: true)
        : null;
  }

  @override
  Widget build(BuildContext context) {
    final prefs = DemoPrefsScope.of(context);

    return Scaffold(
      backgroundColor: kBgDeep,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'flutter_confetti_engine',
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white70),
        ),
        actions: const [
          IconButton(
            tooltip: 'Dismiss overlay',
            onPressed: ConfettiEngine.dismiss,
            icon: Icon(Icons.layers_clear_rounded, color: Colors.white54),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // ── Hero ──────────────────────────────────────────────────────────
          _HeroHeader(),
          const SizedBox(height: 20),

          // ── Physics toggle ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _PhysicsToggle(prefs: prefs),
          ),
          const SizedBox(height: 28),

          // ── Built-in sounds ───────────────────────────────────────────────
          const _SectionHeader(label: '🔊', title: 'Built-in Sounds'),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.82,
              children: const [
                _SoundCard(
                  sound: BuiltinSound.pop,
                  emoji: '💥',
                  label: 'Pop',
                  duration: '~0.4 s',
                  description: 'Punchy confetti-popper snap.',
                  color: kAccentCoral,
                  triggerPreset: Preset.nova,
                ),
                _SoundCard(
                  sound: BuiltinSound.chime,
                  emoji: '🎵',
                  label: 'Chime',
                  duration: '~2.2 s',
                  description: 'Bright C-major bell chord.',
                  color: kAccentTeal,
                  triggerPreset: Preset.flare,
                ),
                _SoundCard(
                  sound: BuiltinSound.fanfare,
                  emoji: '🎺',
                  label: 'Fanfare',
                  duration: '~1.6 s',
                  description: 'Triumphant ascending brass fanfare.',
                  color: kAccentAmber,
                  triggerPreset: Preset.cascade,
                ),
                _SoundCard(
                  sound: BuiltinSound.applause,
                  emoji: '👏',
                  label: 'Applause',
                  duration: '~2.0 s',
                  description: 'Crowd clapping and cheering.',
                  color: Color(0xFF818CF8),
                  triggerPreset: Preset.cascade,
                ),
                _SoundCard(
                  sound: BuiltinSound.whoosh,
                  emoji: '💨',
                  label: 'Whoosh',
                  duration: '~0.55 s',
                  description: 'Fast frequency sweep.',
                  color: Color(0xFF38BDF8),
                  triggerPreset: Preset.crossfire,
                ),
                _SoundCard(
                  sound: BuiltinSound.drumroll,
                  emoji: '🥁',
                  label: 'Drum Roll',
                  duration: '~1.6 s',
                  description: 'Snare roll + cymbal crash.',
                  color: Color(0xFFFB923C),
                  triggerPreset: Preset.nova,
                ),
                _SoundCard(
                  sound: BuiltinSound.levelUp,
                  emoji: '🎮',
                  label: 'Level Up',
                  duration: '~1.0 s',
                  description: '8-bit arpeggio jingle.',
                  color: Color(0xFF4ADE80),
                  triggerPreset: Preset.nova,
                ),
                _SoundCard(
                  sound: BuiltinSound.bell,
                  emoji: '🔔',
                  label: 'Bell',
                  duration: '~2.2 s',
                  description: 'Clear resonant D5 bell.',
                  color: Color(0xFFA78BFA),
                  triggerPreset: Preset.flare,
                ),
                _SoundCard(
                  sound: BuiltinSound.sparkle,
                  emoji: '✨',
                  label: 'Sparkle',
                  duration: '~1.4 s',
                  description: 'Magical high-freq twinkling.',
                  color: Color(0xFFF472B6),
                  triggerPreset: Preset.nova,
                ),
                _SoundCard(
                  sound: BuiltinSound.airhorn,
                  emoji: '📯',
                  label: 'Air Horn',
                  duration: '~0.85 s',
                  description: 'Bold, energetic air-horn blast.',
                  color: Color(0xFFF87171),
                  triggerPreset: Preset.crossfire,
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // ── Presets ───────────────────────────────────────────────────────
          const _SectionHeader(label: '🎆', title: 'Presets'),
          const SizedBox(height: 10),
          ...Preset.values.map(
            (p) => Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: _PresetCard(
                preset: p,
                onTap: () => _pushPresetDetail(context, p),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // ── Showcases ─────────────────────────────────────────────────────
          const _SectionHeader(label: '🎪', title: 'Showcases'),
          const SizedBox(height: 10),
          ...ConfettiShowcase.values.map(
            (s) => Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: _ShowcaseTile(
                mode: s,
                onTap: () => _pushShowcaseDetail(context, s),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // ── Explore more ──────────────────────────────────────────────────
          const _SectionHeader(label: '✦', title: 'Explore More'),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: _CatalogTile(
              icon: Icons.layers_rounded,
              iconColor: const Color(0xFF818CF8),
              title: 'Modal dialog',
              subtitle: 'Full-screen transparent Dialog route',
              onTap: () => _pushDialogDetail(context),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: _CatalogTile(
              icon: Icons.celebration_rounded,
              iconColor: kAccentAmber,
              title: 'Celebrate with message',
              subtitle: 'Banner + optional duration cap',
              onTap: () => _pushMessageDetail(context),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: _CatalogTile(
              icon: Icons.emoji_events_rounded,
              iconColor: kAccentTeal,
              title: 'Achievement scene',
              subtitle: 'CelebrationScene.fromConfettiType + banner',
              onTap: () => _pushAchievementDetail(context),
            ),
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  // ── Push helpers ────────────────────────────────────────────────────────────

  void _pushPresetDetail(BuildContext context, Preset preset) {
    final meta = preset.catalogMeta;
    final tickNote = DemoPrefsScope.of(context).useTickPhysics
        ? '\n  customization: ConfettiCustomization(\n    useTickBasedPhysics: true,\n  ),'
        : '';
    final clipName = ConfettiBundledSounds.builtinForPreset(preset).name;
    final code = '''
ConfettiEngine.celebrate(
  context,
  preset: Preset.${preset.name},$tickNote
  feedback: CelebrationFeedback.bundledForPreset(Preset.${preset.name}),
  // plays BuiltinSound.$clipName automatically
);''';

    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (ctx) => SampleDetailPage(
          title: meta.title,
          subtitle: meta.subtitle,
          description: meta.description,
          code: code.trim(),
          onTry: () {
            ConfettiEngine.celebrate(
              ctx,
              preset: preset,
              feedback: demoFeedbackForPreset(preset),
              customization: _tickExtra(context),
            );
          },
        ),
      ),
    );
  }

  void _pushShowcaseDetail(BuildContext context, ConfettiShowcase mode) {
    final code = '''
ConfettiEngine.celebrate(
  context,
  showcase: ConfettiShowcase.${mode.name},
  feedback: CelebrationFeedback(
    enableHaptics: true,
    enableSound: true,
    builtinSound: BuiltinSound.pop,
  ),
);''';

    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (ctx) => SampleDetailPage(
          title: _showcaseTitle(mode),
          subtitle: _showcaseSubtitle(mode),
          description: _showcaseBody(mode),
          code: code.trim(),
          onTry: () {
            ConfettiEngine.celebrate(
              ctx,
              showcase: mode,
              feedback: demoCelebrationFeedback(),
            );
          },
        ),
      ),
    );
  }

  void _pushDialogDetail(BuildContext context) {
    const description =
        'Uses showDialog with a transparent full-screen Dialog. Blocks the '
        'route until particles finish or duration elapses. Optional '
        'CelebrationMessageOptions for a centered card.';

    const codeCard = '''
await ConfettiEngine.celebrateInDialog(
  context,
  preset: Preset.nova,
  feedback: CelebrationFeedback.bundledForPreset(Preset.nova),
  overlayMessage: CelebrationMessageOptions.withDefaults(
    'Achievement unlocked',
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: Color(0xDD2D2D2D),
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  ),
);''';

    const codeBlend = '''
await ConfettiEngine.celebrateInDialog(
  context,
  preset: Preset.cascade,
  feedback: CelebrationFeedback.bundledForPreset(Preset.cascade),
  customization: ConfettiCustomization(
    particleBlendMode: BlendMode.plus,
  ),
);''';

    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (ctx) => SampleDetailPage(
          title: 'Modal dialog',
          subtitle: 'showDialog · confetti + optional banner',
          description: description,
          code: '$codeCard\n\n// --- Blend mode variant ---\n\n$codeBlend',
          onTry: () async {
            await ConfettiEngine.celebrateInDialog(
              ctx,
              preset: Preset.nova,
              feedback: demoCelebrationFeedback(),
              overlayMessage: CelebrationMessageOptions.withDefaults(
                'Achievement unlocked',
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xDD2D2D2D),
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
            );
          },
          extraActions: [
            SampleExtraAction(
              label: "Try · BlendMode.plus",
              onPressed: () async {
                await ConfettiEngine.celebrateInDialog(
                  ctx,
                  preset: Preset.cascade,
                  feedback: demoFeedbackForPreset(Preset.cascade),
                  customization: const ConfettiCustomization(
                    particleBlendMode: BlendMode.plus,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _pushMessageDetail(BuildContext context) {
    const description =
        'Shortcut API with styled banner text, alignment, and optional '
        'durationInSeconds to cap overlay lifetime.';

    const code = '''
ConfettiEngine.celebrateWithMessage(
  context,
  preset: Preset.nova,
  message: 'Congratulations! 🎉',
  durationInSeconds: 3,
  messageAlignment: Alignment.center,
  messageDecoration: BoxDecoration(
    color: Colors.black45,
    borderRadius: BorderRadius.circular(20),
  ),
  messageInnerPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  messageStyle: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  ),
  feedback: CelebrationFeedback.bundledForPreset(Preset.nova),
);''';

    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (ctx) => SampleDetailPage(
          title: 'Celebrate with message',
          subtitle: 'celebrateWithMessage',
          description: description,
          code: code.trim(),
          onTry: () {
            ConfettiEngine.celebrateWithMessage(
              ctx,
              preset: Preset.nova,
              message: 'Congratulations! 🎉',
              durationInSeconds: 3,
              messageAlignment: Alignment.center,
              messageDecoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(20),
              ),
              messageInnerPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              messageStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                decoration: TextDecoration.none,
              ),
              feedback: demoCelebrationFeedback(),
            );
          },
        ),
      ),
    );
  }

  void _pushAchievementDetail(BuildContext context) {
    const description =
        'Compose preset + palette + density from ConfettiType via '
        'CelebrationScene.fromConfettiType, layered with overlayMessage.';

    const code = '''
ConfettiEngine.celebrate(
  context,
  scene: CelebrationScene.fromConfettiType(
    ConfettiType.milestone,
  ),
  overlayMessage: CelebrationMessageOptions.withDefaults(
    'Achievement unlocked!',
    durationInSeconds: 4,
    alignment: Alignment.bottomCenter,
    decoration: BoxDecoration(
      color: Color(0xCC1B5E20),
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  ),
  feedback: CelebrationFeedback(
    enableHaptics: true,
    enableSound: true,
    builtinSound: BuiltinSound.chime,
  ),
);''';

    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (ctx) => SampleDetailPage(
          title: 'Achievement scene',
          subtitle: 'CelebrationScene + banner',
          description: description,
          code: code.trim(),
          onTry: () {
            ConfettiEngine.celebrate(
              ctx,
              scene: CelebrationScene.fromConfettiType(
                ConfettiType.milestone,
              ),
              overlayMessage: CelebrationMessageOptions.withDefaults(
                'Achievement unlocked!',
                durationInSeconds: 4,
                alignment: Alignment.bottomCenter,
                decoration: const BoxDecoration(
                  color: Color(0xCC1B5E20),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
              feedback: const CelebrationFeedback(
                enableHaptics: true,
                enableSound: true,
                builtinSound: BuiltinSound.chime,
              ),
            );
          },
        ),
      ),
    );
  }
}

// ── Hero header ───────────────────────────────────────────────────────────────

class _HeroHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1E0A3C), Color(0xFF0D0D22), kBgDeep],
          stops: [0.0, 0.6, 1.0],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 4, 24, 28),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('🎉  🎊  ✨  💫',
              style: TextStyle(fontSize: 22, letterSpacing: 8)),
          SizedBox(height: 18),
          Text(
            'Confetti Engine',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.8,
              height: 1.1,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Particles · Haptics · Sound\nOne API call.',
            style: TextStyle(
              color: Color(0xFF9090C0),
              fontSize: 14,
              height: 1.5,
            ),
          ),
          SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _StatChip(label: '4 presets', icon: Icons.auto_awesome_rounded),
              _StatChip(label: '10 sounds', icon: Icons.music_note_rounded),
              _StatChip(label: 'Haptics', icon: Icons.vibration_rounded),
              _StatChip(label: 'Tick physics', icon: Icons.speed_rounded),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: kAccentViolet),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Physics toggle ────────────────────────────────────────────────────────────

class _PhysicsToggle extends StatelessWidget {
  const _PhysicsToggle({required this.prefs});

  final DemoPrefsScope prefs;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kBgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kBorderFaint),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: kAccentViolet.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child:
                const Icon(Icons.speed_rounded, color: kAccentViolet, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tick physics',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  prefs.useTickPhysics
                      ? 'Tick-based simulation active'
                      : 'Matrix-path physics active',
                  style: const TextStyle(color: kTextMuted, fontSize: 12),
                ),
              ],
            ),
          ),
          Switch(
            value: prefs.useTickPhysics,
            onChanged: prefs.onTickPhysicsChanged,
          ),
        ],
      ),
    );
  }
}

// ── Section header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label, required this.title});

  final String label;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: kTextMuted,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(height: 1, color: kBorderFaint),
          ),
        ],
      ),
    );
  }
}

// ── Sound cards ───────────────────────────────────────────────────────────────

class _SoundCard extends StatelessWidget {
  const _SoundCard({
    // ignore: unused_element
    required this.sound,
    required this.emoji,
    required this.label,
    required this.duration,
    required this.description,
    required this.color,
    required this.triggerPreset,
  });

  final BuiltinSound sound;
  final String emoji;
  final String label;
  final String duration;
  final String description;
  final Color color;
  final Preset triggerPreset;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.07),
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => ConfettiEngine.celebrate(
          context,
          preset: triggerPreset,
          feedback: CelebrationFeedback(
            enableHaptics: true,
            enableSound: true,
            builtinSound: sound,
          ),
        ),
        splashColor: color.withValues(alpha: 0.15),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: color.withValues(alpha: 0.25)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 22)),
                  const Spacer(),
                  _Pill(label: duration, color: color),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  color: kTextMuted,
                  fontSize: 11,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: color.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.play_arrow_rounded, size: 14, color: color),
                    const SizedBox(width: 4),
                    Text(
                      'Try it',
                      style: TextStyle(
                        color: color,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Preset card ───────────────────────────────────────────────────────────────

class _PresetVisual {
  const _PresetVisual({
    required this.emoji,
    required this.gradientColors,
    required this.particleCount,
  });

  final String emoji;
  final List<Color> gradientColors;
  final int particleCount;
}

_PresetVisual _visualForPreset(Preset preset) {
  switch (preset) {
    case Preset.nova:
      return const _PresetVisual(
        emoji: '🎉',
        gradientColors: [Color(0xFF6D28D9), Color(0xFF2563EB)],
        particleCount: 120,
      );
    case Preset.cascade:
      return const _PresetVisual(
        emoji: '🌊',
        gradientColors: [Color(0xFF0D9488), Color(0xFF0369A1)],
        particleCount: 200,
      );
    case Preset.flare:
      return const _PresetVisual(
        emoji: '✨',
        gradientColors: [Color(0xFFD97706), Color(0xFFEA580C)],
        particleCount: 72,
      );
    case Preset.crossfire:
      return const _PresetVisual(
        emoji: '💫',
        gradientColors: [Color(0xFFBE185D), Color(0xFF7C3AED)],
        particleCount: 100,
      );
  }
}

class _PresetCard extends StatelessWidget {
  const _PresetCard({required this.preset, required this.onTap});

  final Preset preset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final visual = _visualForPreset(preset);
    final meta = preset.catalogMeta;
    final soundName = ConfettiBundledSounds.builtinForPreset(preset).name;
    final soundColor = switch (soundName) {
      'pop' => kAccentCoral,
      'fanfare' => kAccentAmber,
      'chime' => kAccentTeal,
      _ => kAccentViolet,
    };

    return Material(
      color: kBgCard,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        splashColor: visual.gradientColors.first.withValues(alpha: 0.15),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: kBorderFaint),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Gradient left bar
                Container(
                  width: 5,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: visual.gradientColors,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                // Emoji
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child:
                      Text(visual.emoji, style: const TextStyle(fontSize: 30)),
                ),
                const SizedBox(width: 12),
                // Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          meta.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          meta.subtitle,
                          style:
                              const TextStyle(color: kTextMuted, fontSize: 12),
                        ),
                        const SizedBox(height: 9),
                        Row(
                          children: [
                            _Pill(
                              label: '${visual.particleCount}p',
                              color: visual.gradientColors.first,
                            ),
                            const SizedBox(width: 6),
                            _Pill(
                              label: '🔊 $soundName',
                              color: soundColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: Center(
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 13,
                      color: kTextMuted.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Showcase tile ─────────────────────────────────────────────────────────────

class _ShowcaseTile extends StatelessWidget {
  const _ShowcaseTile({required this.mode, required this.onTap});

  final ConfettiShowcase mode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kBgCard,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: kBorderFaint),
          ),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: kAccentViolet.withValues(alpha: 0.7),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _showcaseTitle(mode),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _showcaseSubtitle(mode),
                      style: const TextStyle(color: kTextMuted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: kTextMuted.withValues(alpha: 0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Catalog tile ──────────────────────────────────────────────────────────────

class _CatalogTile extends StatelessWidget {
  const _CatalogTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kBgCard,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        splashColor: iconColor.withValues(alpha: 0.1),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: kBorderFaint),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(color: kTextMuted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 13,
                color: kTextMuted.withValues(alpha: 0.6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Pill badge ────────────────────────────────────────────────────────────────

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.28), width: 0.5),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color.withValues(alpha: 0.9),
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ── Preset catalog copy (must stay aligned with [Preset]: nova, cascade, flare, crossfire)

class PresetCatalogEntry {
  const PresetCatalogEntry({
    required this.title,
    required this.subtitle,
    required this.description,
  });

  final String title;
  final String subtitle;
  final String description;
}

extension PresetCatalogCopy on Preset {
  /// Display titles and blurbs for each [Preset] in this demo.
  PresetCatalogEntry get catalogMeta => switch (this) {
        Preset.nova => const PresetCatalogEntry(
            title: 'Nova',
            subtitle: 'Center · omnidirectional · star-heavy',
            description:
                'Full-screen overlay via ConfettiEngine. Explosive center burst '
                'with heavy haptic on start. Toggle Tick physics above for tick simulation.',
          ),
        Preset.cascade => const PresetCatalogEntry(
            title: 'Cascade',
            subtitle: 'Top center · wide downward shower',
            description:
                'High particle count raining from the top center. Strong gravity '
                'feel with heavy haptic; pairs beautifully with tick physics.',
          ),
        Preset.flare => const PresetCatalogEntry(
            title: 'Flare',
            subtitle: 'Left edge · directional stream',
            description:
                'Sparse directional emission near the left edge, aimed across '
                'the screen. Medium haptic.',
          ),
        Preset.crossfire => const PresetCatalogEntry(
            title: 'Crossfire',
            subtitle: 'Right edge · stream toward the left',
            description:
                'Directional burst from the right side firing across the screen. '
                'Great for asymmetric and side-action layouts.',
          ),
      };
}

String _showcaseTitle(ConfettiShowcase s) {
  switch (s) {
    case ConfettiShowcase.centerPop:
      return 'Center Pop';
    case ConfettiShowcase.randomAngle:
      return 'Random Angle';
    case ConfettiShowcase.dualLaunch:
      return 'Dual Launch';
    case ConfettiShowcase.starField:
      return 'Star Field';
    case ConfettiShowcase.emojiPop:
      return 'Emoji Pop';
    case ConfettiShowcase.dualStream:
      return 'Dual Stream';
    case ConfettiShowcase.controlledBurst:
      return 'Controlled Burst';
    case ConfettiShowcase.inlineEmitter:
      return 'Inline Emitter';
  }
}

String _showcaseSubtitle(ConfettiShowcase s) {
  switch (s) {
    case ConfettiShowcase.centerPop:
      return 'Tick burst · center pop · y ≈ 60%';
    case ConfettiShowcase.randomAngle:
      return 'Random angle & spread each trigger';
    case ConfettiShowcase.dualLaunch:
      return 'Dual-emitter wave · 360° spread';
    case ConfettiShowcase.starField:
      return 'Warm palette · star shapes · zero gravity';
    case ConfettiShowcase.emojiPop:
      return 'Star-field motion · emojiPool shapes';
    case ConfettiShowcase.dualStream:
      return 'Two-cannon stream · red / white';
    case ConfettiShowcase.controlledBurst:
      return 'CenterPop + ConfettiController lifecycle';
    case ConfettiShowcase.inlineEmitter:
      return 'Bottom-anchored inline emitter';
  }
}

String _showcaseBody(ConfettiShowcase s) {
  switch (s) {
    case ConfettiShowcase.centerPop:
      return 'Canonical upward cone burst parameters as a single tick burst.';
    case ConfettiShowcase.randomAngle:
      return 'Angle and spread randomized per launch for variation.';
    case ConfettiShowcase.dualLaunch:
      return 'One representative wave; repeat with Timer.periodic for continuous bursts.';
    case ConfettiShowcase.starField:
      return 'Warm colors and star geometry with mixed scalar jitter.';
    case ConfettiShowcase.emojiPop:
      return 'Uses kDefaultCelebrationEmojis unless you pass emojiPool on the engine call.';
    case ConfettiShowcase.dualStream:
      return 'Left and right edge cannons with pride palette (override colors via customization).';
    case ConfettiShowcase.controlledBurst:
      return 'Spawn matches basic cannon; pair with ConfettiWidget + ConfettiController.kill() for manual lifecycle control.';
    case ConfettiShowcase.inlineEmitter:
      return 'Emitter anchored at the bottom; clip ConfettiWidget for UI-framed layouts.';
  }
}
