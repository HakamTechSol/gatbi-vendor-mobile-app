class BulkProductModel {
  const BulkProductModel({
    this.success = false,
    this.message,
    this.successCount = 0,
    this.failedCount = 0,
  });

  final bool success;
  final String? message;
  final int successCount;
  final int failedCount;

  factory BulkProductModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const BulkProductModel();
    }

    return BulkProductModel(
      success: _parseBool(json['success']),
      message: json['message']?.toString(),
      successCount: _parseInt(json['success_count']) ?? 0,
      failedCount: _parseInt(json['failed_count']) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'success_count': successCount,
      'failed_count': failedCount,
    };
  }

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
