import 'package:flutter/material.dart';

import '../../../Theme/app_colors.dart';
import '../../../Theme/app_text_styles.dart';

class MyProductStockInfo extends StatelessWidget {
  const MyProductStockInfo({
    super.key,
    required this.stockQuantity,
    this.lowStockThreshold = 5,
  });

  final int stockQuantity;
  final int lowStockThreshold;

  bool get _isOutOfStock => stockQuantity <= 0;

  bool get _isLowStock =>
      stockQuantity > 0 && stockQuantity <= lowStockThreshold;

  Color get _color {
    if (_isOutOfStock) {
      return AppColors.errorDark;
    }

    if (_isLowStock) {
      return Colors.orange.shade800;
    }

    return AppColors.primary;
  }

  Color get _backgroundColor {
    if (_isOutOfStock) {
      return AppColors.errorDark.withValues(alpha: 0.08);
    }

    if (_isLowStock) {
      return Colors.orange.withValues(alpha: 0.10);
    }

    return AppColors.primaryLight;
  }

  IconData get _icon {
    if (_isOutOfStock) {
      return Icons.remove_shopping_cart_outlined;
    }

    if (_isLowStock) {
      return Icons.warning_amber_rounded;
    }

    return Icons.inventory_2_outlined;
  }

  String get _label {
    if (_isOutOfStock) {
      return 'Out of stock';
    }

    if (_isLowStock) {
      return 'Low stock';
    }

    return 'In stock';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: _backgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(_icon, size: 14, color: _color),
        ),

        const SizedBox(width: 7),

        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$stockQuantity',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.navy,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 1),

              Text(
                _label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: _color,
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
