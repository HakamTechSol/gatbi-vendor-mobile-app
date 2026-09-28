import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import 'review_comment.dart';
import 'review_customer_info.dart';
import 'review_rating.dart';
import 'review_reply_input.dart';
import 'review_status_badge.dart';
import 'review_vendor_reply.dart';
import 'review_product_info.dart';

class ReviewCard extends StatelessWidget {
  const ReviewCard({
    super.key,
    required this.reviewId,
    required this.productName,
    required this.customerName,
    required this.rating,
    required this.comment,
    required this.isApproved,
    this.productId,
    this.productImage,
    this.customerAvatar,
    this.createdAt,
    this.vendorReply,
    this.vendorRepliedAt,
    this.onReply,
    this.isReplyLoading = false,
  });

  // ===========================================================================
  // Review
  // ===========================================================================

  final int reviewId;
  final double? rating;
  final String? comment;
  final bool? isApproved;

  // ===========================================================================
  // Product
  // ===========================================================================

  final int? productId;
  final String? productName;
  final String? productImage;

  // ===========================================================================
  // Customer
  // ===========================================================================

  final String? customerName;
  final String? customerAvatar;
  final String? createdAt;

  // ===========================================================================
  // Vendor Reply
  // ===========================================================================

  final String? vendorReply;
  final String? vendorRepliedAt;

  // ===========================================================================
  // Reply
  // ===========================================================================

  final Future<void> Function(String reply)? onReply;
  final bool isReplyLoading;

  // ===========================================================================
  // Build
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    final hasVendorReply = _hasVendorReply;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            // -----------------------------------------------------------------
            // Top Accent
            // -----------------------------------------------------------------
            _buildTopAccent(),

            Padding(
              padding: const EdgeInsets.fromLTRB(17, 16, 17, 17),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // -----------------------------------------------------------
                  // Product
                  // -----------------------------------------------------------
                  ReviewProductInfo(
                    productId: productId,
                    productName: productName,
                    productImage: productImage,
                  ),

                  const SizedBox(height: 16),

                  _buildDivider(),

                  const SizedBox(height: 16),

                  // -----------------------------------------------------------
                  // Customer
                  // -----------------------------------------------------------
                  ReviewCustomerInfo(
                    customerName: customerName,
                    customerAvatar: customerAvatar,
                    createdAt: createdAt,
                  ),

                  const SizedBox(height: 15),

                  // -----------------------------------------------------------
                  // Rating + Status
                  // -----------------------------------------------------------
                  _buildRatingSection(),

                  const SizedBox(height: 14),

                  // -----------------------------------------------------------
                  // Customer Comment
                  // -----------------------------------------------------------
                  ReviewComment(comment: comment),

                  // -----------------------------------------------------------
                  // Vendor Reply
                  // -----------------------------------------------------------
                  if (hasVendorReply) ...[
                    const SizedBox(height: 12),

                    ReviewVendorReply(
                      reply: vendorReply,
                      repliedAt: vendorRepliedAt,
                    ),
                  ],

                  // -----------------------------------------------------------
                  // Reply Input
                  //
                  // IMPORTANT:
                  // Only show when vendor_reply is null/empty.
                  // -----------------------------------------------------------
                  if (!hasVendorReply && onReply != null) ...[
                    const SizedBox(height: 12),

                    ReviewReplyInput(
                      onSubmit: onReply!,
                      isLoading: isReplyLoading,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // Top Accent
  // ===========================================================================

  Widget _buildTopAccent() {
    return Container(
      height: 4,
      decoration: BoxDecoration(gradient: AppColors.primaryGradient),
    );
  }

  // ===========================================================================
  // Rating Section
  // ===========================================================================

  Widget _buildRatingSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // -------------------------------------------------------------------
          // Rating
          // -------------------------------------------------------------------
          ReviewRating(
            rating: rating,
            showValue: true,
            starSize: 17,
            spacing: 2,
          ),

          const Spacer(),

          // -------------------------------------------------------------------
          // Status
          // -------------------------------------------------------------------
          ReviewStatusBadge(isApproved: isApproved),
        ],
      ),
    );
  }

  // ===========================================================================
  // Divider
  // ===========================================================================

  Widget _buildDivider() {
    return const Divider(height: 1, thickness: 1, color: AppColors.divider);
  }

  // ===========================================================================
  // Vendor Reply Check
  // ===========================================================================

  bool get _hasVendorReply {
    return vendorReply != null && vendorReply!.trim().isNotEmpty;
  }
}
