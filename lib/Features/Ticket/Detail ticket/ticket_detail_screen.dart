import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../Models/ticket_model.dart';
import '../Models/ticket_message_model.dart';

import 'Reuse Widgets/ticket_conversation.dart';
import 'Reuse Widgets/ticket_detail_header.dart';
import 'Reuse Widgets/ticket_reply_input.dart';

class TicketDetailScreen extends StatefulWidget {
  const TicketDetailScreen({
    super.key,
    required this.ticket,
    this.onBack,
    this.onCreateTicket,
    this.onSendReply,
  });

  final TicketModel ticket;

  final VoidCallback? onBack;

  final VoidCallback? onCreateTicket;

  final ValueChanged<String>? onSendReply;

  @override
  State<TicketDetailScreen> createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  late final TextEditingController _replyController;

  late final FocusNode _replyFocusNode;

  bool _isSending = false;

  late List<TicketMessageModel> _messages;

  @override
  void initState() {
    super.initState();

    _replyController = TextEditingController();
    _replyFocusNode = FocusNode();

    // ─────────────────────────────────────────────────────────
    // DUMMY CHAT
    // ─────────────────────────────────────────────────────────

    _messages = [
      TicketMessageModel(
        id: 1,
        sender: 'You',
        senderType: 'user',
        message: 'Hi! I need some help with my order.',
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
      ),

      TicketMessageModel(
        id: 2,
        sender: 'Support Team',
        senderType: 'support',
        message: 'Sure! I will be happy to help you with that.',
        createdAt: DateTime.now().subtract(const Duration(minutes: 12)),
      ),

      TicketMessageModel(
        id: 3,
        sender: 'Support Team',
        senderType: 'support',
        message: 'Could you please share your order details?',
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
      ),

      TicketMessageModel(
        id: 4,
        sender: 'You',
        senderType: 'user',
        message: 'Yes, sure. I will share them right away 😊',
        createdAt: DateTime.now().subtract(const Duration(minutes: 7)),
      ),
    ];
  }

  @override
  void dispose() {
    _replyController.dispose();
    _replyFocusNode.dispose();
    super.dispose();
  }

  // ═════════════════════════════════════════════════════════════
  // SEND REPLY
  // ═════════════════════════════════════════════════════════════

  Future<void> _handleSendReply() async {
    final message = _replyController.text.trim();

    if (message.isEmpty || _isSending) {
      return;
    }

    setState(() {
      _isSending = true;
    });

    try {
      // ───────────────────────────────────────────────────────
      // LOCAL DUMMY MESSAGE
      // ───────────────────────────────────────────────────────

      final newMessage = TicketMessageModel(
        id: DateTime.now().millisecondsSinceEpoch,
        sender: 'You',
        senderType: 'user',
        message: message,
        createdAt: DateTime.now(),
      );

      setState(() {
        _messages.add(newMessage);
      });

      // Optional parent callback.
      widget.onSendReply?.call(message);

      // Clear input.
      _replyController.clear();

      // Hide keyboard.
      _replyFocusNode.unfocus();

      // Small dummy sending delay.
      await Future<void>.delayed(const Duration(milliseconds: 300));
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  // ═════════════════════════════════════════════════════════════
  // EMOJI PICKER
  // ═════════════════════════════════════════════════════════════

  Future<void> _openEmojiPicker() async {
    if (_isSending) {
      return;
    }

    // Keyboard temporarily hide.
    _replyFocusNode.unfocus();

    final emoji = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return _EmojiPickerSheet(
          onEmojiSelected: (emoji) {
            Navigator.of(context).pop(emoji);
          },
        );
      },
    );

    if (emoji == null || !mounted) {
      return;
    }

    _insertEmoji(emoji);

    // Keyboard dobara open.
    await Future<void>.delayed(const Duration(milliseconds: 100));

    if (mounted) {
      _replyFocusNode.requestFocus();
    }
  }

  // ═════════════════════════════════════════════════════════════
  // INSERT EMOJI
  // ═════════════════════════════════════════════════════════════

