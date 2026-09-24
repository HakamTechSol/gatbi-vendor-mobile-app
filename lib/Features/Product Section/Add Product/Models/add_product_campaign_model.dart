class AddProductCampaignModel {
  const AddProductCampaignModel({this.id, this.name, this.slug});

  final int? id;
  final String? name;
  final String? slug;

  factory AddProductCampaignModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const AddProductCampaignModel();
    }

    return AddProductCampaignModel(
      id: _parseInt(json['id']),
      name: _parseString(json['name']),
      slug: _parseString(json['slug']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'slug': slug};
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

  static String? _parseString(dynamic value) {
    if (value == null) return null;

    return value.toString();
  }
}
