class EventDetailModel {
  const EventDetailModel({
    this.success = false,
    this.event,
    this.kycStatus,
    this.kycLocked = false,
  });

  final bool success;
  final EventDetailItemModel? event;
  final String? kycStatus;
  final bool kycLocked;

  // ============================================================
  // From JSON
  // ============================================================

  factory EventDetailModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const EventDetailModel();
    }

    return EventDetailModel(
      success: _parseBool(json['success']),
      event: json['event'] is Map
          ? EventDetailItemModel.fromJson(
              Map<String, dynamic>.from(json['event'] as Map),
            )
          : null,
      kycStatus: json['kyc_status']?.toString(),
      kycLocked: _parseBool(json['kyc_locked']),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'event': event?.toJson(),
      'kyc_status': kycStatus,
      'kyc_locked': kycLocked,
    };
  }

  // ============================================================
  // Helpers
  // ============================================================

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;

    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }

    if (value is num) {
      return value != 0;
    }

    return false;
  }
}

// ============================================================
// Event Detail Item Model
// ============================================================

class EventDetailItemModel {
  const EventDetailItemModel({
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
  final dynamic myParticipation;

  // ============================================================
  // From JSON
  // ============================================================

  factory EventDetailItemModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const EventDetailItemModel();
    }

    return EventDetailItemModel(
      id: _parseInt(json['id']),
      name: json['name']?.toString(),
      slug: json['slug']?.toString(),
      description: json['description']?.toString(),
      bannerUrl: json['banner_url']?.toString(),
      bannerMobileUrl: json['banner_mobile_url']?.toString(),
      startDate: json['start_date']?.toString(),
      endDate: json['end_date']?.toString(),
      minDiscountPercentage: _parseNum(json['min_discount_percentage']),
      status: json['status']?.toString(),
      myParticipation: json['my_participation'],
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
      'my_participation': myParticipation,
    };
  }

  // ============================================================
  // Helpers
  // ============================================================

  static int? _parseInt(dynamic value) {
    if (value is int) return value;

    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value);
    }

    return null;
  }

  static num? _parseNum(dynamic value) {
    if (value is num) return value;

    if (value is String) {
      return num.tryParse(value);
    }

    return null;
  }
}
