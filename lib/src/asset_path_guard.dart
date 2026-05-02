/// Lightweight validation for Flutter asset keys passed to [AssetBundle] APIs.
///
/// Defense-in-depth only: the bundle still resolves paths inside packaged assets;
/// this blocks obviously malicious or degenerate strings (path traversal
/// segments, extreme length) before they reach native codecs.
bool isSafeFlutterAssetKey(String path) {
  if (path.isEmpty || path.length > 2048) return false;
  if (path.contains('\x00')) return false;

  final normalized = path.replaceAll(r'\', '/');
  for (final segment in normalized.split('/')) {
    if (segment == '..') return false;
  }
  return true;
}
