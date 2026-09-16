class VendorChatPaginationModel {
  const VendorChatPaginationModel({
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalItems = 0,
    this.limit = 20,
  });

  // ============================================================
  // Fields
  // ============================================================

  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int limit;

  // ============================================================
  // From JSON
  // ============================================================

  factory VendorChatPaginationModel.fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return const VendorChatPaginationModel();
    }

    return VendorChatPaginationModel(
      currentPage: _parseInt(json['current_page']) ?? 1,
      totalPages: _parseInt(json['total_pages']) ?? 1,
      totalItems: _parseInt(json['total_items']) ?? 0,
      limit: _parseInt(json['limit']) ?? 20,
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'total_pages': totalPages,
      'total_items': totalItems,
      'limit': limit,
    };
  }

  // ============================================================
  // Helpers
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
}