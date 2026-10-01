class NotificationItemModel {
  const NotificationItemModel({
    this.id,
    this.type,
    this.title,
    this.message,
    this.link,
    this.isRead = false,
    this.createdAt,
  });

  final int? id;
  final String? type;
  final String? title;
  final String? message;
  final String? link;
  final bool isRead;
  final String? createdAt;

  factory NotificationItemModel.fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return const NotificationItemModel();
    }

    return NotificationItemModel(
      id: _parseInt(json['id']),
      type: _parseString(json['type']),
      title: _parseString(json['title']),
      message: _parseString(json['message']),
      link: _parseString(json['link']),
      isRead: _parseBool(json['is_read']),
      createdAt: _parseString(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'message': message,
      'link': link,
      'is_read': isRead,
      'created_at': createdAt,
    };
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
}