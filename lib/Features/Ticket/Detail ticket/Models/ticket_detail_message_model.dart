class TicketDetailMessageModel {
  const TicketDetailMessageModel({
    this.id,
    this.message,
    this.senderType,
    this.senderName,
    this.createdAt,
  });

  // ============================================================
  // Fields
  // ============================================================

  final int? id;
  final String? message;
  final String? senderType;
  final String? senderName;
  final String? createdAt;

  // ============================================================
  // From JSON
  // ============================================================

  factory TicketDetailMessageModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const TicketDetailMessageModel();
    }

    return TicketDetailMessageModel(
      id: _parseInt(json['id']),
      message: _parseString(json['message']),
      senderType: _parseString(json['sender_type']),
      senderName: _parseString(json['sender_name']),
      createdAt: _parseString(json['created_at']),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'sender_type': senderType,
      'sender_name': senderName,
      'created_at': createdAt,
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

  static String? _parseString(dynamic value) {
    if (value == null) {
      return null;
    }

    return value.toString();
  }
}
