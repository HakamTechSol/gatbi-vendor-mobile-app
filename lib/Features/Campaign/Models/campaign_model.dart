enum CampaignStatus { draft, scheduled, active, completed, cancelled }

class CampaignModel {
  const CampaignModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    this.startDate,
    this.endDate,
    this.discount,
    this.productCount = 0,
    this.imageUrl,
  });

  final int id;
  final String title;
  final String description;
  final CampaignStatus status;
  final DateTime? startDate;
  final DateTime? endDate;
  final double? discount;
  final int productCount;
  final String? imageUrl;

  CampaignModel copyWith({
    int? id,
    String? title,
    String? description,
    CampaignStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    double? discount,
    int? productCount,
    String? imageUrl,
  }) {
    return CampaignModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      discount: discount ?? this.discount,
      productCount: productCount ?? this.productCount,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  factory CampaignModel.fromJson(Map<String, dynamic> json) {
    return CampaignModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      status: _statusFromString(json['status'] as String?),
      startDate: _parseDate(json['start_date']),
      endDate: _parseDate(json['end_date']),
      discount: _parseDouble(json['discount']),
      productCount: json['product_count'] as int? ?? 0,
      imageUrl: json['image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status.name,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'discount': discount,
      'product_count': productCount,
      'image_url': imageUrl,
    };
  }

  static CampaignStatus _statusFromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'draft':
        return CampaignStatus.draft;

      case 'scheduled':
        return CampaignStatus.scheduled;

      case 'active':
        return CampaignStatus.active;

      case 'completed':
        return CampaignStatus.completed;

      case 'cancelled':
      case 'canceled':
        return CampaignStatus.cancelled;

      default:
        return CampaignStatus.draft;
    }
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;

    return DateTime.tryParse(value.toString());
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value.toString());
  }

  bool get isActive => status == CampaignStatus.active;

  bool get isCompleted => status == CampaignStatus.completed;

  bool get isDraft => status == CampaignStatus.draft;

  String get statusLabel {
    switch (status) {
      case CampaignStatus.draft:
        return 'Draft';

      case CampaignStatus.scheduled:
        return 'Scheduled';

      case CampaignStatus.active:
        return 'Active';

      case CampaignStatus.completed:
        return 'Completed';

      case CampaignStatus.cancelled:
        return 'Cancelled';
    }
  }
}
