import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../Models/get_business_change_model.dart';

class BusinessChangeRequestsCard extends StatefulWidget {
  const BusinessChangeRequestsCard({
    super.key,
    required this.requests,
    this.onDelete,
  });

  final List<BusinessChangeRequestModel> requests;
  final ValueChanged<BusinessChangeRequestModel>? onDelete;

  @override
  State<BusinessChangeRequestsCard> createState() =>
      _BusinessChangeRequestsCardState();
}

class _BusinessChangeRequestsCardState
    extends State<BusinessChangeRequestsCard> {
  // ============================================================
  // CONFIG
  // ============================================================

  static const int _itemsPerPage = 5;

  int _visibleCount = _itemsPerPage;

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    // ============================================================
    // HIDE CARD WHEN THERE ARE NO REQUESTS
    // ============================================================

    if (widget.requests.isEmpty) {
      return const SizedBox.shrink();
    }

    final int actualVisibleCount = _visibleCount > widget.requests.length
        ? widget.requests.length
        : _visibleCount;

    final visibleRequests = widget.requests.take(actualVisibleCount).toList();

    final bool hasMore = actualVisibleCount < widget.requests.length;
    final bool canShowLess = actualVisibleCount > _itemsPerPage;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ========================================================
          // HEADER
          // ========================================================
          _buildHeader(),

          const SizedBox(height: 16),

          // ========================================================
          // REQUEST LIST
          // ========================================================
          ...List.generate(visibleRequests.length, (index) {
            final request = visibleRequests[index];

            return Padding(
              padding: EdgeInsets.only(
                bottom: index == visibleRequests.length - 1 ? 0 : 8,
              ),
              child: _BusinessChangeRequestItem(
                request: request,
                onDelete: widget.onDelete,
              ),
            );
          }),

          // ========================================================
          // SHOW MORE / SHOW LESS
          // ========================================================
          if (hasMore || canShowLess) ...[
            const SizedBox(height: 14),
            _buildExpandButton(hasMore: hasMore, canShowLess: canShowLess),
          ],
        ],
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(11),
          ),
          child: const Icon(
            Icons.change_circle_outlined,
            color: AppColors.primary,
            size: 22,
          ),
        ),

        const SizedBox(width: 11),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Change Requests', style: AppTextStyles.titleLarge),
              const SizedBox(height: 2),
              Text(
                '${widget.requests.length} request'
                '${widget.requests.length == 1 ? '' : 's'} submitted',
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
        ),

        // ========================================================
        // TOTAL COUNT
        // ========================================================
        Container(
          constraints: const BoxConstraints(minWidth: 34),
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 9),
          decoration: BoxDecoration(
            color: AppColors.primarySurface,
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: AppColors.borderPrimary),
          ),
          child: Center(
            child: Text(
              widget.requests.length.toString(),
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // SHOW MORE / SHOW LESS
  // ============================================================

  Widget _buildExpandButton({
    required bool hasMore,
    required bool canShowLess,
  }) {
    if (hasMore) {
      final remaining = widget.requests.length - _visibleCount;

      final int nextCount = remaining > _itemsPerPage
          ? _itemsPerPage
          : remaining;

      return InkWell(
        onTap: () {
          setState(() {
            _visibleCount += _itemsPerPage;

            if (_visibleCount > widget.requests.length) {
              _visibleCount = widget.requests.length;
            }
          });
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 14),
          decoration: BoxDecoration(
            color: AppColors.primarySurface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.borderPrimary),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.expand_more_rounded,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 6),
              Text(
                'Show More',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                '($nextCount)',
                style: AppTextStyles.captionMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (canShowLess) {
      return InkWell(
        onTap: () {
          setState(() {
            _visibleCount -= _itemsPerPage;

            if (_visibleCount < _itemsPerPage) {
              _visibleCount = _itemsPerPage;
            }
          });
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 14),
          decoration: BoxDecoration(
            color: AppColors.surfaceSoft,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.expand_less_rounded,
                color: AppColors.textSecondary,
                size: 20,
              ),
              const SizedBox(width: 6),
              Text(
                'Show Less',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

// ==================================================================
// REQUEST ITEM
// ==================================================================

class _BusinessChangeRequestItem extends StatelessWidget {
  const _BusinessChangeRequestItem({required this.request, this.onDelete});

  final BusinessChangeRequestModel request;
  final ValueChanged<BusinessChangeRequestModel>? onDelete;

  @override
  Widget build(BuildContext context) {
    final status = _statusData(request.status);

    // ============================================================
    // CANCELLED REQUEST CHECK
    // ============================================================

    final bool isCancelled =
        request.status?.trim().toLowerCase() == 'cancelled';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ========================================================
          // MAIN CONTENT
          // ========================================================
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --------------------------------------------------
                // FIELD
                // --------------------------------------------------
                Text(
                  request.fieldLabel?.trim().isNotEmpty == true
                      ? request.fieldLabel!
                      : _formatFieldName(request.fieldName),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.titleSmall,
                ),

                const SizedBox(height: 7),

                // --------------------------------------------------
                // CURRENT → REQUESTED
                // --------------------------------------------------
                Row(
                  children: [
                    Expanded(
                      child: _CompactValue(
                        value: _displayValue(request.currentValue),
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 7),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        color: AppColors.textTertiary,
                        size: 16,
                      ),
                    ),

                    Expanded(
                      child: _CompactValue(
                        value: _displayValue(request.requestedValue),
                        highlighted: true,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 7),

                // --------------------------------------------------
                // DATE + DOCUMENT
                // --------------------------------------------------
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      color: AppColors.textTertiary,
                      size: 13,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        _formatDate(request.createdAt),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption,
                      ),
                    ),

                    if (request.hasDocument) ...[
                      const SizedBox(width: 7),
                      const Icon(
                        Icons.attach_file_rounded,
                        color: AppColors.info,
                        size: 14,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        'Document',
                        style: AppTextStyles.captionMedium.copyWith(
                          color: AppColors.infoDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // ========================================================
          // STATUS + DELETE
          // ========================================================
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _StatusBadge(
                label: _formatStatus(request.status),
                backgroundColor: status.backgroundColor,
                foregroundColor: status.foregroundColor,
                icon: status.icon,
              ),

              // ====================================================
              // HIDE DELETE BUTTON FOR CANCELLED REQUEST
              // ====================================================
              if (!isCancelled) ...[
                const SizedBox(height: 8),

                _DeleteButton(
                  onTap: onDelete == null
                      ? null
                      : () {
                          _showDeleteConfirmation(context, request);
                        },
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STATUS DATA
  // ============================================================

  _StatusData _statusData(String? status) {
    switch (status?.toLowerCase().trim()) {
      case 'approved':
        return const _StatusData(
          backgroundColor: AppColors.successLight,
          foregroundColor: AppColors.successDark,
          icon: Icons.check_circle_outline_rounded,
        );

      case 'rejected':
        return const _StatusData(
          backgroundColor: AppColors.errorLight,
          foregroundColor: AppColors.errorDark,
          icon: Icons.cancel_outlined,
        );

      case 'cancelled':
        return const _StatusData(
          backgroundColor: AppColors.surfaceMuted,
          foregroundColor: AppColors.textSecondary,
          icon: Icons.block_outlined,
        );

      case 'pending':
      default:
        return const _StatusData(
          backgroundColor: AppColors.warningLight,
          foregroundColor: AppColors.warningDark,
          icon: Icons.access_time_rounded,
        );
    }
  }

  // ============================================================
  // FIELD NAME
  // ============================================================

  String _formatFieldName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Business Information';
    }

    return value
        .trim()
        .split('_')
        .map((word) {
          if (word.isEmpty) {
            return word;
          }

          return word[0].toUpperCase() + word.substring(1);
        })
        .join(' ');
  }

  // ============================================================
  // STATUS
  // ============================================================

  String _formatStatus(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Pending';
    }

    return value
        .trim()
        .split('_')
        .map((word) {
          if (word.isEmpty) {
            return word;
          }

          return word[0].toUpperCase() + word.substring(1);
        })
        .join(' ');
  }

  // ============================================================
  // VALUE
  // ============================================================

  String _displayValue(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Not available';
    }

    return value.trim();
  }

  // ============================================================
  // DATE
  // ============================================================

  String _formatDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Not available';
    }

    final parsed = DateTime.tryParse(value.replaceFirst(' ', 'T'));

    if (parsed == null) {
      return value;
    }

    final hour = parsed.hour;
    final minute = parsed.minute.toString().padLeft(2, '0');

    final period = hour >= 12 ? 'PM' : 'AM';

    final displayHour = hour % 12 == 0 ? 12 : hour % 12;

    return '${parsed.day.toString().padLeft(2, '0')}/'
        '${parsed.month.toString().padLeft(2, '0')}/'
        '${parsed.year} '
        '$displayHour:$minute $period';
  }

  // ============================================================
  // CANCEL CONFIRMATION
  // ============================================================

  void _showDeleteConfirmation(
    BuildContext context,
    BusinessChangeRequestModel request,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.errorLight,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.error,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  'Cancel Request?',
                  style: AppTextStyles.dialogTitle,
                ),
              ),
            ],
          ),

          content: Text(
            'Are you sure you want to cancel this change request? '
            'This action cannot be undone.',
            style: AppTextStyles.dialogDescription,
          ),

          actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                'Keep Request',
                style: AppTextStyles.buttonText.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),

            const SizedBox(width: 6),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(dialogContext).pop();

                onDelete?.call(request);
              },
              icon: const Icon(Icons.delete_outline_rounded, size: 18),
              label: const Text('Cancel Request'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: AppColors.textOnPrimary,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 11,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ==================================================================
// COMPACT VALUE
// ==================================================================

class _CompactValue extends StatelessWidget {
  const _CompactValue({required this.value, this.highlighted = false});

  final String value;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyles.captionMedium.copyWith(
        color: highlighted ? AppColors.primary : AppColors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

// ==================================================================
// DELETE / CANCEL BUTTON
// ==================================================================

class _DeleteButton extends StatelessWidget {
  const _DeleteButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Cancel request',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.errorLight,
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: AppColors.errorBorder),
          ),
          child: Icon(
            Icons.delete_outline_rounded,
            color: onTap == null ? AppColors.disabledText : AppColors.error,
            size: 19,
          ),
        ),
      ),
    );
  }
}

// ==================================================================
// STATUS BADGE
// ==================================================================

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.icon,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: foregroundColor),
          const SizedBox(width: 3),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ==================================================================
// STATUS MODEL
// ==================================================================

class _StatusData {
  const _StatusData({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.icon,
  });

  final Color backgroundColor;
  final Color foregroundColor;
  final IconData icon;
}
