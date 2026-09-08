// lib/features/chat/data/models/chat_message.dart
class ChatMessage {
  final String id;
  final String conversationId;
  final String senderId;
  final String senderName;
  final bool isVendor; // true = vendor, false = customer
  final String message;
  final String timestamp;
  final bool isRead;

  ChatMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.senderName,
    required this.isVendor,
    required this.message,
    required this.timestamp,
    this.isRead = false,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] ?? '',
      conversationId: json['conversation_id'] ?? json['conversationId'] ?? '',
      senderId: json['sender_id'] ?? json['senderId'] ?? '',
      senderName: json['sender_name'] ?? json['senderName'] ?? '',
      isVendor: json['is_vendor'] ?? json['isVendor'] ?? false,
      message: json['message'] ?? '',
      timestamp: json['timestamp'] ?? '',
      isRead: json['is_read'] ?? json['isRead'] ?? false,
    );
  }
}
