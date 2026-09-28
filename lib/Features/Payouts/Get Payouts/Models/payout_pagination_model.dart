class PayoutPaginationModel {
  const PayoutPaginationModel({
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
  // Pagination Helpers
  // ============================================================

  bool get hasNextPage {
    if (currentPage == null || totalPages == null) {
      return false;
    }

    return currentPage! < totalPages!;
  }

  bool get hasPreviousPage {
    if (currentPage == null) {
      return false;
    }

    return currentPage! > 1;
  }

  int? get nextPage {
    if (!hasNextPage || currentPage == null) {
      return null;
    }

    return currentPage! + 1;
  }

  int? get previousPage {
    if (!hasPreviousPage || currentPage == null) {
      return null;
    }

    return currentPage! - 1;
  }

  // ============================================================
  // From JSON
  // ============================================================

  factory PayoutPaginationModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const PayoutPaginationModel();
    }

    return PayoutPaginationModel(
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
  // Parse Int
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
}
