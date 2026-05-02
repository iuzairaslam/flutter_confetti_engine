# Skill: Add a New Preset

Use this skill when asked to add a new animation preset to flutter_confetti_engine.

## Checklist

1. **Add the value** to the `Preset` enum in `lib/src/presets.dart`.
2. **Add a factory method** `_createYourPreset(Size size)` to `PresetFactory`.
   - Follow existing methods: use `_random`, `_randomParticle()`, return `List<Particle>`.
   - Set gravity/lifetime/velocity per the Physics Rules in CLAUDE.md.
3. **Add a case** in `PresetFactory.createParticles()` switch.
4. **Add a haptic mapping** in `confetti_widget.dart` inside `_fireHaptic()`.
5. **Update the preset table** in CLAUDE.md.
6. **Add a test** in `test/preset_test.dart`:
   ```dart
   test('YourPreset produces correct particle count', () {
     final particles = PresetFactory.createParticles(Preset.yourPreset, testSize);
     expect(particles.length, equals(expectedCount));
   });
   ```
7. **Add a button** in `example/lib/main.dart`.
8. **Update** `doc/flutter_confetti_engine_spec.docx` with new preset table row.

## Particle Count Guideline
| Intensity | Count  |
|-----------|--------|
| Subtle    | 50–80  |
| Normal    | 100–150|
| Heavy     | 150–200|

Never exceed 200 particles — performance degrades on mid-range devices.
