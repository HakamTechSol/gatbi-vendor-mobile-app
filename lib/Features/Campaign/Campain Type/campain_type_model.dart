class CampaignsModel {
  const CampaignsModel({
    this.success = false,
    this.campaignTypes = const [],
    this.notes,
  });

  final bool success;
  final List<CampaignTypeModel> campaignTypes;
  final String? notes;

  factory CampaignsModel.fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return const CampaignsModel();
    }

    return CampaignsModel(
      success: _parseBool(json['success']),
      campaignTypes: _parseCampaignTypes(
        json['campaign_types'],
      ),
      notes: _parseString(json['notes']),
    );
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is num) {
      return value != 0;
    }

    if (value is String) {
      final normalized = value.trim().toLowerCase();

      if (normalized == 'true' || normalized == '1') {
        return true;
      }

      if (normalized == 'false' || normalized == '0') {
        return false;
      }
    }

    return false;
  }

  static String? _parseString(dynamic value) {
    if (value == null) {
      return null;
    }

    final stringValue = value.toString().trim();

    if (stringValue.isEmpty) {
      return null;
    }

    return stringValue;
  }

  static List<CampaignTypeModel> _parseCampaignTypes(
    dynamic value,
  ) {
    if (value is! List) {
      return const [];
    }

    return value
        .whereType<Map>()
        .map(
          (item) => CampaignTypeModel.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }
}

class CampaignTypeModel {
  const CampaignTypeModel({
    this.id,
    this.name,
  });

  final String? id;
  final String? name;

  factory CampaignTypeModel.fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return const CampaignTypeModel();
    }

    return CampaignTypeModel(
      id: _parseString(json['id']),
      name: _parseString(json['name']),
    );
  }

  static String? _parseString(dynamic value) {
    if (value == null) {
      return null;
    }

    final stringValue = value.toString().trim();

    if (stringValue.isEmpty) {
      return null;
    }

    return stringValue;
  }
}