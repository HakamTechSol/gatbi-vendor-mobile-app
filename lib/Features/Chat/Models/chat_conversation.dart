// lib/features/chat/data/models/chat_conversation.dart
class ChatConversation {
  final String id;
  final String customerName;
  final String customerEmail;
  final String? customerAvatar;
  final String lastMessage;
  final String lastMessageTime;
  final String productName;
  final int unreadCount;
  final bool isOnline;
  final String status; // 'read' or 'unread'

  ChatConversation({
    required this.id,
    required this.customerName,
    required this.customerEmail,
    this.customerAvatar,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.productName,
    this.unreadCount = 0,
    this.isOnline = false,
    this.status = 'read',
  });

  factory ChatConversation.fromJson(Map<String, dynamic> json) {
    return ChatConversation(
      id: json['id'] ?? '',
      customerName: json['customer_name'] ?? json['customerName'] ?? '',
      customerEmail: json['customer_email'] ?? json['customerEmail'] ?? '',
      customerAvatar: json['customer_avatar'] ?? json['customerAvatar'],
      lastMessage: json['last_message'] ?? json['lastMessage'] ?? '',
      lastMessageTime:
          json['last_message_time'] ?? json['lastMessageTime'] ?? '',
      productName: json['product_name'] ?? json['productName'] ?? '',
      unreadCount: json['unread_count'] ?? json['unreadCount'] ?? 0,
      isOnline: json['is_online'] ?? json['isOnline'] ?? false,
      status: json['status'] ?? 'read',
    );
  }
}
