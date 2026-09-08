import 'package:flutter/material.dart';

abstract final class AppDimensions {
  AppDimensions._();

  // ═══════════════════════════════════════════════════════════════════════════
  // BASE SPACING
  // ═══════════════════════════════════════════════════════════════════════════

  /// 2px
  static const double spacing2 = 2;

  /// 4px
  static const double spacing4 = 4;

  /// 6px
  static const double spacing6 = 6;

  /// 8px
  static const double spacing8 = 8;

  /// 10px
  static const double spacing10 = 10;

  /// 12px
  static const double spacing12 = 12;

  /// 14px
  static const double spacing14 = 14;

  /// 16px
  static const double spacing16 = 16;

  /// 18px
  static const double spacing18 = 18;

  /// 20px
  static const double spacing20 = 20;

  /// 24px
  static const double spacing24 = 24;

  /// 28px
  static const double spacing28 = 28;

  /// 32px
  static const double spacing32 = 32;

  /// 36px
  static const double spacing36 = 36;

  /// 40px
  static const double spacing40 = 40;

  /// 48px
  static const double spacing48 = 48;

  /// 56px
  static const double spacing56 = 56;

  /// 64px
  static const double spacing64 = 64;

  /// 72px
  static const double spacing72 = 72;

  /// 80px
  static const double spacing80 = 80;

  // ═══════════════════════════════════════════════════════════════════════════
  // SCREEN PADDING
  // ═══════════════════════════════════════════════════════════════════════════

  /// Standard horizontal padding for mobile screens.
  static const double screenHorizontal = 20;

  /// Compact horizontal screen padding.
  static const double screenHorizontalCompact = 16;

  /// Large horizontal screen padding.
  static const double screenHorizontalLarge = 24;

  /// Default top screen spacing.
  static const double screenTop = 20;

  /// Default bottom screen spacing.
  static const double screenBottom = 24;

  /// Authentication screen horizontal padding.
  static const double authHorizontal = 24;

  /// Authentication screen top spacing.
  static const double authTop = 24;

  /// Authentication screen bottom spacing.
  static const double authBottom = 32;

  // ═══════════════════════════════════════════════════════════════════════════
  // CARD
  // ═══════════════════════════════════════════════════════════════════════════

  /// Standard card radius.
  static const double cardRadius = 16;

  /// Small card radius.
  static const double cardRadiusSmall = 12;

  /// Large/hero card radius.
  static const double cardRadiusLarge = 20;

  /// Extra large card radius.
  static const double cardRadiusXLarge = 24;

  /// Card internal horizontal padding.
  static const double cardPaddingHorizontal = 16;

  /// Card internal vertical padding.
  static const double cardPaddingVertical = 16;

  /// Compact card padding.
  static const double cardPaddingCompact = 12;

  /// Large card padding.
  static const double cardPaddingLarge = 20;

  // ═══════════════════════════════════════════════════════════════════════════
  // BORDER RADIUS
  // ═══════════════════════════════════════════════════════════════════════════

  static const double radius4 = 4;

  static const double radius6 = 6;

  static const double radius8 = 8;

  static const double radius10 = 10;

  static const double radius12 = 12;

  static const double radius14 = 14;

  static const double radius16 = 16;

  static const double radius18 = 18;

  static const double radius20 = 20;

  static const double radius24 = 24;

  static const double radius28 = 28;

  static const double radius32 = 32;

  // ═══════════════════════════════════════════════════════════════════════════
  // COMMON BORDER WIDTH
  // ═══════════════════════════════════════════════════════════════════════════

  static const double borderThin = 1;

  static const double borderMedium = 1.5;

  static const double borderThick = 2;

  // ═══════════════════════════════════════════════════════════════════════════
  // BUTTONS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Standard primary button height.
  static const double buttonHeight = 52;

  /// Compact button height.
  static const double buttonHeightSmall = 44;

  /// Large CTA button height.
  static const double buttonHeightLarge = 56;

  /// Button border radius.
  static const double buttonRadius = 12;

  /// Compact button radius.
  static const double buttonRadiusSmall = 10;

  /// Button horizontal padding.
  static const double buttonHorizontalPadding = 20;

  /// Button vertical padding.
  static const double buttonVerticalPadding = 14;

  /// Icon size inside standard button.
  static const double buttonIconSize = 20;

  /// Gap between button icon and label.
  static const double buttonIconGap = 8;

  // ═══════════════════════════════════════════════════════════════════════════
  // INPUT FIELDS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Standard input height.
  static const double inputHeight = 52;

  /// Compact input height.
  static const double inputHeightSmall = 44;

