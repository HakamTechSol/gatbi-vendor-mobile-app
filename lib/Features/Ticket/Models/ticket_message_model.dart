
/// Represents a single message inside a support ticket conversation.
///
/// This model is UI-independent and can later be populated directly
/// from the support ticket API response.
class TicketMessageModel {
  const TicketMessageModel({
    required this.id,
    required this.sender,
    required this.senderType,
    required this.message,
    required this.createdAt,
  });

  final int id;
  final String sender;
  final String senderType;
  final String message;
  final DateTime createdAt;

  TicketMessageModel copyWith({
    int? id,
    String? sender,
    String? senderType,
    String? message,
    DateTime? createdAt,
  }) {
    return TicketMessageModel(
      id: id ?? this.id,
      sender: sender ?? this.sender,
      senderType: senderType ?? this.senderType,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': sender,
      'sender_type': senderType,
      'message': message,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory TicketMessageModel.fromJson(Map<String, dynamic> json) {
    return TicketMessageModel(
      id: _parseInt(json['id']),
      sender: json['sender']?.toString() ?? '',
      senderType: json['sender_type']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      createdAt: _parseDateTime(json['created_at']),
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;

    return int.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }

  static DateTime _parseDateTime(dynamic value) {
    return DateTime.tryParse(
          value?.toString() ?? '',
        ) ??
        DateTime.now();
  }
}
