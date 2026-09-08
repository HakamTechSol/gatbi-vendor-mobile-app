import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../../Models/ticket_message_model.dart';

import 'ticket_message_bubble.dart';

class TicketConversation extends StatelessWidget {
  const TicketConversation({
    super.key,
    required this.messages,
    this.title = 'Conversation',
  });

  final List<TicketMessageModel> messages;
  final String title;

  @override
  Widget build(BuildContext context) {
    final isEmpty = messages.isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Conversation header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
          child: _buildHeader(),
        ),

        // Conversation area
        Expanded(
          child: isEmpty
              ? Center(child: _buildEmptyConversation())
              : _buildMessages(),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // HEADER
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(9),
          ),
          child: const Icon(
            Icons.forum_outlined,
            size: 18,
            color: AppColors.primary,
          ),
        ),

        const SizedBox(width: 9),

        Text(
          title,
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),

        if (messages.isNotEmpty) ...[
          const SizedBox(width: 7),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.chipBackground,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Text(
              '${messages.length}',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // MESSAGES
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildMessages() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(top: 14, left: 12, right: 12, bottom: 4),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            for (final message in messages)
              TicketMessageBubble(message: message),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // EMPTY CONVERSATION
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildEmptyConversation() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.chat_bubble_outline_rounded,
              color: AppColors.primary,
              size: 28,
            ),
          ),

          const SizedBox(height: 14),

          Text(
            'No messages yet',
            textAlign: TextAlign.center,
            style: AppTextStyles.titleMedium.copyWith(
              fontSize: 15,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            'Send a reply below to start the conversation.',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
