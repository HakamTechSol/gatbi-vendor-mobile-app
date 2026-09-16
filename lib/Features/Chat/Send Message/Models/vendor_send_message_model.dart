import 'vendor_chat_message_model.dart';

class VendorSendMessageModel {
  const VendorSendMessageModel({this.success = false, this.message, this.data});

  final bool success;
  final String? message;
  final VendorChatMessageModel? data;

  // ============================================================
  // From JSON
  // ============================================================

  factory VendorSendMessageModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const VendorSendMessageModel();
    }

    return VendorSendMessageModel(
      success: _parseBool(json['success']),
      message: _parseString(json['message']),
      data: json['data'] is Map
          ? VendorChatMessageModel.fromJson(
              Map<String, dynamic>.from(json['data'] as Map),
            )
          : null,
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data?.toJson()};
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

  static String? _parseString(dynamic value) {
    if (value == null) {
      return null;
    }

    final result = value.toString().trim();

    return result.isEmpty ? null : result;
  }
}
