import 'package:flutter/material.dart';

import '../../../../../Core/Custom Widgets/custom_button.dart';
import '../../../../../Core/Custom Widgets/custom_textfield.dart';
import '../../../../../Theme/app_colors.dart';
import '../../../../../Theme/app_text_styles.dart';

class RejectPaymentDialog extends StatefulWidget {
  const RejectPaymentDialog({super.key, required this.onSubmit});

  final Future<void> Function({required String reason, required String notes})
  onSubmit;

  @override
  State<RejectPaymentDialog> createState() => RejectPaymentDialogState();
}

class RejectPaymentDialogState extends State<RejectPaymentDialog> {
  // ============================================================
  // CONTROLLERS
  // ============================================================

  late final TextEditingController _reasonController;

  late final TextEditingController _notesController;

  // ============================================================
  // FORM
  // ============================================================

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // ============================================================
  // LOADING
  // ============================================================

  bool _isSubmitting = false;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    _reasonController = TextEditingController();

    _notesController = TextEditingController();
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _reasonController.dispose();

    _notesController.dispose();

    super.dispose();
  }

  // ============================================================
  // SUBMIT
  // ============================================================

  Future<void> _submit() async {
    if (_isSubmitting) {
      return;
    }

    FocusScope.of(context).unfocus();

    // ==========================================================
    // VALIDATE
    // ==========================================================

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await widget.onSubmit(
        reason: _reasonController.text.trim(),
        notes: _notesController.text.trim(),
      );
    } catch (_) {
      // ========================================================
      // API ERROR
      //
      // Parent already shows snackbar/logs.
      // Dialog ko open rakhenge taa-ke user retry kar sake.
      // ========================================================

      if (!mounted) {
        return;
      }

      setState(() {
        _isSubmitting = false;
      });
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      surfaceTintColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      contentPadding: const EdgeInsets.fromLTRB(20, 8, 20, 20),

      // ========================================================
      // TITLE
      // ========================================================
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(
              Icons.cancel_outlined,
              color: AppColors.error,
              size: 21,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              'Reject Payment Proof',
              style: AppTextStyles.titleMedium.copyWith(color: AppColors.navy),
            ),
          ),
        ],
      ),

      // ========================================================
      // CONTENT
      // ========================================================
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Please provide a reason for rejecting this payment proof.',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 18),

              // ==================================================
              // REASON
              // ==================================================
              CustomTextField(
                controller: _reasonController,
                label: 'Reason',
                hintText: 'Enter reason for rejecting payment proof',
                enabled: !_isSubmitting,
                maxLines: 3,
                minLines: 3,
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                contentPadding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                fillColor: AppColors.background,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Reason is required.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              // ==================================================
              // NOTES
              // ==================================================
              CustomTextField(
                controller: _notesController,
                label: 'Notes',
                hintText: 'Enter additional notes',
                enabled: !_isSubmitting,
                maxLines: 3,
                minLines: 3,
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                contentPadding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                fillColor: AppColors.background,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Notes are required.';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 20),

              // ==================================================
              // ACTION BUTTONS
              // ==================================================
              Row(
                children: [
                  // ==============================================
                  // CANCEL
                  // ==============================================
                  Expanded(
                    child: CustomButton(
                      text: 'Cancel',
                      type: CustomButtonType.outlined,
                      height: 46,
                      borderRadius: 11,
                      isEnabled: !_isSubmitting,
                      onPressed: _isSubmitting
                          ? null
                          : () {
                              Navigator.of(context).pop();
                            },
                      foregroundColor: AppColors.textSecondary,
                      borderColor: AppColors.backgroundSecondary,
                    ),
                  ),

                  const SizedBox(width: 10),

                  // ==============================================
                  // CONFIRM REJECT
                  // ==============================================
                  Expanded(
                    child: CustomButton(
                      text: 'Confirm Reject',
                      height: 46,
                      borderRadius: 11,
                      isLoading: _isSubmitting,
                      isEnabled: !_isSubmitting,
                      backgroundColor: AppColors.error,
                      foregroundColor: AppColors.white,
                      onPressed: _isSubmitting ? null : _submit,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