  void _insertEmoji(String emoji) {
    final text = _replyController.text;

    final selection = _replyController.selection;

    final start = selection.start >= 0 ? selection.start : text.length;

    final end = selection.end >= 0 ? selection.end : text.length;

    final newText = text.replaceRange(start, end, emoji);

    _replyController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: start + emoji.length),
    );

    setState(() {});
  }

  // ═════════════════════════════════════════════════════════════
  // BACK
  // ═════════════════════════════════════════════════════════════

  void _handleBack() {
    if (widget.onBack != null) {
      widget.onBack!.call();
      return;
    }

    Navigator.of(context).maybePop();
  }

  // ═════════════════════════════════════════════════════════════
  // BUILD
  // ═════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    final ticket = widget.ticket;

    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,

      body: SafeArea(
        child: Column(
          children: [
            // ═══════════════════════════════════════════════════
            // HEADER
            // ═══════════════════════════════════════════════════
            TicketDetailHeader(
              ticketNumber: ticket.ticketNumber,
              onBack: _handleBack,
              onMore: () => _showTicketDetails(context),
            ),

            // ═══════════════════════════════════════════════════
            // CHAT
            // ═══════════════════════════════════════════════════
            Expanded(child: TicketConversation(messages: _messages)),

            // ═══════════════════════════════════════════════════
            // REPLY INPUT
            // ═══════════════════════════════════════════════════
            _buildReplyComposer(),
          ],
        ),
      ),
    );
  }

  // ═════════════════════════════════════════════════════════════
  // REPLY COMPOSER
  // ═════════════════════════════════════════════════════════════

  Widget _buildReplyComposer() {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          top: BorderSide(color: AppColors.border.withValues(alpha: 0.75)),
        ),
      ),
      child: TicketReplyInput(
        controller: _replyController,
        enabled: !_isSending,

        // Emoji connected here.
        onEmojiTap: _openEmojiPicker,

        onChanged: (_) {
          setState(() {});
        },

        onSubmitted: (_) {
          _handleSendReply();
        },

        onSend: _handleSendReply,
      ),
    );
  }

  // ═════════════════════════════════════════════════════════════
  // BOTTOM SHEET
  // ═════════════════════════════════════════════════════════════

  void _showTicketDetails(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return _TicketDetailsBottomSheet(ticket: widget.ticket);
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// EMOJI PICKER SHEET
// ═══════════════════════════════════════════════════════════════════════════

class _EmojiPickerSheet extends StatelessWidget {
  const _EmojiPickerSheet({required this.onEmojiSelected});

  final ValueChanged<String> onEmojiSelected;

  static const List<String> _emojis = [
    '😊',
    '😂',
    '🤣',
    '❤️',
    '🔥',
    '👍',
    '🙏',
    '😍',
    '🥰',
    '🤩',
    '😘',
    '💪',
    '✨',
    '🎉',
    '💯',
    '😅',
    '🤔',
    '😭',
    '🥺',
    '😎',
    '🤗',
    '🙌',
    '👏',
    '💕',
    '💫',
    '🌟',
    '⭐',
    '🌈',
    '☀️',
    '🦋',
    '🌸',
    '🌺',
    '🍀',
    '🥹',
    '😇',
    '🤍',
    '🫶',
    '😌',
    '😋',
    '😜',
    '🤭',
    '😴',
    '🤯',
    '😱',
    '😢',
    '😡',
    '🥳',
    '💖',
    '💗',
    '💙',
    '💜',
    '🩷',
    '🩵',
    '💐',
    '🌷',
    '🌹',
    '🍕',
    '☕',
    '🎂',
    '🚀',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 330,
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // Handle
            Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const SizedBox(height: 14),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.emoji_emotions_rounded,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),

                  const SizedBox(width: 10),

                  Text(
                    'Choose an emoji',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const Spacer(),

                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close_rounded, size: 20),
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 4),

            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  childAspectRatio: 1,
                ),
                itemCount: _emojis.length,
                itemBuilder: (context, index) {
                  final emoji = _emojis[index];

                  return Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onTap: () {
                        onEmojiSelected(emoji);
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Center(
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 25),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// TICKET DETAILS BOTTOM SHEET
// ═══════════════════════════════════════════════════════════════════════════

class _TicketDetailsBottomSheet extends StatelessWidget {
  const _TicketDetailsBottomSheet({required this.ticket});

  final TicketModel ticket;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 30,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 18),

            // Header
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.confirmation_number_outlined,
                    color: AppColors.primary,
                    size: 21,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ticket Details',
                        style: AppTextStyles.titleMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      const SizedBox(height: 2),

                      Text(
                        ticket.ticketNumber.isEmpty
                            ? 'Ticket'
                            : ticket.ticketNumber,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close_rounded, size: 21),
                  color: AppColors.textSecondary,
                ),
              ],
            ),

            const SizedBox(height: 20),

            _BottomSheetSubject(subject: ticket.subject),

            const SizedBox(height: 18),

            _InfoRow(
              icon: Icons.circle_outlined,
              label: 'Status',
              value: ticket.status,
            ),

            _InfoRow(
              icon: Icons.flag_outlined,
              label: 'Priority',
              value: ticket.priority,
            ),

            _InfoRow(
              icon: Icons.category_outlined,
              label: 'Category',
              value: ticket.category,
            ),

            _InfoRow(
              icon: Icons.confirmation_number_outlined,
              label: 'Ticket',
              value: ticket.ticketNumber,
            ),

            _InfoRow(
              icon: Icons.calendar_today_outlined,
              label: 'Created',
              value: _formatDate(ticket.createdAt),
            ),

            _InfoRow(
              icon: Icons.update_rounded,
              label: 'Last Updated',
              value: _formatDate(ticket.updatedAt),
              showDivider: false,
            ),

            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();

    return '$day/$month/$year';
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SUBJECT
// ═══════════════════════════════════════════════════════════════════════════

class _BottomSheetSubject extends StatelessWidget {
  const _BottomSheetSubject({required this.subject});

  final String subject;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Subject',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textTertiary,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            subject.trim().isEmpty ? 'Untitled Ticket' : subject,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// INFO ROW
// ═══════════════════════════════════════════════════════════════════════════

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.showDivider = true,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 11),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, size: 16, color: AppColors.primary),
              ),

              const SizedBox(width: 11),

              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Flexible(
                child: Text(
                  value.isEmpty ? '—' : value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),

        if (showDivider)
          Divider(height: 1, color: AppColors.border.withValues(alpha: 0.7)),
      ],
    );
  }
}
