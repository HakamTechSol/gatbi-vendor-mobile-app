import 'vendor_chat_model.dart';
import 'vendor_chat_pagination_model.dart';

class VendorChatsModel {
  const VendorChatsModel({
    this.success = false,
    this.chats = const [],
    this.unreadTotal = 0,
    this.pagination,
  });

  // ============================================================
  // Main Response Fields
  // ============================================================

  final bool success;
  final List<VendorChatModel> chats;
  final int unreadTotal;
  final VendorChatPaginationModel? pagination;

  // ============================================================
  // From JSON
  // ============================================================

  factory VendorChatsModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const VendorChatsModel();
    }

    return VendorChatsModel(
      success: _parseBool(json['success']),
      chats: _parseChats(json['chats']),
      unreadTotal: _parseInt(json['unread_total']) ?? 0,
      pagination: json['pagination'] is Map
          ? VendorChatPaginationModel.fromJson(
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
      'chats': chats.map((e) => e.toJson()).toList(),
      'unread_total': unreadTotal,
      'pagination': pagination?.toJson(),
    };
  }

  // ============================================================
  // Helpers
  // ============================================================

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;

    if (value is String) {
      final normalized = value.toLowerCase().trim();

      return normalized == 'true' || normalized == '1' || normalized == 'yes';
    }

    if (value is num) {
      return value != 0;
    }

    return false;
  }

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

  static List<VendorChatModel> _parseChats(dynamic value) {
    if (value is! List) {
      return const [];
    }

    return value
        .whereType<Map>()
        .map(
          (item) => VendorChatModel.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();
  }
}