class VendorOrderCustomerModel {
  const VendorOrderCustomerModel({this.name, this.email});

  // ============================================================
  // Fields
  // ============================================================

  final String? name;
  final String? email;

  // ============================================================
  // From JSON
  // ============================================================

  factory VendorOrderCustomerModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const VendorOrderCustomerModel();
    }

    return VendorOrderCustomerModel(
      name: _parseString(json['name']),
      email: _parseString(json['email']),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email};
  }

  // ============================================================
  // Safe String Parser
  // ============================================================

  static String? _parseString(dynamic value) {
    if (value == null) return null;

    if (value is String) {
      return value;
    }

    return value.toString();
  }
}