  /// Large input height.
  static const double inputHeightLarge = 56;

  /// Input border radius.
  static const double inputRadius = 12;

  /// Input horizontal padding.
  static const double inputHorizontalPadding = 16;

  /// Input vertical padding.
  static const double inputVerticalPadding = 15;

  /// Standard input icon size.
  static const double inputIconSize = 20;

  /// Input prefix/suffix icon container size.
  static const double inputIconContainerSize = 44;

  // ═══════════════════════════════════════════════════════════════════════════
  // ICONS
  // ═══════════════════════════════════════════════════════════════════════════

  static const double iconSizeXS = 14;

  static const double iconSizeSmall = 18;

  static const double iconSizeMedium = 20;

  static const double iconSizeLarge = 24;

  static const double iconSizeXLarge = 28;

  static const double iconSizeXXLarge = 32;

  static const double iconSizeHuge = 40;

  /// Standard circular icon container.
  static const double iconContainerSmall = 36;

  static const double iconContainerMedium = 44;

  static const double iconContainerLarge = 52;

  static const double iconContainerXLarge = 64;

  // ═══════════════════════════════════════════════════════════════════════════
  // APP BAR
  // ═══════════════════════════════════════════════════════════════════════════

  /// Standard toolbar height.
  static const double appBarHeight = 64;

  /// Compact toolbar height.
  static const double appBarHeightCompact = 56;

  /// App bar horizontal padding.
  static const double appBarHorizontalPadding = 16;

  /// App bar icon size.
  static const double appBarIconSize = 22;

  // ═══════════════════════════════════════════════════════════════════════════
  // BOTTOM NAVIGATION
  // ═══════════════════════════════════════════════════════════════════════════

  static const double bottomNavigationHeight = 72;

  static const double bottomNavigationIconSize = 24;

  static const double bottomNavigationLabelSpacing = 4;

  // ═══════════════════════════════════════════════════════════════════════════
  // DRAWER
  // ═══════════════════════════════════════════════════════════════════════════

  /// Width of mobile navigation drawer.
  static const double drawerWidth = 304;

  /// Drawer header height.
  static const double drawerHeaderHeight = 180;

  /// Drawer item height.
  static const double drawerItemHeight = 48;

  /// Drawer item radius.
  static const double drawerItemRadius = 12;

  /// Drawer horizontal padding.
  static const double drawerHorizontalPadding = 12;

  // ═══════════════════════════════════════════════════════════════════════════
  // AVATARS
  // ═══════════════════════════════════════════════════════════════════════════

  static const double avatarXS = 28;

  static const double avatarSmall = 36;

  static const double avatarMedium = 44;

  static const double avatarLarge = 56;

  static const double avatarXLarge = 72;

  static const double avatarHuge = 96;

  // ═══════════════════════════════════════════════════════════════════════════
  // BADGES
  // ═══════════════════════════════════════════════════════════════════════════

  static const double badgeHeight = 24;

  static const double badgeHeightSmall = 20;

  static const double badgeHeightLarge = 28;

  static const double badgeRadius = 8;

  static const double badgeHorizontalPadding = 8;

  static const double badgeVerticalPadding = 4;

  // ═══════════════════════════════════════════════════════════════════════════
  // CHIPS
  // ═══════════════════════════════════════════════════════════════════════════

  static const double chipHeight = 36;

  static const double chipHeightSmall = 30;

  static const double chipRadius = 10;

  static const double chipHorizontalPadding = 10;

  static const double chipVerticalPadding = 7;

  // ═══════════════════════════════════════════════════════════════════════════
  // AVATAR / ICON TILE
  // ═══════════════════════════════════════════════════════════════════════════

  static const double iconTileSmall = 36;

  static const double iconTileMedium = 44;

  static const double iconTileLarge = 52;

  static const double iconTileRadius = 12;

  // ═══════════════════════════════════════════════════════════════════════════
  // PRODUCT
  // ═══════════════════════════════════════════════════════════════════════════

  /// Product thumbnail used in lists.
  static const double productThumbnail = 72;

  /// Product image in cards.
  static const double productImage = 120;

  /// Large product detail image.
  static const double productImageLarge = 240;

  /// Product gallery thumbnail.
  static const double productGalleryThumbnail = 64;

  /// Product image radius.
  static const double productImageRadius = 12;

  // ═══════════════════════════════════════════════════════════════════════════
  // ORDER
  // ═══════════════════════════════════════════════════════════════════════════

  static const double orderItemImage = 64;

  static const double orderCardRadius = 16;

  static const double orderTimelineDot = 12;

  static const double orderTimelineLine = 2;

