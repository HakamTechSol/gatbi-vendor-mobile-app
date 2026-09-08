import '../Models/ticket_model.dart';

/// Dummy support ticket data for UI development.
///
/// This data will be replaced by API data later.
/// No UI widget should depend directly on this file in production.
abstract final class DummyTicketData {
  DummyTicketData._();

  static final List<TicketModel> tickets = [
    TicketModel(
      id: 1024,
      ticketNumber: 'TKT-1024',
      subject: 'Payment not received',
      category: 'Payment',
      priority: 'High',
      status: 'Open',
      createdAt: DateTime(2026, 9, 3, 9, 30),
      updatedAt: DateTime(2026, 9, 3, 10, 15),
      messages: const [],
    ),

    TicketModel(
      id: 1023,
      ticketNumber: 'TKT-1023',
      subject: 'Product approval is pending',
      category: 'Product',
      priority: 'Medium',
      status: 'Pending',
      createdAt: DateTime(2026, 9, 2, 14, 20),
      updatedAt: DateTime(2026, 9, 3, 8, 45),
      messages: const [],
    ),

    TicketModel(
      id: 1022,
      ticketNumber: 'TKT-1022',
      subject: 'Unable to update product stock',
      category: 'Product',
      priority: 'High',
      status: 'Resolved',
      createdAt: DateTime(2026, 9, 1, 11, 10),
      updatedAt: DateTime(2026, 9, 2, 16, 30),
      messages: const [],
    ),

    TicketModel(
      id: 1021,
      ticketNumber: 'TKT-1021',
      subject: 'Question about recent order',
      category: 'Order',
      priority: 'Low',
      status: 'Closed',
      createdAt: DateTime(2026, 8, 31, 10, 45),
      updatedAt: DateTime(2026, 9, 1, 12, 20),
      messages: const [],
    ),

    TicketModel(
      id: 1020,
      ticketNumber: 'TKT-1020',
      subject: 'Unable to upload product images',
      category: 'Technical',
      priority: 'High',
      status: 'Open',
      createdAt: DateTime(2026, 8, 30, 15, 40),
      updatedAt: DateTime(2026, 9, 1, 9, 15),
      messages: const [],
    ),

    TicketModel(
      id: 1019,
      ticketNumber: 'TKT-1019',
      subject: 'Need help with product listing',
      category: 'General',
      priority: 'Medium',
      status: 'Pending',
      createdAt: DateTime(2026, 8, 29, 13, 25),
      updatedAt: DateTime(2026, 8, 30, 11, 50),
      messages: const [],
    ),

    TicketModel(
      id: 1018,
      ticketNumber: 'TKT-1018',
      subject: 'Order cancellation request',
      category: 'Order',
      priority: 'Medium',
      status: 'Resolved',
      createdAt: DateTime(2026, 8, 28, 9, 15),
      updatedAt: DateTime(2026, 8, 29, 14, 10),
      messages: const [],
    ),

    TicketModel(
      id: 1017,
      ticketNumber: 'TKT-1017',
      subject: 'Payment verification issue',
      category: 'Payment',
      priority: 'High',
      status: 'Closed',
      createdAt: DateTime(2026, 8, 27, 16, 30),
      updatedAt: DateTime(2026, 8, 28, 10, 25),
      messages: const [],
    ),
  ];

  /// Returns a fresh list so the original dummy collection
  /// is not accidentally modified by the UI.
  static List<TicketModel> get all => List.unmodifiable(tickets);

  /// Returns a ticket by its ID.
  static TicketModel? findById(int id) {
    for (final ticket in tickets) {
      if (ticket.id == id) {
        return ticket;
      }
    }

    return null;
  }

  /// Returns tickets filtered by status.
  static List<TicketModel> byStatus(String status) {
    return tickets
        .where(
          (ticket) =>
              ticket.status.toLowerCase() == status.toLowerCase(),
        )
        .toList();
  }

  /// Returns tickets filtered by category.
  static List<TicketModel> byCategory(String category) {
    return tickets
        .where(
          (ticket) =>
              ticket.category.toLowerCase() == category.toLowerCase(),
        )
        .toList();
  }

  /// Returns tickets filtered by priority.
  static List<TicketModel> byPriority(String priority) {
    return tickets
        .where(
          (ticket) =>
              ticket.priority.toLowerCase() == priority.toLowerCase(),
        )
        .toList();
  }
}
