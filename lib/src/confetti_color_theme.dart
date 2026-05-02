import 'package:flutter/material.dart';

/// Named palettes for themed celebration scenes.
///
/// Use with [CelebrationScene.themed] or build a [ConfettiCustomization] via
/// [ConfettiColorThemes.palette].
enum ConfettiColorTheme {
  /// Full-spectrum hues.
  rainbow,

  /// Soft, washed saturation.
  pastel,

  /// High saturation / glow feel.
  neon,

  /// Amber / yellow emphasis.
  gold,

  /// Gray metallics.
  silver,

  /// Red / green mix suited to holidays.
  festive,

  /// Bright party colors.
  birthday,

  /// Cool blues and teals.
  blue,

  /// Greens — reads as “success”.
  green,

  /// Magentas and purples.
  purple,

  /// Warm oranges and corals.
  orange,

  /// Teals and cyans.
  teal,

  /// Pinks and magentas (distinct from [purple]).
  pink,
}

/// Resolves [ConfettiColorTheme] to concrete [Color] lists for [ConfettiCustomization.colors].
abstract final class ConfettiColorThemes {
  ConfettiColorThemes._();

  /// Palette for [ConfettiColorTheme] — finite length, safe for particle picking.
  static List<Color> palette(ConfettiColorTheme theme) {
    switch (theme) {
      case ConfettiColorTheme.rainbow:
        return const [
          Color(0xFFE53935),
          Color(0xFFFF9800),
          Color(0xFFFFEB3B),
          Color(0xFF4CAF50),
          Color(0xFF2196F3),
          Color(0xFF9C27B0),
          Color(0xFFE91E63),
        ];
      case ConfettiColorTheme.pastel:
        return const [
          Color(0xFFFFCDD2),
          Color(0xFFFFE0B2),
          Color(0xFFFFF9C4),
          Color(0xFFC8E6C9),
          Color(0xFFBBDEFB),
          Color(0xFFD1C4E9),
          Color(0xFFF8BBD0),
        ];
      case ConfettiColorTheme.neon:
        return const [
          Color(0xFFFF1744),
          Color(0xFFFFEA00),
          Color(0xFF00E676),
          Color(0xFF00B0FF),
          Color(0xFFD500F9),
          Color(0xFFFF6D00),
        ];
      case ConfettiColorTheme.gold:
        return const [
          Color(0xFFFFF8E1),
          Color(0xFFFFECB3),
          Color(0xFFFFD54F),
          Color(0xFFFFC107),
          Color(0xFFFFA000),
          Color(0xFFFF8F00),
        ];
      case ConfettiColorTheme.silver:
        return const [
          Color(0xFFF5F5F5),
          Color(0xFFE0E0E0),
          Color(0xFFBDBDBD),
          Color(0xFF9E9E9E),
          Color(0xFF78909C),
        ];
      case ConfettiColorTheme.festive:
        return const [
          Color(0xFFC62828),
          Color(0xFF2E7D32),
          Color(0xFFFFFDE7),
          Color(0xFFFFD54F),
          Color(0xFF8D6E63),
        ];
      case ConfettiColorTheme.birthday:
        return const [
          Color(0xFFFF4081),
          Color(0xFF7C4DFF),
          Color(0xFF40C4FF),
          Color(0xFF69F0AE),
          Color(0xFFFFEA00),
          Color(0xFFFF6E40),
        ];
      case ConfettiColorTheme.blue:
        return const [
          Color(0xFFE3F2FD),
          Color(0xFF90CAF9),
          Color(0xFF42A5F5),
          Color(0xFF1E88E5),
          Color(0xFF1565C0),
          Color(0xFF00838F),
        ];
      case ConfettiColorTheme.green:
        return const [
          Color(0xFFE8F5E9),
          Color(0xFF81C784),
          Color(0xFF43A047),
          Color(0xFF2E7D32),
          Color(0xFF00C853),
          Color(0xFF69F0AE),
        ];
      case ConfettiColorTheme.purple:
        return const [
          Color(0xFFF3E5F5),
          Color(0xFFCE93D8),
          Color(0xFFAB47BC),
          Color(0xFF8E24AA),
          Color(0xFF6A1B9A),
          Color(0xFFD500F9),
        ];
      case ConfettiColorTheme.orange:
        return const [
          Color(0xFFFBE9E7),
          Color(0xFFFFAB91),
          Color(0xFFFF7043),
          Color(0xFFFF5722),
          Color(0xFFE64A19),
          Color(0xFFFFCC80),
        ];
      case ConfettiColorTheme.teal:
        return const [
          Color(0xFFE0F2F1),
          Color(0xFF80CBC4),
          Color(0xFF26A69A),
          Color(0xFF00897B),
          Color(0xFF00695C),
          Color(0xFF004D40),
        ];
      case ConfettiColorTheme.pink:
        return const [
          Color(0xFFFCE4EC),
          Color(0xFFF48FB1),
          Color(0xFFEC407A),
          Color(0xFFE91E63),
          Color(0xFFC2185B),
          Color(0xFFFF80AB),
        ];
    }
  }
}
