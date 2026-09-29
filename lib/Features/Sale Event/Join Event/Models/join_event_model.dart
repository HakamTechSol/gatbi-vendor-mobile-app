class JoinEventModel {
  const JoinEventModel({
    this.success = false,
    this.message,
    this.campaignId,
    this.ticketId,
    this.status,
  });

  final bool success;
  final String? message;
  final int? campaignId;
  final int? ticketId;
  final String? status;

  // ============================================================
  // From JSON
  // ============================================================

  factory JoinEventModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const JoinEventModel();
    }

    return JoinEventModel(
      success: _parseBool(json['success']),
      message: json['message']?.toString(),
      campaignId: _parseInt(json['campaign_id']),
      ticketId: _parseInt(json['ticket_id']),
      status: json['status']?.toString(),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'campaign_id': campaignId,
      'ticket_id': ticketId,
      'status': status,
    };
  }

  // ============================================================
  // Parse Bool
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
  // Parse Int
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
}
