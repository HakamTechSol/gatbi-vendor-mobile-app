import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

abstract final class AppTheme {
  AppTheme._();

  // ═══════════════════════════════════════════════════════════════════════════
  // LIGHT THEME
  // ═══════════════════════════════════════════════════════════════════════════

  static ThemeData get light {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,

      // Primary
      primary: AppColors.primary,
      onPrimary: AppColors.textOnPrimary,
      primaryContainer: AppColors.primaryLight,
      onPrimaryContainer: AppColors.navy,

      // Secondary
      secondary: AppColors.purple,
      onSecondary: AppColors.textOnPrimary,
      secondaryContainer: AppColors.purpleLight,
      onSecondaryContainer: AppColors.purpleDark,

      // Tertiary
      tertiary: AppColors.info,
      onTertiary: AppColors.textOnPrimary,
      tertiaryContainer: AppColors.infoLight,
      onTertiaryContainer: AppColors.infoDark,

      // Error
      error: AppColors.error,
      onError: AppColors.textOnPrimary,
      errorContainer: AppColors.errorLight,
      onErrorContainer: AppColors.errorDark,

      // Surface
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,

      surfaceContainerHighest: AppColors.surfaceMuted,
      onSurfaceVariant: AppColors.textSecondary,

      // Outline
      outline: AppColors.border,
      outlineVariant: AppColors.divider,

      // Inverse
      inverseSurface: AppColors.navyDark,
      onInverseSurface: AppColors.white,
      inversePrimary: AppColors.primaryLight,

      // Scrim
      scrim: AppColors.overlay,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // ═══════════════════════════════════════════════════════════════════════
      // COLOR SCHEME
      // ═══════════════════════════════════════════════════════════════════════
      colorScheme: colorScheme,

      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      canvasColor: AppColors.background,

      // ═══════════════════════════════════════════════════════════════════════
      // TYPOGRAPHY
      // ═══════════════════════════════════════════════════════════════════════
      textTheme: _textTheme,

      // ═══════════════════════════════════════════════════════════════════════
      // APP BAR
      // ═══════════════════════════════════════════════════════════════════════
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,

        titleTextStyle: AppTextStyles.headlineSmall,

        iconTheme: IconThemeData(color: AppColors.iconPrimary, size: 22),

        actionsIconTheme: IconThemeData(
          color: AppColors.iconSecondary,
          size: 22,
        ),
      ),

