import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../Chat Details/Controller/vendor_chat_detail_controller.dart';
import '../Chat Details/Controller/vendor_chat_detail_state.dart';
import '../Chat Details/Models/vendor_chat_detail_message_model.dart';
import '../Chat Details/Models/vendor_chat_detail_model.dart';

import '../Reuse Widgets/chat_detail_shimmer.dart';
import '../Reuse Widgets/chat_header.dart';
import '../Reuse Widgets/chat_input_field.dart';
import '../Reuse Widgets/chat_message_bubble.dart';
import '../Reuse Widgets/chat_product_card.dart';
import '../Send Message/Controller/vendor_chat_message_controller.dart';

class ChatDetailScreen extends ConsumerStatefulWidget {
  const ChatDetailScreen({super.key, required this.chatId});

  final int chatId;

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  // ============================================================
  // CONTROLLERS
  // ============================================================

  final TextEditingController _messageController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  // ============================================================
  // SAVED PROVIDER CONTROLLER
  // ============================================================
  //
  // IMPORTANT:
  //
  // We MUST NOT call ref.read() inside dispose().
  //
  // Riverpod's ref becomes unsafe while the widget is being
  // unmounted.
  //
  // Therefore we get the controller once in initState() and
  // keep the reference here.
  //
  // ============================================================

  late final VendorChatDetailController _chatDetailController;

  // ============================================================
  // LOCAL UI STATE
  // ============================================================

  bool _isNearBottom = true;

  bool _restoringPaginationScroll = false;

  // Prevent multiple send operations from the UI layer.
  bool _sendInProgress = false;

  // ============================================================
  // PROVIDER GETTERS
  // ============================================================

  VendorChatDetailController get _detailController {
    return _chatDetailController;
  }

  VendorChatMessageController get _messageControllerProvider {
    return ref.read(
      vendorChatMessageControllerProvider(widget.chatId).notifier,
    );
  }

  // ============================================================
  // LIFECYCLE
  // ============================================================

