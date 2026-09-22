import 'create_ticket_data_model.dart';

class CreateTicketModel {
  const CreateTicketModel({this.success = false, this.message, this.ticket});

  // ============================================================
  // Main Response Fields
  // ============================================================

  final bool success;
  final String? message;
  final CreateTicketDataModel? ticket;

  // ============================================================
  // From JSON
  // ============================================================

  factory CreateTicketModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const CreateTicketModel();
    }

    return CreateTicketModel(
      success: _parseBool(json['success']),
      message: _parseString(json['message']),
      ticket: json['ticket'] is Map
          ? CreateTicketDataModel.fromJson(
              Map<String, dynamic>.from(json['ticket'] as Map),
            )
          : null,
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'ticket': ticket?.toJson()};
  }

  // ============================================================
  // Parsers
  // ============================================================

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;

    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }

    if (value is num) {
      return value != 0;
    }

    return false;
  }

  static String? _parseString(dynamic value) {
    if (value == null) return null;

    return value.toString();
  }
}
