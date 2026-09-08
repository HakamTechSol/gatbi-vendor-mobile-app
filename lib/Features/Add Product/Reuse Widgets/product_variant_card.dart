// import 'package:flutter/material.dart';

// import '../../../../Theme/app_colors.dart';
// import '../../../../Theme/app_text_styles.dart';
// import 'product_text_field.dart';

// class ProductVariantCard extends StatelessWidget {
//   const ProductVariantCard({
//     super.key,
//     required this.variantName,
//     required this.attributes,
//     required this.priceController,
//     required this.stockController,
//     required this.skuController,
//     required this.onDelete,
//     this.compareAtPriceController,
//     this.enabled = true,
//   });

//   final String variantName;
//   final Map<String, String> attributes;

//   final TextEditingController priceController;
//   final TextEditingController stockController;
//   final TextEditingController skuController;

//   final TextEditingController? compareAtPriceController;

//   final VoidCallback onDelete;
//   final bool enabled;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: AppColors.surface,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(
//           color: AppColors.border,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: Text(
//                   variantName,
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                   style: AppTextStyles.bodyMedium.copyWith(
//                     fontWeight: FontWeight.w600,
//                     color: AppColors.textPrimary,
//                   ),
//                 ),
//               ),

//               IconButton(
//                 onPressed: enabled ? onDelete : null,
//                 tooltip: 'Remove variant',
//                 icon: Icon(
//                   Icons.delete_outline_rounded,
//                   color: enabled
//                       ? AppColors.error
//                       : AppColors.iconMuted,
//                   size: 21,
//                 ),
//               ),
//             ],
//           ),

//           if (attributes.isNotEmpty) ...[
//             const SizedBox(height: 10),

//             Wrap(
//               spacing: 8,
//               runSpacing: 8,
//               children: attributes.entries.map((entry) {
//                 return Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 10,
//                     vertical: 6,
//                   ),
//                   decoration: BoxDecoration(
//                     color: AppColors.inputBackground,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: RichText(
//                     text: TextSpan(
//                       children: [
//                         TextSpan(
//                           text: '${entry.key}: ',
//                           style: AppTextStyles.caption.copyWith(
//                             color: AppColors.textMuted,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         TextSpan(
//                           text: entry.value,
//                           style: AppTextStyles.caption.copyWith(
//                             color: AppColors.textPrimary,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               }).toList(),
//             ),
//           ],

//           const SizedBox(height: 18),

//           LayoutBuilder(
//             builder: (context, constraints) {
//               final isWide = constraints.maxWidth >= 700;

//               if (!isWide) {
//                 return Column(
//                   children: [
//                     ProductTextField(
//                       controller: priceController,
//                       label: 'Price',
//                       hintText: '0.00',
//                       enabled: enabled,
//                       keyboardType:
//                           const TextInputType.numberWithOptions(
//                         decimal: true,
//                       ),
//                     ),

//                     const SizedBox(height: 16),

//                     if (compareAtPriceController != null) ...[
//                       ProductTextField(
//                         controller: compareAtPriceController!,
//                         label: 'Compare at Price',
//                         hintText: '0.00',
//                         enabled: enabled,
//                         keyboardType:
//                             const TextInputType.numberWithOptions(
//                           decimal: true,
//                         ),
//                       ),

//                       const SizedBox(height: 16),
//                     ],

//                     ProductTextField(
//                       controller: stockController,
//                       label: 'Stock Quantity',
//                       hintText: 'Enter stock quantity',
//                       enabled: enabled,
//                       keyboardType: TextInputType.number,
//                     ),

//                     const SizedBox(height: 16),

//                     ProductTextField(
//                       controller: skuController,
//                       label: 'SKU',
//                       hintText: 'Enter SKU',
//                       enabled: enabled,
//                     ),
//                   ],
//                 );
//               }

//               return Column(
//                 children: [
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Expanded(
//                         child: ProductTextField(
//                           controller: priceController,
//                           label: 'Price',
//                           hintText: '0.00',
//                           enabled: enabled,
//                           keyboardType:
//                               const TextInputType.numberWithOptions(
//                             decimal: true,
//                           ),
//                         ),
//                       ),

//                       if (compareAtPriceController != null) ...[
//                         const SizedBox(width: 16),

//                         Expanded(
//                           child: ProductTextField(
//                             controller: compareAtPriceController!,
//                             label: 'Compare at Price',
//                             hintText: '0.00',
//                             enabled: enabled,
//                             keyboardType:
//                                 const TextInputType.numberWithOptions(
//                               decimal: true,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ],
//                   ),

//                   const SizedBox(height: 16),

//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Expanded(
//                         child: ProductTextField(
//                           controller: stockController,
//                           label: 'Stock Quantity',
//                           hintText: 'Enter stock quantity',
//                           enabled: enabled,
//                           keyboardType: TextInputType.number,
//                         ),
//                       ),

//                       const SizedBox(width: 16),

//                       Expanded(
//                         child: ProductTextField(
//                           controller: skuController,
//                           label: 'SKU',
//                           hintText: 'Enter SKU',
//                           enabled: enabled,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }