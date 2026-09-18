import '../../Models/order_detail_model.dart';

class VendorOrderStatusUpdateResponseModel {
  const VendorOrderStatusUpdateResponseModel({
    this.success = false,
    this.message,
    this.order,
  });

  // ============================================================
  // Main Response Fields
  // ============================================================

  final bool success;
  final String? message;
  final VendorOrderDetailModel? order;

  // ============================================================
  // From JSON
  // ============================================================

  factory VendorOrderStatusUpdateResponseModel.fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return const VendorOrderStatusUpdateResponseModel();
    }

    return VendorOrderStatusUpdateResponseModel(
      success: _parseBool(json['success']),
      message: _parseString(json['message']),
      order: json['order'] is Map
          ? VendorOrderDetailModel.fromJson(
              Map<String, dynamic>.from(json['order'] as Map),
            )
          : null,
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'order': order?.toJson()};
  }

  // ============================================================
  // Parsers
  // ============================================================

  static bool _parseBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is String) {
      final normalized = value.trim().toLowerCase();

      return normalized == 'true' || normalized == '1';
    }

    if (value is num) {
      return value != 0;
    }

    return false;
  }

  static String? _parseString(dynamic value) {
    if (value == null) {
      return null;
    }

    final result = value.toString().trim();

    return result.isEmpty ? null : result;
  }
}
