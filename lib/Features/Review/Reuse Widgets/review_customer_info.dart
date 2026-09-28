import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class ReviewCustomerInfo extends StatelessWidget {
  const ReviewCustomerInfo({
    super.key,
    required this.customerName,
    this.customerAvatar,
    this.createdAt,
  });

  // ===========================================================================
  // Fields
  // ===========================================================================

  final String? customerName;
  final String? customerAvatar;
  final String? createdAt;

  // ===========================================================================
  // Build
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    final name = customerName?.trim().isNotEmpty == true
        ? customerName!.trim()
        : 'Customer';

    final avatar = customerAvatar?.trim() ?? '';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ---------------------------------------------------------------------
        // Avatar
        // ---------------------------------------------------------------------
        _buildAvatar(name: name, avatarUrl: avatar),

        const SizedBox(width: 11),

        // ---------------------------------------------------------------------
        // Customer Details
        // ---------------------------------------------------------------------
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),

              if (_hasCreatedAt) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.schedule_outlined,
                      size: 13,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        _formatDate(createdAt!),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),

        // ---------------------------------------------------------------------
        // Customer Label
        // ---------------------------------------------------------------------
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.surfaceSoft,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: Text(
            'Customer',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // Avatar
  // ===========================================================================

  Widget _buildAvatar({required String name, required String avatarUrl}) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.primaryGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryShadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(2),
      child: ClipOval(
        child: avatarUrl.isEmpty
            ? _buildInitials(name)
            : Image.network(
                avatarUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return _buildInitials(name);
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }

                  return _buildInitials(name);
                },
              ),
      ),
    );
  }

  // ===========================================================================
  // Initials
  // ===========================================================================

  Widget _buildInitials(String name) {
    final initials = _getInitials(name);

    return Container(
      color: AppColors.primaryLight,
      alignment: Alignment.center,
      child: Text(
        initials,
        style: AppTextStyles.titleSmall.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  // ===========================================================================
  // Helpers
  // ===========================================================================

  bool get _hasCreatedAt {
    return createdAt != null && createdAt!.trim().isNotEmpty;
  }

  String _getInitials(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((item) => item.isNotEmpty)
        .toList();

    if (parts.isEmpty) {
      return 'C';
    }

    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }

    return '${parts.first.substring(0, 1)}'
            '${parts.last.substring(0, 1)}'
        .toUpperCase();
  }

  String _formatDate(String value) {
    try {
      final normalized = value.trim();

      if (normalized.isEmpty) {
        return value;
      }

      final parsed = DateTime.tryParse(normalized.replaceFirst(' ', 'T'));

      if (parsed == null) {
        return value;
      }

      final day = parsed.day.toString().padLeft(2, '0');
      final month = parsed.month.toString().padLeft(2, '0');
      final year = parsed.year.toString();

      final hour = parsed.hour.toString().padLeft(2, '0');
      final minute = parsed.minute.toString().padLeft(2, '0');

      return '$day/$month/$year • $hour:$minute';
    } catch (_) {
      return value;
    }
  }
}
