import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract final class AppTextStyles {
  AppTextStyles._();

  // ═══════════════════════════════════════════════════════════════════════════
  // DISPLAY
  // ═══════════════════════════════════════════════════════════════════════════

  /// Very large text.
  ///
  /// Use for:
  /// - Splash branding
  /// - Large onboarding headlines
  /// - Major promotional sections
  static const TextStyle displayLarge = TextStyle(
    fontSize: 36,
    height: 1.15,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.8,
    color: AppColors.textPrimary,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 32,
    height: 1.18,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.6,
    color: AppColors.textPrimary,
  );

  static const TextStyle displaySmall = TextStyle(
    fontSize: 28,
    height: 1.2,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.4,
    color: AppColors.textPrimary,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // HEADLINES
  // ═══════════════════════════════════════════════════════════════════════════

  /// Main screen heading.
  ///
  /// Example:
  /// Dashboard
  /// Products
  /// Orders
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 26,
    height: 1.2,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.35,
    color: AppColors.textPrimary,
  );

  /// Section heading.
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 22,
    height: 1.25,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
    color: AppColors.textPrimary,
  );

  /// Smaller section heading.
  static const TextStyle headlineSmall = TextStyle(
    fontSize: 20,
    height: 1.3,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.15,
    color: AppColors.textPrimary,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // TITLES
  // ═══════════════════════════════════════════════════════════════════════════

  /// Large card / dialog title.
  static const TextStyle titleLarge = TextStyle(
    fontSize: 18,
    height: 1.35,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.1,
    color: AppColors.textPrimary,
  );

  /// Standard card title.
  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    height: 1.35,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  /// Small title.
  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    height: 1.35,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // BODY
  // ═══════════════════════════════════════════════════════════════════════════

  /// Large body text.
  ///
  /// Good for:
  /// - Onboarding descriptions
  /// - Important explanations
  /// - Empty state descriptions
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    height: 1.55,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    color: AppColors.textSecondary,
  );

  /// Default application body text.
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    height: 1.5,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    color: AppColors.textSecondary,
  );

  /// Small body text.
  static const TextStyle bodySmall = TextStyle(
    fontSize: 13,
    height: 1.45,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    color: AppColors.textSecondary,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // LABELS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Large field / section label.
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    height: 1.3,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  /// Standard field label.
  static const TextStyle labelMedium = TextStyle(
    fontSize: 13,
    height: 1.3,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  /// Small label.
  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    height: 1.25,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    color: AppColors.textSecondary,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // BUTTONS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Large primary button.
  static const TextStyle buttonLarge = TextStyle(
    fontSize: 16,
    height: 1.25,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.1,
    color: AppColors.textOnPrimary,
  );

  /// Standard button.
  static const TextStyle buttonMedium = TextStyle(
    fontSize: 14,
    height: 1.25,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.1,
    color: AppColors.textOnPrimary,
  );

  /// Small button.
  static const TextStyle buttonSmall = TextStyle(
    fontSize: 13,
    height: 1.2,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    color: AppColors.textOnPrimary,
  );

  /// Secondary / outlined button.
  static const TextStyle buttonOutlined = TextStyle(
    fontSize: 14,
    height: 1.25,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    color: AppColors.primary,
  );

  /// Text button.
  static const TextStyle buttonText = TextStyle(
    fontSize: 14,
    height: 1.25,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: AppColors.primary,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // AUTHENTICATION
  // ═══════════════════════════════════════════════════════════════════════════

  /// Authentication screen title.
  static const TextStyle authTitle = TextStyle(
    fontSize: 28,
    height: 1.2,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.4,
    color: AppColors.navy,
  );

  /// Authentication subtitle.
  static const TextStyle authSubtitle = TextStyle(
    fontSize: 15,
    height: 1.45,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    color: AppColors.textSecondary,
  );

  /// Authentication field label.
  static const TextStyle authFieldLabel = TextStyle(
    fontSize: 14,
    height: 1.3,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: AppColors.navy,
  );

  /// Authentication input text.
  static const TextStyle authInput = TextStyle(
    fontSize: 15,
    height: 1.4,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    color: AppColors.textPrimary,
  );

  /// Authentication input hint.
  static const TextStyle authHint = TextStyle(
    fontSize: 15,
    height: 1.4,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    color: AppColors.textMuted,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // DASHBOARD
  // ═══════════════════════════════════════════════════════════════════════════

  /// Dashboard greeting.
  static const TextStyle dashboardGreeting = TextStyle(
    fontSize: 14,
    height: 1.3,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  /// Dashboard vendor name.
  static const TextStyle dashboardTitle = TextStyle(
    fontSize: 24,
    height: 1.2,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.3,
    color: AppColors.textPrimary,
  );

  /// Dashboard metric number.
  static const TextStyle metricValue = TextStyle(
    fontSize: 24,
    height: 1.2,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.3,
    color: AppColors.textPrimary,
  );

  /// Dashboard metric label.
  static const TextStyle metricLabel = TextStyle(
    fontSize: 12,
    height: 1.3,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  /// Metric percentage/change.
  static const TextStyle metricChange = TextStyle(
    fontSize: 12,
    height: 1.25,
    fontWeight: FontWeight.w700,
    color: AppColors.success,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // PRODUCT
  // ═══════════════════════════════════════════════════════════════════════════

  /// Product name.
  static const TextStyle productName = TextStyle(
    fontSize: 15,
    height: 1.35,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  /// Product SKU.
  static const TextStyle productSku = TextStyle(
    fontSize: 12,
    height: 1.3,
    fontWeight: FontWeight.w400,
    color: AppColors.textTertiary,
  );

  /// Product price.
  static const TextStyle productPrice = TextStyle(
    fontSize: 16,
    height: 1.3,
    fontWeight: FontWeight.w800,
    color: AppColors.primary,
  );

  /// Product stock.
  static const TextStyle productStock = TextStyle(
    fontSize: 12,
    height: 1.3,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // ORDERS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Order number.
  static const TextStyle orderNumber = TextStyle(
    fontSize: 14,
    height: 1.3,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  /// Order amount.
  static const TextStyle orderAmount = TextStyle(
    fontSize: 16,
    height: 1.3,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  /// Order metadata.
  static const TextStyle orderMeta = TextStyle(
    fontSize: 12,
    height: 1.35,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // STATUS / BADGES
  // ═══════════════════════════════════════════════════════════════════════════

  /// Standard status badge.
  static const TextStyle statusBadge = TextStyle(
    fontSize: 11,
    height: 1.2,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.05,
  );

  /// Larger status badge.
  static const TextStyle statusBadgeLarge = TextStyle(
    fontSize: 12,
    height: 1.2,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // NAVIGATION
  // ═══════════════════════════════════════════════════════════════════════════

  /// Bottom navigation selected item.
  static const TextStyle navigationSelected = TextStyle(
    fontSize: 11,
    height: 1.2,
    fontWeight: FontWeight.w700,
    color: AppColors.navigationSelected,
  );

  /// Bottom navigation unselected item.
  static const TextStyle navigationUnselected = TextStyle(
    fontSize: 11,
    height: 1.2,
    fontWeight: FontWeight.w500,
    color: AppColors.navigationUnselected,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // TABS / FILTERS / CHIPS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Selected tab.
  static const TextStyle tabSelected = TextStyle(
    fontSize: 13,
    height: 1.25,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  /// Unselected tab.
  static const TextStyle tabUnselected = TextStyle(
    fontSize: 13,
    height: 1.25,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  /// Filter chip.
  static const TextStyle filterChip = TextStyle(
    fontSize: 12,
    height: 1.2,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );

  /// Selected filter chip.
  static const TextStyle filterChipSelected = TextStyle(
    fontSize: 12,
    height: 1.2,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // FORMS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Form section heading.
  static const TextStyle formSectionTitle = TextStyle(
    fontSize: 17,
    height: 1.35,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  /// Form label.
  static const TextStyle formLabel = TextStyle(
    fontSize: 13,
    height: 1.3,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  /// Form helper text.
  static const TextStyle formHelper = TextStyle(
    fontSize: 12,
    height: 1.4,
    fontWeight: FontWeight.w400,
    color: AppColors.textTertiary,
  );

  /// Form validation/error text.
  static const TextStyle formError = TextStyle(
    fontSize: 12,
    height: 1.35,
    fontWeight: FontWeight.w500,
    color: AppColors.error,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // EMPTY / ERROR / INFO STATES
  // ═══════════════════════════════════════════════════════════════════════════

  static const TextStyle emptyStateTitle = TextStyle(
    fontSize: 18,
    height: 1.3,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle emptyStateDescription = TextStyle(
    fontSize: 14,
    height: 1.5,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle errorTitle = TextStyle(
    fontSize: 18,
    height: 1.3,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle errorDescription = TextStyle(
    fontSize: 14,
    height: 1.5,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // DIALOGS / BOTTOM SHEETS
  // ═══════════════════════════════════════════════════════════════════════════

  static const TextStyle dialogTitle = TextStyle(
    fontSize: 19,
    height: 1.3,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle dialogDescription = TextStyle(
    fontSize: 14,
    height: 1.5,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle bottomSheetTitle = TextStyle(
    fontSize: 18,
    height: 1.3,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // CHAT
  // ═══════════════════════════════════════════════════════════════════════════

  static const TextStyle chatMessage = TextStyle(
    fontSize: 14,
    height: 1.45,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const TextStyle chatMessageTime = TextStyle(
    fontSize: 10,
    height: 1.2,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
  );

  static const TextStyle chatInput = TextStyle(
    fontSize: 14,
    height: 1.4,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // SETTINGS
  // ═══════════════════════════════════════════════════════════════════════════

  static const TextStyle settingsSection = TextStyle(
    fontSize: 12,
    height: 1.3,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.4,
    color: AppColors.textTertiary,
  );

  static const TextStyle settingsTitle = TextStyle(
    fontSize: 15,
    height: 1.3,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle settingsSubtitle = TextStyle(
    fontSize: 12,
    height: 1.35,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // CAPTIONS / META
  // ═══════════════════════════════════════════════════════════════════════════

  static const TextStyle caption = TextStyle(
    fontSize: 11,
    height: 1.35,
    fontWeight: FontWeight.w400,
    color: AppColors.textTertiary,
  );

  static const TextStyle captionMedium = TextStyle(
    fontSize: 11,
    height: 1.35,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static const TextStyle overline = TextStyle(
    fontSize: 10,
    height: 1.2,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
    color: AppColors.textTertiary,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // SPECIAL / ONBOARDING
  // ═══════════════════════════════════════════════════════════════════════════

  /// Onboarding main heading.
  static const TextStyle onboardingTitle = TextStyle(
    fontSize: 30,
    height: 1.2,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.4,
    color: AppColors.navy,
  );

  /// Onboarding description.
  static const TextStyle onboardingDescription = TextStyle(
    fontSize: 15,
    height: 1.55,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  /// Splash brand name.
  static const TextStyle splashBrand = TextStyle(
    fontSize: 30,
    height: 1.2,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.4,
    color: AppColors.white,
  );

  /// Splash tagline.
  static const TextStyle splashTagline = TextStyle(
    fontSize: 13,
    height: 1.4,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.2,
    color: AppColors.textOnPrimarySecondary,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // DISABLED
  // ═══════════════════════════════════════════════════════════════════════════

  static const TextStyle disabledText = TextStyle(
    fontSize: 14,
    height: 1.3,
    fontWeight: FontWeight.w600,
    color: AppColors.disabledText,
  );
}
