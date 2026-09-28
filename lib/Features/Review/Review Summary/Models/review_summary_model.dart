class ReviewSummaryModel {
  const ReviewSummaryModel({this.success = false, this.summary});

  // ============================================================
  // Main Response Fields
  // ============================================================

  final bool success;
  final ReviewSummaryDataModel? summary;

  // ============================================================
  // From JSON
  // ============================================================

  factory ReviewSummaryModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const ReviewSummaryModel();
    }

    return ReviewSummaryModel(
      success: _parseBool(json['success']),
      summary: json['summary'] is Map
          ? ReviewSummaryDataModel.fromJson(
              Map<String, dynamic>.from(json['summary'] as Map),
            )
          : null,
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {'success': success, 'summary': summary?.toJson()};
  }

  // ============================================================
  // Parse Bool
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
}

// ============================================================
// Review Summary Data Model
// ============================================================

class ReviewSummaryDataModel {
  const ReviewSummaryDataModel({
    this.averageRating = 0,
    this.totalReviews = 0,
    this.approvedReviews = 0,
    this.pendingReviews = 0,
    this.ratingBreakdown = const {},
  });

  // ============================================================
  // Fields
  // ============================================================

  final double averageRating;
  final int totalReviews;
  final int approvedReviews;
  final int pendingReviews;
  final Map<String, int> ratingBreakdown;

  // ============================================================
  // From JSON
  // ============================================================

  factory ReviewSummaryDataModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const ReviewSummaryDataModel();
    }

    return ReviewSummaryDataModel(
      averageRating: _parseDouble(json['average_rating']),
      totalReviews: _parseInt(json['total_reviews']),
      approvedReviews: _parseInt(json['approved_reviews']),
      pendingReviews: _parseInt(json['pending_reviews']),
      ratingBreakdown: _parseIntMap(json['rating_breakdown']),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'average_rating': averageRating,
      'total_reviews': totalReviews,
      'approved_reviews': approvedReviews,
      'pending_reviews': pendingReviews,
      'rating_breakdown': ratingBreakdown,
    };
  }

  // ============================================================
  // Parse Double
  // ============================================================

  static double _parseDouble(dynamic value) {
    if (value is double) return value;

    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(value) ?? 0;
    }

    return 0;
  }

  // ============================================================
  // Parse Int
  // ============================================================

  static int _parseInt(dynamic value) {
    if (value is int) return value;

    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value) ?? 0;
    }

    return 0;
  }

  // ============================================================
  // Parse Int Map
  // ============================================================

  static Map<String, int> _parseIntMap(dynamic value) {
    if (value is! Map) {
      return const {};
    }

    final result = <String, int>{};

    value.forEach((key, value) {
      if (key == null) return;

      final parsed = _parseIntNullable(value);

      if (parsed != null) {
        result[key.toString()] = parsed;
      }
    });

    return result;
  }

  // ============================================================
  // Parse Nullable Int
  // ============================================================

  static int? _parseIntNullable(dynamic value) {
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
