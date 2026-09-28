// import 'package:flutter/material.dart';

// import '../../../../Theme/app_colors.dart';
// import '../../../../Theme/app_text_styles.dart';

// class StatusFilterChip extends StatelessWidget {
//   const StatusFilterChip({
//     super.key,
//     required this.label,
//     required this.selected,
//     required this.onTap,
//   });

//   final String label;
//   final bool selected;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(10),
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 180),
//           curve: Curves.easeOut,
//           constraints: const BoxConstraints(minHeight: 36, maxHeight: 38),
//           padding: const EdgeInsets.symmetric(horizontal: 14),
//           decoration: BoxDecoration(
//             color: selected ? AppColors.primary : AppColors.surface,
//             borderRadius: BorderRadius.circular(10),
//             border: Border.all(
//               color: selected ? AppColors.primary : AppColors.border,
//             ),
//           ),
//           alignment: Alignment.center,
//           child: Text(
//             label,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             softWrap: false,
//             style: AppTextStyles.captionMedium.copyWith(
//               color: selected
//                   ? AppColors.textOnPrimary
//                   : AppColors.textSecondary,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
