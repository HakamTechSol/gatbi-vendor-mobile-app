import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class PaymentProofCard extends StatelessWidget {
  const PaymentProofCard({super.key, this.paymentProofUrl, this.onView});

  final String? paymentProofUrl;
  final VoidCallback? onView;

  @override
  Widget build(BuildContext context) {
    final hasProof =
        paymentProofUrl != null && paymentProofUrl!.trim().isNotEmpty;

    return Container(
      width: double.infinity,
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
          const _Header(),

          const SizedBox(height: 16),

          if (!hasProof)
            _EmptyProof()
          else
            _ProofContent(imageUrl: paymentProofUrl!, onView: onView),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.image_outlined,
          size: 20,
          color: AppColors.iconPrimary,
        ),
        const SizedBox(width: 9),
        Text(
          'Payment Proof',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.navy,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _ProofContent extends StatelessWidget {
  const _ProofContent({required this.imageUrl, this.onView});

  final String imageUrl;
  final VoidCallback? onView;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onView,
          child: Container(
            width: double.infinity,
            height: 190,
            decoration: BoxDecoration(
              color: AppColors.inputBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return const _ImageError();
              },
            ),
          ),
        ),

        const SizedBox(height: 12),

        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onView,
            icon: const Icon(Icons.open_in_new_rounded, size: 17),
            label: const Text('View Payment Proof'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: BorderSide(color: AppColors.borderPrimary),
              minimumSize: const Size(double.infinity, 44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ImageError extends StatelessWidget {
  const _ImageError();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.broken_image_outlined,
            size: 32,
            color: AppColors.iconMuted,
          ),
          const SizedBox(height: 6),
          Text(
            'Unable to load payment proof',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyProof extends StatelessWidget {
  const _EmptyProof();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 26),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.image_not_supported_outlined,
            size: 30,
            color: AppColors.iconMuted,
          ),
          const SizedBox(height: 8),
          Text(
            'No payment proof uploaded',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
