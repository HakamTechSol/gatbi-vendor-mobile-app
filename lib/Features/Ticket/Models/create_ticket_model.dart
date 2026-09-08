
/// Represents the data required to create a new support ticket.
///
/// This model is intentionally independent from Flutter widgets,
/// controllers, repositories, and API clients.
class CreateTicketModel {
  const CreateTicketModel({
    required this.subject,
    required this.category,
    required this.priority,
    required this.message,
  });

  final String subject;
  final String category;
  final String priority;
  final String message;

  CreateTicketModel copyWith({
    String? subject,
    String? category,
    String? priority,
    String? message,
  }) {
    return CreateTicketModel(
      subject: subject ?? this.subject,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subject': subject,
      'category': category,
      'priority': priority,
      'message': message,
    };
  }

  factory CreateTicketModel.fromJson(Map<String, dynamic> json) {
    return CreateTicketModel(
      subject: json['subject']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      priority: json['priority']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
    );
  }

  bool get isValid {
    return subject.trim().isNotEmpty &&
        category.trim().isNotEmpty &&
        priority.trim().isNotEmpty &&
        message.trim().isNotEmpty;
  }
}
