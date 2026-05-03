import 'package:just_audio/just_audio.dart';

import 'asset_path_guard.dart';

/// Native audio wrapper for platforms where dart:io is available.
///
/// All just_audio calls are guarded by try/catch so that:
/// - A missing asset never throws.
/// - A codec/platform error never crashes the app.
class AudioPlayerWrapper {
  AudioPlayer? _player;

  /// Plays the audio asset at [assetPath].
  ///
  /// Accepts Flutter asset paths (`assets/sounds/x.wav`), package-prefixed
  /// paths (`packages/pkg_name/assets/sounds/x.wav`), or bare file names
  /// (auto-prefixed with `assets/`).
  ///
  /// Silently degrades if playback is impossible for any reason.
  Future<void> play(String assetPath) async {
    if (!isSafeFlutterAssetKey(assetPath)) return;
    try {
      _player ??= AudioPlayer();

      final normalized = assetPath.replaceAll(r'\', '/');
      final String fullPath;
      if (normalized.startsWith('packages/') ||
          normalized.startsWith('assets/')) {
        fullPath = normalized;
      } else {
        fullPath = 'assets/$normalized';
      }

      await _player!.stop();
      await _player!.setAsset(fullPath);
      await _player!.play();
    } catch (_) {
      // Silent degradation — celebration continues without sound.
    }
  }

  /// Releases underlying platform resources.
  ///
  /// Must be called when the owning widget is disposed.
  Future<void> dispose() async {
    try {
      await _player?.dispose();
    } catch (_) {
      // Ignore dispose errors.
    } finally {
      _player = null;
    }
  }
}
