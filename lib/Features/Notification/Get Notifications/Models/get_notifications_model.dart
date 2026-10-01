import 'notification_item_model.dart';
import 'notifications_pagination_model.dart';

class GetNotificationsModel {
  const GetNotificationsModel({
    this.success = false,
    this.unreadCount = 0,
    this.notifications = const [],
    this.pagination,
  });

  final bool success;
  final int unreadCount;
  final List<NotificationItemModel> notifications;
  final NotificationsPaginationModel? pagination;

  factory GetNotificationsModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const GetNotificationsModel();
    }

    return GetNotificationsModel(
      success: _parseBool(json['success']),
      unreadCount: _parseInt(json['unread_count']) ?? 0,
      notifications: _parseList(
        json['notifications'],
        NotificationItemModel.fromJson,
      ),
      pagination: json['pagination'] is Map
          ? NotificationsPaginationModel.fromJson(
              Map<String, dynamic>.from(json['pagination'] as Map),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'unread_count': unreadCount,
      'notifications': notifications
          .map((notification) => notification.toJson())
          .toList(),
      'pagination': pagination?.toJson(),
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

  static List<T> _parseList<T>(
    dynamic value,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (value is! List) return const [];

    return value
        .whereType<Map>()
        .map((item) => fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }
}
