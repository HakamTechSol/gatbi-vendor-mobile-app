import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../Model/bulk_import_model.dart';

class BulkImportProgressCard extends StatelessWidget {
  const BulkImportProgressCard({
    super.key,
    required this.importData,
    this.onViewErrors,
    this.onDone,
  });

  final BulkImportModel importData;
  final VoidCallback? onViewErrors;
  final VoidCallback? onDone;

  bool get _isImporting => importData.status == BulkImportStatus.importing;

  bool get _isCompleted => importData.status == BulkImportStatus.completed;

  bool get _isFailed => importData.status == BulkImportStatus.failed;

  @override
  Widget build(BuildContext context) {
    if (importData.status == BulkImportStatus.idle ||
        importData.status == BulkImportStatus.ready) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _isFailed
              ? AppColors.error.withValues(alpha: 0.25)
              : _isCompleted
              ? AppColors.success.withValues(alpha: 0.25)
              : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 15),
          if (_isImporting) _buildProgress(),
          if (_isCompleted) _buildCompletedContent(),
          if (_isFailed) _buildFailedContent(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final String title;
    final IconData icon;
    final Color iconColor;
    final Color iconBackground;

    if (_isCompleted) {
      title = 'Import Completed';
      icon = Icons.check_circle_outline_rounded;
      iconColor = AppColors.success;
      iconBackground = AppColors.successLight;
    } else if (_isFailed) {
      title = 'Import Failed';
      icon = Icons.error_outline_rounded;
      iconColor = AppColors.error;
      iconBackground = AppColors.errorLight;
    } else {
      title = 'Importing Products';
      icon = Icons.cloud_upload_outlined;
      iconColor = AppColors.primary;
      iconBackground = AppColors.primaryLight;
    }

    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: iconBackground,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, size: 22, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.titleSmall),
              const SizedBox(height: 3),
              Text(_subtitle, style: AppTextStyles.caption),
            ],
          ),
        ),
        if (_isImporting)
          Text(
            '${importData.progressPercentage}%',
            style: AppTextStyles.titleSmall.copyWith(color: AppColors.primary),
          ),
      ],
    );
  }

  String get _subtitle {
    if (_isCompleted) {
      return 'Your product import has finished.';
    }

    if (_isFailed) {
      return 'Some products could not be imported.';
    }

    return 'Please keep this screen open while importing.';
  }

  Widget _buildProgress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: importData.progress,
            minHeight: 8,
            backgroundColor: AppColors.surfaceMuted,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Text(
                '${importData.processedRows} of '
                '${importData.totalRows} products processed',
                style: AppTextStyles.captionMedium,
              ),
            ),
            if (importData.failedCount > 0)
              Text(
                '${importData.failedCount} failed',
                style: AppTextStyles.captionMedium.copyWith(
                  color: AppColors.error,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildCompletedContent() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _ResultItem(
                label: 'Imported',
                value: '${importData.successCount}',
                color: AppColors.success,
                icon: Icons.check_circle_outline_rounded,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _ResultItem(
                label: 'Failed',
                value: '${importData.failedCount}',
                color: importData.failedCount > 0
                    ? AppColors.error
                    : AppColors.textMuted,
                icon: Icons.error_outline_rounded,
              ),
            ),
          ],
        ),
        if (importData.failedCount > 0 && onViewErrors != null) ...[
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: onViewErrors,
              icon: const Icon(Icons.visibility_outlined, size: 18),
              label: const Text('View Failed Rows'),
            ),
          ),
        ],
        if (onDone != null) ...[
          const SizedBox(height: 4),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(onPressed: onDone, child: const Text('Done')),
          ),
        ],
      ],
    );
  }

  Widget _buildFailedContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (importData.hasError)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: AppColors.errorLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              importData.errorMessage!,
              style: AppTextStyles.captionMedium.copyWith(
                color: AppColors.errorDark,
              ),
            ),
          ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _ResultItem(
                label: 'Processed',
                value: '${importData.processedRows}',
                color: AppColors.primary,
                icon: Icons.sync_rounded,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _ResultItem(
                label: 'Failed',
                value: '${importData.failedCount}',
                color: AppColors.error,
                icon: Icons.error_outline_rounded,
              ),
            ),
          ],
        ),
        if (onViewErrors != null) ...[
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: onViewErrors,
              icon: const Icon(Icons.visibility_outlined, size: 18),
              label: const Text('View Failed Rows'),
            ),
          ),
        ],
      ],
    );
  }
}

class _ResultItem extends StatelessWidget {
  const _ResultItem({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  final String label;
  final String value;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, size: 19, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.caption),
                const SizedBox(height: 1),
                Text(
                  value,
                  style: AppTextStyles.titleSmall.copyWith(color: color),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
