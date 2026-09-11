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

      if (!context.mounted) {
        return;
      }

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

        if (!context.mounted) {
          return;
        }

        _showError(context, 'No email app is available on this device.');

        return;
      }

      debugPrint('[NeedHelpCard] Email app opened successfully.');
    } catch (error, stackTrace) {
      debugPrint('[NeedHelpCard] EMAIL LAUNCH ERROR: $error');

      debugPrint('[NeedHelpCard] EMAIL STACK TRACE:\n$stackTrace');

      if (!context.mounted) {
        return;
      }

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

      if (!context.mounted) {
        return;
      }

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

        if (!context.mounted) {
          return;
        }

        _showError(context, 'Unable to open phone dialer.');

        return;
      }

      debugPrint('[NeedHelpCard] Phone dialer opened successfully.');
    } catch (error, stackTrace) {
      debugPrint('[NeedHelpCard] PHONE LAUNCH ERROR: $error');

      debugPrint('[NeedHelpCard] PHONE STACK TRACE:\n$stackTrace');

      if (!context.mounted) {
        return;
      }

      _showError(context, 'Unable to open phone dialer.');
    }

    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ERROR
  // ═══════════════════════════════════════════════════════════════════════════

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.white,
              fontSize: 13,
            ),
          ),
          backgroundColor: AppColors.errorDark,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.75)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowStrong.withValues(alpha: 0.07),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),

          const SizedBox(height: 8),

          Text(
            'Need help with your store, orders, or account? '
            'Our support team is here to help.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11.5,
              height: 1.45,
            ),
          ),

          const SizedBox(height: 15),

          _buildSupportActions(context),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // HEADER
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: AppColors.softGradient,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primaryLight),
          ),
          child: const Icon(
            Icons.support_agent_rounded,
            color: AppColors.primary,
            size: 21,
          ),
        ),

        const SizedBox(width: 11),

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
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                'We are here for you',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 9.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SUPPORT ACTIONS
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildSupportActions(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // ----------------------------------------------------------
        // Small mobile screens
        // ----------------------------------------------------------

        if (constraints.maxWidth < 390) {
          return Column(
            children: [
              _buildActionButton(
                icon: Icons.email_outlined,
                label: 'Email Support',
                onPressed: () => _openEmail(context),
                isPrimary: true,
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.phone_outlined,
                      label: 'Call Support',
                      onPressed: () => _openPhone(context),
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

        // ----------------------------------------------------------
        // Normal mobile / larger screens
        // ----------------------------------------------------------

        return Row(
          children: [
            Expanded(
              child: _buildActionButton(
                icon: Icons.email_outlined,
                label: 'Email Support',
                onPressed: () => _openEmail(context),
                isPrimary: true,
              ),
            ),

            const SizedBox(width: 8),

            Expanded(
              child: _buildActionButton(
                icon: Icons.phone_outlined,
                label: 'Call Support',
                onPressed: () => _openPhone(context),
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
    return SizedBox(
      height: 42,
      child: Material(
        color: isPrimary
            ? AppColors.primary
            : AppColors.primaryLight.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(11),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(11),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 7),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11),
              border: Border.all(
                color: isPrimary
                    ? AppColors.primary
                    : AppColors.primary.withValues(alpha: 0.12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: isPrimary ? AppColors.white : AppColors.primary,
                ),

                const SizedBox(width: 5),

                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.buttonOutlined.copyWith(
                      color: isPrimary ? AppColors.white : AppColors.primary,
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
