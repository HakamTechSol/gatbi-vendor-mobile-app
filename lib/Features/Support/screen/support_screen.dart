import 'package:flutter/material.dart';

import '../../../Theme/app_colors.dart';
import '../../../Theme/app_text_styles.dart';
import '../Data/support_dummy_data.dart';
import '../Reuse Widgets/support_contact_card.dart';
import '../Reuse Widgets/support_header.dart';
import '../Reuse Widgets/support_help_card.dart';
import '../Reuse Widgets/support_quick_action_card.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({
    super.key,
    this.onBack,
    this.onCustomerChatTap,
    this.onCampaignsTap,
    this.onKycTap,
    this.onOrdersTap,
    this.onPaymentsTap,
    this.onCampaignRequestTap,
    this.onAnalyticsTap,
    this.onProductsTap,
    this.onSettingsTap,
    this.onCreateTicketTap,
    this.onEmailTap,
    this.onPhoneTap,
    this.onWhatsAppTap,
  });

  final VoidCallback? onBack;

  final VoidCallback? onCustomerChatTap;
  final VoidCallback? onCampaignsTap;

  final VoidCallback? onKycTap;
  final VoidCallback? onOrdersTap;
  final VoidCallback? onPaymentsTap;
  final VoidCallback? onCampaignRequestTap;

  final VoidCallback? onAnalyticsTap;
  final VoidCallback? onProductsTap;
  final VoidCallback? onSettingsTap;

  final VoidCallback? onCreateTicketTap;

  final VoidCallback? onEmailTap;
  final VoidCallback? onPhoneTap;
  final VoidCallback? onWhatsAppTap;

  void _handleHelpItemTap(SupportHelpItem item) {
    switch (item.routeKey) {
      case 'kyc':
        onKycTap?.call();
        break;

      case 'orders':
        onOrdersTap?.call();
        break;

      case 'payments':
        onPaymentsTap?.call();
        break;

      case 'campaigns':
        onCampaignRequestTap?.call();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              sliver: SliverToBoxAdapter(
                child: SupportHeader(
                  onBack: onBack,
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
              sliver: SliverToBoxAdapter(
                child: _buildQuickActions(),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
              sliver: SliverToBoxAdapter(
                child: _buildQuickHelp(),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
              sliver: SliverToBoxAdapter(
                child: _buildPaymentsCard(),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
              sliver: SliverToBoxAdapter(
                child: SupportContactCard(
                  email: SupportDummyData.supportEmail,
                  phone: SupportDummyData.supportPhone,
                  whatsapp: SupportDummyData.supportWhatsApp,
                  supportHours: SupportDummyData.supportHours,
                  onEmailTap: onEmailTap,
                  onPhoneTap: onPhoneTap,
                  onWhatsAppTap: onWhatsAppTap,
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 30),
              sliver: SliverToBoxAdapter(
                child: _buildCreateTicketCard(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return SizedBox(
      height: 178,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SupportQuickActionCard(
              title: SupportDummyData.customerChatTitle,
              description: SupportDummyData.customerChatDescription,
              icon: Icons.chat_bubble_outline_rounded,
              onTap: onCustomerChatTap ?? () {},
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: SupportQuickActionCard(
              title: SupportDummyData.campaignsTitle,
              description: SupportDummyData.campaignsDescription,
              icon: Icons.campaign_outlined,
              onTap: onCampaignsTap ?? () {},
              gradient: AppColors.heroGradient,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickHelp() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          SupportDummyData.quickHelpTitle,
          style: AppTextStyles.labelMedium,
        ),

        const SizedBox(height: 4),

        Text(
          SupportDummyData.quickHelpDescription,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),

        const SizedBox(height: 14),

        ...SupportDummyData.helpItems.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: SupportHelpCard(
              title: item.title,
              description: item.description,

              // IMPORTANT:
              // Use the constant IconData directly.
              // Do NOT create IconData dynamically from an int.
              icon: item.icon,

              onTap: () => _handleHelpItemTap(item),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.borderPrimary,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_outlined,
                  color: AppColors.iconPrimary,
                  size: 22,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  SupportDummyData.paymentsTitle,
                  style: AppTextStyles.labelMedium,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Text(
            SupportDummyData.paymentsDescription,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.border,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.badge_outlined,
                  size: 19,
                  color: AppColors.iconSecondary,
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        SupportDummyData.merchantIdLabel,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        SupportDummyData.merchantId,
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onPaymentsTap,
              icon: const Icon(
                Icons.support_agent_rounded,
                size: 18,
              ),
              label: const Text(
                SupportDummyData.contactSupportLabel,
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(
                  color: AppColors.borderPrimary,
                ),
                minimumSize: const Size(
                  double.infinity,
                  46,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: AppTextStyles.buttonOutlined,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateTicketCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.edit_note_rounded,
              color: AppColors.iconPrimary,
              size: 24,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Still need help?',
                  style: AppTextStyles.labelMedium,
                ),

                const SizedBox(height: 4),

                Text(
                  'Create a support ticket and tell us what is happening.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          Material(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(11),
            child: InkWell(
              onTap: onCreateTicketTap,
              borderRadius: BorderRadius.circular(11),
              child: const SizedBox(
                width: 42,
                height: 42,
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: AppColors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
