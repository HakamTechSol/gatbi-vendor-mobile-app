import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class PayoutStatusBadge extends StatelessWidget {
  const PayoutStatusBadge({
    super.key,
    required this.status,
  });

  final String? status;

  String get _normalizedStatus {
    return status?.trim().toLowerCase() ?? '';
  }

  String get _label {
    switch (_normalizedStatus) {
      case 'pending':
        return 'Pending';

      case 'processing':
        return 'Processing';

      case 'paid':
        return 'Paid';

      case 'rejected':
        return 'Rejected';

      case 'cancelled':
      case 'canceled':
        return 'Cancelled';

      default:
        if (_normalizedStatus.isEmpty) {
          return 'Unknown';
        }

        return _normalizedStatus
            .replaceAll('_', ' ')
            .split(' ')
            .map(
              (word) => word.isEmpty
                  ? word
                  : '${word[0].toUpperCase()}${word.substring(1)}',
            )
            .join(' ');
    }
  }

  Color get _backgroundColor {
    switch (_normalizedStatus) {
      case 'pending':
        return AppColors.warningLight;

      case 'processing':
        return AppColors.infoLight;

      case 'paid':
        return AppColors.successLight;

      case 'rejected':
      case 'cancelled':
      case 'canceled':
        return AppColors.errorLight;

      default:
        return AppColors.surfaceMuted;
    }
  }

  Color get _foregroundColor {
    switch (_normalizedStatus) {
      case 'pending':
        return AppColors.warning;

      case 'processing':
        return AppColors.info;

      case 'paid':
        return AppColors.success;

      case 'rejected':
      case 'cancelled':
      case 'canceled':
        return AppColors.error;

      default:
        return AppColors.textSecondary;
    }
  }

  IconData get _icon {
    switch (_normalizedStatus) {
      case 'pending':
        return Icons.schedule_rounded;

      case 'processing':
        return Icons.sync_rounded;

      case 'paid':
        return Icons.check_circle_rounded;

      case 'rejected':
        return Icons.cancel_rounded;

      case 'cancelled':
      case 'canceled':
        return Icons.block_rounded;

      default:
        return Icons.info_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _icon,
            size: 14,
            color: _foregroundColor,
          ),
          const SizedBox(width: 5),
          Text(
            _label,
            style: AppTextStyles.statusBadge.copyWith(
              color: _foregroundColor,
            ),
          ),
        ],
      ),
    );
  }
}