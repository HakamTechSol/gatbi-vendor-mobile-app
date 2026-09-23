import 'ticket_detail_message_model.dart';

class TicketDetailModel {
  const TicketDetailModel({this.success = false, this.ticket});

  // ============================================================
  // Main Response Fields
  // ============================================================

  final bool success;
  final TicketDetailDataModel? ticket;

  // ============================================================
  // From JSON
  // ============================================================

  factory TicketDetailModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const TicketDetailModel();
    }

    return TicketDetailModel(
      success: _parseBool(json['success']),
      ticket: json['ticket'] is Map
          ? TicketDetailDataModel.fromJson(
              Map<String, dynamic>.from(json['ticket'] as Map),
            )
          : null,
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {'success': success, 'ticket': ticket?.toJson()};
  }

  // ============================================================
  // Boolean Parser
  // ============================================================

  static bool _parseBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }

    if (value is num) {
      return value != 0;
    }

    return false;
  }
}

// ============================================================================
// Ticket Detail Data
// ============================================================================

class TicketDetailDataModel {
  const TicketDetailDataModel({
    this.id,
    this.ticketNumber,
    this.subject,
    this.category,
    this.priority,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.messages = const [],
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
  // Messages
  // ============================================================

  final List<TicketDetailMessageModel> messages;

  // ============================================================
  // From JSON
  // ============================================================

  factory TicketDetailDataModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const TicketDetailDataModel();
    }

    return TicketDetailDataModel(
      id: _parseInt(json['id']),
      ticketNumber: _parseString(json['ticket_number']),
      subject: _parseString(json['subject']),
      category: _parseString(json['category']),
      priority: _parseString(json['priority']),
      status: _parseString(json['status']),
      createdAt: _parseString(json['created_at']),
      updatedAt: _parseString(json['updated_at']),
      messages: _parseList(json['messages'], TicketDetailMessageModel.fromJson),
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
      'messages': messages.map((message) => message.toJson()).toList(),
    };
  }

  // ============================================================
  // List Parser
  // ============================================================

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

  // ============================================================
  // Integer Parser
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

  // ============================================================
  // String Parser
  // ============================================================

  static String? _parseString(dynamic value) {
    if (value == null) {
      return null;
    }

    return value.toString();
  }
}
