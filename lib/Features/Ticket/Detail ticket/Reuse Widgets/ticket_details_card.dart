import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../../Models/ticket_model.dart';

import 'ticket_detail_category.dart';
import 'ticket_detail_priority.dart';
import 'ticket_detail_status.dart';

class TicketDetailsCard extends StatelessWidget {
  const TicketDetailsCard({super.key, required this.ticket});

  final TicketModel ticket;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSubject(),
          const SizedBox(height: 18),
          _buildDivider(),
          const SizedBox(height: 16),
          _buildInformationGrid(),
          const SizedBox(height: 16),
          _buildDates(),
        ],
      ),
    );
  }

  Widget _buildSubject() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Subject',
          style: AppTextStyles.formLabel.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 7),
        Text(
          ticket.subject.trim().isEmpty ? 'Untitled Ticket' : ticket.subject,
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildInformationGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _InformationItem(
                label: 'Status',
                child: TicketDetailStatus(status: ticket.status),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _InformationItem(
                label: 'Priority',
                child: TicketDetailPriority(priority: ticket.priority),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _InformationItem(
                label: 'Category',
                child: TicketDetailCategory(category: ticket.category),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _InformationItem(
                label: 'Ticket',
                child: Text(
                  ticket.ticketNumber.isEmpty ? '—' : ticket.ticketNumber,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDates() {
    return Row(
      children: [
        Expanded(
          child: _DateItem(
            icon: Icons.calendar_today_outlined,
            label: 'Created',
            value: _formatDate(ticket.createdAt),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _DateItem(
            icon: Icons.update_rounded,
            label: 'Last Updated',
            value: _formatDate(ticket.updatedAt),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, thickness: 1, color: AppColors.border);
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();

    return '$day/$month/$year';
  }
}

class _InformationItem extends StatelessWidget {
  const _InformationItem({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
        ),
        const SizedBox(height: 7),
        child,
      ],
    );
  }
}

class _DateItem extends StatelessWidget {
  const _DateItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(icon, size: 16, color: AppColors.textSecondary),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
