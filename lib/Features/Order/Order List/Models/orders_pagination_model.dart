class VendorOrdersPaginationModel {
  const VendorOrdersPaginationModel({
    this.currentPage,
    this.totalPages,
    this.totalItems,
    this.limit,
  });

  // ============================================================
  // Fields
  // ============================================================

  final int? currentPage;
  final int? totalPages;
  final int? totalItems;
  final int? limit;

  // ============================================================
  // From JSON
  // ============================================================

  factory VendorOrdersPaginationModel.fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return const VendorOrdersPaginationModel();
    }

    return VendorOrdersPaginationModel(
      currentPage: _parseInt(json['current_page']),
      totalPages: _parseInt(json['total_pages']),
      totalItems: _parseInt(json['total_items']),
      limit: _parseInt(json['limit']),
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
  // Safe Int Parser
  // ============================================================

  static int? _parseInt(dynamic value) {
    if (value == null) return null;

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
}