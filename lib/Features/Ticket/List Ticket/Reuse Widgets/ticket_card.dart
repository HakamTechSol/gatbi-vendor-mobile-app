import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../Models/ticket_list_item_model.dart';
import 'ticket_category_badge.dart';
import 'ticket_number_badge.dart';
import 'ticket_priority_badge.dart';
import 'ticket_status_badge.dart';

class TicketCard extends StatelessWidget {
  const TicketCard({
    super.key,
    required this.ticket,
    this.onTap,
  });

  final TicketListItemModel ticket;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final accentColor = _accentColor();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          splashColor: AppColors.primary.withOpacity(0.04),
          highlightColor: AppColors.primary.withOpacity(0.02),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppColors.border.withOpacity(0.8),
                width: 1,
              ),
            ),
            child: Stack(
              children: [
                // =============================================================
                // LEFT STATUS ACCENT
                // =============================================================

                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 4,
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(18),
                        bottomLeft: Radius.circular(18),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    18,
                    16,
                    16,
                    15,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),

                      const SizedBox(height: 15),

                      _buildSubject(),

                      const SizedBox(height: 12),

                      _buildBadges(),

                      const SizedBox(height: 16),

                      _buildDivider(),

                      const SizedBox(height: 12),

                      _buildBottomRow(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // HEADER
  // ===========================================================================

  Widget _buildHeader() {
    final ticketNumber =
        _safeText(ticket.ticketNumber, fallback: 'Ticket');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: TicketNumberBadge(
            ticketNumber: ticketNumber,
          ),
        ),

        const SizedBox(width: 10),

        TicketStatusBadge(
          status: _safeText(
            ticket.status,
            fallback: 'Unknown',
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // SUBJECT
  // ===========================================================================

  Widget _buildSubject() {
    final subject = _safeText(
      ticket.subject,
      fallback: 'Untitled Ticket',
    );

    return Text(
      subject,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyles.titleMedium.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w700,
        height: 1.3,
        letterSpacing: -0.2,
      ),
    );
  }

  // ===========================================================================
  // BADGES
  // ===========================================================================

  Widget _buildBadges() {
    final category = _safeText(
      ticket.category,
      fallback: 'General',
    );

    final priority = _safeText(
      ticket.priority,
      fallback: 'Normal',
    );

    return Row(
      children: [
        Flexible(
          child: TicketCategoryBadge(
            category: category,
          ),
        ),

        const SizedBox(width: 8),

        TicketPriorityBadge(
          priority: priority,
        ),
      ],
    );
  }

  // ===========================================================================
  // DIVIDER
  // ===========================================================================

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: AppColors.border.withOpacity(0.65),
    );
  }

  // ===========================================================================
  // BOTTOM ROW
  // ===========================================================================

  Widget _buildBottomRow() {
    final createdDate = _formatDate(
      ticket.createdAt,
    );

    final updatedDate = _formatDate(
      ticket.updatedAt,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ---------------------------------------------------------------------
        // DATE ICON
        // ---------------------------------------------------------------------

        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: AppColors.surfaceMuted.withOpacity(0.55),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(
            Icons.calendar_today_outlined,
            size: 14,
            color: AppColors.textSecondary,
          ),
        ),

        const SizedBox(width: 9),

        // ---------------------------------------------------------------------
        // DATE INFORMATION
        // ---------------------------------------------------------------------

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Created',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textTertiary,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                createdDate,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        // ---------------------------------------------------------------------
        // UPDATED INFORMATION
        // ---------------------------------------------------------------------

        if (updatedDate != 'N/A') ...[
          const SizedBox(width: 10),

          Container(
            width: 1,
            height: 28,
            color: AppColors.border.withOpacity(0.7),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Updated',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textTertiary,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  updatedDate,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(width: 10),

        // ---------------------------------------------------------------------
        // VIEW BUTTON
        // ---------------------------------------------------------------------

        _buildViewButton(),
      ],
    );
  }

  // ===========================================================================
  // VIEW BUTTON
  // ===========================================================================

  Widget _buildViewButton() {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted.withOpacity(0.45),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.border.withOpacity(0.55),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'View',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(width: 5),

          Icon(
            Icons.arrow_forward_rounded,
            size: 15,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // ACCENT COLOR
  // ===========================================================================

  Color _accentColor() {
    final status =
        _safeText(
          ticket.status,
          fallback: '',
        ).toLowerCase().trim();

    switch (status) {
      case 'open':
        return AppColors.primary;

      case 'pending':
        return const Color(0xFFF59E0B);

      case 'closed':
        return const Color(0xFF10B981);

      case 'resolved':
        return const Color(0xFF10B981);

      case 'cancelled':
      case 'canceled':
        return const Color(0xFFEF4444);

      default:
        return AppColors.primary;
    }
  }

  // ===========================================================================
  // SAFE STRING
  // ===========================================================================

  String _safeText(
    String? value, {
    required String fallback,
  }) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return fallback;
    }

    return text;
  }

  // ===========================================================================
  // DATE FORMAT
  // ===========================================================================

  String _formatDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'N/A';
    }

    final rawValue = value.trim();

    DateTime? parsedDate = DateTime.tryParse(
      rawValue,
    );

    // API format:
    // 2026-09-22 14:31:44
    //
    // Dart's DateTime.tryParse normally handles this format,
    // but the fallback below also handles the space explicitly.

    if (parsedDate == null) {
      parsedDate = DateTime.tryParse(
        rawValue.replaceFirst(' ', 'T'),
      );
    }

    if (parsedDate == null) {
      return rawValue;
    }

    final day =
        parsedDate.day.toString().padLeft(2, '0');

    final month =
        parsedDate.month.toString().padLeft(2, '0');

    final year =
        parsedDate.year.toString();

    final hour =
        parsedDate.hour.toString().padLeft(2, '0');

    final minute =
        parsedDate.minute.toString().padLeft(2, '0');

    return '$day/$month/$year • $hour:$minute';
  }
}