import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../../Order List/Models/order_model.dart';
import '../../Order List/Reuse Widgets/order_status_badge.dart';
import '../Models/order_detail_model.dart';

class OrderDetailHeader extends StatelessWidget {
  const OrderDetailHeader({
    super.key,
    required this.order,
    required this.status,
    this.onBack,
    this.onRefresh,
  });

  final OrderStatus status;
  final OrderDetailModel order;
  final VoidCallback? onBack;
  final VoidCallback? onRefresh;

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
              Text(order.orderNumber, style: AppTextStyles.headlineSmall),

              const SizedBox(height: 3),

              Text('Order details', style: AppTextStyles.bodySmall),
            ],
          ),
        ),


        OrderStatusBadge(status: status),
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
