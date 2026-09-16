class VendorOrderTrackingModel {
  const VendorOrderTrackingModel({this.data = const {}});

  // ============================================================
  // Tracking Data
  // ============================================================

  final Map<String, dynamic> data;

  // ============================================================
  // From JSON
  // ============================================================

  factory VendorOrderTrackingModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const VendorOrderTrackingModel();
    }

    return VendorOrderTrackingModel(data: Map<String, dynamic>.from(json));
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return Map<String, dynamic>.from(data);
  }
}
