import 'package:flutter/material.dart';

import '../../../Theme/app_colors.dart';
import '../../../Theme/app_text_styles.dart';

class NeedHelpCard extends StatelessWidget {
  const NeedHelpCard({
    super.key,
    this.onEmailSupport,
    this.onCallSupport,
    this.onCreateTicket,
  });

  final VoidCallback? onEmailSupport;
  final VoidCallback? onCallSupport;
  final VoidCallback? onCreateTicket;

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

          _buildSupportActions(),
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

  Widget _buildSupportActions() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Small mobile screens:
        // Stack buttons vertically to guarantee zero overflow.
        if (constraints.maxWidth < 390) {
          return Column(
            children: [
              _buildActionButton(
                icon: Icons.email_outlined,
                label: 'Email Support',
                onPressed: onEmailSupport,
                isPrimary: true,
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.phone_outlined,
                      label: 'Call Support',
                      onPressed: onCallSupport,
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

        // Normal mobile / larger screens.
        return Row(
          children: [
            Expanded(
              child: _buildActionButton(
                icon: Icons.email_outlined,
                label: 'Email Support',
                onPressed: onEmailSupport,
                isPrimary: true,
              ),
            ),

            const SizedBox(width: 8),

            Expanded(
              child: _buildActionButton(
                icon: Icons.phone_outlined,
                label: 'Call Support',
                onPressed: onCallSupport,
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
