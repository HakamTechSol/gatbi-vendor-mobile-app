import 'package:flutter/material.dart';

import '../../../Core/Custom Widgets/custom_button.dart';
import '../../../Core/Custom Widgets/custom_textfield.dart';
import '../../../Theme/app_colors.dart';
import '../../../Theme/app_text_styles.dart';
import '../Data/support_dummy_data.dart';
import '../Reuse Widgets/support_ticket_priority_selector.dart';

class CreateSupportTicketScreen extends StatefulWidget {
  const CreateSupportTicketScreen({super.key, this.onBack, this.onSubmit});

  final VoidCallback? onBack;

  /// UI-only callback.
  ///
  /// Later this can be connected to:
  /// Screen → Provider → Repository → API
  final Future<void> Function({
    required String subject,
    required String message,
    required String priority,
  })?
  onSubmit;

  @override
  State<CreateSupportTicketScreen> createState() =>
      _CreateSupportTicketScreenState();
}

class _CreateSupportTicketScreenState extends State<CreateSupportTicketScreen> {
  final _formKey = GlobalKey<FormState>();

  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  String _selectedPriority = SupportDummyData.defaultPriority;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (widget.onSubmit == null) {
      _showDemoMessage();
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await widget.onSubmit!(
        subject: _subjectController.text.trim(),
        message: _messageController.text.trim(),
        priority: _selectedPriority.toLowerCase(),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _showDemoMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Support ticket submission will be connected to the API later.',
        ),
      ),
    );
  }

  String? _validateSubject(String? value) {
    final subject = value?.trim() ?? '';

    if (subject.isEmpty) {
      return 'Please enter a subject';
    }

    if (subject.length < SupportDummyData.minSubjectLength) {
      return 'Subject must be at least '
          '${SupportDummyData.minSubjectLength} characters';
    }

    if (subject.length > SupportDummyData.maxSubjectLength) {
      return 'Subject cannot exceed '
          '${SupportDummyData.maxSubjectLength} characters';
    }

    return null;
  }

  String? _validateMessage(String? value) {
    final message = value?.trim() ?? '';

    if (message.isEmpty) {
      return 'Please describe your issue';
    }

    if (message.length < SupportDummyData.minMessageLength) {
      return 'Message must be at least '
          '${SupportDummyData.minMessageLength} characters';
    }

    if (message.length > SupportDummyData.maxMessageLength) {
      return 'Message cannot exceed '
          '${SupportDummyData.maxMessageLength} characters';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildIntroCard(),
                      const SizedBox(height: 22),
                      _buildForm(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
      child: Row(
        children: [
          _HeaderBackButton(
            onPressed: widget.onBack ?? () => Navigator.of(context).maybePop(),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  SupportDummyData.createTicketTitle,
                  style: AppTextStyles.labelMedium,
                ),
                const SizedBox(height: 3),
                Text(
                  SupportDummyData.createTicketSubtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(18),
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
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.support_agent_rounded,
              color: AppColors.white,
              size: 25,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Need assistance?',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tell us what you need help with and our support team will assist you.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.white.withValues(alpha: 0.82),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Ticket Details', style: AppTextStyles.titleMedium),
        const SizedBox(height: 16),

        Text(SupportDummyData.subjectLabel, style: AppTextStyles.formLabel),
        const SizedBox(height: 8),
        CustomTextField(
          controller: _subjectController,
          hintText: SupportDummyData.subjectHint,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.sentences,
          maxLength: SupportDummyData.maxSubjectLength,
          validator: _validateSubject,
        ),

        const SizedBox(height: 18),

        Text(SupportDummyData.messageLabel, style: AppTextStyles.formLabel),
        const SizedBox(height: 8),
        CustomTextField(
          controller: _messageController,
          hintText: SupportDummyData.messageHint,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          textCapitalization: TextCapitalization.sentences,
          minLines: 6,
          maxLines: 8,
          maxLength: SupportDummyData.maxMessageLength,
          validator: _validateMessage,
        ),

        const SizedBox(height: 20),

        SupportTicketPrioritySelector(
          selectedPriority: _selectedPriority,
          priorities: SupportDummyData.priorities,
          onChanged: (priority) {
            setState(() {
              _selectedPriority = priority;
            });
          },
        ),

        const SizedBox(height: 28),

        SizedBox(
          width: double.infinity,
          child: CustomButton(
            text: SupportDummyData.submitTicketButton,
            onPressed: _handleSubmit,
            isLoading: _isSubmitting,
            width: double.infinity,
            height: 54,
            borderRadius: 14,
            icon: Icons.send_rounded,
            iconPosition: CustomButtonIconPosition.trailing,
          ),
        ),

        const SizedBox(height: 12),

        Center(
          child: Text(
            'Our support team will review your request and get back to you.',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textTertiary,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

class _HeaderBackButton extends StatelessWidget {
  const _HeaderBackButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: AppColors.iconPrimary,
          ),
        ),
      ),
    );
  }
}
