import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class PayoutMethodBadge extends StatelessWidget {
  const PayoutMethodBadge({super.key, required this.method});

  final String? method;

  String get _normalizedMethod {
    return method?.trim().toLowerCase() ?? '';
  }

  String get _label {
    if (_normalizedMethod.isEmpty) {
      return 'Payment Method';
    }

    return _normalizedMethod
        .replaceAll('_', ' ')
        .replaceAll('-', ' ')
        .split(' ')
        .map(
          (word) => word.isEmpty
              ? word
              : '${word[0].toUpperCase()}${word.substring(1)}',
        )
        .join(' ');
  }

  IconData get _icon {
    switch (_normalizedMethod) {
      case 'bank':
      case 'bank transfer':
      case 'bank_transfer':
        return Icons.account_balance_rounded;

      case 'paypal':
        return Icons.account_balance_wallet_rounded;

      case 'stripe':
        return Icons.credit_card_rounded;

      case 'wallet':
      case 'digital wallet':
      case 'digital_wallet':
        return Icons.account_balance_wallet_outlined;

      case 'cash':
      case 'cash payment':
        return Icons.payments_rounded;

      default:
        return Icons.payment_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: AppColors.borderPrimary),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: 15, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(
            _label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.captionMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
