class CampaignTypeModel {
  const CampaignTypeModel({
    this.id,
    this.name,
    this.automated,
    this.description,
  });

  // ============================================================
  // Fields
  // ============================================================

  final String? id;
  final String? name;
  final bool? automated;
  final String? description;

  // ============================================================
  // From JSON
  // ============================================================

  factory CampaignTypeModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const CampaignTypeModel();
    }

    return CampaignTypeModel(
      id: _parseString(json['id']),
      name: _parseString(json['name']),
      automated: _parseBool(json['automated']),
      description: _parseString(json['description']),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'automated': automated,
      'description': description,
    };
  }

  // ============================================================
  // Parsers
  // ============================================================

  static String? _parseString(dynamic value) {
    if (value == null) return null;

    if (value is String) {
      return value;
    }

    return value.toString();
  }

  static bool? _parseBool(dynamic value) {
    if (value == null) return null;

    if (value is bool) {
      return value;
    }

    if (value is String) {
      final normalized = value.toLowerCase().trim();

      if (normalized == 'true' || normalized == '1') {
        return true;
      }

      if (normalized == 'false' || normalized == '0') {
        return false;
      }
    }

    if (value is num) {
      return value != 0;
    }

    return null;
  }
}
