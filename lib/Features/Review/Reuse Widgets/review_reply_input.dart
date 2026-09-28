import 'package:flutter/material.dart';

import '../../../../Core/Custom Widgets/custom_button.dart';
import '../../../../Core/Custom Widgets/custom_textfield.dart';
import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class ReviewReplyInput extends StatefulWidget {
  const ReviewReplyInput({
    super.key,
    required this.onSubmit,
    this.isLoading = false,
    this.enabled = true,
    this.initialReply = '',
    this.hintText = 'Write a reply to this customer...',
    this.maxLength = 500,
  });

  // ===========================================================================
  // Fields
  // ===========================================================================

  final Future<void> Function(String reply) onSubmit;

  final bool isLoading;
  final bool enabled;
  final String initialReply;
  final String hintText;
  final int maxLength;

  @override
  State<ReviewReplyInput> createState() => _ReviewReplyInputState();
}

class _ReviewReplyInputState extends State<ReviewReplyInput> {
  // ===========================================================================
  // Controllers
  // ===========================================================================

  late final TextEditingController _replyController;
  late final FocusNode _replyFocusNode;

  // ===========================================================================
  // State
  // ===========================================================================

  bool _isSubmitting = false;

  // ===========================================================================
  // Lifecycle
  // ===========================================================================

  @override
  void initState() {
    super.initState();

    _replyController = TextEditingController(text: widget.initialReply);

    _replyFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _replyController.dispose();
    _replyFocusNode.dispose();
    super.dispose();
  }

  // ===========================================================================
  // Build
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    final isBusy = widget.isLoading || _isSubmitting;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // -------------------------------------------------------------------
          // Header
          // -------------------------------------------------------------------
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(
                  Icons.edit_outlined,
                  size: 17,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  'Reply to Customer',
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // -------------------------------------------------------------------
          // Reply Field
          // -------------------------------------------------------------------
          CustomTextField(
            controller: _replyController,
            focusNode: _replyFocusNode,
            hintText: widget.hintText,
            enabled: widget.enabled && !isBusy,
            maxLines: 4,
            minLines: 3,
            maxLength: widget.maxLength,
            textInputAction: TextInputAction.newline,
            textCapitalization: TextCapitalization.sentences,
            onSubmitted: (_) {
              // Do not submit from keyboard because this is a multiline field.
            },
          ),

          const SizedBox(height: 12),

          // -------------------------------------------------------------------
          // Bottom Row
          // -------------------------------------------------------------------
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  'Keep your response helpful and professional.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 105,
                child: CustomButton(
                  text: 'Send',
                  height: 44,
                  borderRadius: 10,
                  isLoading: isBusy,
                  isEnabled: widget.enabled && !isBusy,
                  onPressed: _handleSubmit,
                  icon: Icons.send_rounded,
                  iconPosition: CustomButtonIconPosition.trailing,
                  textStyle: AppTextStyles.buttonSmall.copyWith(
                    color: AppColors.textOnPrimary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // Submit
  // ===========================================================================

  Future<void> _handleSubmit() async {
    if (_isSubmitting || widget.isLoading || !widget.enabled) {
      return;
    }

    final reply = _replyController.text.trim();

    if (reply.isEmpty) {
      _showMessage('Please write a reply before submitting.', isError: true);
      _replyFocusNode.requestFocus();
      return;
    }

    if (reply.length > widget.maxLength) {
      _showMessage(
        'Reply cannot exceed ${widget.maxLength} characters.',
        isError: true,
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await widget.onSubmit(reply);

      if (!mounted) {
        return;
      }

      _replyController.clear();
      _replyFocusNode.unfocus();
    } catch (_) {
      // -----------------------------------------------------------------------
      // API/controller error is intentionally handled by the parent.
      // -----------------------------------------------------------------------
    } finally {
      if (!mounted) {
        return;
      }

      setState(() {
        _isSubmitting = false;
      });
    }
  }

  // ===========================================================================
  // Message
  // ===========================================================================

  void _showMessage(String message, {required bool isError}) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: isError ? AppColors.error : AppColors.success,
        ),
      );
  }
}
