import 'package:audioplayers/audioplayers.dart';

import 'asset_path_guard.dart';

/// A crash-safe wrapper around [AudioPlayer] for optional confetti sound.
///
/// [AudioPlayer.setSourceAsset] uses [AudioCache] with a default prefix of
/// `'assets/'`. Full Flutter keys like `'assets/sounds/x.mp3'` must be normalized
/// (otherwise loading resolves to `'assets/assets/...'`). Keys starting with
/// `'packages/'` need an empty prefix. [play] applies both conventions.
///
/// All [audioplayers] calls are guarded by try/catch so that:
/// - A missing asset never throws.
/// - A codec/platform error never crashes the app.
/// - Consumers who pass `enableSound: false` never instantiate this class.
///
/// This class is an internal implementation detail and is not exported by
/// the package barrel.
class AudioPlayerWrapper {
  AudioPlayer? _player;

  /// Plays the audio asset at [assetPath] (a Flutter asset path registered in
  /// the consuming app's `pubspec.yaml`).
  ///
  /// Silently degrades if playback is impossible for any reason.
  Future<void> play(String assetPath) async {
    if (!isSafeFlutterAssetKey(assetPath)) return;
    try {
      _player ??= AudioPlayer();

      final normalized = assetPath.replaceAll(r'\', '/');
      final AudioCache cache;
      final String fileName;
      if (normalized.startsWith('packages/')) {
        cache = AudioCache(prefix: '');
        fileName = normalized;
      } else {
        cache = AudioCache(prefix: 'assets/');
        fileName = normalized.startsWith('assets/')
            ? normalized.substring('assets/'.length)
            : normalized;
      }
      _player!.audioCache = cache;

      await _player!.stop();
      await _player!.setSourceAsset(fileName);
      await _player!.resume();
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
