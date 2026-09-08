import 'package:flutter/material.dart';

import '../../../Theme/app_colors.dart';
import '../../../Theme/app_text_styles.dart';

class MyProductStatusBadge extends StatelessWidget {
  const MyProductStatusBadge({super.key, required this.status});

  final String status;

  bool get _isActive => status.toLowerCase() == 'active';

  bool get _isPending => status.toLowerCase() == 'pending';

  bool get _isDraft => status.toLowerCase() == 'draft';

  Color get _backgroundColor {
    if (_isActive) {
      return AppColors.primaryLight;
    }

    if (_isPending) {
      return Colors.orange.withValues(alpha: 0.10);
    }

    if (_isDraft) {
      return Colors.grey.withValues(alpha: 0.10);
    }

    return AppColors.errorDark.withValues(alpha: 0.08);
  }

  Color get _foregroundColor {
    if (_isActive) {
      return AppColors.primary;
    }

    if (_isPending) {
      return Colors.orange.shade800;
    }

    if (_isDraft) {
      return AppColors.textSecondary;
    }

    return AppColors.errorDark;
  }

  IconData get _icon {
    if (_isActive) {
      return Icons.check_circle_outline_rounded;
    }

    if (_isPending) {
      return Icons.access_time_rounded;
    }

    if (_isDraft) {
      return Icons.edit_note_rounded;
    }

    return Icons.block_rounded;
  }

  String get _label {
    if (status.trim().isEmpty) {
      return 'Unknown';
    }

    return status
        .trim()
        .split(' ')
        .map(
          (word) => word.isEmpty
              ? word
              : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}',
        )
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: 12, color: _foregroundColor),

          const SizedBox(width: 4),

          Text(
            _label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: _foregroundColor,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
