import 'product_detail_item_model.dart';

class ProductDetailModel {
  const ProductDetailModel({this.success = false, this.product});

  final bool success;
  final ProductDetailItemModel? product;

  // ============================================================
  // From JSON
  // ============================================================

  factory ProductDetailModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const ProductDetailModel();
    }

    return ProductDetailModel(
      success: _parseBool(json['success']),
      product: json['product'] is Map
          ? ProductDetailItemModel.fromJson(
              Map<String, dynamic>.from(json['product'] as Map),
            )
          : null,
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {'success': success, 'product': product?.toJson()};
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
