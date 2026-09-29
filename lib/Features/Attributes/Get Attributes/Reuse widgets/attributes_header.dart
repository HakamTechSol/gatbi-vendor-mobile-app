import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class AttributesHeader extends StatelessWidget {
  const AttributesHeader({
    super.key,
    this.onBack,
    this.onAddAttribute,
    this.showAddButton = true,
    this.isAddEnabled = true,
  });

  final VoidCallback? onBack;
  final VoidCallback? onAddAttribute;
  final bool showAddButton;
  final bool isAddEnabled;

  // ============================================================
  // Back
  // ============================================================

  void _handleBack(BuildContext context) {
    if (onBack != null) {
      onBack!.call();
      return;
    }

    context.pop();
  }

  // ============================================================
  // Build
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        // ======================================================
        // Very Small Screens
        // ======================================================

        if (width < 360) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildBackButton(context),

                  const SizedBox(width: 10),

                  Expanded(child: _buildTitle()),
                ],
              ),

              if (showAddButton) ...[
                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: _buildAddButton(fullWidth: true),
                ),
              ],
            ],
          );
        }

        // ======================================================
        // Normal / Wide Screens
        // ======================================================

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildBackButton(context),

            const SizedBox(width: 12),

            Expanded(child: _buildTitle()),

            if (showAddButton) ...[
              const SizedBox(width: 12),

              _buildAddButton(fullWidth: false),
            ],
          ],
        );
      },
    );
  }

  // ============================================================
  // Back Button
  // ============================================================

  Widget _buildBackButton(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () => _handleBack(context),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: const Icon(
            Icons.arrow_back_rounded,
            size: 22,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // Title
  // ============================================================

  Widget _buildTitle() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                'Attributes',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.headlineMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 3),

        Text(
          'Manage product attributes and values',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // Add Attribute Button
  // ============================================================

  Widget _buildAddButton({required bool fullWidth}) {
    final button = Material(
      color: isAddEnabled ? AppColors.primary : AppColors.border,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: isAddEnabled ? onAddAttribute : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 44,
          width: fullWidth ? double.infinity : null,
          padding: const EdgeInsets.symmetric(horizontal: 13),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: Row(
            mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: fullWidth
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              Icon(
                Icons.add_rounded,
                size: 19,
                color: isAddEnabled ? AppColors.white : AppColors.textTertiary,
              ),

              const SizedBox(width: 5),

              Text(
                'Add Attribute',
                style: AppTextStyles.buttonMedium.copyWith(
                  color: isAddEnabled
                      ? AppColors.white
                      : AppColors.textTertiary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // ==========================================================
    // Finite Width on Normal Screens
    // ==========================================================

    if (!fullWidth) {
      return ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 120, maxWidth: 145),
        child: button,
      );
    }

    return button;
  }
}
