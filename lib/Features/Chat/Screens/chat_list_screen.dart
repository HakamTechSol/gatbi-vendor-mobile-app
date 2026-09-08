// lib/features/chat/presentation/screens/chat_list_screen.dart
import 'package:flutter/material.dart';
import '../../../../Theme/app_colors.dart';
import '../Reuse Widgets/chat_header.dart';
import '../Reuse Widgets/chat_list_item.dart';
import '../Reuse Widgets/chat_loading.dart';
import '../Reuse Widgets/empty_chat_state.dart';
import '../Reuse Widgets/searching/search_bar.dart';
import '../Reuse Widgets/searching/search_empty_state.dart';
import 'chat_detail_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen>
    with SingleTickerProviderStateMixin {
  // Sample conversations data
  final List<Map<String, dynamic>> _allConversations = [
    {
      'id': '1',
      'customerName': 'Irfan Alam',
      'customerEmail': 'malikirfanalam@outlook.com',
      'customerAvatar': null,
      'lastMessage': 'hi',
      'lastMessageTime': 'Aug 28, 2026',
      'productName': 'General Inquiry',
      'unreadCount': 0,
      'isOnline': false,
      'status': 'read',
    },
    {
      'id': '2',
      'customerName': 'Sarah Ahmed',
      'customerEmail': 'sarah.ahmed@email.com',
      'customerAvatar': null,
      'lastMessage': 'When will my order arrive?',
      'lastMessageTime': 'Aug 27, 2026',
      'productName': 'Premium Phone Case',
      'unreadCount': 3,
      'isOnline': true,
      'status': 'unread',
    },
    {
      'id': '3',
      'customerName': 'Mohammad Khan',
      'customerEmail': 'mkhan@email.com',
      'customerAvatar': null,
      'lastMessage': 'Thanks for the great service!',
      'lastMessageTime': 'Aug 26, 2026',
      'productName': 'Wireless Earbuds',
      'unreadCount': 0,
      'isOnline': false,
      'status': 'read',
    },
    {
      'id': '4',
      'customerName': 'Fatima Noor',
      'customerEmail': 'fatima.noor@email.com',
      'customerAvatar': null,
      'lastMessage': 'Can I get a discount code?',
      'lastMessageTime': 'Aug 25, 2026',
      'productName': 'Smart Watch',
      'unreadCount': 1,
      'isOnline': false,
      'status': 'unread',
    },
    {
      'id': '5',
      'customerName': 'Ali Hassan',
      'customerEmail': 'ali.hassan@email.com',
      'customerAvatar': null,
      'lastMessage': 'Order confirmed, thank you!',
      'lastMessageTime': 'Aug 24, 2026',
      'productName': 'Laptop Bag',
      'unreadCount': 0,
      'isOnline': true,
      'status': 'read',
    },
  ];

  List<Map<String, dynamic>> _filteredConversations = [];
  bool _isLoading = false;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredConversations = _allConversations;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    setState(() {
      if (query.trim().isEmpty) {
        _filteredConversations = _allConversations;
        return;
      }

      final lowercaseQuery = query.toLowerCase().trim();
      _filteredConversations = _allConversations.where((conversation) {
        final customerName = conversation['customerName']?.toLowerCase() ?? '';
        final customerEmail =
            conversation['customerEmail']?.toLowerCase() ?? '';
        final productName = conversation['productName']?.toLowerCase() ?? '';
        final lastMessage = conversation['lastMessage']?.toLowerCase() ?? '';

        return customerName.contains(lowercaseQuery) ||
            customerEmail.contains(lowercaseQuery) ||
            productName.contains(lowercaseQuery) ||
            lastMessage.contains(lowercaseQuery);
      }).toList();
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _filteredConversations = _allConversations;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // App Bar
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
          // Search Bar
          if (_isSearching)
            ChatSearchBar(
              controller: _searchController,
              onSearch: _performSearch,
              onClose: _toggleSearch,
            ),
          // Content
          Expanded(child: _isLoading ? const ChatLoading() : _buildContent()),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_filteredConversations.isEmpty) {
      if (_isSearching && _searchController.text.isNotEmpty) {
        return SearchEmptyState(searchQuery: _searchController.text);
      }
      return const EmptyChatState();
    }

    return _buildConversationList();
  }

  Widget _buildConversationList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: _filteredConversations.length,
      separatorBuilder: (context, index) =>
          const Divider(height: 1, color: AppColors.divider),
      itemBuilder: (context, index) {
        final conversation = _filteredConversations[index];

        // Check if this conversation matches the search query
        final isHighlighted =
            _isSearching &&
            _searchController.text.isNotEmpty &&
            _matchesSearch(conversation, _searchController.text);

        return ChatListItem(
          customerName: conversation['customerName']!,
          customerEmail: conversation['customerEmail']!,
          customerAvatar: conversation['customerAvatar'],
          lastMessage: conversation['lastMessage']!,
          lastMessageTime: conversation['lastMessageTime']!,
          productName: conversation['productName']!,
          unreadCount: conversation['unreadCount'] ?? 0,
          isOnline: conversation['isOnline'] ?? false,
          status: conversation['status'] ?? 'read',
          isHighlighted: isHighlighted,
          searchQuery: isHighlighted ? _searchController.text : '',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ChatDetailScreen(),
                settings: RouteSettings(arguments: conversation),
              ),
            ).then((_) {
              // Refresh data when returning
              _performSearch(_searchController.text);
            });
          },
        );
      },
    );
  }

  bool _matchesSearch(Map<String, dynamic> conversation, String query) {
    final lowercaseQuery = query.toLowerCase().trim();
    final customerName = conversation['customerName']?.toLowerCase() ?? '';
    final customerEmail = conversation['customerEmail']?.toLowerCase() ?? '';
    final productName = conversation['productName']?.toLowerCase() ?? '';
    final lastMessage = conversation['lastMessage']?.toLowerCase() ?? '';

    return customerName.contains(lowercaseQuery) ||
        customerEmail.contains(lowercaseQuery) ||
        productName.contains(lowercaseQuery) ||
        lastMessage.contains(lowercaseQuery);
  }
}
