import 'package:flutter/material.dart';

import '../../../../Core/Custom Widgets/custom_button.dart';
import '../../../../Core/Custom Widgets/custom_textfield.dart';
import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class QuestionAnswerInput extends StatefulWidget {
  const QuestionAnswerInput({
    super.key,
    required this.onSubmit,
    this.enabled = true,
  });

  final Future<void> Function(String answer) onSubmit;
  final bool enabled;

  @override
  State<QuestionAnswerInput> createState() => _QuestionAnswerInputState();
}

class _QuestionAnswerInputState extends State<QuestionAnswerInput> {
  late final TextEditingController _answerController;
  late final FocusNode _answerFocusNode;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();

    _answerController = TextEditingController();
    _answerFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _answerController.dispose();
    _answerFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_isSubmitting || !widget.enabled) {
      return;
    }

    final answer = _answerController.text.trim();

    if (answer.isEmpty) {
      _showError('Please enter an answer.');
      _answerFocusNode.requestFocus();
      return;
    }

    if (answer.length > 500) {
      _showError('Answer cannot be longer than 500 characters.');
      _answerFocusNode.requestFocus();
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await widget.onSubmit(answer);

      if (!mounted) {
        return;
      }

      _answerController.clear();
      _answerFocusNode.unfocus();
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showError(error.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (!mounted) {
        return;
      }

      setState(() {
        _isSubmitting = false;
      });
    }
  }

  void _showError(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.enabled && !_isSubmitting;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 11),
          CustomTextField(
            controller: _answerController,
            focusNode: _answerFocusNode,
            hintText: 'Write an answer to this customer...',
            enabled: isEnabled,
            maxLines: 4,
            minLines: 3,
            maxLength: 500,
            textInputAction: TextInputAction.newline,
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 10),
          _buildBottomRow(isEnabled),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(9),
          ),
          child: const Icon(
            Icons.reply_rounded,
            size: 18,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            'Answer Customer',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomRow(bool isEnabled) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            'Keep your answer helpful and professional.',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 105,
          child: CustomButton(
            text: 'Send',
            onPressed: isEnabled ? _handleSubmit : null,
            isLoading: _isSubmitting,
            isEnabled: isEnabled,
            height: 42,
            borderRadius: 11,
            icon: Icons.send_rounded,
            iconPosition: CustomButtonIconPosition.trailing,
            textStyle: AppTextStyles.buttonSmall.copyWith(
              color: AppColors.textOnPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
