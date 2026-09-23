// import 'package:flutter/material.dart';

// import '../../../Core/Custom Widgets/custom_button.dart';
// import '../../../Theme/app_colors.dart';

// class ProductActionButtons extends StatelessWidget {
//   const ProductActionButtons({
//     super.key,
//     required this.onEdit,
//     required this.onStockEdit,
//     required this.onDelete,
//     this.isDeleting = false,
//   });

//   final VoidCallback onEdit;
//   final VoidCallback onStockEdit;
//   final VoidCallback onDelete;
//   final bool isDeleting;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.fromLTRB(16, 20, 16, 28),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: AppColors.white,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(
//           color: AppColors.border.withOpacity(.7),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(.05),
//             blurRadius: 22,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: CustomButton(
//                   text: 'Edit Product',
//                   icon: Icons.edit_outlined,
//                   height: 50,
//                   borderRadius: 14,
//                   elevation: 2,
//                   onPressed: onEdit,
//                 ),
//               ),

//               const SizedBox(width: 10),

//               Expanded(
//                 child: CustomButton(
//                   text: 'Edit Stock',
//                   icon: Icons.inventory_2_outlined,
//                   height: 50,
//                   borderRadius: 14,
//                   type: CustomButtonType.outlined,
//                   onPressed: onStockEdit,
//                 ),
//               ),
//             ],
//           ),

//           const SizedBox(height: 10),

//           CustomButton(
//             text: 'Delete Product',
//             icon: Icons.delete_outline_rounded,
//             height: 46,
//             borderRadius: 13,
//             type: CustomButtonType.outlined,
//             foregroundColor: AppColors.error,
//             borderColor: AppColors.error.withOpacity(.25),
//             isLoading: isDeleting,
//             isEnabled: !isDeleting,
//             onPressed: onDelete,
//           ),
//         ],
//       ),
//     );
//   }
// }