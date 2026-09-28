import 'payout_model.dart';
import 'payout_pagination_model.dart';

class GetPayoutModel {
  const GetPayoutModel({
    this.success = false,
    this.payouts = const [],
    this.pagination,
  });

  // ============================================================
  // Fields
  // ============================================================

  final bool success;
  final List<PayoutModel> payouts;
  final PayoutPaginationModel? pagination;

  // ============================================================
  // From JSON
  // ============================================================

  factory GetPayoutModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const GetPayoutModel();
    }

    return GetPayoutModel(
      success: _parseBool(json['success']),
      payouts: _parsePayouts(json['payouts']),
      pagination: json['pagination'] is Map
          ? PayoutPaginationModel.fromJson(
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
      'payouts': payouts.map((e) => e.toJson()).toList(),
      'pagination': pagination?.toJson(),
    };
  }

  // ============================================================
  // Parse Bool
  // ============================================================

  static bool _parseBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }

    if (value is num) {
      return value != 0;
    }

    return false;
  }

  // ============================================================
  // Parse Payout List
  // ============================================================

  static List<PayoutModel> _parsePayouts(dynamic value) {
    if (value is! List) {
      return const [];
    }

    return value
        .whereType<Map>()
        .map((item) => PayoutModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }
}
