import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../Core/Custom Widgets/custom_button.dart';
import '../../../Core/Custom Widgets/custom_textfield.dart';
import '../../../Services/api_exception.dart';
import '../../../Theme/app_colors.dart';
import '../../../Theme/app_text_styles.dart';

import '../Create Support/Controller/support_controller.dart';
import '../Reuse Widgets/support_ticket_priority_selector.dart';

class CreateSupportTicketScreen extends ConsumerStatefulWidget {
  const CreateSupportTicketScreen({super.key, this.onBack});

  final VoidCallback? onBack;

  @override
  ConsumerState<CreateSupportTicketScreen> createState() =>
      _CreateSupportTicketScreenState();
}

class _CreateSupportTicketScreenState
    extends ConsumerState<CreateSupportTicketScreen> {
  // ============================================================
  // Form
  // ============================================================

  final _formKey = GlobalKey<FormState>();

  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  // ============================================================
  // Form Values
  // ============================================================

  String _selectedPriority = 'medium';

  String _selectedCategory = 'general';

  bool _isSubmitting = false;

  // ============================================================
  // Constants
  // ============================================================

  static const int _minSubjectLength = 3;
  static const int _maxSubjectLength = 100;

  static const int _minMessageLength = 10;
  static const int _maxMessageLength = 1000;

  static const List<String> _categories = [
    'general',
    'order',
    'product',
    'payment',
    'technical',
  ];

  static const List<String> _priorities = ['low', 'medium', 'high'];

  // ============================================================
  // Dispose
  // ============================================================

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // ============================================================
  // Submit
  // ============================================================

  Future<void> _handleSubmit() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_isSubmitting) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final result = await ref
          .read(supportControllerProvider)
          .createSupportRequest(
            subject: _subjectController.text.trim(),
            category: _selectedCategory,
            priority: _selectedPriority,
            message: _messageController.text.trim(),
          );

      if (!mounted) {
        return;
      }

      // ============================================================
      // API Success
      // ============================================================

      if (result.success == true) {
        // Clear all fields after successful API response.
        _subjectController.clear();
        _messageController.clear();

        setState(() {
          _selectedCategory = 'general';
          _selectedPriority = 'medium';
          _isSubmitting = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result.message?.trim().isNotEmpty == true
                  ? result.message!.trim()
                  : 'Support request submitted successfully.',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Give SnackBar a small moment before going back.
        await Future<void>.delayed(const Duration(milliseconds: 350));

        if (!mounted) {
          return;
        }

        context.pop();
        return;
      }

      // ============================================================
      // API returned success: false
      // ============================================================

      setState(() {
        _isSubmitting = false;
      });

      _showErrorMessage(
        result.message?.trim().isNotEmpty == true
            ? result.message!.trim()
            : 'Unable to submit support request.',
      );
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isSubmitting = false;
      });

      _showErrorMessage(
        error.message.trim().isNotEmpty
            ? error.message.trim()
            : 'Something went wrong. Please try again.',
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isSubmitting = false;
      });

      _showErrorMessage('Something went wrong. Please try again.');
    }
  }

  // ============================================================
  // Error Snackbar
  // ============================================================

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }

  // ============================================================
  // Subject Validator
  // ============================================================

  String? _validateSubject(String? value) {
    final subject = value?.trim() ?? '';

    if (subject.isEmpty) {
      return 'Please enter a subject';
    }

    if (subject.length < _minSubjectLength) {
      return 'Subject must be at least $_minSubjectLength characters';
    }

    if (subject.length > _maxSubjectLength) {
      return 'Subject cannot exceed $_maxSubjectLength characters';
    }

    return null;
  }

  // ============================================================
  // Message Validator
  // ============================================================

  String? _validateMessage(String? value) {
    final message = value?.trim() ?? '';

    if (message.isEmpty) {
      return 'Please describe your issue';
    }

    if (message.length < _minMessageLength) {
      return 'Message must be at least $_minMessageLength characters';
    }

    if (message.length > _maxMessageLength) {
      return 'Message cannot exceed $_maxMessageLength characters';
    }

    return null;
  }

  // ============================================================
  // Build
  // ============================================================

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

  // ============================================================
  // Header
  // ============================================================

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
      child: Row(
        children: [
          _HeaderBackButton(
            onPressed:
                widget.onBack ??
                () {
                  context.pop();
                },
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Create Support Ticket', style: AppTextStyles.labelMedium),
                const SizedBox(height: 3),
                Text(
                  'Tell us how we can help you.',
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

  // ============================================================
  // Intro Card
  // ============================================================

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

  // ============================================================
  // Form
  // ============================================================

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Ticket Details', style: AppTextStyles.titleMedium),

        const SizedBox(height: 16),

        // ========================================================
        // Subject
        // ========================================================
        Text('Subject', style: AppTextStyles.formLabel),

        const SizedBox(height: 8),

        CustomTextField(
          controller: _subjectController,
          hintText: 'Enter ticket subject',
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.sentences,
          maxLength: _maxSubjectLength,
          validator: _validateSubject,
        ),

        const SizedBox(height: 18),

        // ========================================================
        // Category
        // ========================================================
        Text('Category', style: AppTextStyles.formLabel),

        const SizedBox(height: 8),

        _buildCategoryDropdown(),

        const SizedBox(height: 18),

        // ========================================================
        // Message
        // ========================================================
        Text('Message', style: AppTextStyles.formLabel),

        const SizedBox(height: 8),

        CustomTextField(
          controller: _messageController,
          hintText: 'Describe your issue or request',
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          textCapitalization: TextCapitalization.sentences,
          minLines: 6,
          maxLines: 8,
          maxLength: _maxMessageLength,
          validator: _validateMessage,
        ),

        const SizedBox(height: 20),

        // ========================================================
        // Priority
        // ========================================================


        SupportTicketPrioritySelector(
          selectedPriority: _selectedPriority,
          priorities: _priorities,
          onChanged: (priority) {
            if (_isSubmitting) {
              return;
            }

            setState(() {
              _selectedPriority = priority.toLowerCase();
            });
          },
        ),

        const SizedBox(height: 28),

        // ========================================================
        // Submit Button
        // ========================================================
        SizedBox(
          width: double.infinity,
          child: CustomButton(
            text: 'Submit Ticket',
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

  // ============================================================
  // Category Dropdown
  // ============================================================

  Widget _buildCategoryDropdown() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCategory,
          isExpanded: true,
          borderRadius: BorderRadius.circular(14),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.iconPrimary,
          ),
          dropdownColor: AppColors.white,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
          ),
          items: _categories.map((category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Text(
                _categoryLabel(category),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            );
          }).toList(),
          onChanged: _isSubmitting
              ? null
              : (value) {
                  if (value == null) {
                    return;
                  }

                  setState(() {
                    _selectedCategory = value;
                  });
                },
        ),
      ),
    );
  }

  // ============================================================
  // Category Label
  // ============================================================

  String _categoryLabel(String category) {
    switch (category) {
      case 'general':
        return 'General';

      case 'order':
        return 'Order';

      case 'product':
        return 'Product';

      case 'payment':
        return 'Payment';

      case 'technical':
        return 'Technical';

      default:
        return category;
    }
  }
}

// ============================================================================
// Header Back Button
// ============================================================================

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
