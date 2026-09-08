import 'package:flutter/material.dart';

import '../../../Theme/app_colors.dart';
import '../../../Theme/app_text_styles.dart';

enum MyProductAction { edit, stock, view, delete }

class MyProductActionMenu extends StatelessWidget {
  const MyProductActionMenu({super.key, required this.onAction});

  final ValueChanged<MyProductAction> onAction;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MyProductAction>(
      tooltip: 'Product actions',
      padding: EdgeInsets.zero,
      icon: const Icon(
        Icons.more_vert_rounded,
        color: AppColors.textSecondary,
        size: 21,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 5,
      onSelected: onAction,
      itemBuilder: (context) {
        return [
          _buildMenuItem(
            value: MyProductAction.view,
            icon: Icons.visibility_outlined,
            label: 'View Product',
          ),

          _buildMenuItem(
            value: MyProductAction.edit,
            icon: Icons.edit_outlined,
            label: 'Edit Product',
          ),

          _buildMenuItem(
            value: MyProductAction.stock,
            icon: Icons.inventory_2_outlined,
            label: 'Update Stock',
          ),

          const PopupMenuDivider(),

          _buildMenuItem(
            value: MyProductAction.delete,
            icon: Icons.delete_outline_rounded,
            label: 'Delete Product',
            isDestructive: true,
          ),
        ];
      },
    );
  }

  PopupMenuItem<MyProductAction> _buildMenuItem({
    required MyProductAction value,
    required IconData icon,
    required String label,
    bool isDestructive = false,
  }) {
    final color = isDestructive ? AppColors.errorDark : AppColors.navy;

    return PopupMenuItem<MyProductAction>(
      value: value,
      height: 44,
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),

          const SizedBox(width: 11),

          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyMedium.copyWith(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
