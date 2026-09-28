import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';

class CampaignDetailHelpers {
  CampaignDetailHelpers._();

  // ============================================================
  // Campaign Type
  // ============================================================

  static String formatCampaignType(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Campaign';
    }

    return _formatWords(value);
  }

  // ============================================================
  // Status
  // ============================================================

  static String formatStatus(String? status, {String? statusLabel}) {
    if (statusLabel != null && statusLabel.trim().isNotEmpty) {
      return statusLabel.trim();
    }

    if (status == null || status.trim().isEmpty) {
      return 'Unknown';
    }

    return _formatWords(status);
  }

  // ============================================================
  // Discount
  // ============================================================

  static String formatPercentage(double? value) {
    if (value == null) {
      return '—';
    }

    if (value == value.roundToDouble()) {
      return '${value.toInt()}%';
    }

    return '${value.toStringAsFixed(1)}%';
  }

  // ============================================================
  // Date
  // ============================================================

  static String formatDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '—';
    }

    final dateValue = value.trim();

    final parts = dateValue.split('-');

    if (parts.length != 3) {
      return dateValue;
    }

    final year = parts[0];
    final month = int.tryParse(parts[1]);
    final day = int.tryParse(parts[2]);

    if (month == null || day == null) {
      return dateValue;
    }

    const months = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    if (month < 1 || month > 12) {
      return dateValue;
    }

    return '${months[month - 1]} $day, $year';
  }

  // ============================================================
  // Date Time
  // ============================================================

  static String formatDateTime(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '—';
    }

    final dateTimeValue = value.trim();

    final parts = dateTimeValue.split(' ');

    if (parts.length < 2) {
      return formatDate(dateTimeValue);
    }

    final date = parts[0];
    final time = parts.sublist(1).join(' ');

    final formattedDate = formatDate(date);

    if (formattedDate == '—') {
      return dateTimeValue;
    }

    return '$formattedDate • $time';
  }

  // ============================================================
  // Product IDs
  // ============================================================

  static List<String> parseProductIds(String? value) {
    if (value == null || value.trim().isEmpty) {
      return <String>[];
    }

    return value
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  // ============================================================
  // Notes
  // ============================================================

  static bool hasText(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  static String noteOrEmpty(
    String? value, {
    String emptyText = 'No notes available.',
  }) {
    if (!hasText(value)) {
      return emptyText;
    }

    return value!.trim();
  }

  // ============================================================
  // Status Colors
  // ============================================================

  static Color statusForegroundColor(String? status) {
    switch (status?.trim().toLowerCase()) {
      case 'active':
      case 'completed':
        return AppColors.success;

      case 'scheduled':
      case 'processing':
        return AppColors.info;

      case 'pending':
        return AppColors.warning;

      case 'cancelled':
      case 'rejected':
        return AppColors.error;

      case 'draft':
        return AppColors.textSecondary;

      default:
        return AppColors.textSecondary;
    }
  }

  static Color statusBackgroundColor(String? status) {
    switch (status?.trim().toLowerCase()) {
      case 'active':
      case 'completed':
        return AppColors.successLight;

      case 'scheduled':
      case 'processing':
        return AppColors.infoLight;

      case 'pending':
        return AppColors.warningLight;

      case 'cancelled':
      case 'rejected':
        return AppColors.errorLight;

      case 'draft':
        return AppColors.surfaceMuted;

      default:
        return AppColors.surfaceMuted;
    }
  }

  // ============================================================
  // Private
  // ============================================================

  static String _formatWords(String value) {
    return value
        .trim()
        .split(RegExp(r'[_\-\s]+'))
        .where((word) => word.isNotEmpty)
        .map(
          (word) =>
              '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}',
        )
        .join(' ');
  }
}
