import 'vendor_chat_product_model.dart';
import 'vendor_chat_user_model.dart';

class VendorChatModel {
  const VendorChatModel({
    this.id,
    this.user,
    this.product,
    this.lastMessage,
    this.lastMessageAt,
    this.unreadCount = 0,
  });

  // ============================================================
  // Fields
  // ============================================================

  final int? id;
  final VendorChatUserModel? user;
  final VendorChatProductModel? product;
  final String? lastMessage;
  final String? lastMessageAt;
  final int unreadCount;

  // ============================================================
  // From JSON
  // ============================================================

  factory VendorChatModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const VendorChatModel();
    }

    return VendorChatModel(
      id: _parseInt(json['id']),
      user: json['user'] is Map
          ? VendorChatUserModel.fromJson(
              Map<String, dynamic>.from(json['user'] as Map),
            )
          : null,
      product: json['product'] is Map
          ? VendorChatProductModel.fromJson(
              Map<String, dynamic>.from(json['product'] as Map),
            )
          : null,
      lastMessage: _parseString(json['last_message']),
      lastMessageAt: _parseString(json['last_message_at']),
      unreadCount: _parseInt(json['unread_count']) ?? 0,
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user?.toJson(),
      'product': product?.toJson(),
      'last_message': lastMessage,
      'last_message_at': lastMessageAt,
      'unread_count': unreadCount,
    };
  }

  // ============================================================
  // Search Text
  // ============================================================

  String get searchableText {
    return [
          user?.name,
          user?.firstName,
          user?.lastName,
          user?.email,
          product?.name,
          product?.slug,
          product?.merchantName,
          lastMessage,
        ]
        .whereType<String>()
        .where((value) => value.trim().isNotEmpty)
        .join(' ')
        .toLowerCase();
  }

  // ============================================================
  // Helpers
  // ============================================================

  static int? _parseInt(dynamic value) {
    if (value is int) return value;

    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value);
    }

    return null;
  }

  static String? _parseString(dynamic value) {
    if (value == null) return null;

    if (value is String) {
      final result = value.trim();

      return result.isEmpty ? null : result;
    }

    return value.toString();
  }
}
