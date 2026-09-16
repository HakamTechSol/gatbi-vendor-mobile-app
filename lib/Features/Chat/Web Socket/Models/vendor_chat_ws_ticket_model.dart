class VendorChatWsTicketModel {
  const VendorChatWsTicketModel({
    this.success = false,
    this.token,
    this.expiresIn,
    this.publicUrl,
  });

  // ============================================================
  // Response Fields
  // ============================================================

  final bool success;
  final String? token;
  final int? expiresIn;
  final String? publicUrl;

  // ============================================================
  // From JSON
  // ============================================================

  factory VendorChatWsTicketModel.fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return const VendorChatWsTicketModel();
    }

    return VendorChatWsTicketModel(
      success: _parseBool(json['success']),
      token: _parseString(json['token']),
      expiresIn: _parseInt(json['expires_in']),
      publicUrl: _parseString(json['public_url']),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'token': token,
      'expires_in': expiresIn,
      'public_url': publicUrl,
    };
  }

  // ============================================================
  // Helpers
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