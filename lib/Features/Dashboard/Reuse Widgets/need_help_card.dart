import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Theme/app_colors.dart';
import '../../../Theme/app_text_styles.dart';

class NeedHelpCard extends StatelessWidget {
  const NeedHelpCard({
    super.key,
    required this.supportEmail,
    required this.supportPhone,
    this.onCreateTicket,
  });

  /// Email received from Settings API.
  final String supportEmail;

  /// Phone number received from Settings API.
  final String supportPhone;

  final VoidCallback? onCreateTicket;

  // ═══════════════════════════════════════════════════════════════════════════
  // OPEN EMAIL
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _openEmail(BuildContext context) async {
    final email = supportEmail.trim();

    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('[NeedHelpCard] Email button clicked');
    debugPrint('[NeedHelpCard] Support email: "$email"');

    if (email.isEmpty) {
      debugPrint('[NeedHelpCard] ERROR: Support email is empty.');

      if (!context.mounted) return;

      _showError(context, 'Support email is not available.');

      return;
    }

    final emailUri = Uri(scheme: 'mailto', path: email);

    debugPrint('[NeedHelpCard] Email URI: $emailUri');

    try {
      final launched = await launchUrl(
        emailUri,
        mode: LaunchMode.externalApplication,
      );

      debugPrint('[NeedHelpCard] Email launch result: $launched');

      if (!launched) {
        debugPrint('[NeedHelpCard] ERROR: Email app could not be opened.');

        if (!context.mounted) return;

        _showError(context, 'No email app is available on this device.');

        return;
      }

      debugPrint('[NeedHelpCard] Email app opened successfully.');
    } catch (error, stackTrace) {
      debugPrint('[NeedHelpCard] EMAIL LAUNCH ERROR: $error');

      debugPrint('[NeedHelpCard] EMAIL STACK TRACE:\n$stackTrace');

      if (!context.mounted) return;

      _showError(context, 'Unable to open email app.');
    }

    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // OPEN PHONE DIALER
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _openPhone(BuildContext context) async {
    final phone = supportPhone.trim();

    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('[NeedHelpCard] Phone button clicked');
    debugPrint('[NeedHelpCard] Support phone: "$phone"');

    if (phone.isEmpty) {
      debugPrint('[NeedHelpCard] ERROR: Support phone is empty.');

      if (!context.mounted) return;

      _showError(context, 'Support phone number is not available.');

      return;
    }

    final phoneUri = Uri(scheme: 'tel', path: phone);

    debugPrint('[NeedHelpCard] Phone URI: $phoneUri');

    try {
      final launched = await launchUrl(
        phoneUri,
        mode: LaunchMode.externalApplication,
      );

      debugPrint('[NeedHelpCard] Phone launch result: $launched');

      if (!launched) {
        debugPrint('[NeedHelpCard] ERROR: Phone dialer could not be opened.');

        if (!context.mounted) return;

        _showError(context, 'Unable to open phone dialer.');

        return;
      }

      debugPrint('[NeedHelpCard] Phone dialer opened successfully.');
    } catch (error, stackTrace) {
      debugPrint('[NeedHelpCard] PHONE LAUNCH ERROR: $error');

      debugPrint('[NeedHelpCard] PHONE STACK TRACE:\n$stackTrace');

      if (!context.mounted) return;

      _showError(context, 'Unable to open phone dialer.');
    }

    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ERROR SNACKBAR
  // ═══════════════════════════════════════════════════════════════════════════

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: AppColors.white,
                size: 19,
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.white,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.errorDark,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    final hasEmail = supportEmail.trim().isNotEmpty;
    final hasPhone = supportPhone.trim().isNotEmpty;
    final hasTicket = onCreateTicket != null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.65)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowStrong.withValues(alpha: 0.055),
            blurRadius: 24,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildSupportMessage(),
          const SizedBox(height: 15),
          _buildContactInfo(hasEmail: hasEmail, hasPhone: hasPhone),
          const SizedBox(height: 14),
          _buildSupportActions(
            context,
            hasEmail: hasEmail,
            hasPhone: hasPhone,
            hasTicket: hasTicket,
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // HEADER
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            gradient: AppColors.softGradient,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.08),
            ),
          ),
          child: const Icon(
            Icons.support_agent_rounded,
            color: AppColors.primary,
            size: 23,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Need Help?',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.navy,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'We are here to support your business',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 10.5,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        _buildSupportBadge(),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SUPPORT BADGE
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildSupportBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            'Support',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.success,
              fontSize: 9,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SUPPORT MESSAGE
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildSupportMessage() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        gradient: AppColors.softGradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.07)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.lightbulb_outline_rounded,
              color: AppColors.primary,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Need help with your store, orders, or account? '
              'Our support team is ready to assist you.',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.navy,
                fontSize: 10.5,
                height: 1.45,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CONTACT INFORMATION
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildContactInfo({required bool hasEmail, required bool hasPhone}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 390) {
          return Column(
            children: [
              _buildContactItem(
                icon: Icons.email_outlined,
                label: 'Email',
                value: hasEmail ? supportEmail.trim() : 'Not available',
                isAvailable: hasEmail,
              ),
              const SizedBox(height: 8),
              _buildContactItem(
                icon: Icons.phone_outlined,
                label: 'Phone',
                value: hasPhone ? supportPhone.trim() : 'Not available',
                isAvailable: hasPhone,
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child: _buildContactItem(
                icon: Icons.email_outlined,
                label: 'Email',
                value: hasEmail ? supportEmail.trim() : 'Not available',
                isAvailable: hasEmail,
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: _buildContactItem(
                icon: Icons.phone_outlined,
                label: 'Phone',
                value: hasPhone ? supportPhone.trim() : 'Not available',
                isAvailable: hasPhone,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String label,
    required String value,
    required bool isAvailable,
  }) {
    final iconColor = isAvailable ? AppColors.primary : AppColors.textSecondary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.45)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(9),
              border: Border.all(
                color: AppColors.border.withValues(alpha: 0.5),
              ),
            ),
            child: Icon(icon, size: 16, color: iconColor),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 8.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isAvailable
                        ? AppColors.navy
                        : AppColors.textSecondary,
                    fontSize: 9.5,
                    fontWeight: isAvailable ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SUPPORT ACTIONS
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildSupportActions(
    BuildContext context, {
    required bool hasEmail,
    required bool hasPhone,
    required bool hasTicket,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 390) {
          return Column(
            children: [
              _buildActionButton(
                icon: Icons.email_outlined,
                label: 'Email Support',
                onPressed: hasEmail ? () => _openEmail(context) : null,
                isPrimary: true,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.phone_outlined,
                      label: 'Call Support',
                      onPressed: hasPhone ? () => _openPhone(context) : null,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.confirmation_number_outlined,
                      label: 'Create Ticket',
                      onPressed: onCreateTicket,
                    ),
                  ),
                ],
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child: _buildActionButton(
                icon: Icons.email_outlined,
                label: 'Email Support',
                onPressed: hasEmail ? () => _openEmail(context) : null,
                isPrimary: true,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildActionButton(
                icon: Icons.phone_outlined,
                label: 'Call Support',
                onPressed: hasPhone ? () => _openPhone(context) : null,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildActionButton(
                icon: Icons.confirmation_number_outlined,
                label: 'Create Ticket',
                onPressed: onCreateTicket,
              ),
            ),
          ],
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ACTION BUTTON
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
    bool isPrimary = false,
  }) {
    final isEnabled = onPressed != null;

    final backgroundColor = isPrimary && isEnabled
        ? AppColors.primary
        : isEnabled
        ? AppColors.primaryLight.withValues(alpha: 0.4)
        : AppColors.background;

    final foregroundColor = isPrimary && isEnabled
        ? AppColors.white
        : isEnabled
        ? AppColors.primary
        : AppColors.textSecondary;

    final borderColor = isPrimary && isEnabled
        ? AppColors.primary
        : isEnabled
        ? AppColors.primary.withValues(alpha: 0.1)
        : AppColors.border.withValues(alpha: 0.5);

    return SizedBox(
      height: 44,
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
              boxShadow: isPrimary && isEnabled
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.16),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 17, color: foregroundColor),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.buttonOutlined.copyWith(
                      color: foregroundColor,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
