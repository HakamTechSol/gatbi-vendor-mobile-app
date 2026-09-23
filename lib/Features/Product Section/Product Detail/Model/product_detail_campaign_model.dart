class ProductDetailCampaignModel {
  const ProductDetailCampaignModel({this.data = const {}});

  final Map<String, dynamic> data;

  // ============================================================
  // From JSON
  // ============================================================

  factory ProductDetailCampaignModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const ProductDetailCampaignModel();
    }

    return ProductDetailCampaignModel(data: Map<String, dynamic>.from(json));
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return Map<String, dynamic>.from(data);
  }
}
