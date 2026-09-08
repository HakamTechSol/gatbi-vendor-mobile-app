// import 'package:flutter/material.dart';

// import '../../../Theme/app_colors.dart';
// import '../../../Theme/app_text_styles.dart';
// import '../Model/product_detail_model.dart';
// import 'product_detail_row.dart';

// class ProductInformationCard extends StatelessWidget {
//   const ProductInformationCard({super.key, required this.product});

//   final ProductDetailModel product;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: AppColors.white,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: AppColors.border.withOpacity(.65)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(.025),
//             blurRadius: 18,
//             offset: const Offset(0, 7),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildHeader(),

//           const SizedBox(height: 14),

//           ProductDetailRow(
//             label: 'Category',
//             value: _display(product.categoryName),
//             icon: Icons.category_outlined,
//           ),

//           ProductDetailRow(
//             label: 'Brand',
//             value: _display(product.brandName),
//             icon: Icons.branding_watermark_outlined,
//           ),

//           ProductDetailRow(
//             label: 'SKU',
//             value: _display(product.sku),
//             icon: Icons.qr_code_2_rounded,
//           ),

//           ProductDetailRow(
//             label: 'Status',
//             value: _display(product.status),
//             icon: Icons.verified_outlined,
//             valueColor: _statusColor(),
//           ),

//           ProductDetailRow(
//             label: 'Featured',
//             value: _yesNo(product.isFeatured),
//             icon: Icons.star_outline_rounded,
//             valueColor: product.isFeatured ? AppColors.warning : null,
//           ),

//           ProductDetailRow(
//             label: 'Trending',
//             value: _yesNo(product.isTrending),
//             icon: Icons.trending_up_rounded,
//             valueColor: product.isTrending ? AppColors.primary : null,
//           ),

//           ProductDetailRow(
//             label: 'Flash Deal',
//             value: _yesNo(product.isFlashDeal),
//             icon: Icons.bolt_outlined,
//             valueColor: product.isFlashDeal ? AppColors.error : null,
//           ),

//           ProductDetailRow(
//             label: 'Affiliates',
//             value: product.allowAffiliates ? 'Allowed' : 'Not allowed',
//             icon: Icons.people_outline_rounded,
//             valueColor: product.allowAffiliates
//                 ? AppColors.success
//                 : AppColors.textSecondary,
//             showDivider: false,
//           ),
//         ],
//       ),
//     );
//   }

//   // ═══════════════════════════════════════════════════════════════════════════
//   // HEADER
//   // ═══════════════════════════════════════════════════════════════════════════

//   Widget _buildHeader() {
//     return Row(
//       children: [
//         Container(
//           width: 40,
//           height: 40,
//           decoration: BoxDecoration(
//             color: AppColors.primary.withOpacity(.09),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: const Icon(
//             Icons.inventory_outlined,
//             color: AppColors.primary,
//             size: 21,
//           ),
//         ),

//         const SizedBox(width: 11),

//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Product Information',
//                 style: AppTextStyles.titleMedium.copyWith(
//                   color: AppColors.navy,
//                   fontWeight: FontWeight.w800,
//                 ),
//               ),
//               const SizedBox(height: 2),
//               Text(
//                 'Category, brand & product settings',
//                 style: AppTextStyles.caption.copyWith(
//                   color: AppColors.textSecondary,
//                   fontSize: 10.5,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   // ═══════════════════════════════════════════════════════════════════════════
//   // HELPERS
//   // ═══════════════════════════════════════════════════════════════════════════

//   String _display(String? value) {
//     if (value == null || value.trim().isEmpty) {
//       return '—';
//     }

//     return value;
//   }

//   String _yesNo(bool value) {
//     return value ? 'Yes' : 'No';
//   }

//   Color _statusColor() {
//     if (product.status.toLowerCase() == 'active') {
//       return AppColors.success;
//     }

//     if (product.status.toLowerCase() == 'inactive') {
//       return AppColors.error;
//     }

//     return AppColors.textSecondary;
//   }
// }
