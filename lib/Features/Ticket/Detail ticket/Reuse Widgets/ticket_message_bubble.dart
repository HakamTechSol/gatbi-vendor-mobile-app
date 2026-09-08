import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../../Models/ticket_message_model.dart';

class TicketMessageBubble extends StatelessWidget {
  const TicketMessageBubble({super.key, required this.message});

  final TicketMessageModel message;

  bool get _isVendor {
    final type = message.senderType.trim().toLowerCase();

    return type == 'vendor' ||
        type == 'user' ||
        type == 'customer' ||
        type == 'seller';
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: _isVendor ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 310),
        child: Container(
          margin: EdgeInsets.only(
            left: _isVendor ? 42 : 0,
            right: _isVendor ? 0 : 42,
            bottom: 10,
          ),
          padding: const EdgeInsets.fromLTRB(14, 11, 14, 9),
          decoration: BoxDecoration(
            color: _isVendor ? AppColors.primary : AppColors.surface,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(15),
              topRight: const Radius.circular(15),
              bottomLeft: Radius.circular(_isVendor ? 15 : 4),
              bottomRight: Radius.circular(_isVendor ? 4 : 15),
            ),
            border: _isVendor ? null : Border.all(color: AppColors.border),
            boxShadow: _isVendor
                ? null
                : const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!_isVendor && message.sender.trim().isNotEmpty)
                _buildSenderName(),
              if (!_isVendor && message.sender.trim().isNotEmpty)
                const SizedBox(height: 4),
              Text(
                message.message,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: _isVendor ? Colors.white : AppColors.textPrimary,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 5),
              _buildTime(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSenderName() {
    return Text(
      message.sender,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyles.caption.copyWith(
        color: AppColors.primary,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildTime() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Text(
        _formatTime(message.createdAt),
        style: AppTextStyles.caption.copyWith(
          fontSize: 10,
          color: _isVendor
              ? Colors.white.withValues(alpha: 0.72)
              : AppColors.textTertiary,
        ),
      ),
    );
  }

  String _formatTime(DateTime date) {
    final hour = date.hour == 0
        ? 12
        : date.hour > 12
        ? date.hour - 12
        : date.hour;

    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';

    return '$hour:$minute $period';
  }
}