  @override
  void initState() {
    super.initState();

    // ------------------------------------------------------------
    // SAVE DETAIL CONTROLLER ONCE
    // ------------------------------------------------------------
    //
    // This is intentionally done before the widget can be disposed.
    //
    // dispose() will use this saved reference instead of ref.read().
    //
    // ------------------------------------------------------------

    _chatDetailController = ref.read(
      vendorChatDetailControllerProvider(widget.chatId).notifier,
    );

    // ------------------------------------------------------------
    // SCROLL LISTENER
    // ------------------------------------------------------------

    _scrollController.addListener(_onScroll);

    // ------------------------------------------------------------
    // START CHAT AFTER FIRST FRAME
    // ------------------------------------------------------------

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      // ----------------------------------------------------------
      // CHAT OPEN
      // ----------------------------------------------------------
      //
      // Start WebSocket realtime immediately.
      //
      // The controller itself should protect against duplicate
      // connections.
      //
      // ----------------------------------------------------------

      unawaited(_chatDetailController.startChatRealtime());

      // ----------------------------------------------------------
      // LOAD CHAT DATA
      // ----------------------------------------------------------

      unawaited(_chatDetailController.loadChat());
    });
  }

  @override
  void dispose() {
    // ------------------------------------------------------------
    // REMOVE SCROLL LISTENER
    // ------------------------------------------------------------

    _scrollController.removeListener(_onScroll);

    // ------------------------------------------------------------
    // CHAT CLOSED
    // ------------------------------------------------------------
    //
    // IMPORTANT:
    //
    // DO NOT use:
    //
    // ref.read(...)
    //
    // here.
    //
    // The ConsumerState is already being unmounted.
    //
    // We use the controller saved in initState().
    //
    // stopChatRealtime() should:
    //
    // 1. Mark realtime inactive.
    // 2. Stop polling.
    // 3. Disconnect WebSocket.
    // 4. Disable automatic reconnect.
    //
    // ------------------------------------------------------------

    unawaited(_chatDetailController.stopChatRealtime());

    // ------------------------------------------------------------
    // DISPOSE LOCAL CONTROLLERS
    // ------------------------------------------------------------

    _messageController.dispose();

    _scrollController.dispose();

    super.dispose();
  }

  // ============================================================
  // SCROLL LISTENER
  // ============================================================

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final position = _scrollController.position;

    // ----------------------------------------------------------
    // Bottom detection
    // ----------------------------------------------------------

    final distanceFromBottom = position.maxScrollExtent - position.pixels;

    _isNearBottom = distanceFromBottom < 140;

    // ----------------------------------------------------------
    // Top pagination
    // ----------------------------------------------------------

    if (position.pixels <= 120) {
      // --------------------------------------------------------
      // IMPORTANT:
      //
      // Use saved controller instead of ref.read().
      // --------------------------------------------------------

      final controller = _chatDetailController;

      final state = ref.read(vendorChatDetailControllerProvider(widget.chatId));

      if (!state.isLoading &&
          !state.isLoadingMore &&
          state.hasMore &&
          !_restoringPaginationScroll) {
        unawaited(_loadOlderMessages(controller));
      }
    }
  }

  // ============================================================
  // LOAD OLDER MESSAGES
  // ============================================================

  Future<void> _loadOlderMessages(VendorChatDetailController controller) async {
    if (!_scrollController.hasClients) {
      await controller.loadMoreMessages();
      return;
    }

    if (_restoringPaginationScroll) {
      return;
    }

    _restoringPaginationScroll = true;

    final double oldMaxScrollExtent =
        _scrollController.position.maxScrollExtent;

    final double oldPixels = _scrollController.position.pixels;

    try {
      await controller.loadMoreMessages();

      if (!mounted) {
        return;
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }

        if (!_scrollController.hasClients) {
          _restoringPaginationScroll = false;
          return;
        }

        final double newMaxScrollExtent =
            _scrollController.position.maxScrollExtent;

        final double scrollDifference = newMaxScrollExtent - oldMaxScrollExtent;

        final double targetOffset = oldPixels + scrollDifference;

        final double safeOffset = targetOffset.clamp(
          0.0,
          _scrollController.position.maxScrollExtent,
        );

        _scrollController.jumpTo(safeOffset);

        _restoringPaginationScroll = false;
      });
    } catch (_) {
      _restoringPaginationScroll = false;
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(vendorChatDetailControllerProvider(widget.chatId));

    final messageState = ref.watch(
      vendorChatMessageControllerProvider(widget.chatId),
    );

    return Scaffold(
      backgroundColor: AppColors.background,

      // ========================================================
      // HEADER
      // ========================================================
      appBar: ChatHeader(
        title: _customerName(state),
        showBackButton: true,
        actions: [_buildOnlineStatus()],
      ),

      // ========================================================
      // BODY
      // ========================================================
      body: Column(
        children: [
          _buildCustomerInfo(state),

          Expanded(child: _buildBody(state)),

          // ----------------------------------------------------
          // SEND INPUT
          // ----------------------------------------------------
          ChatInputField(
            controller: _messageController,
            onSend: _sendMessage,
            isLoading: messageState.isSending,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SEND MESSAGE
  // ============================================================

  Future<void> _sendMessage(String message) async {
    // ----------------------------------------------------------
    // Prevent double tap / duplicate UI requests.
    // ----------------------------------------------------------

    if (_sendInProgress) {
      return;
    }

    final trimmedMessage = message.trim();

    // ----------------------------------------------------------
    // Local validation.
    // ----------------------------------------------------------

    if (trimmedMessage.isEmpty) {
      return;
    }

    _sendInProgress = true;

    try {
      final sentMessage = await _messageControllerProvider.sendMessage(
        message: trimmedMessage,
      );

      if (!mounted) {
        return;
      }

      // --------------------------------------------------------
      // API FAILED
      // --------------------------------------------------------

      if (sentMessage == null) {
        return;
      }

      // --------------------------------------------------------
      // Convert API send model into detail message model.
      // --------------------------------------------------------

      final detailMessage = VendorChatDetailMessageModel.fromJson(
        sentMessage.toJson(),
      );

      // --------------------------------------------------------
      // Add message to detail controller.
      // --------------------------------------------------------

      _detailController.addMessage(detailMessage);

      // --------------------------------------------------------
      // Clear input ONLY after successful API response.
      // --------------------------------------------------------

      _messageController.clear();

      // --------------------------------------------------------
      // Scroll to latest message.
      // --------------------------------------------------------

      _scrollToBottom(animated: true);
    } finally {
      _sendInProgress = false;
    }
  }

  // ============================================================
  // BODY
  // ============================================================

  Widget _buildBody(VendorChatDetailState state) {
    // ----------------------------------------------------------
    // INITIAL SHIMMER
    // ----------------------------------------------------------

    if (state.isLoading && state.messages.isEmpty) {
      return const ChatDetailShimmer(itemCount: 7);
    }

    // ----------------------------------------------------------
    // ERROR
    // ----------------------------------------------------------

    if (state.errorMessage != null && state.messages.isEmpty) {
      return _buildErrorState(state.errorMessage!);
    }

    // ----------------------------------------------------------
    // EMPTY
    // ----------------------------------------------------------

    if (state.messages.isEmpty) {
      return _buildEmptyMessages(state);
    }

    // ----------------------------------------------------------
    // MESSAGES
    // ----------------------------------------------------------

    return Stack(
      children: [
        _buildMessagesList(state),

        if (!_isNearBottom)
          Positioned(
            right: 16,
            bottom: 16,
            child: _buildScrollToBottomButton(),
          ),
      ],
    );
  }

  // ============================================================
  // CUSTOMER INFO
  // ============================================================

  Widget _buildCustomerInfo(VendorChatDetailState state) {
    final chat = state.chat;

    final user = _extractUser(chat);

    final email = _mapString(user?['email']);

    if (email.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
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
              email,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textTertiary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ONLINE STATUS
  // ============================================================

  Widget _buildOnlineStatus() {
    return const SizedBox(width: 8);
  }

  // ============================================================
  // MESSAGE LIST
  // ============================================================

  Widget _buildMessagesList(VendorChatDetailState state) {
    final messages = state.messages;

    return ListView.builder(
      controller: _scrollController,

      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

      reverse: false,

      itemCount: messages.length + (state.isLoadingMore ? 1 : 0),

      itemBuilder: (context, index) {
        // ------------------------------------------------------
        // TOP PAGINATION LOADER
        // ------------------------------------------------------

        if (state.isLoadingMore && index == 0) {
          return const ChatOlderMessagesShimmer();
        }

        final messageIndex = state.isLoadingMore ? index - 1 : index;

        final message = messages[messageIndex];

        return _buildMessageItem(message);
      },
    );
  }

  // ============================================================
  // MESSAGE ITEM
  // ============================================================

  Widget _buildMessageItem(VendorChatDetailMessageModel message) {
    // ----------------------------------------------------------
    // PRODUCT CARD
    // ----------------------------------------------------------

    if (message.isProductCard) {
      final product = message.productCard;

      if (product != null) {
        return _buildProductMessage(message, product);
      }

      return const SizedBox.shrink();
    }

    // ----------------------------------------------------------
    // NORMAL TEXT
    // ----------------------------------------------------------

    return ChatMessageBubble(
      message: message.message ?? '',
      timestamp: _formatMessageTime(message.createdAt),
      isVendor: _isVendorMessage(message),
      senderName: message.senderName ?? '',
    );
  }

  // ============================================================
  // PRODUCT MESSAGE
  // ============================================================

  Widget _buildProductMessage(
    VendorChatDetailMessageModel message,
    dynamic product,
  ) {
    final productMap = _productToMap(product);

    final isVendor = _isVendorMessage(message);

    return Align(
      alignment: isVendor ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 330),
        child: Column(
          crossAxisAlignment: isVendor
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            if (!isVendor && (message.senderName ?? '').trim().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 5),
                child: Text(
                  message.senderName!,
                  style: AppTextStyles.captionMedium.copyWith(
                    color: AppColors.textTertiary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

            ChatProductCard(product: productMap),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                _formatMessageTime(message.createdAt),
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // VENDOR / CUSTOMER
  // ============================================================

  bool _isVendorMessage(VendorChatDetailMessageModel message) {
    final senderType = (message.senderType ?? '').trim().toLowerCase();

    return senderType == 'merchant' || senderType == 'vendor';
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget _buildEmptyMessages(VendorChatDetailState state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
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
              '${_customerName(state)}',
              style: AppTextStyles.emptyStateDescription,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ERROR STATE
  // ============================================================

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_off_rounded,
                size: 34,
                color: AppColors.textMuted,
              ),
            ),

            const SizedBox(height: 16),

            Text('Unable to load chat', style: AppTextStyles.emptyStateTitle),

            const SizedBox(height: 8),

            Text(
              error,
              textAlign: TextAlign.center,
              style: AppTextStyles.emptyStateDescription,
            ),

            const SizedBox(height: 18),

            OutlinedButton.icon(
              onPressed: () {
                // ------------------------------------------------
                // Use saved controller.
                // ------------------------------------------------

                unawaited(_chatDetailController.loadChat());
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SCROLL TO BOTTOM BUTTON
  // ============================================================

  Widget _buildScrollToBottomButton() {
    return Material(
      color: AppColors.primary,
      shape: const CircleBorder(),
      elevation: 4,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () {
          _scrollToBottom();
        },
        child: const SizedBox(
          width: 44,
          height: 44,
          child: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white),
        ),
      ),
    );
  }

  // ============================================================
  // AUTO SCROLL
  // ============================================================

  void _scrollToBottom({bool animated = true}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      if (!_scrollController.hasClients) {
        return;
      }

      final maxScroll = _scrollController.position.maxScrollExtent;

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
  // CUSTOMER / SENDER NAME
  // ============================================================

  String _customerName(VendorChatDetailState state) {
    // ----------------------------------------------------------
    // First priority:
    // Messages API se user/sender ka name
    // ----------------------------------------------------------

    for (final message in state.messages) {
      final senderName = (message.senderName ?? '').trim();

      final senderType = (message.senderType ?? '').trim().toLowerCase();

      if (senderName.isNotEmpty && senderType == 'user') {
        return senderName;
      }
    }

    // ----------------------------------------------------------
    // Second priority:
    // Existing chat user information
    // ----------------------------------------------------------

    final user = _extractUser(state.chat);

    final name = _mapString(user?['name']);

    if (name.isNotEmpty) {
      return name;
    }

    final firstName = _mapString(user?['first_name']);

    final lastName = _mapString(user?['last_name']);

    final fullName = '$firstName $lastName'.trim();

    if (fullName.isNotEmpty) {
      return fullName;
    }

    // ----------------------------------------------------------
    // Fallback
    // ----------------------------------------------------------

    return 'Chat';
  }
  // ============================================================
  // EXTRACT USER
  // ============================================================

  Map<String, dynamic>? _extractUser(VendorChatDetailChatInfoModel? chat) {
    return null;
  }

  // ============================================================
  // PRODUCT MAP
  // ============================================================

  Map<String, dynamic> _productToMap(dynamic product) {
    if (product is Map<String, dynamic>) {
      return product;
    }

    if (product is Map) {
      return Map<String, dynamic>.from(product);
    }

    try {
      final dynamic json = product.toJson();

      if (json is Map<String, dynamic>) {
        return json;
      }

      if (json is Map) {
        return Map<String, dynamic>.from(json);
      }
    } catch (_) {
      // Ignore conversion error.
    }

    return <String, dynamic>{};
  }

  // ============================================================
  // STRING HELPER
  // ============================================================

  String _mapString(dynamic value) {
    if (value == null) {
      return '';
    }

    return value.toString().trim();
  }

  // ============================================================
  // TIME FORMAT
  // ============================================================

  String _formatMessageTime(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '';
    }

    try {
      final date = DateTime.parse(value.replaceFirst(' ', 'T'));

      final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;

      final minute = date.minute.toString().padLeft(2, '0');

      final period = date.hour >= 12 ? 'PM' : 'AM';

      return '$hour:$minute $period';
    } catch (_) {
      return value;
    }
  }
}
