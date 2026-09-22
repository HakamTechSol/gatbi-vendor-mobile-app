import 'ticket_list_item_model.dart';
import 'ticket_list_pagination_model.dart';

class TicketListModel {
  const TicketListModel({
    this.success = false,
    this.tickets = const [],
    this.pagination,
  });

  // ============================================================
  // Main Response Fields
  // ============================================================

  final bool success;
  final List<TicketListItemModel> tickets;
  final TicketListPaginationModel? pagination;

  // ============================================================
  // From JSON
  // ============================================================

  factory TicketListModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const TicketListModel();
    }

    return TicketListModel(
      success: _parseBool(json['success']),
      tickets: _parseList(json['tickets'], TicketListItemModel.fromJson),
      pagination: json['pagination'] is Map
          ? TicketListPaginationModel.fromJson(
              Map<String, dynamic>.from(json['pagination'] as Map),
            )
          : null,
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'tickets': tickets.map((e) => e.toJson()).toList(),
      'pagination': pagination?.toJson(),
    };
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
}
