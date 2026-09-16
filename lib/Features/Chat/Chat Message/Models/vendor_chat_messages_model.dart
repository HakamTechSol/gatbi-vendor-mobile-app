class VendorChatMessagesModel {
  const VendorChatMessagesModel({
    this.success = false,
    this.messages = const [],
    this.pagination,
  });

  // ============================================================
  // Main Response Fields
  // ============================================================

  final bool success;
  final List<VendorChatMessageModel> messages;
  final VendorChatMessagesPaginationModel? pagination;

  // ============================================================
  // From JSON
  // ============================================================

  factory VendorChatMessagesModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const VendorChatMessagesModel();
    }

    return VendorChatMessagesModel(
      success: _parseBool(json['success']),
      messages: _parseList(json['messages'], VendorChatMessageModel.fromJson),
      pagination: json['pagination'] is Map
          ? VendorChatMessagesPaginationModel.fromJson(
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
      'messages': messages.map((message) => message.toJson()).toList(),
      'pagination': pagination?.toJson(),
    };
  }

  // ============================================================
  // Parse Boolean
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

  // ============================================================
  // Parse List
  // ============================================================

  static List<T> _parseList<T>(
    dynamic value,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (value is! List) {
      return const [];
    }

    return value
        .whereType<Map>()
        .map((item) => fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }
}

// ============================================================
// Message Model
// ============================================================

class VendorChatMessageModel {
  const VendorChatMessageModel({
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

  // ============================================================
  // Fields
  // ============================================================

  final int? id;
  final int? conversationId;
  final int? senderId;
  final String? senderType;
  final String? message;
  final int? isRead;
  final String? createdAt;
  final String? senderName;
  final String? type;
  final VendorChatProductCardModel? productCard;

  // ============================================================
  // Helpers
  // ============================================================

  bool get isMerchant {
    return senderType?.toLowerCase() == 'merchant';
  }

  bool get isUser {
    return senderType?.toLowerCase() == 'user';
  }

  bool get isText {
    return type?.toLowerCase() == 'text';
  }

  bool get isProductCard {
    return type?.toLowerCase() == 'product_card';
  }

  bool get read {
    return isRead == 1;
  }

  bool get unread {
    return isRead == 0;
  }

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
      senderName: _parseString(json['sender_name']),
      type: _parseString(json['type']),
      productCard: json['product_card'] is Map
          ? VendorChatProductCardModel.fromJson(
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

    return value.toString();
  }
}

// ============================================================
// Product Card Model
// ============================================================

class VendorChatProductCardModel {
  const VendorChatProductCardModel({
    this.id,
    this.name,
    this.slug,
    this.price,
    this.oldPrice,
    this.currency,
    this.heroImageUrl,
    this.productUrl,
    this.merchantName,
  });

  // ============================================================
  // Fields
  // ============================================================

  final int? id;
  final String? name;
  final String? slug;
  final num? price;
  final num? oldPrice;
  final String? currency;
  final String? heroImageUrl;
  final String? productUrl;
  final String? merchantName;

  // ============================================================
  // From JSON
  // ============================================================

  factory VendorChatProductCardModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const VendorChatProductCardModel();
    }

    return VendorChatProductCardModel(
      id: _parseInt(json['id']),
      name: _parseString(json['name']),
      slug: _parseString(json['slug']),
      price: _parseNum(json['price']),
      oldPrice: _parseNum(json['old_price']),
      currency: _parseString(json['currency']),
      heroImageUrl: _parseString(json['hero_image_url']),
      productUrl: _parseString(json['product_url']),
      merchantName: _parseString(json['merchant_name']),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'price': price,
      'old_price': oldPrice,
      'currency': currency,
      'hero_image_url': heroImageUrl,
      'product_url': productUrl,
      'merchant_name': merchantName,
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

  static num? _parseNum(dynamic value) {
    if (value is num) {
      return value;
    }

    if (value is String) {
      return num.tryParse(value);
    }

    return null;
  }

  static String? _parseString(dynamic value) {
    if (value == null) {
      return null;
    }

    return value.toString();
  }
}

// ============================================================
// Pagination Model
// ============================================================

class VendorChatMessagesPaginationModel {
  const VendorChatMessagesPaginationModel({
    this.currentPage = 1,
    this.totalItems = 0,
    this.limit = 50,
  });

  final int currentPage;
  final int totalItems;
  final int limit;

  // ============================================================
  // From JSON
  // ============================================================

  factory VendorChatMessagesPaginationModel.fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return const VendorChatMessagesPaginationModel();
    }

    return VendorChatMessagesPaginationModel(
      currentPage: _parseInt(json['current_page']) ?? 1,
      totalItems: _parseInt(json['total_items']) ?? 0,
      limit: _parseInt(json['limit']) ?? 50,
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'total_items': totalItems,
      'limit': limit,
    };
  }

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
}
