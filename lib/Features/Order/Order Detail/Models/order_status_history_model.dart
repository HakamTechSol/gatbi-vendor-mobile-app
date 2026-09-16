class VendorOrderStatusHistoryModel {
  const VendorOrderStatusHistoryModel({
    this.id,
    this.orderId,
    this.status,
    this.notes,
    this.updatedBy,
    this.updatedByType,
    this.createdAt,
    this.updatedAt,
  });

  // ============================================================
  // Status History Fields
  // ============================================================

  final int? id;
  final int? orderId;

  final String? status;
  final String? notes;

  final int? updatedBy;
  final String? updatedByType;

  final String? createdAt;
  final String? updatedAt;

  // ============================================================
  // From JSON
  // ============================================================

  factory VendorOrderStatusHistoryModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const VendorOrderStatusHistoryModel();
    }

    return VendorOrderStatusHistoryModel(
      id: _parseInt(json['id']),
      orderId: _parseInt(json['order_id']),
      status: _parseString(json['status']),
      notes: _parseString(json['notes']),
      updatedBy: _parseInt(json['updated_by']),
      updatedByType: _parseString(json['updated_by_type']),
      createdAt: _parseString(json['created_at']),
      updatedAt: _parseString(json['updated_at']),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'status': status,
      'notes': notes,
      'updated_by': updatedBy,
      'updated_by_type': updatedByType,
      'created_at': createdAt,
      'updated_at': updatedAt,
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
}
