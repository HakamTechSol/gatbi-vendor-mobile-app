class UpdateProductGalleryModel {
  const UpdateProductGalleryModel({this.id, this.image, this.sortOrder});

  final int? id;

  final String? image;

  final int? sortOrder;

  factory UpdateProductGalleryModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const UpdateProductGalleryModel();
    }

    return UpdateProductGalleryModel(
      id: _parseInt(json['id']),
      image: json['image']?.toString(),
      sortOrder: _parseInt(json['sort_order']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'image': image, 'sort_order': sortOrder};
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
}
