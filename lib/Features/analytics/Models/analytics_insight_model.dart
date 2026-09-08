import 'package:flutter/material.dart';

enum AnalyticsInsightType { info, success, warning, error }

class AnalyticsInsightModel {
  const AnalyticsInsightModel({
    required this.title,
    required this.message,
    this.buttonText,
    this.type = AnalyticsInsightType.info,
    this.icon,
  });

  final String title;
  final String message;

  final String? buttonText;

  final AnalyticsInsightType type;

  final IconData? icon;

  AnalyticsInsightModel copyWith({
    String? title,
    String? message,
    String? buttonText,
    AnalyticsInsightType? type,
    IconData? icon,
  }) {
    return AnalyticsInsightModel(
      title: title ?? this.title,
      message: message ?? this.message,
      buttonText: buttonText ?? this.buttonText,
      type: type ?? this.type,
      icon: icon ?? this.icon,
    );
  }

  factory AnalyticsInsightModel.fromJson(Map<String, dynamic> json) {
    return AnalyticsInsightModel(
      title: json['title']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      buttonText:
          json['button_text']?.toString() ?? json['buttonText']?.toString(),
      type: _parseType(json['type']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'message': message,
      'button_text': buttonText,
      'type': type.name,
    };
  }

  static AnalyticsInsightType _parseType(dynamic value) {
    switch (value?.toString().toLowerCase()) {
      case 'success':
        return AnalyticsInsightType.success;

      case 'warning':
        return AnalyticsInsightType.warning;

      case 'error':
        return AnalyticsInsightType.error;

      case 'info':
      default:
        return AnalyticsInsightType.info;
    }
  }
}