  // ═══════════════════════════════════════════════════════════════════════════
  // DASHBOARD
  // ═══════════════════════════════════════════════════════════════════════════

  /// Dashboard stat card minimum height.
  static const double dashboardStatCardHeight = 120;

  /// Dashboard welcome card height.
  static const double dashboardWelcomeHeight = 180;

  /// Dashboard quick action height.
  static const double dashboardQuickActionHeight = 48;

  /// Dashboard metric icon container.
  static const double dashboardMetricIcon = 44;

  // ═══════════════════════════════════════════════════════════════════════════
  // AUTHENTICATION
  // ═══════════════════════════════════════════════════════════════════════════

  /// Authentication logo size.
  static const double authLogoSize = 88;

  /// Authentication logo/icon container.
  static const double authLogoContainer = 104;

  /// Authentication title bottom spacing.
  static const double authTitleSpacing = 8;

  /// Authentication subtitle bottom spacing.
  static const double authSubtitleSpacing = 28;

  /// Authentication field spacing.
  static const double authFieldSpacing = 18;

  /// Authentication button top spacing.
  static const double authButtonSpacing = 24;

  /// Authentication footer spacing.
  static const double authFooterSpacing = 20;

  // ═══════════════════════════════════════════════════════════════════════════
  // SPLASH
  // ═══════════════════════════════════════════════════════════════════════════

  /// Splash logo size.
  static const double splashLogoSize = 112;

  /// Splash brand mark container.
  static const double splashLogoContainer = 128;

  /// Splash brand-to-tagline gap.
  static const double splashBrandSpacing = 10;

  /// Splash bottom padding.
  static const double splashBottomPadding = 48;

  // ═══════════════════════════════════════════════════════════════════════════
  // ONBOARDING
  // ═══════════════════════════════════════════════════════════════════════════

  /// Onboarding illustration height.
  static const double onboardingIllustrationHeight = 300;

  /// Onboarding illustration width.
  static const double onboardingIllustrationWidth = 300;

  /// Onboarding illustration radius.
  static const double onboardingIllustrationRadius = 28;

  /// Onboarding title spacing.
  static const double onboardingTitleSpacing = 16;

  /// Onboarding description spacing.
  static const double onboardingDescriptionSpacing = 12;

  /// Onboarding page indicator size.
  static const double onboardingIndicatorSize = 8;

  /// Active onboarding indicator width.
  static const double onboardingIndicatorActiveWidth = 24;

  /// Onboarding indicator height.
  static const double onboardingIndicatorHeight = 8;

  /// Onboarding bottom controls height.
  static const double onboardingControlsHeight = 56;

  // ═══════════════════════════════════════════════════════════════════════════
  // DIALOGS
  // ═══════════════════════════════════════════════════════════════════════════

  static const double dialogRadius = 20;

  static const double dialogHorizontalPadding = 24;

  static const double dialogVerticalPadding = 24;

  static const double dialogMaxWidth = 420;

  // ═══════════════════════════════════════════════════════════════════════════
  // BOTTOM SHEET
  // ═══════════════════════════════════════════════════════════════════════════

  static const double bottomSheetRadius = 24;

  static const double bottomSheetHorizontalPadding = 20;

  static const double bottomSheetVerticalPadding = 24;

  static const double bottomSheetHandleWidth = 40;

  static const double bottomSheetHandleHeight = 4;

  // ═══════════════════════════════════════════════════════════════════════════
  // LISTS
  // ═══════════════════════════════════════════════════════════════════════════

  static const double listItemHeight = 64;

  static const double listItemHeightLarge = 76;

  static const double listItemHorizontalPadding = 16;

  static const double listItemVerticalPadding = 8;

  static const double listItemGap = 12;

  // ═══════════════════════════════════════════════════════════════════════════
  // GRID
  // ═══════════════════════════════════════════════════════════════════════════

  static const double gridSpacing = 12;

  static const double gridRunSpacing = 12;

  // ═══════════════════════════════════════════════════════════════════════════
  // CHAT
  // ═══════════════════════════════════════════════════════════════════════════

  static const double chatBubbleRadius = 16;

  static const double chatBubbleRadiusSmall = 6;

  static const double chatBubbleHorizontalPadding = 14;

  static const double chatBubbleVerticalPadding = 10;

  static const double chatInputHeight = 52;

  static const double chatSendButtonSize = 44;

  // ═══════════════════════════════════════════════════════════════════════════
  // FORM
  // ═══════════════════════════════════════════════════════════════════════════

  static const double formSectionSpacing = 28;

  static const double formFieldSpacing = 18;

  static const double formLabelSpacing = 8;

