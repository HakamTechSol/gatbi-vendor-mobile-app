import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../../Models/ticket_model.dart';

import 'ticket_category_badge.dart';
import 'ticket_number_badge.dart';
import 'ticket_priority_badge.dart';
import 'ticket_status_badge.dart';

class TicketCard extends StatelessWidget {
  const TicketCard({super.key, required this.ticket, this.onTap});

  final TicketModel ticket;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
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
                // Left accent line
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 4,
                    decoration: BoxDecoration(
                      color: _accentColor(),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(18),
                        bottomLeft: Radius.circular(18),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 16, 16, 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),

                      const SizedBox(height: 14),

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

  // ─────────────────────────────────────────────
  // HEADER
  // ─────────────────────────────────────────────

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TicketNumberBadge(ticketNumber: ticket.ticketNumber),

        const Spacer(),

        TicketStatusBadge(status: ticket.status),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // SUBJECT
  // ─────────────────────────────────────────────

  Widget _buildSubject() {
    return Text(
      ticket.subject.isEmpty ? 'Untitled Ticket' : ticket.subject,
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

  // ─────────────────────────────────────────────
  // BADGES
  // ─────────────────────────────────────────────

  Widget _buildBadges() {
    return Row(
      children: [
        Flexible(child: TicketCategoryBadge(category: ticket.category)),

        const SizedBox(width: 8),

        TicketPriorityBadge(priority: ticket.priority),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // DIVIDER
  // ─────────────────────────────────────────────

  Widget _buildDivider() {
    return Container(height: 1, color: AppColors.border.withOpacity(0.65));
  }

  // ─────────────────────────────────────────────
  // BOTTOM ROW
  // ─────────────────────────────────────────────

  Widget _buildBottomRow() {
    return Row(
      children: [
        // Date
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: AppColors.surfaceMuted.withOpacity(0.55),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.calendar_today_outlined,
            size: 13,
            color: AppColors.textSecondary,
          ),
        ),

        const SizedBox(width: 9),

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
              const SizedBox(height: 1),
              Text(
                _formatDate(ticket.createdAt),
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        // View ticket
        Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: AppColors.surfaceMuted.withOpacity(0.45),
            borderRadius: BorderRadius.circular(10),
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
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // ACCENT COLOR
  // ─────────────────────────────────────────────

  Color _accentColor() {
    final status = ticket.status.toString().toLowerCase();

    if (status.contains('open')) {
      return AppColors.primary;
    }

    if (status.contains('pending')) {
      return const Color(0xFFF59E0B);
    }

    if (status.contains('closed') || status.contains('resolved')) {
      return const Color(0xFF10B981);
    }

    return AppColors.primary;
  }

  // ─────────────────────────────────────────────
  // DATE FORMAT
  // ─────────────────────────────────────────────

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();

    return '$day/$month/$year';
  }
}
