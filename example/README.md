# Example: `flutter_confetti_engine`

Interactive demo for the parent package. See the [package README](../README.md) for API details.

```bash
cd example
flutter run
```

**UI:** dark catalog (**`demo_theme.dart`**), **`ListView`** of presets (`nova`, `cascade`, `flare`, `crossfire`), showcases, dialogs/banners → detail screens with code + **Let’s try**. **`demo_prefs.dart`** / **`DemoPrefsScope`** toggles tick physics for preset previews.

**Sound:** **`demo_feedback.dart`** builds **`CelebrationFeedback`** with **`BuiltinSound`** (bundled `.wav` clips from the package — see parent **`README.md`** → Built-in Sounds). Preset samples use **`CelebrationFeedback.bundledForPreset`**. The example **`pubspec`** may still list **`assets/children_yay.mp3`** for local experiments or tests; primary demos use **`BuiltinSound`**, not custom MP3 paths.
