import 'dart:math';
import 'dart:ui' show Path, lerpDouble;

import 'package:flutter/material.dart';

import 'confetti_customization.dart';
import 'flutter_confetti_physics.dart';
import 'particle.dart';
import 'particle_shape.dart';
import 'tick_confetti_physics.dart';
import 'tick_confetti_spawn_options.dart';

/// Default unicode strings used for [ParticleShape.emoji] particles when
/// particles are created without a custom emoji list (see [ConfettiWidget.emojiPool]).
///
/// Override per celebration via [ConfettiWidget.emojiPool] or
/// [ConfettiEngine.celebrate]’s `emojiPool` argument.
const List<String> kDefaultCelebrationEmojis = [
  '🎉',
  '🎊',
  '⭐',
  '🌟',
  '✨',
  '💫',
  '🎈',
  '🎁',
];

/// Built-in animation presets — curated factory layouts
/// (“nova”, “cascade”, “flare”, “crossfire”).
///
/// Pass to [ConfettiEngine.celebrate] or [ConfettiWidget.preset].
enum Preset {
  /// Center of the screen — omnidirectional burst with **star-heavy** shapes
  /// (same intent as the demo's **nova** button).
  /// Fires [HapticFeedback.heavyImpact] on play.
  nova,

  /// Top center — wide downward cone, high particle count and fall speed
  /// (**cascade**: top-center downward cone, `blastDirection` π/2, strong gravity).
  /// Fires [HapticFeedback.heavyImpact] on play.
  cascade,

  /// Near the **left** edge — narrow cone aimed **right**, fewer / smaller pieces
  /// (**flare**: sparse left-edge directional stream).
  /// Fires [HapticFeedback.mediumImpact] on play.
  flare,

  /// Near the **right** edge — narrow cone aimed **left** (**crossfire**:
  /// directional stream across the screen).
  /// Fires [HapticFeedback.mediumImpact] on play.
  crossfire,
}

/// Internal factory that converts a [Preset] into a list of [Particle] objects.
///
/// Not part of the public API — consumers should use [Preset] values only.
class PresetFactory {
  PresetFactory._();

  static const double _fallbackLayoutExtent = 400.0;

  /// Caps pool size and string length so hostile inputs cannot allocate
  /// unbounded memory before particle spawn.
  static const int _maxEmojiPoolEntries = 512;
  static const int _maxEmojiRunesPerEntry = 32;

  /// Limits copying huge customization lists from untrusted sources.
  static const int _maxCustomPaletteColors = 512;
  static const int _maxCustomShapeMixEntries = 64;

  static final _random = Random();

  // ─── Color palettes ────────────────────────────────────────────────────────

