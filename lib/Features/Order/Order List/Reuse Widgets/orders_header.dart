import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class OrdersHeader extends StatelessWidget {
  const OrdersHeader({
    super.key,
    this.onBack,
    this.onRefresh,
    this.showBackButton = false,
  });

  final VoidCallback? onBack;
  final VoidCallback? onRefresh;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
          _HeaderIconButton(
            icon: Icons.arrow_back_rounded,
            onTap: onBack ?? () => Navigator.of(context).maybePop(),
          ),

          const SizedBox(width: 12),
        

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Orders', style: AppTextStyles.headlineSmall),

              const SizedBox(height: 3),

              Text(
                'Manage and track your customer orders',
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
        ),

        if (onRefresh != null)
          _HeaderIconButton(icon: Icons.refresh_rounded, onTap: onRefresh),
      ],
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: Icon(icon, size: 21, color: AppColors.iconPrimary),
        ),
      ),
    );
  }
}
