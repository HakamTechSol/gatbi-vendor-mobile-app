import 'question_item_model.dart';
import 'question_pagination_model.dart';

class QuestionModel {
  const QuestionModel({
    this.success,
    this.questions = const [],
    this.pagination,
  });

  // ============================================================
  // Main Response Fields
  // ============================================================

  final bool? success;
  final List<QuestionItemModel> questions;
  final QuestionPaginationModel? pagination;

  // ============================================================
  // From JSON
  // ============================================================

  factory QuestionModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const QuestionModel();
    }

    return QuestionModel(
      success: _parseBool(json['success']),
      questions: _parseList(json['questions'], QuestionItemModel.fromJson),
      pagination: json['pagination'] is Map
          ? QuestionPaginationModel.fromJson(
              Map<String, dynamic>.from(json['pagination'] as Map),
            )
          : null,
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'questions': questions.map((e) => e.toJson()).toList(),
      'pagination': pagination?.toJson(),
    };
  }

  // ============================================================
  // Parse Bool
  // ============================================================

  static bool? _parseBool(dynamic value) {
    if (value is bool) {
      return value;
    }

    if (value is String) {
      final normalized = value.toLowerCase();

      if (normalized == 'true' || normalized == '1') {
        return true;
      }

      if (normalized == 'false' || normalized == '0') {
        return false;
      }
    }

    if (value is num) {
      return value != 0;
    }

    return null;
  }

  // ============================================================
  // Parse List
  // ============================================================

  static List<T> _parseList<T>(
    dynamic value,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (value is! List) {
      return const [];
    }

    return value
        .whereType<Map>()
        .map((item) => fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }
}
