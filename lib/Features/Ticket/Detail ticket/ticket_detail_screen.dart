import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../Send Message/Controller/ticket_send_controller.dart';
import '../Send Message/Models/ticket_send_model.dart';
import 'Controller/ticket_detail_controller.dart';
import 'Models/ticket_detail_message_model.dart';
import 'Models/ticket_detail_model.dart';
import 'Reuse Widgets/ticket_conversation.dart';
import 'Reuse Widgets/ticket_detail_header.dart';
import 'Reuse Widgets/ticket_details_shimmer_screen.dart';
import 'Reuse Widgets/ticket_reply_input.dart';

class TicketDetailScreen extends ConsumerStatefulWidget {
  const TicketDetailScreen({
    super.key,
    required this.ticketId,
    this.ticketNumber,
    this.onBack,
    this.onCreateTicket,
    this.onSendReply,
  });

  final int ticketId;

  /// Optional fallback ticket number.
  ///
  /// Actual ticket number API detail response se update hoga.
  final String? ticketNumber;

  final VoidCallback? onBack;

  final VoidCallback? onCreateTicket;

  final ValueChanged<String>? onSendReply;

  @override
  ConsumerState<TicketDetailScreen> createState() {
    return _TicketDetailScreenState();
  }
}

class _TicketDetailScreenState extends ConsumerState<TicketDetailScreen> {
  late final TextEditingController _replyController;

  late final FocusNode _replyFocusNode;

  bool _isLoading = false;
  bool _hasError = false;
  bool _isSending = false;

  String? _errorMessage;

  TicketDetailDataModel? _ticket;

  List<TicketDetailMessageModel> _messages = [];

