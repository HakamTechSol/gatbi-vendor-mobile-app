import '../../Order List/models/order_model.dart';

class OrderTimelineModel {
  const OrderTimelineModel({
    required this.id,
    required this.status,
    required this.title,
    required this.createdAt,
    this.description,
    this.location,
    this.isCompleted = false,
    this.isCurrent = false,
  });

  final String id;
  final OrderStatus status;
  final String title;
  final DateTime createdAt;

  final String? description;
  final String? location;

  final bool isCompleted;
  final bool isCurrent;

  factory OrderTimelineModel.fromJson(Map<String, dynamic> json) {
    return OrderTimelineModel(
      id: json['id']?.toString() ?? '',
      status: OrderStatusExtension.fromString(json['status']?.toString()),
      title: json['title']?.toString() ?? '',
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
      description: json['description']?.toString(),
      location: json['location']?.toString(),
      isCompleted: _parseBool(json['is_completed']),
      isCurrent: _parseBool(json['is_current']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status.value,
      'title': title,
      'created_at': createdAt.toIso8601String(),
      'description': description,
      'location': location,
      'is_completed': isCompleted,
      'is_current': isCurrent,
    };
  }

  OrderTimelineModel copyWith({
    String? id,
    OrderStatus? status,
    String? title,
    DateTime? createdAt,
    String? description,
    String? location,
    bool? isCompleted,
    bool? isCurrent,
  }) {
    return OrderTimelineModel(
      id: id ?? this.id,
      status: status ?? this.status,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      description: description ?? this.description,
      location: location ?? this.location,
      isCompleted: isCompleted ?? this.isCompleted,
      isCurrent: isCurrent ?? this.isCurrent,
    );
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;

    return value?.toString().toLowerCase() == 'true' ||
        value?.toString() == '1';
  }
}
