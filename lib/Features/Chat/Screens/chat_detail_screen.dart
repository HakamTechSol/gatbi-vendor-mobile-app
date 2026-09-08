// lib/features/chat/presentation/screens/chat_detail_screen.dart

import 'package:flutter/material.dart';

import '../Reuse Widgets/chat_header.dart';
import '../Reuse Widgets/chat_input_field.dart';
import '../Reuse Widgets/chat_loading.dart';
import '../Reuse Widgets/chat_message_bubble.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({super.key});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  // ============================================================
  // CONVERSATION
  // ============================================================

  // TODO: Replace with ViewModel when API is ready
  final Map<String, dynamic> _conversation = {
    'customerName': 'Irfan Alam',
    'customerEmail': 'malikirfanalam@outlook.com',
    'isOnline': false,
  };

  // ============================================================
  // MESSAGES
  // ============================================================

  // IMPORTANT:
  // Messages are stored in chronological order.
  // Oldest message = index 0
  // Latest message = last index
  final List<Map<String, dynamic>> _messages = [
    {
      'id': '1',
      'senderName': 'Irfan Alam',
      'isVendor': false,
      'message': 'hi',
      'timestamp': 'Aug 28, 12:59 PM',
    },
  ];

  bool _isLoading = false;
  bool _isSending = false;

  // ============================================================
  // INIT STATE
  // ============================================================

  @override
  void initState() {
    super.initState();

    // After the first frame, scroll to the latest message.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom(animated: false);
    });
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      // ========================================================
      // APP BAR
      // ========================================================
      appBar: ChatHeader(
        title: _conversation['customerName'] ?? 'Chat',
        showBackButton: true,
        actions: [_buildOnlineStatus()],
      ),

      // ========================================================
      // BODY
      // ========================================================
      body: Column(
        children: [
          // ======================================================
          // CUSTOMER EMAIL
          // ======================================================
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: AppColors.surface,
            child: Row(
              children: [
                const Icon(
                  Icons.email_outlined,
                  size: 16,
                  color: AppColors.textTertiary,
                ),

                const SizedBox(width: 6),

                Expanded(
                  child: Text(
                    _conversation['customerEmail'] ?? '',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textTertiary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // ======================================================
          // MESSAGES
          // ======================================================
          Expanded(
            child: _isLoading
                ? const ChatLoading()
                : _messages.isEmpty
                ? _buildEmptyMessages()
                : _buildMessagesList(),
          ),

          // ======================================================
          // INPUT FIELD
          // ======================================================
          ChatInputField(
            controller: _messageController,
            onSend: _sendMessage,
            isLoading: _isSending,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ONLINE STATUS
  // ============================================================

  Widget _buildOnlineStatus() {
    final bool isOnline = _conversation['isOnline'] ?? false;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isOnline ? AppColors.success : AppColors.border,
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 6),

          Text(
            isOnline ? 'Online' : 'Offline',
            style: AppTextStyles.captionMedium.copyWith(
              color: isOnline ? AppColors.success : AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // EMPTY MESSAGES
  // ============================================================

  Widget _buildEmptyMessages() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.chat_bubble_outline_rounded,
              size: 36,
              color: AppColors.primary.withOpacity(0.6),
            ),
          ),

          const SizedBox(height: 16),

          Text('No messages yet', style: AppTextStyles.emptyStateTitle),

          const SizedBox(height: 8),

          Text(
            'Start the conversation with '
            '${_conversation['customerName']}',
            style: AppTextStyles.emptyStateDescription,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MESSAGES LIST
  // ============================================================

  Widget _buildMessagesList() {
    return ListView.builder(
      controller: _scrollController,

      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

      // IMPORTANT:
      // false = normal top-to-bottom list
      reverse: false,

      itemCount: _messages.length,

      itemBuilder: (context, index) {
        // IMPORTANT:
        // Do NOT reverse the index.
        // Messages are already stored oldest -> newest.
        final message = _messages[index];

        return ChatMessageBubble(
          message: message['message'] ?? '',
          timestamp: message['timestamp'] ?? '',
          isVendor: message['isVendor'] ?? false,
          senderName: message['senderName'] ?? '',
        );
      },
    );
  }

  // ============================================================
  // SCROLL TO BOTTOM
  // ============================================================

  void _scrollToBottom({bool animated = true}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      if (!_scrollController.hasClients) return;

      final double maxScroll = _scrollController.position.maxScrollExtent;

      if (animated) {
        _scrollController.animateTo(
          maxScroll,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      } else {
        _scrollController.jumpTo(maxScroll);
      }
    });
  }

  // ============================================================
  // SEND MESSAGE
  // ============================================================

  Future<void> _sendMessage(String text) async {
    final String messageText = text.trim();

    // Don't send empty message
    if (messageText.isEmpty) return;

    // Don't send multiple messages at the same time
    if (_isSending) return;

    setState(() {
      _isSending = true;
    });

    // ==========================================================
    // TODO:
    // Replace this with your API call.
    // ==========================================================

    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    setState(() {
      // IMPORTANT:
      // add() puts the new message at the END.
      //
      // Since ListView is reverse:false,
      // the END of the list is the BOTTOM of the screen.
      _messages.add({
        'id': DateTime.now().toString(),
        'senderName': 'You',
        'isVendor': true,
        'message': messageText,
        'timestamp': _formatTimestamp(DateTime.now()),
      });

      // Clear input
      _messageController.clear();

      _isSending = false;
    });

    // ==========================================================
    // AUTO SCROLL TO LATEST MESSAGE
    // ==========================================================

    _scrollToBottom();
  }

  // ============================================================
  // FORMAT TIMESTAMP
  // ============================================================

  String _formatTimestamp(DateTime dateTime) {
    final month = _getMonthAbbr(dateTime.month);

    final day = dateTime.day;

    // Convert 24-hour to 12-hour format
    final int hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;

    final minute = dateTime.minute.toString().padLeft(2, '0');

    final ampm = dateTime.hour >= 12 ? 'PM' : 'AM';

    return '$month $day, '
        '$hour:$minute $ampm';
  }

  // ============================================================
  // MONTH
  // ============================================================

  String _getMonthAbbr(int month) {
    const months = [
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

    return months[month - 1];
  }
}
