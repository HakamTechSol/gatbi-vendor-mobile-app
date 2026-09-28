class CampaignTypeModel {
  const CampaignTypeModel({
    this.success = false,
    this.campaignTypes = const [],
  });

  final bool success;
  final List<CampaignTypeData> campaignTypes;

  factory CampaignTypeModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const CampaignTypeModel();
    }

    return CampaignTypeModel(
      success: _parseBool(json['success']),
      campaignTypes: _parseList(
        json['campaign_types'],
        CampaignTypeData.fromJson,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'campaign_types': campaignTypes.map((e) => e.toJson()).toList(),
    };
  }

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
// Campaign Type Data
// ============================================================

class CampaignTypeData {
  const CampaignTypeData({
    this.id,
    this.name,
    this.description,
    this.automated = false,
    this.isActive = false,
    this.sortOrder,
  });

  final String? id;
  final String? name;
  final String? description;
  final bool automated;
  final bool isActive;
  final int? sortOrder;

  factory CampaignTypeData.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const CampaignTypeData();
    }

    return CampaignTypeData(
      id: _parseString(json['id']),
      name: _parseString(json['name']),
      description: _parseString(json['description']),
      automated: _parseBool(json['automated']),
      isActive: _parseBool(json['is_active']),
      sortOrder: _parseInt(json['sort_order']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'automated': automated,
      'is_active': isActive,
      'sort_order': sortOrder,
    };
  }

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
