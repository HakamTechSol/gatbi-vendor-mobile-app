class ProductDetailGalleryModel {
  const ProductDetailGalleryModel({this.id, this.image, this.sortOrder});

  final int? id;
  final String? image;
  final int? sortOrder;

  // ============================================================
  // FROM JSON
  // ============================================================

  factory ProductDetailGalleryModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const ProductDetailGalleryModel();
    }

    return ProductDetailGalleryModel(
      id: _parseInt(json['id']),
      image: _parseString(json['image']),
      sortOrder: _parseInt(json['sort_order']),
    );
  }

  // ============================================================
  // TO JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {'id': id, 'image': image, 'sort_order': sortOrder};
  }

  // ============================================================
  // PARSERS
  // ============================================================

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

    return int.tryParse(value.toString());
  }

  static String? _parseString(dynamic value) {
    if (value == null) {
      return null;
    }

    final result = value.toString().trim();

    return result.isEmpty ? null : result;
  }
}