      // ═══════════════════════════════════════════════════════════════════════
      // CARD
      // ═══════════════════════════════════════════════════════════════════════
      cardTheme: CardThemeData(
        color: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.divider, width: 1),
        ),

        shadowColor: AppColors.shadow,
      ),

      // ═══════════════════════════════════════════════════════════════════════
      // INPUT / TEXT FIELD
      // ═══════════════════════════════════════════════════════════════════════
      inputDecorationTheme: InputDecorationTheme(
        filled: true,

        fillColor: AppColors.inputBackground,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),

        hintStyle: AppTextStyles.authHint,

        labelStyle: AppTextStyles.authFieldLabel,

        floatingLabelStyle: AppTextStyles.authFieldLabel.copyWith(
          color: AppColors.primary,
        ),

        prefixIconColor: AppColors.iconSecondary,

        suffixIconColor: AppColors.iconSecondary,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border, width: 1),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border, width: 1),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.inputFocusedBorder,
            width: 1.5,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),

        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border, width: 1),
        ),

        errorStyle: AppTextStyles.formError,
      ),
      // ═══════════════════════════════════════════════════════════════════════
      // ELEVATED BUTTON
      // ═══════════════════════════════════════════════════════════════════════
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          elevation: const WidgetStatePropertyAll(0),

          minimumSize: const WidgetStatePropertyAll(Size(double.infinity, 52)),

          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),

          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),

          backgroundColor: const WidgetStatePropertyAll(AppColors.primary),

          foregroundColor: const WidgetStatePropertyAll(
            AppColors.textOnPrimary,
          ),

          overlayColor: WidgetStatePropertyAll(
            AppColors.primaryDark.withValues(alpha: 0.15),
          ),

          textStyle: const WidgetStatePropertyAll(AppTextStyles.buttonLarge),
        ),
      ),

      // ═══════════════════════════════════════════════════════════════════════
      // OUTLINED BUTTON
      // ═══════════════════════════════════════════════════════════════════════
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(Size(double.infinity, 52)),

          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),

          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),

          side: const WidgetStatePropertyAll(
            BorderSide(color: AppColors.borderPrimary, width: 1),
          ),

          foregroundColor: const WidgetStatePropertyAll(AppColors.primary),

          overlayColor: WidgetStatePropertyAll(
            AppColors.primary.withValues(alpha: 0.06),
          ),

          textStyle: const WidgetStatePropertyAll(AppTextStyles.buttonOutlined),
        ),
      ),

      // ═══════════════════════════════════════════════════════════════════════
      // TEXT BUTTON
      // ═══════════════════════════════════════════════════════════════════════
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(Size(48, 44)),

          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),

          foregroundColor: const WidgetStatePropertyAll(AppColors.primary),

          overlayColor: WidgetStatePropertyAll(
            AppColors.primary.withValues(alpha: 0.06),
          ),

          textStyle: const WidgetStatePropertyAll(AppTextStyles.buttonText),

          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),

      // ═══════════════════════════════════════════════════════════════════════
      // ICON BUTTON
      // ═══════════════════════════════════════════════════════════════════════
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          foregroundColor: const WidgetStatePropertyAll(
            AppColors.iconSecondary,
          ),

          overlayColor: WidgetStatePropertyAll(
            AppColors.primary.withValues(alpha: 0.08),
          ),

          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),

      // ═══════════════════════════════════════════════════════════════════════
      // FLOATING ACTION BUTTON
      // ═══════════════════════════════════════════════════════════════════════
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 4,
        shape: CircleBorder(),
      ),

      // ═══════════════════════════════════════════════════════════════════════
      // CHIP
      // ═══════════════════════════════════════════════════════════════════════
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.chipBackground,
        selectedColor: AppColors.selectedBackground,

        disabledColor: AppColors.disabled,

        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),

        labelStyle: AppTextStyles.filterChip,

        secondaryLabelStyle: AppTextStyles.filterChipSelected,

        side: const BorderSide(color: AppColors.border, width: 1),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),

        elevation: 0,
      ),

      // ═══════════════════════════════════════════════════════════════════════
      // DIVIDER
      // ═══════════════════════════════════════════════════════════════════════
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),

      // ═══════════════════════════════════════════════════════════════════════
      // CHECKBOX
      // ═══════════════════════════════════════════════════════════════════════
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),

        side: const BorderSide(color: AppColors.borderStrong, width: 1.5),

        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }

          return AppColors.white;
        }),

        checkColor: const WidgetStatePropertyAll(AppColors.white),
      ),

      // ═══════════════════════════════════════════════════════════════════════
      // RADIO
      // ═══════════════════════════════════════════════════════════════════════
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }

          return AppColors.borderStrong;
        }),
      ),

      // ═══════════════════════════════════════════════════════════════════════
      // SWITCH
      // ═══════════════════════════════════════════════════════════════════════
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.white;
          }

          return AppColors.textMuted;
        }),

        trackColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }

          return AppColors.surfaceMuted;
        }),

        trackOutlineColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }

          return AppColors.border;
        }),
      ),

      // ═══════════════════════════════════════════════════════════════════════
      // PROGRESS INDICATOR
      // ═══════════════════════════════════════════════════════════════════════
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.primaryLight,
        circularTrackColor: AppColors.primaryLight,
      ),

      // ═══════════════════════════════════════════════════════════════════════
      // DROPDOWN
      // ═══════════════════════════════════════════════════════════════════════
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: AppTextStyles.bodyMedium,

        menuStyle: MenuStyle(
          backgroundColor: const WidgetStatePropertyAll(AppColors.surface),

          elevation: const WidgetStatePropertyAll(6),

          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: AppColors.divider),
            ),
          ),
        ),
      ),

      // ═══════════════════════════════════════════════════════════════════════
      // DIALOG
      // ═══════════════════════════════════════════════════════════════════════
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 8,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

        titleTextStyle: AppTextStyles.dialogTitle,

        contentTextStyle: AppTextStyles.dialogDescription,

        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      ),

      // ═══════════════════════════════════════════════════════════════════════
      // BOTTOM SHEET
      // ═══════════════════════════════════════════════════════════════════════
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 8,

        modalElevation: 8,

        showDragHandle: true,

        dragHandleColor: AppColors.borderStrong,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),

      // ═══════════════════════════════════════════════════════════════════════
      // SNACKBAR
      // ═══════════════════════════════════════════════════════════════════════
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.navyDark,

        contentTextStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.white,
        ),

        actionTextColor: AppColors.primaryLight,

        behavior: SnackBarBehavior.floating,

        elevation: 6,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),

      // ═══════════════════════════════════════════════════════════════════════
      // TOOLTIP
      // ═══════════════════════════════════════════════════════════════════════
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.navyDark,
          borderRadius: BorderRadius.circular(8),
        ),

        textStyle: const TextStyle(
          color: AppColors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),

        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),

      // ═══════════════════════════════════════════════════════════════════════
      // LIST TILE
      // ═══════════════════════════════════════════════════════════════════════
      listTileTheme: const ListTileThemeData(
        tileColor: Colors.transparent,

        iconColor: AppColors.iconSecondary,

        textColor: AppColors.textPrimary,

        titleTextStyle: AppTextStyles.titleMedium,

        subtitleTextStyle: AppTextStyles.bodySmall,

        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),

        minLeadingWidth: 24,
      ),

      // ═══════════════════════════════════════════════════════════════════════
      // PAGE TRANSITIONS
      // ═══════════════════════════════════════════════════════════════════════
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.linux: CupertinoPageTransitionsBuilder(),
        },
      ),

      // ═══════════════════════════════════════════════════════════════════════
      // SPLASH / HIGHLIGHT
      // ═══════════════════════════════════════════════════════════════════════
      splashFactory: InkSparkle.splashFactory,

      highlightColor: Colors.transparent,

      splashColor: AppColors.primary.withValues(alpha: 0.08),

      // ═══════════════════════════════════════════════════════════════════════
      // MATERIAL
      // ═══════════════════════════════════════════════════════════════════════
      materialTapTargetSize: MaterialTapTargetSize.padded,

      visualDensity: VisualDensity.standard,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // TEXT THEME
  // ═══════════════════════════════════════════════════════════════════════════

  static TextTheme get _textTheme {
    return const TextTheme(
      displayLarge: AppTextStyles.displayLarge,
      displayMedium: AppTextStyles.displayMedium,
      displaySmall: AppTextStyles.displaySmall,

      headlineLarge: AppTextStyles.headlineLarge,
      headlineMedium: AppTextStyles.headlineMedium,
      headlineSmall: AppTextStyles.headlineSmall,

      titleLarge: AppTextStyles.titleLarge,
      titleMedium: AppTextStyles.titleMedium,
      titleSmall: AppTextStyles.titleSmall,

      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.bodyMedium,
      bodySmall: AppTextStyles.bodySmall,

      labelLarge: AppTextStyles.labelLarge,
      labelMedium: AppTextStyles.labelMedium,
      labelSmall: AppTextStyles.labelSmall,
    );
  }
}
