class CampaignPaginationModel {
  const CampaignPaginationModel({
    this.total,
    this.perPage,
    this.currentPage,
    this.lastPage,
  });

  // ============================================================
  // Fields
  // ============================================================

  final int? total;
  final int? perPage;
  final int? currentPage;
  final int? lastPage;

  // ============================================================
  // Convenience Getters
  // ============================================================

  bool get hasNextPage {
    if (currentPage == null || lastPage == null) {
      return false;
    }

    return currentPage! < lastPage!;
  }

  bool get hasPreviousPage {
    if (currentPage == null) {
      return false;
    }

    return currentPage! > 1;
  }

  int get nextPage {
    if (!hasNextPage) {
      return currentPage ?? 1;
    }

    return (currentPage ?? 1) + 1;
  }

  int get previousPage {
    if (!hasPreviousPage) {
      return currentPage ?? 1;
    }

    return (currentPage ?? 1) - 1;
  }

  // ============================================================
  // From JSON
  // ============================================================

  factory CampaignPaginationModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const CampaignPaginationModel();
    }

    return CampaignPaginationModel(
      total: _parseInt(json['total']),
      perPage: _parseInt(json['per_page']),
      currentPage: _parseInt(json['current_page']),
      lastPage: _parseInt(json['last_page']),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'per_page': perPage,
      'current_page': currentPage,
      'last_page': lastPage,
    };
  }

  // ============================================================
  // Parser
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
