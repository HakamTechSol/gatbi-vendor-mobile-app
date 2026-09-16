class VendorOrderDetailCustomerModel {
  const VendorOrderDetailCustomerModel({
    this.firstName,
    this.lastName,
    this.email,
  });

  // ============================================================
  // Customer Fields
  // ============================================================

  final String? firstName;
  final String? lastName;
  final String? email;

  // ============================================================
  // From JSON
  // ============================================================

  factory VendorOrderDetailCustomerModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const VendorOrderDetailCustomerModel();
    }

    return VendorOrderDetailCustomerModel(
      firstName: _parseString(json['first_name']),
      lastName: _parseString(json['last_name']),
      email: _parseString(json['email']),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {'first_name': firstName, 'last_name': lastName, 'email': email};
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
}