  static const double formHelperSpacing = 6;

  // ═══════════════════════════════════════════════════════════════════════════
  // KYC / DOCUMENT UPLOAD
  // ═══════════════════════════════════════════════════════════════════════════

  static const double documentUploadHeight = 140;

  static const double documentUploadRadius = 16;

  static const double documentPreviewSize = 100;

  // ═══════════════════════════════════════════════════════════════════════════
  // SETTINGS
  // ═══════════════════════════════════════════════════════════════════════════

  static const double settingsItemHeight = 64;

  static const double settingsIconContainer = 42;

  static const double settingsSectionSpacing = 28;

  // ═══════════════════════════════════════════════════════════════════════════
  // DIVIDERS
  // ═══════════════════════════════════════════════════════════════════════════

  static const double dividerThickness = 1;

  static const double dividerIndent = 16;

  // ═══════════════════════════════════════════════════════════════════════════
  // IMAGE / MEDIA
  // ═══════════════════════════════════════════════════════════════════════════

  static const double imageRadius = 12;

  static const double imageRadiusSmall = 8;

  static const double imageRadiusLarge = 20;

  // ═══════════════════════════════════════════════════════════════════════════
  // LOADING
  // ═══════════════════════════════════════════════════════════════════════════

  static const double loadingIndicatorSmall = 18;

  static const double loadingIndicatorMedium = 24;

  static const double loadingIndicatorLarge = 32;

  // ═══════════════════════════════════════════════════════════════════════════
  // RESPONSIVE BREAKPOINTS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Compact mobile width.
  static const double mobileBreakpoint = 480;

  /// Large mobile / small tablet width.
  static const double tabletBreakpoint = 768;

  /// Desktop breakpoint.
  static const double desktopBreakpoint = 1024;

  /// Large desktop breakpoint.
  static const double largeDesktopBreakpoint = 1440;

  // ═══════════════════════════════════════════════════════════════════════════
  // SAFE AREA / SYSTEM UI
  // ═══════════════════════════════════════════════════════════════════════════

  static const double safeAreaExtraBottom = 16;

  static const double safeAreaExtraTop = 8;

  // ═══════════════════════════════════════════════════════════════════════════
  // COMMON EDGE INSETS
  // ═══════════════════════════════════════════════════════════════════════════

  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: screenHorizontal,
    vertical: screenTop,
  );

  static const EdgeInsets screenHorizontalPadding = EdgeInsets.symmetric(
    horizontal: screenHorizontal,
  );

  static const EdgeInsets screenCompactPadding = EdgeInsets.symmetric(
    horizontal: screenHorizontalCompact,
  );

  static const EdgeInsets screenLargePadding = EdgeInsets.symmetric(
    horizontal: screenHorizontalLarge,
  );

  static const EdgeInsets cardPadding = EdgeInsets.symmetric(
    horizontal: cardPaddingHorizontal,
    vertical: cardPaddingVertical,
  );

  static const EdgeInsets cardPaddingCompactInsets = EdgeInsets.all(
    cardPaddingCompact,
  );

  static const EdgeInsets cardPaddingLargeInsets = EdgeInsets.all(
    cardPaddingLarge,
  );

  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: buttonHorizontalPadding,
    vertical: buttonVerticalPadding,
  );

  static const EdgeInsets inputPadding = EdgeInsets.symmetric(
    horizontal: inputHorizontalPadding,
    vertical: inputVerticalPadding,
  );

  static const EdgeInsets authPadding = EdgeInsets.symmetric(
    horizontal: authHorizontal,
    vertical: authTop,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // COMMON BORDER RADIUS OBJECTS
  // ═══════════════════════════════════════════════════════════════════════════

  static final BorderRadius cardBorderRadius =
      BorderRadius.circular(cardRadius);

  static final BorderRadius cardSmallBorderRadius =
      BorderRadius.circular(cardRadiusSmall);

  static final BorderRadius cardLargeBorderRadius =
      BorderRadius.circular(cardRadiusLarge);

  static final BorderRadius inputBorderRadius =
      BorderRadius.circular(inputRadius);

  static final BorderRadius buttonBorderRadius =
      BorderRadius.circular(buttonRadius);

  static final BorderRadius chipBorderRadius =
      BorderRadius.circular(chipRadius);

  static final BorderRadius badgeBorderRadius =
      BorderRadius.circular(badgeRadius);

  static final BorderRadius dialogBorderRadius =
      BorderRadius.circular(dialogRadius);

  static const BorderRadius bottomSheetBorderRadius =
      BorderRadius.vertical(
    top: Radius.circular(bottomSheetRadius),
  );
}