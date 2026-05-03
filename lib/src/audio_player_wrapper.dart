// Platform-adaptive audio wrapper.
// On native (dart:io): delegates to just_audio via audio_player_wrapper_io.dart.
// On web / WASM (dart:js_interop): uses HTMLAudioElement via
// audio_player_wrapper_web.dart — zero dart:io, fully WASM-compatible.
// Fallback stub (no platform libraries): no-op.
// All three implementations expose the same AudioPlayerWrapper class name
// so callers in confetti_widget.dart require no conditional code.
export 'audio_player_wrapper_stub.dart'
    if (dart.library.io) 'audio_player_wrapper_io.dart'
    if (dart.library.js_interop) 'audio_player_wrapper_web.dart';
