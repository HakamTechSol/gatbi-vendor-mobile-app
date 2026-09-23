import 'package:flutter/material.dart';

import '../../../../../Theme/app_colors.dart';
import '../../../../../Theme/app_text_styles.dart';

class MyProductsFilter extends StatelessWidget {
  const MyProductsFilter({
    super.key,
    required this.selectedAction,
    required this.actions,
    required this.onActionChanged,
    required this.onApply,
    this.isApplying = false,
  });

  /// Currently selected bulk action.
  ///
  /// null = No Action
  final String? selectedAction;

  /// Available bulk actions.
  final List<String> actions;

  /// Bulk action changed callback.
  final ValueChanged<String?> onActionChanged;

  /// Apply bulk action callback.
  final VoidCallback onApply;

  /// Shows loading state on Apply button.
  final bool isApplying;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ==========================================================
        // BULK ACTION DROPDOWN
        // ==========================================================
        Expanded(child: _buildActionDropdown()),

        const SizedBox(width: 10),

        // ==========================================================
        // APPLY BUTTON
        // ==========================================================
        SizedBox(width: 96, height: 44, child: _buildApplyButton()),
      ],
    );
  }

  // ============================================================
  // ACTION DROPDOWN
  // ============================================================

  Widget _buildActionDropdown() {
    const String hint = 'Select Action';

    final dropdownItems = <String>[
      hint,
      ...actions.where((action) => action != hint),
    ];

    final dropdownValue = selectedAction ?? hint;

    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selectedAction != null
              ? AppColors.primary.withValues(alpha: 0.45)
              : AppColors.border,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: dropdownValue,

          // ------------------------------------------------------
          // Important:
          // Dropdown gets bounded width from Expanded.
          // ------------------------------------------------------
          isExpanded: true,

          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 18,
            color: AppColors.textSecondary,
          ),

          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.navy,
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
          ),

          borderRadius: BorderRadius.circular(14),

          dropdownColor: AppColors.white,

          items: dropdownItems.map((item) {
            final isHint = item == hint;

            return DropdownMenuItem<String>(
              value: item,
              child: Row(
                children: [
                  Icon(
                    _getActionIcon(item),
                    size: 16,
                    color: isHint
                        ? AppColors.textSecondary
                        : _getActionColor(item),
                  ),

                  const SizedBox(width: 7),

                  Expanded(
                    child: Text(
                      _getActionLabel(item),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isHint
                            ? AppColors.textSecondary
                            : AppColors.navy,
                        fontSize: 10.5,
                        fontWeight: isHint ? FontWeight.w500 : FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),

          onChanged: (newValue) {
            if (newValue == null || newValue == hint) {
              onActionChanged(null);
              return;
            }

            onActionChanged(newValue);
          },
        ),
      ),
    );
  }

  // ============================================================
  // APPLY BUTTON
  // ============================================================

  Widget _buildApplyButton() {
    final bool enabled = selectedAction != null && !isApplying;

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: ElevatedButton.icon(
        onPressed: enabled ? onApply : null,

        icon: isApplying
            ? const SizedBox(
                width: 15,
                height: 15,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.white,
                ),
              )
            : const Icon(Icons.check_rounded, size: 17),

        label: Text(
          isApplying ? 'Applying...' : 'Apply',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,

          foregroundColor: AppColors.white,

          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.35),

          disabledForegroundColor: AppColors.white.withValues(alpha: 0.85),

          elevation: 0,

          padding: const EdgeInsets.symmetric(horizontal: 10),

          minimumSize: Size.zero,

          tapTargetSize: MaterialTapTargetSize.shrinkWrap,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),

          textStyle: AppTextStyles.buttonText.copyWith(
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ACTION LABEL
  // ============================================================

  String _getActionLabel(String action) {
    switch (action.toLowerCase().trim()) {
      case 'activate':
        return 'Activate';

      case 'deactivate':
        return 'Deactivate';

      case 'delete':
        return 'Delete';

      case 'select action':
        return 'Select Action';

      default:
        return action;
    }
  }

  // ============================================================
  // ACTION ICON
  // ============================================================

  IconData _getActionIcon(String action) {
    switch (action.toLowerCase().trim()) {
      case 'activate':
        return Icons.check_circle_outline_rounded;

      case 'deactivate':
        return Icons.pause_circle_outline_rounded;

      case 'delete':
        return Icons.delete_outline_rounded;

      default:
        return Icons.tune_rounded;
    }
  }

  // ============================================================
  // ACTION COLOR
  // ============================================================

  Color _getActionColor(String action) {
    switch (action.toLowerCase().trim()) {
      case 'activate':
        return AppColors.success;

      case 'deactivate':
        return AppColors.warning;

      case 'delete':
        return AppColors.errorDark;

      default:
        return AppColors.primary;
    }
  }
}
