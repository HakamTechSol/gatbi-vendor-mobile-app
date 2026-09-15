import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

enum KycStatus {
  pending,
  approved,
  rejected,
  notSubmitted,
}

class KycStatusBadge extends StatelessWidget {
  const KycStatusBadge({
    super.key,
    required this.status,
  });

  final KycStatus status;

  String get _label {
    switch (status) {
      case KycStatus.pending:
        return 'STATUS: PENDING';

      case KycStatus.approved:
        return 'STATUS: APPROVED';

      case KycStatus.rejected:
        return 'STATUS: REJECTED';

      case KycStatus.notSubmitted:
        return 'STATUS: NOT SUBMITTED';
    }
  }

  Color get _backgroundColor {
    switch (status) {
      case KycStatus.pending:
        return AppColors.pendingLight;

      case KycStatus.approved:
        return AppColors.successLight;

      case KycStatus.rejected:
        return AppColors.errorLight;

      case KycStatus.notSubmitted:
        return AppColors.draftLight;
    }
  }

  Color get _textColor {
    switch (status) {
      case KycStatus.pending:
        return AppColors.warningDark;

      case KycStatus.approved:
        return AppColors.successDark;

      case KycStatus.rejected:
        return AppColors.errorDark;

      case KycStatus.notSubmitted:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        _label,
        style: AppTextStyles.statusBadgeLarge.copyWith(
          color: _textColor,
        ),
      ),
    );
  }
}