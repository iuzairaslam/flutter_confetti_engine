import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ── Brand palette ────────────────────────────────────────────────────────────

const Color kBgDeep      = Color(0xFF090919);
const Color kBgCard      = Color(0xFF12122A);
const Color kBgCodeBlock = Color(0xFF06060F);
const Color kBorderFaint = Color(0x18FFFFFF);
const Color kTextMuted   = Color(0xFF7575A8);

const Color kAccentViolet = Color(0xFF8B5CF6);
const Color kAccentCoral  = Color(0xFFFF6B6B);
const Color kAccentTeal   = Color(0xFF06D6A0);
const Color kAccentAmber  = Color(0xFFFFD166);

// ── Theme builder ─────────────────────────────────────────────────────────────

ThemeData buildDemoTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: kAccentViolet,
    brightness: Brightness.dark,
  ).copyWith(
    surface: kBgDeep,
    surfaceContainerLow: kBgCard,
    surfaceContainerHighest: const Color(0xFF1C1C35),
    primary: kAccentViolet,
    onPrimary: Colors.white,
    secondary: kAccentCoral,
    tertiary: kAccentTeal,
    onSurface: Colors.white,
    onSurfaceVariant: kTextMuted,
  );

  final base = ThemeData(
    colorScheme: scheme,
    useMaterial3: true,
    scaffoldBackgroundColor: kBgDeep,
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: kBgDeep,
      foregroundColor: Colors.white,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      iconTheme: IconThemeData(color: Colors.white),
      actionsIconTheme: IconThemeData(color: Colors.white),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      color: kBgCard,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: kBorderFaint),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(54),
        backgroundColor: kAccentViolet,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: kBgCard,
      contentTextStyle: const TextStyle(color: Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      behavior: SnackBarBehavior.floating,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected) ? kAccentViolet : kTextMuted,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected)
            ? kAccentViolet.withValues(alpha: 0.3)
            : Colors.white12,
      ),
    ),
  );

  return base.copyWith(
    textTheme: base.textTheme.apply(decoration: TextDecoration.none),
  );
}
