class EventsModel {
  const EventsModel({
    this.success = false,
    this.events = const [],
    this.kycStatus,
    this.kycLocked = false,
    this.notes,
  });

  // ============================================================
  // Main Response Fields
  // ============================================================

  final bool success;
  final List<EventItemModel> events;
  final String? kycStatus;
  final bool kycLocked;
  final String? notes;

  // ============================================================
  // From JSON
  // ============================================================

  factory EventsModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const EventsModel();
    }

    return EventsModel(
      success: _parseBool(json['success']),
      events: _parseList(json['events'], EventItemModel.fromJson),
      kycStatus: _parseString(json['kyc_status']),
      kycLocked: _parseBool(json['kyc_locked']),
      notes: _parseString(json['notes']),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'events': events.map((event) => event.toJson()).toList(),
      'kyc_status': kycStatus,
      'kyc_locked': kycLocked,
      'notes': notes,
    };
  }

  // ============================================================
  // Parsers
  // ============================================================

  static bool _parseBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is String) {
      final normalized = value.toLowerCase().trim();

      return normalized == 'true' || normalized == '1' || normalized == 'yes';
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

    if (value is String) {
      return value;
    }

    return value.toString();
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
// Event Item Model
// ============================================================

class EventItemModel {
  const EventItemModel({
    this.id,
    this.name,
    this.slug,
    this.description,
    this.bannerUrl,
    this.bannerMobileUrl,
    this.startDate,
    this.endDate,
    this.minDiscountPercentage,
    this.status,
    this.myParticipation,
  });

  // ============================================================
  // Fields
  // ============================================================

  final int? id;
  final String? name;
  final String? slug;
  final String? description;
  final String? bannerUrl;
  final String? bannerMobileUrl;
  final String? startDate;
  final String? endDate;
  final num? minDiscountPercentage;
  final String? status;

  /// Null when vendor has not participated.
  ///
  /// Example:
  /// {
  ///   "campaign_id": 33,
  ///   "status": "pending",
  ///   "requested_discount_percentage": 15,
  ///   "discount_percentage": null
  /// }
  final MyParticipationModel? myParticipation;

  // ============================================================
  // From JSON
  // ============================================================

  factory EventItemModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const EventItemModel();
    }

    return EventItemModel(
      id: _parseInt(json['id']),
      name: _parseString(json['name']),
      slug: _parseString(json['slug']),
      description: _parseString(json['description']),
      bannerUrl: _parseString(json['banner_url']),
      bannerMobileUrl: _parseString(json['banner_mobile_url']),
      startDate: _parseString(json['start_date']),
      endDate: _parseString(json['end_date']),
      minDiscountPercentage: _parseNum(json['min_discount_percentage']),
      status: _parseString(json['status']),
      myParticipation: _parseParticipation(json['my_participation']),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'banner_url': bannerUrl,
      'banner_mobile_url': bannerMobileUrl,
      'start_date': startDate,
      'end_date': endDate,
      'min_discount_percentage': minDiscountPercentage,
      'status': status,
      'my_participation': myParticipation?.toJson(),
    };
  }

  // ============================================================
  // Parsers
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

  static num? _parseNum(dynamic value) {
    if (value is num) {
      return value;
    }

    if (value is String) {
      return num.tryParse(value);
    }

    return null;
  }

  static String? _parseString(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is String) {
      return value;
    }

    return value.toString();
  }

  static MyParticipationModel? _parseParticipation(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is Map) {
      return MyParticipationModel.fromJson(Map<String, dynamic>.from(value));
    }

    return null;
  }
}

// ============================================================
// My Participation Model
// ============================================================

class MyParticipationModel {
  const MyParticipationModel({
    this.campaignId,
    this.status,
    this.requestedDiscountPercentage,
    this.discountPercentage,
  });

  // ============================================================
  // Fields
  // ============================================================

  final int? campaignId;
  final String? status;
  final num? requestedDiscountPercentage;
  final num? discountPercentage;

  // ============================================================
  // From JSON
  // ============================================================

  factory MyParticipationModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const MyParticipationModel();
    }

    return MyParticipationModel(
      campaignId: _parseInt(json['campaign_id']),
      status: _parseString(json['status']),
      requestedDiscountPercentage: _parseNum(
        json['requested_discount_percentage'],
      ),
      discountPercentage: _parseNum(json['discount_percentage']),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'campaign_id': campaignId,
      'status': status,
      'requested_discount_percentage': requestedDiscountPercentage,
      'discount_percentage': discountPercentage,
    };
  }

  // ============================================================
  // Parsers
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

  static num? _parseNum(dynamic value) {
    if (value is num) {
      return value;
    }

    if (value is String) {
      return num.tryParse(value);
    }

    return null;
  }

  static String? _parseString(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is String) {
      return value;
    }

    return value.toString();
  }
}
