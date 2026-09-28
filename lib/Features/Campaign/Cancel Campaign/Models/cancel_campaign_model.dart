class CancelCampaignModel {
  const CancelCampaignModel({
    this.success = false,
    this.message,
    this.campaignId,
    this.status,
  });

  final bool success;
  final String? message;
  final int? campaignId;
  final String? status;

  // ============================================================
  // FROM JSON
  // ============================================================

  factory CancelCampaignModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const CancelCampaignModel();
    }

    return CancelCampaignModel(
      success: _parseBool(json['success']),
      message: _parseString(json['message']),
      campaignId: _parseInt(json['campaign_id']),
      status: _parseString(json['status']),
    );
  }

  // ============================================================
  // TO JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'campaign_id': campaignId,
      'status': status,
    };
  }

  // ============================================================
  // PARSE BOOL
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
  // PARSE INT
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

  // ============================================================
  // PARSE STRING
  // ============================================================

  static String? _parseString(dynamic value) {
    if (value == null) {
      return null;
    }

    return value.toString();
  }
}
