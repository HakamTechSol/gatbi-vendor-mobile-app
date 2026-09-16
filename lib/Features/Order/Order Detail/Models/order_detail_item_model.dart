class VendorOrderDetailItemModel {
  const VendorOrderDetailItemModel({
    this.id,
    this.productId,
    this.name,
    this.slug,
    this.image,
    this.price,
    this.quantity,
    this.total,
  });

  // ============================================================
  // Item Fields
  // ============================================================

  final int? id;
  final int? productId;

  final String? name;
  final String? slug;
  final String? image;

  final num? price;
  final int? quantity;
  final num? total;

  // ============================================================
  // From JSON
  // ============================================================

  factory VendorOrderDetailItemModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const VendorOrderDetailItemModel();
    }

    return VendorOrderDetailItemModel(
      id: _parseInt(json['id']),
      productId: _parseInt(json['product_id']),
      name: _parseString(json['name']),
      slug: _parseString(json['slug']),
      image: _parseString(json['image']),
      price: _parseNum(json['price']),
      quantity: _parseInt(json['quantity']),
      total: _parseNum(json['total']),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'name': name,
      'slug': slug,
      'image': image,
      'price': price,
      'quantity': quantity,
      'total': total,
    };
  }

  // ============================================================
  // Helpers
  // ============================================================

  static String? _parseString(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is String) {
      return value;
    }

    return value.toString();
  }

  static int? _parseInt(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    if (value is String) {
      return int.tryParse(value);
    }

    return null;
  }

  static num? _parseNum(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is num) {
      return value;
    }

    if (value is String) {
      return num.tryParse(value);
    }

    return null;
  }
}