  static const _defaultColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.pink,
    Colors.cyan,
    Color(0xFFFFD700), // gold
    Color(0xFFFF69B4), // hot pink
    Color(0xFF7B2FBE), // violet
    Color(0xFF00BFA5), // teal
  ];

  /// Matches `example/lib/main.dart` “nova” button palette.
  static const _novaColors = [
    Colors.green,
    Colors.blue,
    Colors.pink,
    Colors.orange,
    Colors.purple,
  ];

  /// Tick-mode default palette plus warm accents.
  static const List<Color> _tickExtendedPalette = [
    ...kTickConfettiPackageColors,
    ...kTickConfettiWarmPalette,
  ];

  // ─── Public entry point ────────────────────────────────────────────────────

  /// Returns the configured particle list for [preset] sized to [size].
  ///
  /// When [emojiPool] is null or empty, [kDefaultCelebrationEmojis] is used for
  /// any particle with [ParticleShape.emoji].
  ///
  /// [customization] optionally overrides count, colors, shape mix, gravity,
  /// and velocity / lifetime scaling — see [ConfettiCustomization].
  static List<Particle> createParticles(
    Preset preset,
    Size size, {
    List<String>? emojiPool,
    ConfettiCustomization? customization,
  }) {
    final safe = _safeLayoutSize(size);
    final emojis = _resolveEmojiPool(emojiPool);
    switch (preset) {
      case Preset.nova:
        return _createBlastStars(safe, emojis, customization);
      case Preset.cascade:
        return _createGoliath(safe, emojis, customization);
      case Preset.flare:
        return _createSingles(safe, emojis, customization);
      case Preset.crossfire:
        return _createPumpLeft(safe, emojis, customization);
    }
  }

  /// Replaces non-finite or non-positive extents so spawn math and layout stay
  /// finite (e.g. unbounded [LayoutBuilder] constraints).
  static Size _safeLayoutSize(Size size) {
    var w = size.width;
    var h = size.height;
    if (!w.isFinite || w <= 0) w = _fallbackLayoutExtent;
    if (!h.isFinite || h <= 0) h = _fallbackLayoutExtent;
    return Size(w, h);
  }

  static List<Color> _palette(List<Color> preset, ConfettiCustomization? c) {
    final list = c?.colors;
    if (list != null && list.isNotEmpty) {
      final n = list.length > _maxCustomPaletteColors
          ? _maxCustomPaletteColors
          : list.length;
      return List<Color>.from(list.sublist(0, n));
    }
    return preset;
  }

  static List<ParticleShape> _shapes(
    List<ParticleShape> preset,
    ConfettiCustomization? c,
  ) {
    final list = c?.shapeMix;
    if (list != null && list.isNotEmpty) {
      final n = list.length > _maxCustomShapeMixEntries
          ? _maxCustomShapeMixEntries
          : list.length;
      return List<ParticleShape>.from(list.sublist(0, n));
    }
    return preset;
  }

  static String _truncateEmojiEntry(String s) {
    final runes = s.runes;
    if (runes.length <= _maxEmojiRunesPerEntry) return s;
    return String.fromCharCodes(runes.take(_maxEmojiRunesPerEntry));
  }

  static List<String> _resolveEmojiPool(List<String>? emojiPool) {
    if (emojiPool == null || emojiPool.isEmpty) {
      return List<String>.from(kDefaultCelebrationEmojis);
    }
    final filtered =
        emojiPool.map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    if (filtered.isEmpty) {
      return List<String>.from(kDefaultCelebrationEmojis);
    }
    final capped = filtered.length > _maxEmojiPoolEntries
        ? filtered.sublist(0, _maxEmojiPoolEntries)
        : filtered;
    return capped.map(_truncateEmojiEntry).toList();
  }

  // ─── Preset implementations ─────────────────────────────────────────────────

  /// “Blast stars” — center, explosive, demo star path + matrix-path physics.
  static List<Particle> _createBlastStars(
    Size size,
    List<String> emojiPool,
    ConfettiCustomization? cust,
  ) {
    if (cust?.useTickBasedPhysics == true) {
      return _spawnPresetTick(
        preset: Preset.nova,
        size: size,
        emojiPool: emojiPool,
        cust: cust,
        defaultCount: 120,
        emitter: (s) => Offset(s.width / 2, s.height / 2),
        defaultShapes: const [
          ParticleShape.star,
          ParticleShape.circle,
          ParticleShape.square,
          ParticleShape.triangle,
        ],
        presetNominalGravityPx: 500,
      );
    }

    const defaultCount = 120;
    final count = ConfettiCustomization.effectiveCount(defaultCount, cust);
    final cx = size.width / 2;
    final cy = size.height / 2;

    const defaultShapes = [ParticleShape.star];
    final shapes = _shapes(defaultShapes, cust);
    final colors = _palette(_novaColors, cust);

    final shapePick = shapes.isNotEmpty ? shapes : [ParticleShape.star];
    return List.generate(count, (_) {
      final visual = shapePick[_random.nextInt(shapePick.length)];
      return _spawnFlutterParticle(
        originX: cx,
        originY: cy,
        presetNominalGravityPx: 500,
        baseGravity01: 0.2,
        particleDrag: 0.05,
        minBlast: 5,
        maxBlast: 20,
        blastDirectionRad: 0,
        explosive: true,
        lifetimeSec: 1.5 + _random.nextDouble() * 0.5,
        minPaper: const Size(20, 10),
        maxPaper: const Size(30, 15),
        visualShape: visual,
        colors: colors,
        customization: cust,
      );
    });
  }

  /// “Goliath” — top center, shower downward (`blastDirection` π/2, gravity 1).
  static List<Particle> _createGoliath(
    Size size,
    List<String> emojiPool,
    ConfettiCustomization? cust,
  ) {
    if (cust?.useTickBasedPhysics == true) {
      return _spawnPresetTick(
        preset: Preset.cascade,
        size: size,
        emojiPool: emojiPool,
        cust: cust,
        defaultCount: 200,
        emitter: (s) => Offset(
          s.width / 2 + (_random.nextDouble() - 0.5) * s.width * 0.08,
          s.height * 0.06,
        ),
        defaultShapes: const [
          ParticleShape.circle,
          ParticleShape.square,
          ParticleShape.triangle,
          ParticleShape.star,
        ],
        presetNominalGravityPx: 480,
      );
    }

    const defaultCount = 200;
    final count = ConfettiCustomization.effectiveCount(defaultCount, cust);

    const defaultShapes = [
      ParticleShape.paper,
      ParticleShape.star,
      ParticleShape.circle,
      ParticleShape.square,
    ];
    final shapes = _shapes(defaultShapes, cust);
    final colors = _palette(_defaultColors, cust);

    final cx = size.width / 2;
    final cy = size.height * 0.06;

    final shapePick = shapes.isNotEmpty ? shapes : [ParticleShape.paper];
    return List.generate(count, (_) {
      final visual = shapePick[_random.nextInt(shapePick.length)];
      return _spawnFlutterParticle(
        originX: cx + (_random.nextDouble() - 0.5) * size.width * 0.08,
        originY: cy,
        presetNominalGravityPx: 480,
        baseGravity01: 1.0,
        particleDrag: 0.05,
        minBlast: 2,
        maxBlast: 5,
        blastDirectionRad: _directionRadFromCustomization(
          cust,
          defaultCenterDeg: 90,
        ),
        explosive: false,
        lifetimeSec: 2.2 + _random.nextDouble() * 1.2,
        minPaper: const Size(20, 10),
        maxPaper: const Size(30, 15),
        visualShape: visual,
        colors: colors,
        customization: cust,
      );
    });
  }

  /// “Singles” — left edge, directional to the right (`blastDirection` 0), large size variance.
  static List<Particle> _createSingles(
    Size size,
    List<String> emojiPool,
    ConfettiCustomization? cust,
  ) {
    if (cust?.useTickBasedPhysics == true) {
      return _spawnPresetTick(
        preset: Preset.flare,
        size: size,
        emojiPool: emojiPool,
        cust: cust,
        defaultCount: 72,
        emitter: (s) => Offset(
          s.width * 0.06,
          s.height / 2 + (_random.nextDouble() - 0.5) * s.height * 0.35,
        ),
        defaultShapes: const [
          ParticleShape.circle,
          ParticleShape.square,
          ParticleShape.triangle,
        ],
        presetNominalGravityPx: 220,
      );
    }

    const defaultCount = 72;
    final count = ConfettiCustomization.effectiveCount(defaultCount, cust);

    const defaultShapes = [
      ParticleShape.paper,
      ParticleShape.star,
      ParticleShape.circle,
    ];
    final shapes = _shapes(defaultShapes, cust);
    final colors = _palette(_defaultColors, cust);

    final ox = size.width * 0.06;
    final oy = size.height / 2;

    final shapePick = shapes.isNotEmpty ? shapes : [ParticleShape.paper];
    return List.generate(count, (_) {
      final visual = shapePick[_random.nextInt(shapePick.length)];
      return _spawnFlutterParticle(
        originX: ox,
        originY: oy + (_random.nextDouble() - 0.5) * size.height * 0.35,
        presetNominalGravityPx: 220,
        baseGravity01: 0.1,
        particleDrag: 0.05,
        minBlast: 5,
        maxBlast: 20,
        blastDirectionRad: _directionRadFromCustomization(
          cust,
          defaultCenterDeg: 0,
        ),
        explosive: false,
        lifetimeSec: 2.0 + _random.nextDouble() * 1.4,
        minPaper: const Size(10, 10),
        maxPaper: const Size(50, 50),
        visualShape: visual,
        colors: colors,
        customization: cust,
      );
    });
  }

  /// “Pump left” — right edge, directional to the left (`blastDirection` π).
  static List<Particle> _createPumpLeft(
    Size size,
    List<String> emojiPool,
    ConfettiCustomization? cust,
  ) {
    if (cust?.useTickBasedPhysics == true) {
      return _spawnPresetTick(
        preset: Preset.crossfire,
        size: size,
        emojiPool: emojiPool,
        cust: cust,
        defaultCount: 100,
        emitter: (s) => Offset(
          s.width * 0.94,
          s.height / 2 + (_random.nextDouble() - 0.5) * s.height * 0.3,
        ),
        defaultShapes: const [
          ParticleShape.circle,
          ParticleShape.square,
          ParticleShape.triangle,
          ParticleShape.star,
        ],
        presetNominalGravityPx: 280,
      );
    }

    const defaultCount = 100;
    final count = ConfettiCustomization.effectiveCount(defaultCount, cust);

    const defaultShapes = [
      ParticleShape.paper,
      ParticleShape.star,
      ParticleShape.square,
    ];
    final shapes = _shapes(defaultShapes, cust);
    final colors = _palette(_defaultColors, cust);

    final ox = size.width * 0.94;
    final oy = size.height / 2;

    final shapePick = shapes.isNotEmpty ? shapes : [ParticleShape.paper];
    return List.generate(count, (_) {
      final visual = shapePick[_random.nextInt(shapePick.length)];
      return _spawnFlutterParticle(
        originX: ox,
        originY: oy + (_random.nextDouble() - 0.5) * size.height * 0.3,
        presetNominalGravityPx: 280,
        baseGravity01: 0.05,
        particleDrag: 0.05,
        minBlast: 5,
        maxBlast: 20,
        blastDirectionRad: _directionRadFromCustomization(
          cust,
          defaultCenterDeg: 180,
        ),
        explosive: false,
        lifetimeSec: 1.8 + _random.nextDouble() * 1.2,
        minPaper: const Size(20, 10),
        maxPaper: const Size(30, 15),
        visualShape: visual,
        colors: colors,
        customization: cust,
      );
    });
  }

  // ─── Tick-mode spawn ───────────────────────────────────────────────────────

  static double _presetNominalGravityPx(Preset preset) {
    switch (preset) {
      case Preset.nova:
        return 500;
      case Preset.cascade:
        return 480;
      case Preset.flare:
        return 220;
      case Preset.crossfire:
        return 280;
    }
  }

  /// Defaults tuned for tick-mode spawn options.
  static TickConfettiSpawnOptions _tickPresetDefaults(Preset preset) {
    switch (preset) {
      case Preset.nova:
        return const TickConfettiSpawnOptions(
          angle: 90,
          spread: 360,
          startVelocity: 55,
          decay: 0.94,
          gravity: 1,
          drift: 0,
          flat: false,
          scalar: 1.2,
          ticks: 220,
        );
      case Preset.cascade:
        return const TickConfettiSpawnOptions(
          angle: 90,
          spread: 55,
          startVelocity: 48,
          decay: 0.9,
          gravity: 1,
          drift: 0,
          flat: false,
          scalar: 1,
          ticks: 280,
        );
      case Preset.flare:
        return const TickConfettiSpawnOptions(
          angle: 0,
          spread: 38,
          startVelocity: 52,
          decay: 0.92,
          gravity: 0.8,
          drift: 0,
          flat: false,
          scalar: 1.1,
          ticks: 240,
        );
      case Preset.crossfire:
        return const TickConfettiSpawnOptions(
          angle: 180,
          spread: 48,
          startVelocity: 50,
          decay: 0.9,
          gravity: 0.85,
          drift: 0,
          flat: false,
          scalar: 1,
          ticks: 230,
        );
    }
  }

  static TickConfettiSpawnOptions _resolvedTickOpts(
    Preset preset,
    ConfettiCustomization? cust,
  ) {
    final base = cust?.tickSpawnOptions ?? _tickPresetDefaults(preset);
    final nominal = _presetNominalGravityPx(preset);
    final eff = ConfettiCustomization.effectiveGravity(nominal, cust);
    final factor = eff / nominal;
    return base.copyWith(
      gravity: (base.gravity * factor).clamp(0.01, 12.0),
    );
  }

  static List<Particle> _spawnPresetTick({
    required Preset preset,
    required Size size,
    required List<String> emojiPool,
    required ConfettiCustomization? cust,
    required int defaultCount,
    required Offset Function(Size size) emitter,
    required List<ParticleShape> defaultShapes,
    required double presetNominalGravityPx,
  }) {
    final count = ConfettiCustomization.effectiveCount(defaultCount, cust);
    final opts = _resolvedTickOpts(preset, cust);
    final lm = ConfettiCustomization.effectiveLifetimeMultiplier(cust);
    final colors = _palette(_tickExtendedPalette, cust);
    final shapes = _shapes(defaultShapes, cust);
    final shapePick =
        shapes.isNotEmpty ? shapes : List<ParticleShape>.from(defaultShapes);

    return List.generate(count, (_) {
      final origin = emitter(size);
      final visual = shapePick[_random.nextInt(shapePick.length)];
      final color = colors[_random.nextInt(colors.length)];
      final tc = TickConfettiPhysics.spawn(
        emitterX: origin.dx,
        emitterY: origin.dy,
        options: opts,
        color: color,
        random: _random,
      );
      final emoji = visual == ParticleShape.emoji
          ? emojiPool[_random.nextInt(emojiPool.length)]
          : null;

      return Particle(
        x: origin.dx,
        y: origin.dy,
        vx: 0,
        vy: 0,
        gravity: ConfettiCustomization.effectiveGravity(
          presetNominalGravityPx,
          cust,
        ),
        rotation: 0,
        rotationSpeed: 0,
        color: color,
        shape: visual,
        size: opts.scalar * 16,
        maxLifetime: opts.ticks / 60.0 * lm,
        emoji: emoji,
        tickConfetti: tc,
      );
    });
  }

  // ─── Matrix-path preset spawn ───────────────────────────────────────────────

  /// Converts [ConfettiCustomization.burstDirectionDegrees] to radians when set;
  /// otherwise uses [defaultCenterDeg] (0 = east, 90 = down).
  static double _directionRadFromCustomization(
    ConfettiCustomization? cust, {
    required double defaultCenterDeg,
  }) {
    final dir = cust?.burstDirectionDegrees;
    if (dir != null && dir.isFinite) {
      return dir * pi / 180.0;
    }
    return defaultCenterDeg * pi / 180.0;
  }

  /// Maps [ConfettiCustomization.gravity] (px²-scale API) onto normalized `gravity` ∈ [0,1].
  static double _physicsGravity01(
    ConfettiCustomization? c,
    double baseDemo01,
  ) {
    final g = c?.gravity;
    if (g == null || !g.isFinite) return baseDemo01.clamp(0.0, 1.0);
    return (g / 800.0).clamp(0.0, 1.0);
  }

  static Path _flutterPathForShape(ParticleShape shape, double w, double h) {
    switch (shape) {
      case ParticleShape.star:
        return flutterConfettiDemoStarPath(w, h);
      case ParticleShape.emoji:
      case ParticleShape.circle:
      case ParticleShape.square:
      case ParticleShape.paper:
      case ParticleShape.ribbon:
      case ParticleShape.triangle:
      case ParticleShape.pentagon:
      case ParticleShape.hexagon:
      case ParticleShape.ring:
      case ParticleShape.lightning:
      case ParticleShape.crescent:
      case ParticleShape.arrow:
        return flutterConfettiPaperPath(w, h);
    }
  }

  static Size _randomPaperSize(Random r, Size min, Size max) {
    return Size(
      lerpDouble(min.width, max.width, r.nextDouble())!,
      lerpDouble(min.height, max.height, r.nextDouble())!,
    );
  }

  static (double, double) _blastForce(
    Random r, {
    required bool explosive,
    required double blastDirectionRad,
    required double minF,
    required double maxF,
  }) {
    var dir = blastDirectionRad;
    if (explosive) {
      dir = r.nextInt(359) * pi / 180.0;
    }
    final blastRadius = lerpDouble(minF, maxF, r.nextDouble())!;
    return (blastRadius * cos(dir), blastRadius * sin(dir));
  }

  static Particle _spawnFlutterParticle({
    required double originX,
    required double originY,
    required double presetNominalGravityPx,
    required double baseGravity01,
    required double particleDrag,
    required double minBlast,
    required double maxBlast,
    required double blastDirectionRad,
    required bool explosive,
    required double lifetimeSec,
    required Size minPaper,
    required Size maxPaper,
    required ParticleShape visualShape,
    required List<Color> colors,
    ConfettiCustomization? customization,
  }) {
    final sm = ConfettiCustomization.effectiveSpeedMultiplier(customization);
    final lm = ConfettiCustomization.effectiveLifetimeMultiplier(customization);
    final displayGravity = ConfettiCustomization.effectiveGravity(
        presetNominalGravityPx, customization);
    final g01 = _physicsGravity01(customization, baseGravity01);

    final paper = _randomPaperSize(_random, minPaper, maxPaper);
    final (fx, fy) = _blastForce(
      _random,
      explosive: explosive,
      blastDirectionRad: blastDirectionRad,
      minF: minBlast,
      maxF: maxBlast,
    );

    final colorList = colors.isNotEmpty ? colors : [Colors.white];
    final path = _flutterPathForShape(visualShape, paper.width, paper.height);

    final fc = FlutterConfettiPhysics(
      originX: originX,
      originY: originY,
      gravity01: g01,
      particleDrag: particleDrag,
      startupForceX: fx,
      startupForceY: fy,
      mass: lerpDouble(1, 11, _random.nextDouble())!,
      rotateZ: _random.nextBool(),
      paperWidth: paper.width,
      paperHeight: paper.height,
      random: _random,
      speedMultiplier: sm,
    );

    return Particle(
      x: originX,
      y: originY,
      vx: 0,
      vy: 0,
      gravity: displayGravity,
      rotation: 0,
      rotationSpeed: 0,
      color: colorList[_random.nextInt(colorList.length)],
      shape: visualShape,
      size: max(paper.width, paper.height),
      maxLifetime: lifetimeSec * lm,
      emoji: null,
      flutterConfetti: fc,
      flutterConfettiPath: path,
    );
  }
}

/// Default particle totals before [ConfettiCustomization] — matches [PresetFactory] spawn counts.
extension PresetDefaultParticleCount on Preset {
  /// Particle count used when no [ConfettiCustomization.particleCount] override is set.
  int get defaultParticleCount {
    switch (this) {
      case Preset.nova:
        return 120;
      case Preset.cascade:
        return 200;
      case Preset.flare:
        return 72;
      case Preset.crossfire:
        return 100;
    }
  }
}
