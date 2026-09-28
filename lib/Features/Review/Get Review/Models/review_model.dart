// ============================================================
// Review List Model
// ============================================================

class ReviewListModel {
  const ReviewListModel({
    this.success,
    this.reviews = const [],
    this.pagination,
  });

  // ============================================================
  // Main Response Fields
  // ============================================================

  final bool? success;
  final List<ReviewModel> reviews;
  final ReviewPaginationModel? pagination;

  // ============================================================
  // From JSON
  // ============================================================

  factory ReviewListModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const ReviewListModel();
    }

    return ReviewListModel(
      success: _parseBool(json['success']),
      reviews: _parseList(json['reviews'], ReviewModel.fromJson),
      pagination: json['pagination'] is Map
          ? ReviewPaginationModel.fromJson(
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
      'reviews': reviews.map((e) => e.toJson()).toList(),
      'pagination': pagination?.toJson(),
    };
  }

  // ============================================================
  // Parse Bool
  // ============================================================

  static bool? _parseBool(dynamic value) {
    if (value is bool) return value;

    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }

    if (value is num) {
      return value != 0;
    }

    return null;
  }

  // ============================================================
  // Parse List
  // ============================================================

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

// ============================================================
// Review Model
// ============================================================

class ReviewModel {
  const ReviewModel({
    this.id,
    this.product,
    this.customer,
    this.rating,
    this.comment,
    this.isApproved,
    this.vendorReply,
    this.vendorRepliedAt,
    this.createdAt,
  });

  // ============================================================
  // Fields
  // ============================================================

  final int? id;
  final ReviewProductModel? product;
  final ReviewCustomerModel? customer;
  final int? rating;
  final String? comment;
  final bool? isApproved;
  final String? vendorReply;
  final String? vendorRepliedAt;
  final String? createdAt;

  // ============================================================
  // From JSON
  // ============================================================

  factory ReviewModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const ReviewModel();
    }

    return ReviewModel(
      id: _parseInt(json['id']),
      product: json['product'] is Map
          ? ReviewProductModel.fromJson(
              Map<String, dynamic>.from(json['product'] as Map),
            )
          : null,
      customer: json['customer'] is Map
          ? ReviewCustomerModel.fromJson(
              Map<String, dynamic>.from(json['customer'] as Map),
            )
          : null,
      rating: _parseInt(json['rating']),
      comment: _parseString(json['comment']),
      isApproved: _parseBool(json['is_approved']),
      vendorReply: _parseString(json['vendor_reply']),
      vendorRepliedAt: _parseString(json['vendor_replied_at']),
      createdAt: _parseString(json['created_at']),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product?.toJson(),
      'customer': customer?.toJson(),
      'rating': rating,
      'comment': comment,
      'is_approved': isApproved,
      'vendor_reply': vendorReply,
      'vendor_replied_at': vendorRepliedAt,
      'created_at': createdAt,
    };
  }

  // ============================================================
  // Parse Int
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

  // ============================================================
  // Parse String
  // ============================================================

  static String? _parseString(dynamic value) {
    if (value == null) return null;

    if (value is String) {
      return value;
    }

    return value.toString();
  }

  // ============================================================
  // Parse Bool
  // ============================================================

  static bool? _parseBool(dynamic value) {
    if (value is bool) return value;

    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }

    if (value is num) {
      return value != 0;
    }

    return null;
  }
}

// ============================================================
// Review Product Model
// ============================================================

class ReviewProductModel {
  const ReviewProductModel({this.id, this.name, this.image});

  // ============================================================
  // Fields
  // ============================================================

  final int? id;
  final String? name;
  final String? image;

  // ============================================================
  // From JSON
  // ============================================================

  factory ReviewProductModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const ReviewProductModel();
    }

    return ReviewProductModel(
      id: _parseInt(json['id']),
      name: _parseString(json['name']),
      image: _parseString(json['image']),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'image': image};
  }

  // ============================================================
  // Parse Int
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

  // ============================================================
  // Parse String
  // ============================================================

  static String? _parseString(dynamic value) {
    if (value == null) return null;

    if (value is String) {
      return value;
    }

    return value.toString();
  }
}

// ============================================================
// Review Customer Model
// ============================================================

class ReviewCustomerModel {
  const ReviewCustomerModel({
    this.firstName,
    this.lastName,
    this.name,
    this.avatar,
  });

  // ============================================================
  // Fields
  // ============================================================

  final String? firstName;
  final String? lastName;
  final String? name;
  final String? avatar;

  // ============================================================
  // From JSON
  // ============================================================

  factory ReviewCustomerModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const ReviewCustomerModel();
    }

    return ReviewCustomerModel(
      firstName: _parseString(json['first_name']),
      lastName: _parseString(json['last_name']),
      name: _parseString(json['name']),
      avatar: _parseString(json['avatar']),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'name': name,
      'avatar': avatar,
    };
  }

  // ============================================================
  // Parse String
  // ============================================================

  static String? _parseString(dynamic value) {
    if (value == null) return null;

    if (value is String) {
      return value;
    }

    return value.toString();
  }
}

// ============================================================
// Review Pagination Model
// ============================================================

class ReviewPaginationModel {
  const ReviewPaginationModel({
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

  factory ReviewPaginationModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const ReviewPaginationModel();
    }

    return ReviewPaginationModel(
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
    if (value is int) return value;

    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value);
    }

    return null;
  }

  // ============================================================
  // Pagination Helpers
  // ============================================================

  bool get hasNextPage {
    final current = currentPage;
    final total = totalPages;

    if (current == null || total == null) {
      return false;
    }

    return current < total;
  }

  bool get hasPreviousPage {
    final current = currentPage;

    if (current == null) {
      return false;
    }

    return current > 1;
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
}
