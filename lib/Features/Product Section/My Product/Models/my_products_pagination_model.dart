class MyProductsPaginationModel {
  const MyProductsPaginationModel({
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalItems = 0,
    this.limit = 20,
  });

  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int limit;

  bool get hasNextPage => currentPage < totalPages;

  bool get hasPreviousPage => currentPage > 1;

  factory MyProductsPaginationModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const MyProductsPaginationModel();
    }

    return MyProductsPaginationModel(
      currentPage: _parseInt(json['current_page']) ?? 1,
      totalPages: _parseInt(json['total_pages']) ?? 1,
      totalItems: _parseInt(json['total_items']) ?? 0,
      limit: _parseInt(json['limit']) ?? 20,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'total_pages': totalPages,
      'total_items': totalItems,
      'limit': limit,
    };
  }

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
