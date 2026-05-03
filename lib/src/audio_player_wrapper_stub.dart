/// No-op audio wrapper for platforms where neither dart:io nor
/// dart:js_interop is available.
class AudioPlayerWrapper {
  /// No-op play.
  Future<void> play(String assetPath) async {}

  /// No-op dispose.
  Future<void> dispose() async {}
}
