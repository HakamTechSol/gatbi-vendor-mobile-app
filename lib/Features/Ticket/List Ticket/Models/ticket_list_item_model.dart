class TicketListItemModel {
  const TicketListItemModel({
    this.id,
    this.ticketNumber,
    this.subject,
    this.category,
    this.priority,
    this.status,
    this.createdAt,
    this.updatedAt,
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
  final String? updatedAt;

  // ============================================================
  // From JSON
  // ============================================================

  factory TicketListItemModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const TicketListItemModel();
    }

    return TicketListItemModel(
      id: _parseInt(json['id']),
      ticketNumber: _parseString(json['ticket_number']),
      subject: _parseString(json['subject']),
      category: _parseString(json['category']),
      priority: _parseString(json['priority']),
      status: _parseString(json['status']),
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
      'ticket_number': ticketNumber,
      'subject': subject,
      'category': category,
      'priority': priority,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
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
