class VendorOrderShippingAddressModel {
  const VendorOrderShippingAddressModel({
    this.id,
    this.userId,
    this.fullName,
    this.phone,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.postalCode,
    this.country,
    this.isDefault,
    this.createdAt,
    this.updatedAt,
  });

  // ============================================================
  // Shipping Address Fields
  // ============================================================

  final int? id;
  final int? userId;

  final String? fullName;
  final String? phone;

  final String? addressLine1;
  final String? addressLine2;

  final String? city;
  final String? state;
  final String? postalCode;
  final String? country;

  final int? isDefault;

  final String? createdAt;
  final String? updatedAt;

  // ============================================================
  // From JSON
  // ============================================================

  factory VendorOrderShippingAddressModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const VendorOrderShippingAddressModel();
    }

    return VendorOrderShippingAddressModel(
      id: _parseInt(json['id']),
      userId: _parseInt(json['user_id']),
      fullName: _parseString(json['full_name']),
      phone: _parseString(json['phone']),
      addressLine1: _parseString(json['address_line1']),
      addressLine2: _parseString(json['address_line2']),
      city: _parseString(json['city']),
      state: _parseString(json['state']),
      postalCode: _parseString(json['postal_code']),
      country: _parseString(json['country']),
      isDefault: _parseInt(json['is_default']),
      createdAt: _parseString(json['created_at']),
      updatedAt: _parseString(json['updated_at']),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'full_name': fullName,
      'phone': phone,
      'address_line1': addressLine1,
      'address_line2': addressLine2,
      'city': city,
      'state': state,
      'postal_code': postalCode,
      'country': country,
      'is_default': isDefault,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  // ============================================================
  // Helpers
  // ============================================================

  static String? _parseString(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is String) {
      return value;
    }

    return value.toString();
  }

  static int? _parseInt(dynamic value) {
    if (value == null) {
      return null;
    }

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
