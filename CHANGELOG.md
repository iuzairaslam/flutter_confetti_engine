# Changelog

## 1.0.7 — 2026-05-03

### Added

- **10 built-in synthesized sounds** — `BuiltinSound.pop`, `.chime`, `.fanfare`, `.applause`, `.whoosh`, `.drumroll`, `.levelUp`, `.bell`, `.sparkle`, `.airhorn`. All clips are original Python-synthesized WAV files, MIT-licensed, zero external assets needed.
- **`BuiltinSound` enum** with `assetPath` getter (automatically prefixed with `packages/flutter_confetti_engine/…`) — no `pubspec.yaml` registration required in the consuming app.
- **`ConfettiBundledSounds`** updated: 10 convenience path getters, `builtinForPreset()`, and `pathForPreset()` mapping each preset to the best-matched clip.
- **`CelebrationFeedback.builtinSound`** field — pick any `BuiltinSound` directly without a custom asset path.
- **`CelebrationFeedback.bundledForPreset(Preset)`** factory auto-selects the matching built-in clip.
- **Explicit `platforms:` declaration** in `pubspec.yaml` — supports `android`, `ios`, `linux`, `macos`, `web`, `windows`.

### Changed

- **`Preset` enum renamed** for clarity and originality: `nova` (was `blastStars`), `cascade` (was `goliath`), `flare` (was `singles`), `crossfire` (was `pumpLeft`).
- **Example app** updated: 10-sound showcase grid, new preset display names, stat chip shows "10 sounds".
- **`ConfettiDensity` enum values** now have individual doc comments (`low`, `medium`, `high`).

## 1.0.6 — 2026-05-03

### Changed

- Dev dependency **`flutter_lints`** raised to **^6.0.0** (latest compatible with current SDK).

## 1.0.5 — 2026-05-03

### Changed

- Patch release to trigger **pub.dev** publish via GitHub Actions tag workflow (`v1.0.5` / aligned `publish.yml`).

## 1.0.4 — 2026-05-03

### Fixed

- **CI:** Applied `dart format` and `dart fix` so `flutter analyze` is clean (package + example app). Restores green GitHub Actions for format, analyze, test, and `dart pub publish --dry-run`.

## 1.0.3 — 2026-05-02

### Fixed

- **Pub.dev score / metadata:** Removed explicit `documentation:` URL from `pubspec.yaml` so package analysis does not fail the “Documentation URL” check before hosted API docs are generated (pub.dev still links to generated docs automatically).
- **Dartdoc:** Resolved broken `[reference]` links in library comments (public API docs).

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
