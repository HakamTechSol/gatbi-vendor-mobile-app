class VendorChatMessageModel {
  const VendorChatMessageModel({
    this.id,
    this.conversationId,
    this.senderId,
    this.senderType,
    this.message,
    this.isRead,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final int? conversationId;
  final int? senderId;
  final String? senderType;
  final String? message;
  final int? isRead;
  final String? createdAt;
  final String? updatedAt;

  // ============================================================
  // Helpers
  // ============================================================

  bool get isMerchant => senderType == 'merchant';

  bool get isUser => senderType == 'user';

  bool get read => isRead == 1;

  // ============================================================
  // From JSON
  // ============================================================

  factory VendorChatMessageModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const VendorChatMessageModel();
    }

    return VendorChatMessageModel(
      id: _parseInt(json['id']),
      conversationId: _parseInt(json['conversation_id']),
      senderId: _parseInt(json['sender_id']),
      senderType: _parseString(json['sender_type']),
      message: _parseString(json['message']),
      isRead: _parseInt(json['is_read']),
      createdAt: _parseString(json['created_at']),
      updatedAt: _parseString(json['updated_at']),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversation_id': conversationId,
      'sender_id': senderId,
      'sender_type': senderType,
      'message': message,
      'is_read': isRead,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  // ============================================================
  // Parsers
  // ============================================================

  static int? _parseInt(dynamic value) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value);
    }

    return null;
  }

  static String? _parseString(dynamic value) {
    if (value == null) {
      return null;
    }

    final result = value.toString().trim();

    return result.isEmpty ? null : result;
  }
}
