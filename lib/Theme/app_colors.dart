import 'package:flutter/material.dart';

abstract final class AppColors {
  AppColors._();

  // ═══════════════════════════════════════════════════════════════════════════
  // BRAND COLORS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Main Gatbi blue.
  static const Color primary = Color(0xFF3156E8);

  /// Darker primary blue for pressed/strong states.
  static const Color primaryDark = Color(0xFF2443C5);

  /// Light primary background used for icons, selected states and chips.
  static const Color primaryLight = Color(0xFFE9EDFF);

  /// Very subtle primary background.
  static const Color primarySurface = Color(0xFFF4F6FF);

  /// Main purple used in the brand gradient.
  static const Color purple = Color(0xFF7A2CF5);

  /// Dark purple for strong gradient/pressed states.
  static const Color purpleDark = Color(0xFF6120D0);

  /// Light purple background.
  static const Color purpleLight = Color(0xFFF1E9FF);

  // ═══════════════════════════════════════════════════════════════════════════
  // BRAND GRADIENTS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Main button/action gradient.
  ///
  /// Use for:
  /// - Login
  /// - Register
  /// - Primary CTA
  /// - Important action buttons
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [primary, purple],
  );

  /// Main hero gradient.
  ///
  /// Use for:
  /// - Splash
  /// - Authentication header
  /// - Onboarding hero areas
  /// - Promotional banners
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF7028E4), Color(0xFF4B45E8), Color(0xFF245BEA)],
  );

  /// Soft gradient for cards/banners where a lighter appearance is required.
  static const LinearGradient softGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF0F2FF), Color(0xFFF7F1FF)],
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // CORE / NAVY COLORS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Main dark heading/navigation color.
  static const Color navy = Color(0xFF102052);

  /// Slightly lighter navy.
  static const Color navySoft = Color(0xFF1A2B61);

  /// Deepest app text/background when a dark section is needed.
  static const Color navyDark = Color(0xFF0A1538);

  // ═══════════════════════════════════════════════════════════════════════════
  // BACKGROUNDS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Main application background.
  static const Color background = Color(0xFFF6F8FC);

  /// Slightly darker background for grouped sections.
  static const Color backgroundSecondary = Color(0xFFF0F3F9);

  /// Pure white.
  static const Color white = Color(0xFFFFFFFF);

  /// Card / modal / bottom sheet surface.
  static const Color surface = Color(0xFFFFFFFF);

  /// Soft surface used behind fields, filters and secondary cards.
  static const Color surfaceSoft = Color(0xFFF7F8FC);

  /// Alternative muted surface.
  static const Color surfaceMuted = Color(0xFFF1F4FA);

  // ═══════════════════════════════════════════════════════════════════════════
  // TEXT COLORS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Main headings and important text.
  static const Color textPrimary = Color(0xFF142047);

  /// Normal body/content text.
  static const Color textSecondary = Color(0xFF64708A);

  /// Less important metadata.
  static const Color textTertiary = Color(0xFF7D879C);

  /// Placeholder / disabled / very subtle text.
  static const Color textMuted = Color(0xFF98A2B5);

  /// Text used on dark/colored backgrounds.
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  /// Secondary white text for gradients/dark backgrounds.
  static const Color textOnPrimarySecondary = Color(0xCCFFFFFF);

  // ═══════════════════════════════════════════════════════════════════════════
  // BORDER / DIVIDER COLORS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Standard border.
  static const Color border = Color(0xFFDCE2EF);

  /// Slightly darker border for focused/strong components.
  static const Color borderStrong = Color(0xFFC9D1E2);

  /// Very subtle divider.
  static const Color divider = Color(0xFFE9EDF4);

  /// Border used around primary-selected components.
  static const Color borderPrimary = Color(0xFFB9C5FF);

  // ═══════════════════════════════════════════════════════════════════════════
  // INPUT COLORS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Default input background.
  static const Color inputBackground = Color(0xFFFFFFFF);

  /// Input icon background.
  static const Color inputIconBackground = Color(0xFFE9EDFF);

  /// Input icon color.
  static const Color inputIcon = Color(0xFF3156E8);

  /// Focused input border.
  static const Color inputFocusedBorder = Color(0xFF3156E8);

  /// Disabled input background.
  static const Color inputDisabledBackground = Color(0xFFF1F3F7);

  /// Disabled input text.
  static const Color inputDisabledText = Color(0xFF9CA5B5);

  // ═══════════════════════════════════════════════════════════════════════════
  // SUCCESS
  // ═══════════════════════════════════════════════════════════════════════════

  static const Color success = Color(0xFF16A36A);

  static const Color successDark = Color(0xFF087A4B);

  static const Color successLight = Color(0xFFE8F8F1);

  static const Color successBorder = Color(0xFFB9E9D3);

  // ═══════════════════════════════════════════════════════════════════════════
  // WARNING
  // ═══════════════════════════════════════════════════════════════════════════

  static const Color warning = Color(0xFFF2A51A);

  static const Color warningDark = Color(0xFFC77C00);

  static const Color warningLight = Color(0xFFFFF5DE);

  static const Color warningBorder = Color(0xFFF6D997);

  // ═══════════════════════════════════════════════════════════════════════════
  // ERROR / DANGER
  // ═══════════════════════════════════════════════════════════════════════════

  static const Color error = Color(0xFFE55353);

  /// Alias for places where "danger" is more semantically appropriate.
  static const Color danger = error;

  static const Color errorDark = Color(0xFFC73535);

  static const Color errorLight = Color(0xFFFFECEC);

  static const Color errorBorder = Color(0xFFF4BABA);

  // ═══════════════════════════════════════════════════════════════════════════
  // INFO
  // ═══════════════════════════════════════════════════════════════════════════

  static const Color info = Color(0xFF3487E8);

  static const Color infoDark = Color(0xFF1D63B8);

  static const Color infoLight = Color(0xFFEAF3FF);

  static const Color infoBorder = Color(0xFFBCD8F7);

  // ═══════════════════════════════════════════════════════════════════════════
  // STATUS COLORS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Pending / awaiting action.
  static const Color pending = Color(0xFFF2A51A);

  static const Color pendingLight = Color(0xFFFFF5DE);

  /// Processing / active.
  static const Color processing = Color(0xFF3487E8);

  static const Color processingLight = Color(0xFFEAF3FF);

  /// Completed / delivered / approved.
  static const Color completed = Color(0xFF16A36A);

  static const Color completedLight = Color(0xFFE8F8F1);

  /// Cancelled / rejected / failed.
  static const Color cancelled = Color(0xFFE55353);

  static const Color cancelledLight = Color(0xFFFFECEC);

  /// Draft status.
  static const Color draft = Color(0xFF7D879C);

  static const Color draftLight = Color(0xFFF0F2F5);

  // ═══════════════════════════════════════════════════════════════════════════
  // SPECIAL UI COLORS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Selected tab / chip background.
  static const Color selectedBackground = Color(0xFFE9EDFF);

  /// Unselected chip background.
  static const Color chipBackground = Color(0xFFF1F4FA);

  /// Overlay for modal / bottom sheet.
  static const Color overlay = Color(0x66000000);

  /// Skeleton/shimmer base.
  static const Color shimmerBase = Color(0xFFE9EDF4);

  /// Skeleton/shimmer highlight.
  static const Color shimmerHighlight = Color(0xFFF7F9FC);

  /// Disabled button background.
  static const Color disabled = Color(0xFFE1E5EC);

  /// Disabled button/text foreground.
  static const Color disabledText = Color(0xFF9AA3B2);

  // ═══════════════════════════════════════════════════════════════════════════
  // SHADOW COLORS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Standard card shadow.
  static const Color shadow = Color(0x140F1D3D);

  /// Stronger shadow for floating/hero components.
  static const Color shadowStrong = Color(0x220F1D3D);

  /// Primary-colored shadow for gradient buttons.
  static const Color primaryShadow = Color(0x333156E8);

  // ═══════════════════════════════════════════════════════════════════════════
  // ICON COLORS
  // ═══════════════════════════════════════════════════════════════════════════

  static const Color iconPrimary = Color(0xFF3156E8);

  static const Color iconSecondary = Color(0xFF64708A);

  static const Color iconMuted = Color(0xFF98A2B5);

  static const Color iconOnPrimary = Color(0xFFFFFFFF);

  // ═══════════════════════════════════════════════════════════════════════════
  // NAVIGATION
  // ═══════════════════════════════════════════════════════════════════════════

  /// Selected bottom-navigation icon/text.
  static const Color navigationSelected = Color(0xFF3156E8);

  /// Unselected bottom-navigation icon/text.
  static const Color navigationUnselected = Color(0xFF8B95A8);

  /// Bottom-navigation background.
  static const Color navigationBackground = Color(0xFFFFFFFF);

  /// Navigation divider.
  static const Color navigationBorder = Color(0xFFE7EBF3);

  // ═══════════════════════════════════════════════════════════════════════════
  // PRODUCT / ORDER SPECIFIC SEMANTIC COLORS
  // ═══════════════════════════════════════════════════════════════════════════

  /// In-stock product.
  static const Color inStock = Color(0xFF16A36A);

  /// Low-stock product.
  static const Color lowStock = Color(0xFFF2A51A);

  /// Out-of-stock product.
  static const Color outOfStock = Color(0xFFE55353);

  /// Order pending.
  static const Color orderPending = Color(0xFFF2A51A);

  /// Order processing.
  static const Color orderProcessing = Color(0xFF3487E8);

  /// Order shipped.
  static const Color orderShipped = Color(0xFF7A2CF5);

  /// Order delivered.
  static const Color orderDelivered = Color(0xFF16A36A);

  /// Order cancelled.
  static const Color orderCancelled = Color(0xFFE55353);

  // ═══════════════════════════════════════════════════════════════════════════
  // KYC COLORS
  // ═══════════════════════════════════════════════════════════════════════════

  static const Color kycPending = Color(0xFFF2A51A);

  static const Color kycApproved = Color(0xFF16A36A);

  static const Color kycRejected = Color(0xFFE55353);

  static const Color kycNotSubmitted = Color(0xFF7D879C);
}
