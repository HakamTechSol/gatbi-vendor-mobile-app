import 'question_customer_model.dart';
import 'question_product_model.dart';

class QuestionItemModel {
  const QuestionItemModel({
    this.id,
    this.product,
    this.customer,
    this.question,
    this.isAnswered,
    this.answer,
    this.answerCreatedAt,
    this.createdAt,
  });

  // ============================================================
  // Question Fields
  // ============================================================

  final int? id;
  final QuestionProductModel? product;
  final QuestionCustomerModel? customer;
  final String? question;
  final bool? isAnswered;
  final String? answer;
  final String? answerCreatedAt;
  final String? createdAt;

  // ============================================================
  // From JSON
  // ============================================================

  factory QuestionItemModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const QuestionItemModel();
    }

    return QuestionItemModel(
      id: _parseInt(json['id']),

      product: json['product'] is Map
          ? QuestionProductModel.fromJson(
              Map<String, dynamic>.from(json['product'] as Map),
            )
          : null,

      customer: json['customer'] is Map
          ? QuestionCustomerModel.fromJson(
              Map<String, dynamic>.from(json['customer'] as Map),
            )
          : null,

      question: _parseString(json['question']),
      isAnswered: _parseBool(json['is_answered']),
      answer: _parseString(json['answer']),
      answerCreatedAt: _parseString(json['answer_created_at']),
      createdAt: _parseString(json['created_at']),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product?.toJson(),
      'customer': customer?.toJson(),
      'question': question,
      'is_answered': isAnswered,
      'answer': answer,
      'answer_created_at': answerCreatedAt,
      'created_at': createdAt,
    };
  }

  // ============================================================
  // Parse Int
  // ============================================================

  static int? _parseInt(dynamic value) {
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
  // Parse String
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
}
