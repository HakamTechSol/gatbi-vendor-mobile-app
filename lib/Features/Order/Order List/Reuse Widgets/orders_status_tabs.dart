import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../Models/order_model.dart';

class OrdersStatusTabs extends StatelessWidget {
  const OrdersStatusTabs({
    super.key,
    required this.selectedStatus,
    required this.onStatusChanged,
  });

  final OrderStatus? selectedStatus;
  final ValueChanged<OrderStatus?> onStatusChanged;

  static const List<_OrderStatusTab> _tabs = [
    _OrderStatusTab(label: 'All', status: null),
    _OrderStatusTab(label: 'Pending', status: OrderStatus.pending),
    _OrderStatusTab(label: 'Processing', status: OrderStatus.processing),
    _OrderStatusTab(label: 'Shipped', status: OrderStatus.shipped),
    _OrderStatusTab(label: 'Delivered', status: OrderStatus.delivered),
    _OrderStatusTab(label: 'Cancelled', status: OrderStatus.cancelled),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _tabs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final tab = _tabs[index];

          final isSelected = selectedStatus == tab.status;

          return _StatusTab(
            label: tab.label,
            isSelected: isSelected,
            onTap: () => onStatusChanged(tab.status),
          );
        },
      ),
    );
  }
}

class _OrderStatusTab {
  const _OrderStatusTab({required this.label, required this.status});

  final String label;
  final OrderStatus? status;
}

class _StatusTab extends StatelessWidget {
  const _StatusTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primaryShadow,
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style:
                (isSelected
                        ? AppTextStyles.tabSelected
                        : AppTextStyles.tabUnselected)
                    .copyWith(
                      color: isSelected
                          ? AppColors.textOnPrimary
                          : AppColors.textSecondary,
                    ),
          ),
        ),
      ),
    );
  }
}
