import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../Theme/app_colors.dart';
import '../../../../../Theme/app_text_styles.dart';

class MyProductsHeader extends StatelessWidget {
  const MyProductsHeader({super.key, this.onAddProduct, this.onExportCsv});

  final VoidCallback? onAddProduct;
  final VoidCallback? onExportCsv;

  // ============================================================
  // SHOW DROPDOWN MENU
  // ============================================================

  Future<void> _showActionsMenu(BuildContext context) async {
    HapticFeedback.selectionClick();

    final RenderBox button = context.findRenderObject() as RenderBox;

    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    final buttonPosition = button.localToGlobal(Offset.zero, ancestor: overlay);

    final buttonSize = button.size;

    // ============================================================
    // MENU SIZE
    // ============================================================

    const menuWidth = 160.0;
    const menuHeight = 108.0;

    // ============================================================
    // POSITION
    // ============================================================
    //
    // Menu ka RIGHT edge icon ke RIGHT edge ke exactly uper hoga.
    // Menu icon ke uper open hoga.
    //

    final right = overlay.size.width - (buttonPosition.dx + buttonSize.width);

    final bottom = overlay.size.height - buttonPosition.dy + 8;

    final selectedAction = await showMenu<_ProductAction>(
      context: context,

      color: AppColors.white,

      elevation: 8,

      shadowColor: AppColors.shadowStrong.withValues(alpha: 0.18),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: AppColors.divider.withValues(alpha: 0.8)),
      ),

      position: RelativeRect.fromLTRB(
        overlay.size.width - right - menuWidth,
        buttonPosition.dy - menuHeight - 8,
        right,
        bottom,
      ),

      items: [
        // ==========================================================
        // ADD PRODUCT
        // ==========================================================
        PopupMenuItem<_ProductAction>(
          value: _ProductAction.addProduct,
          height: 48,
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.09),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(
                  Icons.add_box_outlined,
                  color: AppColors.primary,
                  size: 18,
                ),
              ),

              const SizedBox(width: 10),

              Text(
                'Add Product',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        // ==========================================================
        // EXPORT CSV
        // ==========================================================
        PopupMenuItem<_ProductAction>(
          value: _ProductAction.exportCsv,
          height: 48,
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.09),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(
                  Icons.file_download_outlined,
                  color: AppColors.primary,
                  size: 18,
                ),
              ),

              const SizedBox(width: 10),

              Text(
                'Export CSV',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    if (selectedAction == null) return;

    // ============================================================
    // ACTION
    // ============================================================

    switch (selectedAction) {
      case _ProductAction.addProduct:
        HapticFeedback.selectionClick();
        onAddProduct?.call();
        break;

      case _ProductAction.exportCsv:
        HapticFeedback.selectionClick();
        onExportCsv?.call();
        break;
    }
  }
  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isSmallScreen = size.width < 380;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ========================================================
        // TITLE
        // ========================================================
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Products',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.headlineMedium.copyWith(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w800,
                  fontSize: isSmallScreen ? 19 : 21,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                'Manage your store catalogue',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: isSmallScreen ? 10.5 : 11.5,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 10),

        // ========================================================
        // MENU ICON
        // ========================================================
        _buildMenuButton(context, isSmallScreen: isSmallScreen),
      ],
    );
  }

  // ============================================================
  // MENU BUTTON
  // ============================================================

  Widget _buildMenuButton(BuildContext context, {required bool isSmallScreen}) {
    final buttonSize = isSmallScreen ? 40.0 : 44.0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showActionsMenu(context),
        borderRadius: BorderRadius.circular(13),
        child: Ink(
          width: buttonSize,
          height: buttonSize,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: AppColors.divider.withValues(alpha: 0.8)),
          ),
          child: Icon(
            Icons.more_vert_rounded,
            color: AppColors.textSecondary,
            size: isSmallScreen ? 21 : 23,
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// PRODUCT ACTION
// ============================================================================

enum _ProductAction { addProduct, exportCsv }
