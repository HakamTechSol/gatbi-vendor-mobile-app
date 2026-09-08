import 'package:flutter/material.dart';

class AnalyticsStatModel {
  const AnalyticsStatModel({
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.iconBackgroundColor,
  });

  final String title;
  final String value;
  final String? subtitle;

  final IconData? icon;
  final Color? iconColor;
  final Color? iconBackgroundColor;

  AnalyticsStatModel copyWith({
    String? title,
    String? value,
    String? subtitle,
    IconData? icon,
    Color? iconColor,
    Color? iconBackgroundColor,
  }) {
    return AnalyticsStatModel(
      title: title ?? this.title,
      value: value ?? this.value,
      subtitle: subtitle ?? this.subtitle,
      icon: icon ?? this.icon,
      iconColor: iconColor ?? this.iconColor,
      iconBackgroundColor: iconBackgroundColor ?? this.iconBackgroundColor,
    );
  }

  factory AnalyticsStatModel.fromJson(Map<String, dynamic> json) {
    return AnalyticsStatModel(
      title: json['title']?.toString() ?? '',
      value: json['value']?.toString() ?? '',
      subtitle: json['subtitle']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'value': value, 'subtitle': subtitle};
  }
}
