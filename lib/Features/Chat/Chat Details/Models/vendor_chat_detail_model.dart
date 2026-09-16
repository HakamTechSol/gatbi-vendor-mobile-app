import 'vendor_chat_detail_message_model.dart';
import 'vendor_chat_detail_pagination_model.dart';
import 'vendor_chat_detail_product_model.dart';

class VendorChatDetailModel {
  const VendorChatDetailModel({
    this.success = false,
    this.chat,
    this.messages = const [],
    this.pagination,
  });

  final bool success;
  final VendorChatDetailChatInfoModel? chat;
  final List<VendorChatDetailMessageModel> messages;
  final VendorChatDetailPaginationModel? pagination;

  // ============================================================
  // From JSON
  // ============================================================

  factory VendorChatDetailModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const VendorChatDetailModel();
    }

    return VendorChatDetailModel(
      success: _parseBool(json['success']),
      chat: json['chat'] is Map
          ? VendorChatDetailChatInfoModel.fromJson(
              Map<String, dynamic>.from(json['chat'] as Map),
            )
          : null,
      messages: _parseMessages(json['messages']),
      pagination: json['pagination'] is Map
          ? VendorChatDetailPaginationModel.fromJson(
              Map<String, dynamic>.from(json['pagination'] as Map),
            )
          : null,
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'chat': chat?.toJson(),
      'messages': messages.map((e) => e.toJson()).toList(),
      'pagination': pagination?.toJson(),
    };
  }

  // ============================================================
  // Parsers
  // ============================================================

  static bool _parseBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }

    if (value is num) {
      return value != 0;
    }

    return false;
  }

  static List<VendorChatDetailMessageModel> _parseMessages(dynamic value) {
    if (value is! List) {
      return const [];
    }

    return value
        .whereType<Map>()
        .map(
          (item) => VendorChatDetailMessageModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }
}

// ============================================================
// Chat Info
// ============================================================

class VendorChatDetailChatInfoModel {
  const VendorChatDetailChatInfoModel({
    this.id,
    this.userId,
    this.merchantId,
    this.productId,
    this.lastMessageAt,
    this.createdAt,
    this.updatedAt,
    this.product,
  });

  final int? id;
  final int? userId;
  final int? merchantId;
  final int? productId;
  final String? lastMessageAt;
  final String? createdAt;
  final String? updatedAt;
  final VendorChatDetailProductModel? product;

  // ============================================================
  // From JSON
  // ============================================================

  factory VendorChatDetailChatInfoModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const VendorChatDetailChatInfoModel();
    }

    return VendorChatDetailChatInfoModel(
      id: _parseInt(json['id']),
      userId: _parseInt(json['user_id']),
      merchantId: _parseInt(json['merchant_id']),
      productId: _parseInt(json['product_id']),
      lastMessageAt: _parseString(json['last_message_at']),
      createdAt: _parseString(json['created_at']),
      updatedAt: _parseString(json['updated_at']),
      product: json['product'] is Map
          ? VendorChatDetailProductModel.fromJson(
              Map<String, dynamic>.from(json['product'] as Map),
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
      'user_id': userId,
      'merchant_id': merchantId,
      'product_id': productId,
      'last_message_at': lastMessageAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'product': product?.toJson(),
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
