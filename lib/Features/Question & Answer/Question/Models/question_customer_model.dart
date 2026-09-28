class QuestionCustomerModel {
  const QuestionCustomerModel({
    this.firstName,
    this.lastName,
    this.name,
    this.avatar,
  });

  // ============================================================
  // Customer Fields
  // ============================================================

  final String? firstName;
  final String? lastName;
  final String? name;
  final String? avatar;

  // ============================================================
  // From JSON
  // ============================================================

  factory QuestionCustomerModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const QuestionCustomerModel();
    }

    return QuestionCustomerModel(
      firstName: _parseString(json['first_name']),
      lastName: _parseString(json['last_name']),
      name: _parseString(json['name']),
      avatar: _parseString(json['avatar']),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'name': name,
      'avatar': avatar,
    };
  }

  // ============================================================
  // Parse String
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
