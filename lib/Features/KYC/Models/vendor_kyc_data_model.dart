
import 'vendor_kyc_detail_model.dart';
import 'vendor_kyc_document_model.dart';
import 'vendor_kyc_field_review_model.dart';

class VendorKycDataModel {
  const VendorKycDataModel({
    this.merchantId,
    this.status,
    this.statusLabel,
    this.submissionCount = 0,
    this.canResubmit = false,
    this.rejectionReason,
    this.fieldReviews = const [],
    this.detail,
    this.documents = const [],
  });

  final int? merchantId;
  final String? status;
  final String? statusLabel;
  final int submissionCount;
  final bool canResubmit;
  final String? rejectionReason;

  final List<VendorKycFieldReviewModel> fieldReviews;

  /// API mein:
  /// - pending/approved detail = Map
  /// - approved response mein detail = false
  ///
  /// Isliye false ko null treat karenge.
  final VendorKycDetailModel? detail;

  final List<VendorKycDocumentModel> documents;

  // ============================================================
  // From JSON
  // ============================================================

  factory VendorKycDataModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const VendorKycDataModel();
    }

    return VendorKycDataModel(
      merchantId: _parseInt(json['merchant_id']),
      status: _parseString(json['status']),
      statusLabel: _parseString(json['status_label']),
      submissionCount: _parseInt(json['submission_count']) ?? 0,
      canResubmit: _parseBool(json['can_resubmit']),
      rejectionReason: _parseString(json['rejection_reason']),

      fieldReviews: _parseList(
        json['field_reviews'],
        VendorKycFieldReviewModel.fromJson,
      ),

      detail: json['detail'] is Map
          ? VendorKycDetailModel.fromJson(
              Map<String, dynamic>.from(json['detail'] as Map),
            )
          : null,

      documents: _parseList(json['documents'], VendorKycDocumentModel.fromJson),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'merchant_id': merchantId,
      'status': status,
      'status_label': statusLabel,
      'submission_count': submissionCount,
      'can_resubmit': canResubmit,
      'rejection_reason': rejectionReason,
      'field_reviews': fieldReviews.map((e) => e.toJson()).toList(),
      'detail': detail?.toJson(),
      'documents': documents.map((e) => e.toJson()).toList(),
    };
  }

  // ============================================================
  // Helpers
  // ============================================================

  static String? _parseString(dynamic value) {
    if (value == null) return null;

    if (value is String) {
      final result = value.trim();

      return result.isEmpty ? null : result;
    }

    return value.toString();
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

  static List<T> _parseList<T>(
    dynamic value,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (value is! List) return const [];

    return value
        .whereType<Map>()
        .map((item) => fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }
}
