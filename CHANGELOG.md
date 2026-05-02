# Changelog

## 1.0.0 — 2026-05-02

### Changed

- Stable **1.0.0** release; dependency constraint for consumers: `flutter_confetti_engine: ^1.0.0`.

## 0.1.0 — 2026-05-02

### Added

- Particle physics, eight shapes, four presets (`burst`, `rain`, `fireworks`, `snow`).
- `ConfettiWidget`, `ConfettiController`, platform haptics, optional sound via `audioplayers`.
- `ConfettiEngine.celebrate()` full-screen overlay API.
- Stock cheerful MP3s under `assets/sounds/` and **`ConfettiBundledSounds`** (`burst`, `rain`, `fireworks`, `snow`, plus `pathForPreset`).
- **`CelebrationFeedback.bundledForPreset`** / **`CelebrationFeedback.customAsset`** — explicit package vs app-owned sound choice; **`none()`** / **`hapticsOnly()`** — disable sound and/or haptics.
- **`emojiPool`** on **`ConfettiWidget`** / **`ConfettiEngine.celebrate`** and exported **`kDefaultCelebrationEmojis`** for emoji-shaped particles.
- **10 new `ParticleShape` values** (`pentagon`, `hexagon`, `ring`, `plus`, `lightning`, `crescent`, `arrow`, `shield`, `oval`, `sunburst`) with canvas implementations in **`ConfettiPainter`**.
- **`ConfettiCustomization`** — optional `particleCount`, `colors`, `shapeMix`, `gravity`, `speedMultiplier`, `lifetimeMultiplier` on **`ConfettiWidget`** / **`ConfettiEngine.celebrate`**.
