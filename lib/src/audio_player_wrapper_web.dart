import 'dart:js_interop';

import 'package:web/web.dart' as web;

import 'asset_path_guard.dart';

/// WASM-compatible audio wrapper for web platforms.
///
/// Uses the browser's native HTMLAudioElement via package:web — no dart:io,
/// no native plugins. Flutter web serves Flutter assets at their asset path
/// (e.g. `packages/flutter_confetti_engine/assets/sounds/pop.wav`) so those
/// paths are used directly as the element's `src`.
class AudioPlayerWrapper {
  web.HTMLAudioElement? _audio;

  /// Plays the audio asset at [assetPath] using HTMLAudioElement.
  ///
  /// Silently degrades if playback fails for any reason.
  Future<void> play(String assetPath) async {
    if (!isSafeFlutterAssetKey(assetPath)) return;
    try {
      final normalized = assetPath.replaceAll(r'\', '/');
      final String src;
      if (normalized.startsWith('packages/') ||
          normalized.startsWith('assets/')) {
        src = normalized;
      } else {
        src = 'assets/$normalized';
      }
      _audio = web.HTMLAudioElement();
      _audio!.src = src;
      await _audio!.play().toDart;
    } catch (_) {
      // Silent degradation — celebration continues without sound.
    }
  }

  /// Stops and releases the audio element.
  Future<void> dispose() async {
    try {
      _audio?.pause();
    } catch (_) {
      // Ignore dispose errors.
    } finally {
      _audio = null;
    }
  }
}
