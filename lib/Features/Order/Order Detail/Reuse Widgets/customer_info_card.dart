import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../Models/order_detail_model.dart';

class CustomerInfoCard extends StatelessWidget {
  const CustomerInfoCard({super.key, required this.order});

  final OrderDetailModel order;

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      icon: Icons.person_outline_rounded,
      title: 'Customer Information',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _Avatar(
                name: order.customer.name,
                imageUrl: order.customer.avatarUrl,
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  order.customer.name,
                  style: AppTextStyles.productName.copyWith(
                    color: AppColors.navy,
                  ),
                ),
              ),
            ],
          ),

          if (_hasValue(order.customer.email)) ...[
            const SizedBox(height: 16),
            _InfoRow(icon: Icons.email_outlined, value: order.customer.email!),
          ],

          if (_hasValue(order.customer.phone)) ...[
            const SizedBox(height: 11),
            _InfoRow(icon: Icons.phone_outlined, value: order.customer.phone!),
          ],
        ],
      ),
    );
  }

  bool _hasValue(String? value) {
    return value != null && value.trim().isNotEmpty;
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.child,
  });

  final IconData icon;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowStrong.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.iconPrimary),
              const SizedBox(width: 9),
              Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.name, this.imageUrl});

  final String name;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.trim().isNotEmpty;

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.borderPrimary),
      ),
      clipBehavior: Clip.antiAlias,
      child: hasImage
          ? Image.network(
              imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return _Initials(name: name);
              },
            )
          : _Initials(name: name),
    );
  }
}

class _Initials extends StatelessWidget {
  const _Initials({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final initials = name
        .trim()
        .split(' ')
        .where((value) => value.isNotEmpty)
        .take(2)
        .map((value) => value[0].toUpperCase())
        .join();

    return Center(
      child: Text(
        initials.isEmpty ? '?' : initials,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.iconSecondary),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
