class CreateTicketDataModel {
  const CreateTicketDataModel({
    this.id,
    this.ticketNumber,
    this.subject,
    this.category,
    this.priority,
    this.status,
    this.createdAt,
  });

  // ============================================================
  // Ticket Fields
  // ============================================================

  final int? id;
  final String? ticketNumber;
  final String? subject;
  final String? category;
  final String? priority;
  final String? status;
  final String? createdAt;

  // ============================================================
  // From JSON
  // ============================================================

  factory CreateTicketDataModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const CreateTicketDataModel();
    }

    return CreateTicketDataModel(
      id: _parseInt(json['id']),
      ticketNumber: _parseString(json['ticket_number']),
      subject: _parseString(json['subject']),
      category: _parseString(json['category']),
      priority: _parseString(json['priority']),
      status: _parseString(json['status']),
      createdAt: _parseString(json['created_at']),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ticket_number': ticketNumber,
      'subject': subject,
      'category': category,
      'priority': priority,
      'status': status,
      'created_at': createdAt,
    };
  }

  // ============================================================
  // Parsers
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

    return value.toString();
  }
}