  @override
  void initState() {
    super.initState();

    _replyController = TextEditingController();
    _replyFocusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTicketDetail();
    });
  }

  @override
  void dispose() {
    _replyController.dispose();
    _replyFocusNode.dispose();

    super.dispose();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // LOAD TICKET DETAIL
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _loadTicketDetail() async {
    if (_isLoading) {
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = null;
    });

    try {
      final result = await ref
          .read(ticketDetailControllerProvider)
          .getTicketDetail(ticketId: widget.ticketId);

      if (!mounted) {
        return;
      }

      final ticket = result.ticket;

      setState(() {
        _ticket = ticket;
        _messages = List<TicketDetailMessageModel>.from(
          ticket?.messages ?? const [],
        );

        _isLoading = false;
        _hasError = false;
        _errorMessage = null;
      });
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = error.message;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Unable to load ticket details. Please try again.';
      });
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SEND REPLY
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _handleSendReply() async {
    final message = _replyController.text.trim();

    if (message.isEmpty || _isSending) {
      return;
    }

    setState(() {
      _isSending = true;
    });

    try {
      final result = await ref
          .read(ticketSendControllerProvider)
          .sendTicketReply(ticketId: widget.ticketId, message: message);

      if (!mounted) {
        return;
      }

      _handleSendResponse(result, sentMessage: message);

      _replyController.clear();

      _replyFocusNode.unfocus();

      widget.onSendReply?.call(message);
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      _showErrorMessage(error.message);
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showErrorMessage('Unable to send reply. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // HANDLE SEND RESPONSE
  // ═══════════════════════════════════════════════════════════════════════════

  void _handleSendResponse(
    TicketSendModel result, {
    required String sentMessage,
  }) {
    final updatedTicket = result.ticket;

    if (updatedTicket == null) {
      return;
    }

    final updatedMessages = updatedTicket.messages;

    setState(() {
      _messages = updatedMessages
          .map(
            (message) => TicketDetailMessageModel(
              id: message.id,
              message: message.message,
              senderType: message.senderType,
              senderName: message.senderName,
              createdAt: message.createdAt,
            ),
          )
          .toList();

      _ticket = TicketDetailDataModel(
        id: updatedTicket.id,
        ticketNumber: updatedTicket.ticketNumber,
        subject: updatedTicket.subject,
        category: updatedTicket.category,
        priority: updatedTicket.priority,
        status: updatedTicket.status,
        createdAt: updatedTicket.createdAt,
        updatedAt: updatedTicket.updatedAt,
        messages: _messages,
      );
    });
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // EMOJI PICKER
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _openEmojiPicker() async {
    if (_isSending) {
      return;
    }

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

    await Future<void>.delayed(const Duration(milliseconds: 100));

    if (mounted) {
      _replyFocusNode.requestFocus();
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // INSERT EMOJI
  // ═══════════════════════════════════════════════════════════════════════════

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
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BACK
  // ═══════════════════════════════════════════════════════════════════════════

  void _handleBack() {
    if (widget.onBack != null) {
      widget.onBack!.call();
      return;
    }

    Navigator.of(context).maybePop();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ERROR MESSAGE
  // ═══════════════════════════════════════════════════════════════════════════

  void _showErrorMessage(String? message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: AppColors.white,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message == null || message.trim().isEmpty
                      ? 'Something went wrong. Please try again.'
                      : message,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFFDC2626),
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    final ticketNumber = _ticket?.ticketNumber ?? widget.ticketNumber ?? '';

    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            // ═══════════════════════════════════════════════════════════════
            // HEADER
            // ═══════════════════════════════════════════════════════════════
            TicketDetailHeader(
              ticketNumber: ticketNumber,
              onBack: _handleBack,
              onMore: _ticket == null
                  ? null
                  : () => _showTicketDetails(context, _ticket!),
            ),

            // ═══════════════════════════════════════════════════════════════
            // CONTENT
            // ═══════════════════════════════════════════════════════════════
            Expanded(child: _buildContent()),

            // ═══════════════════════════════════════════════════════════════
            // REPLY INPUT
            // ═══════════════════════════════════════════════════════════════
            if (!_isLoading && !_hasError) _buildReplyComposer(),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CONTENT
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildContent() {
    if (_isLoading) {
      return TicketDetailsShimmerScreen();
    }

    if (_hasError) {
      return _buildError();
    }

    return TicketConversation(messages: _messages);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // LOADING
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: SizedBox(
                width: 23,
                height: 23,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          Text(
            'Loading conversation...',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ERROR
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 66,
              height: 66,
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_off_rounded,
                color: Color(0xFFDC2626),
                size: 29,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              'Unable to load ticket',
              textAlign: TextAlign.center,
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 7),

            Text(
              _errorMessage == null || _errorMessage!.trim().isEmpty
                  ? 'Something went wrong while loading this ticket.'
                  : _errorMessage!,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                height: 1.45,
              ),
            ),

            const SizedBox(height: 18),

            SizedBox(
              height: 42,
              child: ElevatedButton.icon(
                onPressed: _loadTicketDetail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: Text(
                  'Try Again',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // REPLY COMPOSER
  // ═══════════════════════════════════════════════════════════════════════════

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

  // ═══════════════════════════════════════════════════════════════════════════
  // TICKET DETAILS
  // ═══════════════════════════════════════════════════════════════════════════

  void _showTicketDetails(BuildContext context, TicketDetailDataModel ticket) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return _TicketDetailsBottomSheet(ticket: ticket);
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// EMOJI PICKER
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

            Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const SizedBox(height: 14),

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

  final TicketDetailDataModel ticket;

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
                        _valueOrDash(ticket.ticketNumber),
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

  static String _valueOrDash(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '—';
    }

    return value.trim();
  }

  static String _formatDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '—';
    }

    final date = DateTime.tryParse(value.trim().replaceFirst(' ', 'T'));

    if (date == null) {
      return value;
    }

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

  final String? subject;

  @override
  Widget build(BuildContext context) {
    final value = subject?.trim() ?? '';

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
            value.isEmpty ? 'Untitled Ticket' : value,
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
  final String? value;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final displayValue = value == null || value!.trim().isEmpty
        ? '—'
        : value!.trim();

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
                  displayValue,
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
