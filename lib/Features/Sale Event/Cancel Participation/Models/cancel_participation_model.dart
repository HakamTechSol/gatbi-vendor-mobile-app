class CancelParticipationModel {
  const CancelParticipationModel({
    this.success = false,
    this.message,
    this.eventId,
    this.campaignId,
    this.status,
  });

  // ============================================================
  // Response Fields
  // ============================================================

  final bool success;

  final String? message;

  final int? eventId;

  final int? campaignId;

  final String? status;

  // ============================================================
  // From JSON
  // ============================================================

  factory CancelParticipationModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const CancelParticipationModel();
    }

    return CancelParticipationModel(
      success: _parseBool(json['success']),
      message: json['message']?.toString(),
      eventId: _parseInt(json['event_id']),
      campaignId: _parseInt(json['campaign_id']),
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
      'event_id': eventId,
      'campaign_id': campaignId,
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
