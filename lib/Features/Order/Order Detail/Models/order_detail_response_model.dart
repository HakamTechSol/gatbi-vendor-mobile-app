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

    // Extract the order map first
    final orderJson = json['order'] is Map
        ? Map<String, dynamic>.from(json['order'] as Map)
        : <String, dynamic>{};

    // Root level fields ko orderJson mein merge kar rahe hain
    // taake VendorOrderDetailModel unhe easily parse kar sake.
    if (json.containsKey('courier_shipment')) {
      orderJson['courier_shipment'] = json['courier_shipment'];
    }
    if (json.containsKey('can_request_pickup')) {
      orderJson['can_request_pickup'] = json['can_request_pickup'];
    }
    if (json.containsKey('pickup_block_reason')) {
      orderJson['pickup_block_reason'] = json['pickup_block_reason'];
    }
    if (json.containsKey('pickup_provider')) {
      orderJson['pickup_provider'] = json['pickup_provider'];
    }

    return VendorOrderDetailResponseModel(
      success: _parseBool(json['success']),
      order: orderJson.isNotEmpty
          ? VendorOrderDetailModel.fromJson(orderJson)
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
      'courier_shipment': order?.courierShipment?.toJson(),
      'can_request_pickup': order?.canRequestPickup,
      'pickup_block_reason': order?.pickupBlockReason,
      'pickup_provider': order?.pickupProvider,
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