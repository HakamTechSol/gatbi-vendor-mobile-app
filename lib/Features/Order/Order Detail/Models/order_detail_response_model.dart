import 'order_detail_model.dart';
import 'order_payment_proof_model.dart';

class VendorOrderDetailResponseModel {
  const VendorOrderDetailResponseModel({
    this.success = false,
    this.order,
    this.paymentProof,
  });

  // ============================================================
  // Main Response Fields
  // ============================================================

  final bool success;
  final VendorOrderDetailModel? order;
  final VendorOrderPaymentProofModel? paymentProof;

  // ============================================================
  // From JSON
  // ============================================================

  factory VendorOrderDetailResponseModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const VendorOrderDetailResponseModel();
    }

    return VendorOrderDetailResponseModel(
      success: _parseBool(json['success']),
      order: json['order'] is Map
          ? VendorOrderDetailModel.fromJson(
              Map<String, dynamic>.from(json['order'] as Map),
            )
          : null,
      paymentProof: json['payment_proof'] is Map
          ? VendorOrderPaymentProofModel.fromJson(
              Map<String, dynamic>.from(json['payment_proof'] as Map),
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
      'order': order?.toJson(),
      'payment_proof': paymentProof?.toJson(),
    };
  }

  // ============================================================
  // Helpers
  // ============================================================

  static bool _parseBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is String) {
      final normalized = value.toLowerCase().trim();

      return normalized == 'true' || normalized == '1' || normalized == 'yes';
    }

    if (value is num) {
      return value != 0;
    }

    return false;
  }
}
