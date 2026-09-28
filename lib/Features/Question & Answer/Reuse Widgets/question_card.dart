import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../Question/Models/question_item_model.dart';
import 'question_answer.dart';
import 'question_answer_input.dart';
import 'question_content.dart';
import 'question_customer_info.dart';
import 'question_product_info.dart';
import 'question_status_badge.dart';

class QuestionCard extends StatelessWidget {
  const QuestionCard({
    super.key,
    required this.question,
    this.onSubmitAnswer,
    this.isAnswering = false,
  });

  /// Single question item
  final QuestionItemModel question;

  /// Called when vendor submits an answer.
  final Future<void> Function(String answer)? onSubmitAnswer;

  /// Shows disabled/loading state for answer input.
  final bool isAnswering;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _buildTopAccent(),
          Padding(
            padding: const EdgeInsets.fromLTRB(17, 16, 17, 17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ------------------------------------------------------
                // Product
                // ------------------------------------------------------
                _buildProductInfo(),

                const SizedBox(height: 14),

                _buildDivider(),

                const SizedBox(height: 14),

                // ------------------------------------------------------
                // Customer
                // ------------------------------------------------------
                _buildCustomerSection(),

                const SizedBox(height: 13),

                // ------------------------------------------------------
                // Status
                // ------------------------------------------------------
                _buildStatusSection(),

                const SizedBox(height: 13),

                // ------------------------------------------------------
                // Customer Question
                // ------------------------------------------------------
                QuestionContent(question: question.question),

                const SizedBox(height: 13),

                // ------------------------------------------------------
                // Answer / Answer Input
                // ------------------------------------------------------
                _buildAnswerSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Top Accent
  // ============================================================

  Widget _buildTopAccent() {
    return Container(
      height: 4,
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
    );
  }

  // ============================================================
  // Product Info
  // ============================================================

  Widget _buildProductInfo() {
    return QuestionProductInfo(
      productName: question.product?.name,
      productId: question.product?.id,

      // Current API does not return product image.
      productImage: null,
    );
  }

  // ============================================================
  // Customer Info
  // ============================================================

  Widget _buildCustomerSection() {
    return QuestionCustomerInfo(
      customerName: question.customer?.name,
      avatarUrl: question.customer?.avatar,
      createdAt: question.createdAt,
    );
  }

  // ============================================================
  // Status
  // ============================================================

  Widget _buildStatusSection() {
    return Row(
      children: [
        Text(
          'Status',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        QuestionStatusBadge(isAnswered: question.isAnswered),
      ],
    );
  }

  // ============================================================
  // Answer Section
  // ============================================================

  Widget _buildAnswerSection() {
    // ------------------------------------------------------------
    // Already Answered
    // ------------------------------------------------------------

    if (question.isAnswered == true) {
      return QuestionAnswer(
        answer: question.answer,
        createdAt: question.answerCreatedAt,
      );
    }

    // ------------------------------------------------------------
    // Pending Answer but callback is not provided
    // ------------------------------------------------------------

    if (onSubmitAnswer == null) {
      return const SizedBox.shrink();
    }

    // ------------------------------------------------------------
    // Pending Answer
    // ------------------------------------------------------------

    return QuestionAnswerInput(
      enabled: !isAnswering,
      onSubmit: onSubmitAnswer!,
    );
  }

  // ============================================================
  // Divider
  // ============================================================

  Widget _buildDivider() {
    return Divider(height: 1, thickness: 1, color: AppColors.border);
  }
}
