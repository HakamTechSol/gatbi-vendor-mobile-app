// ============================================================
// Create Campaign Request Model
// ============================================================

class CreateCampaignRequestModel {
  const CreateCampaignRequestModel({
    required this.campaignType,
    required this.productIds,
    required this.startDate,
    required this.endDate,
    required this.notes,
  });

  final String campaignType;
  final String productIds;
  final String startDate;
  final String endDate;
  final String notes;

  Map<String, dynamic> toJson() {
    return {
      'campaign_type': campaignType,
      'product_ids': productIds,
      'start_date': startDate,
      'end_date': endDate,
      'notes': notes,
    };
  }
}

// ============================================================
// Create Campaign Response Model
// ============================================================

class CreateCampaignModel {
  const CreateCampaignModel({
    this.success = false,
    this.message,
    this.campaignId,
    this.ticketId,
    this.ticketNumber,
    this.status,
  });

  final bool success;
  final String? message;
  final int? campaignId;
  final int? ticketId;
  final String? ticketNumber;
  final String? status;

  factory CreateCampaignModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const CreateCampaignModel();
    }

    return CreateCampaignModel(
      success: _parseBool(json['success']),
      message: _parseString(json['message']),
      campaignId: _parseInt(json['campaign_id']),
      ticketId: _parseInt(json['ticket_id']),
      ticketNumber: _parseString(json['ticket_number']),
      status: _parseString(json['status']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'campaign_id': campaignId,
      'ticket_id': ticketId,
      'ticket_number': ticketNumber,
      'status': status,
    };
  }

  // ==========================================================
  // Parsers
  // ==========================================================

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

    return value.toString();
  }
}
