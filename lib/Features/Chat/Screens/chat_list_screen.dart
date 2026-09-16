// lib/features/chat/presentation/screens/chat_list_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Theme/app_colors.dart';

import '../Chat List/Controller/vendor_chat_controller.dart';
import '../Chat List/Controller/vendor_chat_state.dart';
import '../Chat List/Models/vendor_chat_model.dart';

import '../Reuse Widgets/chat_header.dart';
import '../Reuse Widgets/chat_list_item.dart';
import '../Reuse Widgets/chat_loading.dart';
import '../Reuse Widgets/empty_chat_state.dart';
import '../Reuse Widgets/searching/search_bar.dart';
import '../Reuse Widgets/searching/search_empty_state.dart';

import 'chat_detail_screen.dart';

class ChatListScreen extends ConsumerStatefulWidget {
  const ChatListScreen({super.key});

  @override
  ChatListScreenState createState() => ChatListScreenState();
}

class ChatListScreenState extends ConsumerState<ChatListScreen> {
  // ============================================================
  // Controllers
  // ============================================================

  final TextEditingController _searchController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  // ============================================================
  // Local UI State
  // ============================================================

  bool _isSearching = false;

  // ============================================================
  // Init
  // ============================================================

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      ref.read(vendorChatControllerProvider.notifier).loadChats();
    });
  }

  // ============================================================
  // Scroll Listener
  // ============================================================

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final position = _scrollController.position;

    // ----------------------------------------------------------
    // Start pagination slightly before reaching the bottom.
    // This gives smoother UX.
    // ----------------------------------------------------------

    const threshold = 250.0;

    if (position.pixels >= position.maxScrollExtent - threshold) {
      ref.read(vendorChatControllerProvider.notifier).loadMoreChats();
    }
  }

  // ============================================================
  // Search
  // ============================================================

  void _performSearch(String query) {
    ref.read(vendorChatControllerProvider.notifier).searchChats(query);
  }

  // ============================================================
  // Toggle Search
  // ============================================================

  void _toggleSearch() {
    if (_isSearching) {
      _closeSearch();
      return;
    }

    setState(() {
      _isSearching = true;
    });
  }

  // ============================================================
  // Close Search
  // ============================================================

  void _closeSearch() {
    _searchController.clear();

    ref.read(vendorChatControllerProvider.notifier).clearSearch();

    if (!mounted) return;

    setState(() {
      _isSearching = false;
    });
  }

  // ============================================================
  // Refresh
  // ============================================================

  Future<void> _refreshChats() async {
    await ref.read(vendorChatControllerProvider.notifier).refreshChats();
  }

  Future<void> refresh() async {
    await _refreshChats();

    if (!mounted) {
      return;
    }
  }

  // ============================================================
  // Open Chat
  // ============================================================

  Future<void> _openChat(VendorChatModel chat) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatDetailScreen(chatId: chat.id!),
        settings: RouteSettings(arguments: chat),
      ),
    );

    // ----------------------------------------------------------
    // User may have sent a new message / unread count changed.
    // Refresh page 1 when returning from detail.
    // ----------------------------------------------------------

    if (!mounted) return;

    await ref.read(vendorChatControllerProvider.notifier).refreshChats();
  }

  // ============================================================
  // Dispose
  // ============================================================

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();

    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(vendorChatControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ======================================================
          // HEADER
          // ======================================================
          ChatHeader(
            title: 'Messages',
            showBackButton: false,
            actions: [
              if (!_isSearching) ...[
                IconButton(
                  onPressed: _toggleSearch,
                  icon: const Icon(Icons.search_rounded),
                  tooltip: 'Search messages',
                  splashRadius: 22,
                ),
                const SizedBox(width: 4),
              ],
            ],
          ),

          // ======================================================
          // SEARCH
          // ======================================================
          if (_isSearching)
            ChatSearchBar(
              controller: _searchController,
              onSearch: _performSearch,
              onClose: _closeSearch,
            ),

          // ======================================================
          // CONTENT
          // ======================================================
          Expanded(child: _buildBody(state)),
        ],
      ),
    );
  }

  // ============================================================
  // BODY
  // ============================================================

  Widget _buildBody(VendorChatState state) {
    if (state.isLoading) {
      return const ChatLoading(itemCount: 12);
    }

    // ============================================================
    // Error + No Data
    // ============================================================

    if (state.errorMessage != null && state.chats.isEmpty) {
      return _buildErrorState(state.errorMessage!);
    }

    // ============================================================
    // Search Empty
    // ============================================================

    if (state.searchQuery.trim().isNotEmpty && state.filteredChats.isEmpty) {
      return SearchEmptyState(searchQuery: state.searchQuery);
    }

    // ============================================================
    // API Empty
    // ============================================================

    if (state.filteredChats.isEmpty) {
      return const EmptyChatState();
    }

    // ============================================================
    // Chat List
    // ============================================================

    return _buildConversationList(state);
  }
  // ============================================================
  // CHAT LIST
  // ============================================================

  Widget _buildConversationList(VendorChatState state) {
  final chats = state.filteredChats;

  final itemCount = chats.length + (state.isLoadingMore ? 1 : 0);

  return RefreshIndicator(
    color: AppColors.primary,
    backgroundColor: AppColors.white,
    onRefresh: _refreshChats,
    child: ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),

      // No default top/bottom padding.
      padding: EdgeInsets.zero,

      itemCount: itemCount,

      itemBuilder: (context, index) {
        // ====================================================
        // PAGINATION LOADER
        // ====================================================

        if (index >= chats.length) {
          return const SizedBox(
            height: 60,
            child: ChatLoading(
              compact: true,
              size: 26,
            ),
          );
        }

        // ====================================================
        // CHAT
        // ====================================================

        final chat = chats[index];

        final user = chat.user;
        final product = chat.product;

        final customerName = _getCustomerName(chat);

        final customerEmail = user?.email ?? '';

        final productName = product?.name ?? 'Product Inquiry';

        final lastMessage = chat.lastMessage ?? 'No messages yet';

        final lastMessageTime =
            _formatChatDate(chat.lastMessageAt);

        final searchQuery = state.searchQuery.trim();

        final isHighlighted =
            searchQuery.isNotEmpty &&
            chat.searchableText.contains(
              searchQuery.toLowerCase(),
            );

        return Padding(
          padding: EdgeInsets.only(
            top: 3,
            bottom: index == chats.length - 1 ? 0 : 1,
          ),
          child: ChatListItem(
            customerName: customerName,
            customerEmail: customerEmail,
            customerAvatar: null,
            lastMessage: lastMessage,
            lastMessageTime: lastMessageTime,
            productName: productName,
            unreadCount: chat.unreadCount,

            // API does not currently provide online status.
            isOnline: false,

            status: chat.unreadCount > 0
                ? 'unread'
                : 'read',

            isHighlighted: isHighlighted,
            searchQuery: isHighlighted
                ? searchQuery
                : '',

            onTap: () => _openChat(chat),
          ),
        );
      },
    ),
  );
}
  // ============================================================
  // CUSTOMER NAME
  // ============================================================

  String _getCustomerName(VendorChatModel chat) {
    final user = chat.user;

    final name = user?.name?.trim();

    if (name != null && name.isNotEmpty) {
      return name;
    }

    final firstName = user?.firstName?.trim() ?? '';

    final lastName = user?.lastName?.trim() ?? '';

    final fullName = [
      firstName,
      lastName,
    ].where((value) => value.isNotEmpty).join(' ').trim();

    if (fullName.isNotEmpty) {
      return fullName;
    }

    return 'Customer';
  }

  // ============================================================
  // DATE FORMAT
  // ============================================================

  String _formatChatDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return '';
    }

    DateTime? date;

    try {
      date = DateTime.parse(value.replaceFirst(' ', 'T'));
    } catch (_) {
      return value;
    }

    final now = DateTime.now();

    // ----------------------------------------------------------
    // Today
    // ----------------------------------------------------------

    final isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;

    if (isToday) {
      final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;

      final minute = date.minute.toString().padLeft(2, '0');

      final period = date.hour >= 12 ? 'PM' : 'AM';

      return '$hour:$minute $period';
    }

    // ----------------------------------------------------------
    // Yesterday
    // ----------------------------------------------------------

    final yesterday = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(const Duration(days: 1));

    final isYesterday =
        date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;

    if (isYesterday) {
      return 'Yesterday';
    }

    // ----------------------------------------------------------
    // Same Year
    // ----------------------------------------------------------

    if (date.year == now.year) {
      return '${_monthName(date.month)} ${date.day}';
    }

    // ----------------------------------------------------------
    // Previous Year
    // ----------------------------------------------------------

    return '${_monthName(date.month)} ${date.day}, ${date.year}';
  }

  // ============================================================
  // MONTH
  // ============================================================

  String _monthName(int month) {
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

    if (month < 1 || month > 12) {
      return '';
    }

    return months[month - 1];
  }

  // ============================================================
  // ERROR STATE
  // ============================================================

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: AppColors.softGradient,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.cloud_off_rounded,
                size: 48,
                color: AppColors.primary.withOpacity(0.55),
              ),
            ),

            const SizedBox(height: 22),

            Text(
              'Unable to Load Messages',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: () {
                ref.read(vendorChatControllerProvider.notifier).loadChats();
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
