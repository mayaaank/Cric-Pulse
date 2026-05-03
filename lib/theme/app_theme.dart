import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static const _surface = Color(0xFF11131A);
  static const _surfaceDim = Color(0xFF11131A);
  static const _surfaceBright = Color(0xFF363940);
  static const _surfaceContainerLowest = Color(0xFF0B0E15);
  static const _surfaceContainerLow = Color(0xFF191B22);
  static const _surfaceContainer = Color(0xFF1D2026);
  static const _surfaceContainerHigh = Color(0xFF272A31);
  static const _surfaceContainerHighest = Color(0xFF32353C);
  static const _onSurface = Color(0xFFE1E2EB);
  static const _onSurfaceVariant = Color(0xFFC2C6D5);
  static const _outline = Color(0xFF8C909F);
  static const _outlineVariant = Color(0xFF424753);
  static const _primary = Color(0xFFADC6FF);
  static const _onPrimary = Color(0xFF002E69);
  static const _primaryContainer = Color(0xFF4D8EFE);
  static const _onPrimaryContainer = Color(0xFF00285C);
  static const _secondary = Color(0xFF6DDD81);
  static const _onSecondary = Color(0xFF003914);
  static const _secondaryContainer = Color(0xFF30A550);
  static const _tertiary = Color(0xFFFBBC06);
  static const _onTertiary = Color(0xFF402D00);
  static const _error = Color(0xFFFFB4AB);
  static const _onError = Color(0xFF690005);
  static const _errorContainer = Color(0xFF93000A);
  static const _background = Color(0xFF11131A);

  static final ColorScheme darkScheme = const ColorScheme.dark().copyWith(
    surface: _surface,
    onSurface: _onSurface,
    onSurfaceVariant: _onSurfaceVariant,
    surfaceDim: _surfaceDim,
    surfaceBright: _surfaceBright,
    surfaceContainerLowest: _surfaceContainerLowest,
    surfaceContainerLow: _surfaceContainerLow,
    surfaceContainer: _surfaceContainer,
    surfaceContainerHigh: _surfaceContainerHigh,
    surfaceContainerHighest: _surfaceContainerHighest,
    primary: _primary,
    onPrimary: _onPrimary,
    primaryContainer: _primaryContainer,
    onPrimaryContainer: _onPrimaryContainer,
    secondary: _secondary,
    onSecondary: _onSecondary,
    secondaryContainer: _secondaryContainer,
    tertiary: _tertiary,
    onTertiary: _onTertiary,
    error: _error,
    onError: _onError,
    errorContainer: _errorContainer,
    outline: _outline,
    outlineVariant: _outlineVariant,
  );

  static TextTheme _buildTextTheme() {
    final spline = GoogleFonts.splineSansTextTheme();
    final lexend = GoogleFonts.lexendTextTheme();
    return TextTheme(
      displayLarge: spline.displayLarge!.copyWith(fontSize: 48, fontWeight: FontWeight.w700, height: 56 / 48, letterSpacing: -0.02 * 48, color: _onSurface),
      displayMedium: spline.displayMedium!.copyWith(fontSize: 40, fontWeight: FontWeight.w700, height: 48 / 40, color: _onSurface),
      displaySmall: spline.displaySmall!.copyWith(fontSize: 36, fontWeight: FontWeight.w700, height: 44 / 36, color: _onSurface),
      headlineLarge: spline.headlineLarge!.copyWith(fontSize: 32, fontWeight: FontWeight.w700, height: 40 / 32, color: _onSurface),
      headlineMedium: spline.headlineMedium!.copyWith(fontSize: 24, fontWeight: FontWeight.w700, height: 32 / 24, color: _onSurface),
      headlineSmall: spline.headlineSmall!.copyWith(fontSize: 20, fontWeight: FontWeight.w700, height: 28 / 20, color: _onSurface),
      bodyLarge: lexend.bodyLarge!.copyWith(fontSize: 18, fontWeight: FontWeight.w400, height: 28 / 18, color: _onSurface),
      bodyMedium: lexend.bodyMedium!.copyWith(fontSize: 16, fontWeight: FontWeight.w400, height: 24 / 16, color: _onSurface),
      bodySmall: lexend.bodySmall!.copyWith(fontSize: 14, fontWeight: FontWeight.w400, height: 20 / 14, color: _onSurfaceVariant),
      labelLarge: lexend.labelLarge!.copyWith(fontSize: 14, fontWeight: FontWeight.w500, height: 20 / 14, letterSpacing: 0.1, color: _onSurface),
      labelMedium: lexend.labelMedium!.copyWith(fontSize: 12, fontWeight: FontWeight.w500, height: 16 / 12, letterSpacing: 0.5, color: _onSurfaceVariant),
      labelSmall: lexend.labelSmall!.copyWith(fontSize: 11, fontWeight: FontWeight.w500, height: 16 / 11, letterSpacing: 0.5, color: _onSurfaceVariant),
      titleLarge: spline.titleLarge!.copyWith(fontSize: 22, fontWeight: FontWeight.w700, height: 28 / 22, color: _onSurface),
      titleMedium: lexend.titleMedium!.copyWith(fontSize: 16, fontWeight: FontWeight.w600, height: 24 / 16, color: _onSurface),
      titleSmall: lexend.titleSmall!.copyWith(fontSize: 14, fontWeight: FontWeight.w600, height: 20 / 14, color: _onSurface),
    );
  }

  static ThemeData dark() {
    final textTheme = _buildTextTheme();
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: darkScheme,
      scaffoldBackgroundColor: _background,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: _background,
        foregroundColor: _onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: _surfaceContainerHigh.withValues(alpha: 0.5),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryContainer,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: textTheme.labelLarge,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: _surfaceContainerLow,
        selectedItemColor: _primaryContainer,
        unselectedItemColor: _outline,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: textTheme.labelSmall!.copyWith(color: _primaryContainer),
        unselectedLabelStyle: textTheme.labelSmall,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: _surfaceContainerHigh,
        labelStyle: textTheme.labelSmall!,
        shape: const StadiumBorder(),
        side: BorderSide.none,
      ),
      dividerTheme: DividerThemeData(color: _outlineVariant.withValues(alpha: 0.5), thickness: 0.5),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? _primaryContainer : _outline),
        trackColor: WidgetStateProperty.resolveWith((s) => s.contains(WidgetState.selected) ? _primaryContainer.withValues(alpha: 0.3) : _surfaceContainerHigh),
      ),
    );
  }
}
