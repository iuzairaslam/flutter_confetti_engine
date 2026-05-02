# Skill: Debug Performance Issues

Use this when confetti animation is dropping frames or running below 60fps.

## Diagnosis Steps

1. **Check particle count** — open the relevant preset in `presets.dart` and confirm
   count is within the guideline (max 200). Reduce if over.

2. **Profile with Flutter DevTools**:
   ```
   flutter run --profile
   # Open DevTools → Performance tab → record while animation plays
   ```
   Look for: long `build` frames, expensive `paint` calls, GC pressure.

3. **Check emoji shape usage** — `TextPainter` is the most expensive shape.
   If emoji count is high in a preset, reduce or replace with `star`/`circle`.

4. **Check `setState` frequency** — `confetti_widget.dart` calls `setState` every frame.
   Confirm it's guarded: only called when `_animationController.isAnimating`.

5. **Check `shouldRepaint`** — currently always returns `true` during animation.
   After animation stops, the Ticker is stopped so no repaints occur. Verify
   `_animationController.stop()` is called when all particles are dead.

6. **Check for memory leaks**:
   - `ConfettiController.dispose()` called in host widget's `dispose()`?
   - `AudioPlayerWrapper.dispose()` called in `confetti_widget.dart dispose()`?
   - `_animationController.dispose()` called?

## Quick Fix: Reduce Count
In `presets.dart`, halve the particle count for the offending preset.
This is always the fastest fix — profile afterward to confirm.
