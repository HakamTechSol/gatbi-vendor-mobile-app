import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Core/Custom Widgets/custom_button.dart';
import '../../../../Services/api_exception.dart';
import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../Controller/notification_setting_controller.dart';
import '../Reuse Widgets/notification_setting_card.dart';
import '../Reuse Widgets/notification_setting_header.dart';
import '../Reuse Widgets/notification_setting_header_card.dart';
import '../Reuse Widgets/notification_setting_info_card.dart';
import '../Reuse Widgets/notification_setting_switch_tile.dart';

class NotificationSettingScreen extends ConsumerStatefulWidget {
  const NotificationSettingScreen({super.key});

  @override
  ConsumerState<NotificationSettingScreen> createState() =>
      _NotificationSettingScreenState();
}

class _NotificationSettingScreenState
    extends ConsumerState<NotificationSettingScreen> {
  // ============================================================
  // LOCAL SETTINGS
  // ============================================================

  bool _emailNotifications = true;
  bool _smsNotifications = true;
  bool _marketingEmails = true;

  // ============================================================
  // LOADING
  // ============================================================

  bool _isSaving = false;

  // ============================================================
  // SAVE SETTINGS
  // ============================================================

  Future<void> _saveChanges() async {
    if (_isSaving) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final controller = ref.read(notificationSettingControllerProvider);

      final result = await controller.updateNotificationSettings(
        emailNotifications: _emailNotifications,
        smsNotifications: _smsNotifications,
        marketingEmails: _marketingEmails,
      );

      if (!mounted) {
        return;
      }

      if (!result.success) {
        throw ApiException(
          message:
              result.message ?? 'Unable to update notification preferences.',
          code: 'UPDATE_NOTIFICATION_SETTINGS_FAILED',
        );
      }

      // ----------------------------------------------------------
      // Sync UI with server response
      // ----------------------------------------------------------

      final user = result.user;

      if (user != null) {
        setState(() {
          _emailNotifications = user.emailNotifications;

          _smsNotifications = user.smsNotifications;

          _marketingEmails = user.marketingEmails;
        });
      }

      _showSuccessMessage(
        result.message ?? 'Notification preferences updated successfully.',
      );
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      _showErrorMessage(error.message);
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showErrorMessage('Something went wrong. Please try again.');
    } finally {
      if (!mounted) {
        return;
      }

      setState(() {
        _isSaving = false;
      });
    }
  }

  // ============================================================
  // SUCCESS MESSAGE
  // ============================================================

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.successDark,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: AppColors.white,
                size: 21,
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  message,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  // ============================================================
  // ERROR MESSAGE
  // ============================================================

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.errorDark,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Row(
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: AppColors.white,
                size: 21,
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  message,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  // ============================================================
  // TOGGLE EMAIL
  // ============================================================

  void _onEmailChanged(bool value) {
    if (_isSaving) {
      return;
    }

    setState(() {
      _emailNotifications = value;
    });
  }

  // ============================================================
  // TOGGLE SMS
  // ============================================================

  void _onSmsChanged(bool value) {
    if (_isSaving) {
      return;
    }

    setState(() {
      _smsNotifications = value;
    });
  }

  // ============================================================
  // TOGGLE MARKETING
  // ============================================================

  void _onMarketingChanged(bool value) {
    if (_isSaving) {
      return;
    }

    setState(() {
      _marketingEmails = value;
    });
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      child: const NotificationSettingHeader(),
    );
  }

  // ============================================================
  // BODY
  // ============================================================

  Widget _buildBody() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const NotificationSettingHeaderCard(),

          const SizedBox(height: 18),

          _buildSectionTitle(),

          const SizedBox(height: 10),

          _buildSettingsCard(),

          const SizedBox(height: 14),

          const NotificationSettingInfoCard(),

          const SizedBox(height: 22),

          _buildSaveButton(),
        ],
      ),
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget _buildSectionTitle() {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Choose your preferences',
            style: AppTextStyles.formSectionTitle,
          ),
        ),

        _buildActiveIndicator(),
      ],
    );
  }

  // ============================================================
  // ACTIVE INDICATOR
  // ============================================================

  Widget _buildActiveIndicator() {
    final enabledCount = [
      _emailNotifications,
      _smsNotifications,
      _marketingEmails,
    ].where((value) => value).length;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: enabledCount == 0
            ? AppColors.surfaceMuted
            : AppColors.successLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: enabledCount == 0 ? AppColors.border : AppColors.successBorder,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: enabledCount == 0
                  ? AppColors.textMuted
                  : AppColors.success,
            ),
          ),

          const SizedBox(width: 6),

          Text(
            '$enabledCount of 3 enabled',
            style: AppTextStyles.captionMedium.copyWith(
              color: enabledCount == 0
                  ? AppColors.textSecondary
                  : AppColors.successDark,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SETTINGS CARD
  // ============================================================

  Widget _buildSettingsCard() {
    return NotificationSettingCard(
      child: Column(
        children: [
          NotificationSettingSwitchTile(
            title: 'Email Notifications',
            description:
                'Receive account updates, order activity and important alerts by email.',
            icon: Icons.email_outlined,
            value: _emailNotifications,
            onChanged: _onEmailChanged,
            isEnabled: !_isSaving,
            iconColor: AppColors.primary,
            iconBackgroundColor: AppColors.primaryLight,
          ),

          const SizedBox(height: 12),

          NotificationSettingSwitchTile(
            title: 'SMS Notifications',
            description:
                'Get important updates and alerts directly through SMS messages.',
            icon: Icons.sms_outlined,
            value: _smsNotifications,
            onChanged: _onSmsChanged,
            isEnabled: !_isSaving,
            iconColor: AppColors.success,
            iconBackgroundColor: AppColors.successLight,
          ),

          const SizedBox(height: 12),

          NotificationSettingSwitchTile(
            title: 'Marketing Emails',
            description:
                'Receive promotions, offers, campaigns and product updates.',
            icon: Icons.campaign_outlined,
            value: _marketingEmails,
            onChanged: _onMarketingChanged,
            isEnabled: !_isSaving,
            iconColor: AppColors.purple,
            iconBackgroundColor: AppColors.purpleLight,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SAVE BUTTON
  // ============================================================

  Widget _buildSaveButton() {
    return CustomButton(
      text: 'Save Changes',
      icon: Icons.check_rounded,
      iconPosition: CustomButtonIconPosition.trailing,
      height: 54,
      borderRadius: 14,
      elevation: 2,
      isLoading: _isSaving,
      isEnabled: !_isSaving,
      onPressed: _saveChanges,
    );
  }
}
