# Skill: Add a New Particle Shape

Use this skill when asked to add a new visual shape to flutter_confetti_engine.

## Checklist

1. **Add the value** to `ParticleShape` enum in `lib/src/particle_shape.dart`.
2. **Add a case** in `ConfettiPainter._drawShape()` in `confetti_painter.dart`.
   - Draw centered on `(0, 0)` — the canvas is already translated to the particle position.
   - Use `canvas.save()` / `canvas.restore()` if sub-transforms are needed.
3. **If the shape needs extra data** (like emoji text), add a nullable field to `Particle` and
   pass it through `PresetFactory._randomParticle()`.
4. **Add the shape** to at least one preset's shape list in `presets.dart`.
5. **Update CLAUDE.md** shape rules table.
6. **Add a visual test** in `test/` to confirm it doesn't throw during paint.

## Canvas Rules for Shapes
- All coordinates relative to (0, 0) center.
- `size` is the bounding dimension (diameter for circle, side for square, etc.).
- `half = size / 2` is your main reference.
- Never hardcode pixel values — always derive from `particle.size`.
