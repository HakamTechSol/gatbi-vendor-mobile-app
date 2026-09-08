
import 'ticket_message_model.dart';

/// Represents a support ticket.
///
/// This model is intentionally kept independent from UI and API code
/// so it can be reused later when the real API is connected.
class TicketModel {
  const TicketModel({
    required this.id,
    required this.ticketNumber,
    required this.subject,
    required this.category,
    required this.priority,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.messages = const [],
  });

  /// Unique ticket ID from backend.
  final int id;

  /// Human-readable ticket number.
  ///
  /// Example: TKT-1024
  final String ticketNumber;

  /// Ticket subject/title.
  final String subject;

  /// Ticket category.
  ///
  /// Examples:
  /// General, Order, Product, Payment, Technical
  final String category;

  /// Ticket priority.
  ///
  /// Examples:
  /// Low, Medium, High
  final String priority;

  /// Current ticket status.
  ///
  /// Examples:
  /// Open, Pending, Resolved, Closed
  final String status;

  /// Ticket creation date/time.
  final DateTime createdAt;

  /// Last ticket update date/time.
  final DateTime updatedAt;

  /// Conversation messages.
  ///
  /// This will be useful on Ticket Detail screen.
  final List<TicketMessageModel> messages;

  /// Creates a copy of this ticket with updated values.
  TicketModel copyWith({
    int? id,
    String? ticketNumber,
    String? subject,
    String? category,
    String? priority,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<TicketMessageModel>? messages,
  }) {
    return TicketModel(
      id: id ?? this.id,
      ticketNumber: ticketNumber ?? this.ticketNumber,
      subject: subject ?? this.subject,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      messages: messages ?? this.messages,
    );
  }

  /// Converts the model into a JSON-compatible map.
  ///
  /// Useful later when API integration is added.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ticket_number': ticketNumber,
      'subject': subject,
      'category': category,
      'priority': priority,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'messages': messages.map((message) => message.toJson()).toList(),
    };
  }

  /// Creates a TicketModel from API JSON.
  ///
  /// Keeping this here makes the UI independent from the backend response.
  factory TicketModel.fromJson(Map<String, dynamic> json) {
    final rawMessages = json['messages'];

    return TicketModel(
      id: _parseInt(json['id']),
      ticketNumber: json['ticket_number']?.toString() ?? '',
      subject: json['subject']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      priority: json['priority']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
      messages: rawMessages is List
          ? rawMessages
                .whereType<Map<String, dynamic>>()
                .map(TicketMessageModel.fromJson)
                .toList()
          : const [],
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static DateTime _parseDateTime(dynamic value) {
    return DateTime.tryParse(value?.toString() ?? '') ?? DateTime.now();
  }
}
