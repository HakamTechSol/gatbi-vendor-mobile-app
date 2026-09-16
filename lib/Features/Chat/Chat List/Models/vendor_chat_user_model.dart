class VendorChatUserModel {
  const VendorChatUserModel({
    this.id,
    this.firstName,
    this.lastName,
    this.name,
    this.email,
  });

  // ============================================================
  // Fields
  // ============================================================

  final int? id;
  final String? firstName;
  final String? lastName;
  final String? name;
  final String? email;

  // ============================================================
  // From JSON
  // ============================================================

  factory VendorChatUserModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const VendorChatUserModel();
    }

    return VendorChatUserModel(
      id: _parseInt(json['id']),
      firstName: _parseString(json['first_name']),
      lastName: _parseString(json['last_name']),
      name: _parseString(json['name']),
      email: _parseString(json['email']),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'name': name,
      'email': email,
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

  static String? _parseString(dynamic value) {
    if (value == null) return null;

    if (value is String) {
      final result = value.trim();

      return result.isEmpty ? null : result;
    }

    return value.toString();
  }
}
