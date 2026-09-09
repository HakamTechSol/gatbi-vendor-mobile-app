import 'package:flutter/material.dart';

/// Temporary static data for the Support feature.
///
/// This file is used during the UI development phase.
/// Later, API-driven data can replace these values without
/// changing the Support screen UI structure.
abstract final class SupportDummyData {
  SupportDummyData._();

  // ═══════════════════════════════════════════════════════════════════════════
  // SUPPORT CONTACT DETAILS
  // ═══════════════════════════════════════════════════════════════════════════

  static const String supportEmail = 'support@gatbi.ae';

  static const String supportPhone = '+971567568887';

  static const String supportWhatsApp = '+971567568887';

  static const String supportHours = 'Monday – Friday, 9:00 AM – 6:00 PM';

  // ═══════════════════════════════════════════════════════════════════════════
  // MERCHANT
  // ═══════════════════════════════════════════════════════════════════════════

  /// Temporary merchant ID.
  ///
  /// Later this value should come from the authenticated vendor profile/API.
  static const String merchantId = 'GTB-00012345';

  // ═══════════════════════════════════════════════════════════════════════════
  // HEADER
  // ═══════════════════════════════════════════════════════════════════════════

  static const String screenTitle = 'Support';

  static const String screenSubtitle = 'How can we help you?';

  static const String screenDescription =
      'Find quick answers or contact our support team for assistance.';

  // ═══════════════════════════════════════════════════════════════════════════
  // QUICK ACTIONS
  // ═══════════════════════════════════════════════════════════════════════════

  static const String customerChatTitle = 'Customer Chat';

  static const String customerChatDescription = 'Chat with our support team';

  static const String campaignsTitle = 'Campaigns';

  static const String campaignsDescription = 'Manage your campaigns';

  // ═══════════════════════════════════════════════════════════════════════════
  // QUICK HELP
  // ═══════════════════════════════════════════════════════════════════════════

  static const String quickHelpTitle = 'Quick Help';

  static const String quickHelpDescription =
      'Find answers to common vendor questions.';

  // ═══════════════════════════════════════════════════════════════════════════
  // HELP ITEMS
  // ═══════════════════════════════════════════════════════════════════════════

  static const List<SupportHelpItem> helpItems = [
    SupportHelpItem(
      title: "Can't add products?",
      description: 'Complete your KYC or check your account settings.',
      icon: Icons.inventory_2_outlined,
      routeKey: 'kyc',
    ),
    SupportHelpItem(
      title: 'Orders & delivery',
      description: 'Manage orders and get help with delivery issues.',
      icon: Icons.local_shipping_outlined,
      routeKey: 'orders',
    ),
    SupportHelpItem(
      title: 'Payments & payouts',
      description: 'Need help with payouts or bank-related questions?',
      icon: Icons.payments_outlined,
      routeKey: 'payments',
    ),
    SupportHelpItem(
      title: 'Campaign request',
      description: 'Get help with creating or managing campaigns.',
      icon: Icons.campaign_outlined,
      routeKey: 'campaigns',
    ),
  ];

  // ═══════════════════════════════════════════════════════════════════════════
  // PAYMENTS
  // ═══════════════════════════════════════════════════════════════════════════

  static const String paymentsTitle = 'Payments & payouts';

  static const String paymentsDescription =
      'For payout or bank-related questions, please contact our support team.';

  static const String merchantIdLabel = 'Merchant ID';

  static const String contactSupportLabel = 'Contact Support';

  // ═══════════════════════════════════════════════════════════════════════════
  // CONTACT SUPPORT
  // ═══════════════════════════════════════════════════════════════════════════

  static const String contactTitle = 'Contact Support';

  static const String contactDescription =
      'Reach us through your preferred channel.';

  static const String emailLabel = 'Email';

  static const String phoneLabel = 'Phone';

  static const String whatsappLabel = 'WhatsApp';

  static const String whatsappAction = 'Chat with support';

  // ═══════════════════════════════════════════════════════════════════════════
  // USEFUL LINKS
  // ═══════════════════════════════════════════════════════════════════════════

  static const String usefulLinksTitle = 'Useful Links';

  static const List<SupportUsefulLink> usefulLinks = [
    SupportUsefulLink(
      title: 'Analytics',
      routeKey: 'analytics',
      icon: Icons.analytics_outlined,
    ),
    SupportUsefulLink(
      title: 'Products',
      routeKey: 'products',
      icon: Icons.inventory_2_outlined,
    ),
    SupportUsefulLink(
      title: 'Orders',
      routeKey: 'orders',
      icon: Icons.local_shipping_outlined,
    ),
    SupportUsefulLink(
      title: 'Settings',
      routeKey: 'settings',
      icon: Icons.settings_outlined,
    ),
  ];

  // ═══════════════════════════════════════════════════════════════════════════
  // CREATE TICKET
  // ═══════════════════════════════════════════════════════════════════════════

  static const String createTicketTitle = 'Contact Support';

  static const String createTicketSubtitle = 'Tell us how we can help you.';

  static const String subjectLabel = 'Subject';

  static const String subjectHint = 'What do you need help with?';

  static const String messageLabel = 'Message';

  static const String messageHint = 'Describe your issue in detail...';

  static const String priorityLabel = 'Priority';

  static const String submitTicketButton = 'Submit Support Ticket';

  // ═══════════════════════════════════════════════════════════════════════════
  // PRIORITIES
  // ═══════════════════════════════════════════════════════════════════════════

  static const List<String> priorities = [
    'Low',
    'Medium',
    'High',
  ];

  static const String defaultPriority = 'Medium';

  // ═══════════════════════════════════════════════════════════════════════════
  // VALIDATION
  // ═══════════════════════════════════════════════════════════════════════════

  static const int minSubjectLength = 5;

  static const int maxSubjectLength = 255;

  static const int minMessageLength = 10;

  static const int maxMessageLength = 5000;
}

// ══════════════════════════════════════════════════════════════════════════════
// SUPPORT HELP ITEM
// ══════════════════════════════════════════════════════════════════════════════

class SupportHelpItem {
  const SupportHelpItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.routeKey,
  });

  final String title;

  final String description;

  /// Material icon used by the UI.
  ///
  /// Keeping IconData directly allows Flutter to perform icon tree-shaking
  /// correctly in release builds.
  final IconData icon;

  /// Logical navigation key.
  ///
  /// This keeps the dummy data independent from GoRouter.
  final String routeKey;
}

// ══════════════════════════════════════════════════════════════════════════════
// SUPPORT USEFUL LINK
// ══════════════════════════════════════════════════════════════════════════════

class SupportUsefulLink {
  const SupportUsefulLink({
    required this.title,
    required this.routeKey,
    required this.icon,
  });

  final String title;

  /// Logical navigation key.
  final String routeKey;

  /// Material icon used by the UI.
  final IconData icon;
}
