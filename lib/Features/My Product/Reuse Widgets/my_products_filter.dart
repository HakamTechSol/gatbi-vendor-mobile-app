import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class MyProductsFilter extends StatelessWidget {
  const MyProductsFilter({
    super.key,
    required this.selectedCategory,
    required this.selectedStatus,
    required this.categories,
    required this.statuses,
    required this.onCategoryChanged,
    required this.onStatusChanged,
    this.onClear,
  });

  /// Currently selected category.
  ///
  /// null = All Categories
  final String? selectedCategory;

  /// Currently selected status.
  ///
  /// null = All Status
  final String? selectedStatus;

  /// Dynamic categories.
  ///
  /// Later these can directly come from API.
  final List<String> categories;

  /// Dynamic statuses.
  ///
  /// Later these can directly come from API/config.
  final List<String> statuses;

  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<String?> onStatusChanged;

  /// Optional clear-all callback.
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    // final hasFilters = selectedCategory != null || selectedStatus != null;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildFilter(
                icon: Icons.category_outlined,
                value: selectedCategory,
                hint: 'All Categories',
                items: categories,
                onChanged: onCategoryChanged,
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: _buildFilter(
                icon: Icons.tune_rounded,
                value: selectedStatus,
                hint: 'All Status',
                items: statuses,
                onChanged: onStatusChanged,
              ),
            ),
          ],
        ),

        // if (hasFilters && onClear != null) ...[
        //   const SizedBox(height: 10),

        //   Align(
        //     alignment: Alignment.centerRight,
        //     child: GestureDetector(
        //       onTap: onClear,
        //       behavior: HitTestBehavior.opaque,
        //       child: Padding(
        //         padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        //         child: Row(
        //           mainAxisSize: MainAxisSize.min,
        //           children: [
        //             const Icon(
        //               Icons.clear_all_rounded,
        //               size: 15,
        //               color: AppColors.primary,
        //             ),

        //             const SizedBox(width: 5),

        //             Text(
        //               'Clear filters',
        //               style: AppTextStyles.caption.copyWith(
        //                 color: AppColors.primary,
        //                 fontSize: 10.5,
        //                 fontWeight: FontWeight.w700,
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //     ),
        //   ),
        // ],
      ],
    );
  }

  Widget _buildFilter({
    required IconData icon,
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    final dropdownItems = <String>[
      hint,
      ...items.where((item) => item != hint),
    ];

    final dropdownValue = value ?? hint;

    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: value != null
              ? AppColors.primary.withValues(alpha: 0.45)
              : AppColors.border,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: dropdownValue,
          isExpanded: true,

          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 18,
            color: AppColors.textSecondary,
          ),

          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.navy,
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
          ),

          borderRadius: BorderRadius.circular(14),

          dropdownColor: AppColors.white,

          items: dropdownItems.map((item) {
            final isHint = item == hint;

            return DropdownMenuItem<String>(
              value: item,
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 16,
                    color: isHint ? AppColors.textSecondary : AppColors.primary,
                  ),

                  const SizedBox(width: 7),

                  Expanded(
                    child: Text(
                      item,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isHint
                            ? AppColors.textSecondary
                            : AppColors.navy,
                        fontSize: 10.5,
                        fontWeight: isHint ? FontWeight.w500 : FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),

          onChanged: (newValue) {
            if (newValue == null || newValue == hint) {
              onChanged(null);
              return;
            }

            onChanged(newValue);
          },
        ),
      ),
    );
  }
}
