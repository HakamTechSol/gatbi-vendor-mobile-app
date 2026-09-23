import '../../Models/my_product_model.dart';

class AddStockProductModel {
  const AddStockProductModel({
    this.success = false,
    this.message,
    this.product,
  });

  final bool success;
  final String? message;
  final MyProductModel? product;

  // ============================================================
  // From JSON
  // ============================================================

  factory AddStockProductModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const AddStockProductModel();
    }

    return AddStockProductModel(
      success: _parseBool(json['success']),
      message: _parseString(json['message']),
      product: json['product'] is Map
          ? MyProductModel.fromJson(
              Map<String, dynamic>.from(json['product'] as Map),
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
      'message': message,
      'product': product?.toJson(),
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
  // Parse String
  // ============================================================

  static String? _parseString(dynamic value) {
    if (value == null) {
      return null;
    }

    return value.toString();
  }
}
