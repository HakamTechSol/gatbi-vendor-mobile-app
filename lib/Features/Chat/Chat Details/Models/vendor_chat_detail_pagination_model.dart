class VendorChatDetailPaginationModel {
  const VendorChatDetailPaginationModel({
    this.currentPage = 1,
    this.limit = 50,
  });

  final int currentPage;
  final int limit;

  // ============================================================
  // From JSON
  // ============================================================

  factory VendorChatDetailPaginationModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const VendorChatDetailPaginationModel();
    }

    return VendorChatDetailPaginationModel(
      currentPage: _parseInt(json['current_page']) ?? 1,
      limit: _parseInt(json['limit']) ?? 50,
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {'current_page': currentPage, 'limit': limit};
  }

  // ============================================================
  // Parser
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
