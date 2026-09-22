import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../Models/vendor_kyc_detail_model.dart';

class KycDetailsCard extends StatelessWidget {
  const KycDetailsCard({super.key, required this.detail});

  final VendorKycDetailModel? detail;

  @override
  Widget build(BuildContext context) {
    if (detail == null) {
      return _buildUnavailable();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),

          const SizedBox(height: 18),

          _buildGrid([
            _KycDetailItem(label: 'Owner Name', value: detail!.ownerName),
            _KycDetailItem(label: 'Owner Email', value: detail!.ownerEmail),
            _KycDetailItem(label: 'Owner Phone', value: detail!.ownerPhone),
            _KycDetailItem(
              label: 'Designation',
              value: detail!.authorizedPersonDesignation,
            ),
            _KycDetailItem(
              label: 'Trade License',
              value: detail!.tradeLicenseNumber,
            ),
            _KycDetailItem(
              label: 'License Expiry',
              value: detail!.tradeLicenseExpiry,
            ),
            _KycDetailItem(
              label: 'Tax Registration Number',
              value: detail!.taxRegistrationNumber,
            ),
            _KycDetailItem(label: 'Website', value: detail!.website),
            _KycDetailItem(
              label: 'Business Address',
              value: detail!.businessAddress,
              fullWidth: true,
            ),
            _KycDetailItem(
              label: 'Notes',
              value: detail!.notes,
              fullWidth: true,
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(11),
          ),
          child: const Icon(
            Icons.business_center_outlined,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Submitted Information', style: AppTextStyles.titleMedium),
              const SizedBox(height: 3),
              Text(
                'Information submitted for KYC verification',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGrid(List<_KycDetailItem> items) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 600;

        final children = <Widget>[];

        for (final item in items) {
          if (!wide || item.fullWidth) {
            children.add(
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _buildItem(item),
              ),
            );
            continue;
          }

          children.add(
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _buildItem(item),
              ),
            ),
          );
        }

        if (!wide) {
          return Column(children: children);
        }

        final rows = <Widget>[];

        for (int i = 0; i < children.length; i++) {
          if (items[i].fullWidth) {
            rows.add(children[i]);
            continue;
          }

          if (i + 1 < children.length && !items[i + 1].fullWidth) {
            rows.add(
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  children[i],
                  const SizedBox(width: 14),
                  children[i + 1],
                ],
              ),
            );
            i++;
          } else {
            rows.add(children[i]);
          }
        }

        return Column(children: rows);
      },
    );
  }

  Widget _buildItem(_KycDetailItem item) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 5),
          Text(_displayValue(item.value), style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildUnavailable() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        'Detailed KYC information is not available.',
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  String _displayValue(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Not provided';
    }

    return value.trim();
  }
}

class _KycDetailItem {
  const _KycDetailItem({
    required this.label,
    required this.value,
    this.fullWidth = false,
  });

  final String label;
  final String? value;
  final bool fullWidth;
}
