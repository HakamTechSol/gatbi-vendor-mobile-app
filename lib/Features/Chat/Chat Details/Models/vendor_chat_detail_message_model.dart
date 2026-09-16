import 'vendor_chat_detail_product_model.dart';

class VendorChatDetailMessageModel {
  const VendorChatDetailMessageModel({
    this.id,
    this.conversationId,
    this.senderId,
    this.senderType,
    this.message,
    this.isRead,
    this.createdAt,
    this.senderName,
    this.type,
    this.productCard,
  });

  final int? id;
  final int? conversationId;
  final int? senderId;
  final String? senderType;
  final String? message;
  final int? isRead;
  final String? createdAt;
  final String? senderName;
  final String? type;
  final VendorChatDetailProductModel? productCard;

  // ============================================================
  // Helpers
  // ============================================================

  bool get isText => type == 'text';

  bool get isProductCard => type == 'product_card';

  bool get isMerchant => senderType == 'merchant';

  bool get isUser => senderType == 'user';

  bool get read => isRead == 1;

  // ============================================================
  // From JSON
  // ============================================================

  factory VendorChatDetailMessageModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const VendorChatDetailMessageModel();
    }

    return VendorChatDetailMessageModel(
      id: _parseInt(json['id']),
      conversationId: _parseInt(json['conversation_id']),
      senderId: _parseInt(json['sender_id']),
      senderType: _parseString(json['sender_type']),
      message: _parseString(json['message']),
      isRead: _parseInt(json['is_read']),
      createdAt: _parseString(json['created_at']),
      senderName: _parseString(json['sender_name']),
      type: _parseString(json['type']),
      productCard: json['product_card'] is Map
          ? VendorChatDetailProductModel.fromJson(
              Map<String, dynamic>.from(json['product_card'] as Map),
            )
          : null,
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
      'sender_name': senderName,
      'type': type,
      'product_card': productCard?.toJson(),
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
