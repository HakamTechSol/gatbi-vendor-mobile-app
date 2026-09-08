import 'package:flutter/material.dart';

import '../../../../Theme/app_text_styles.dart';

class ProductFormHeader extends StatelessWidget {
  const ProductFormHeader({
    super.key,
    required this.title,
    required this.description,
    this.onBack,
    this.trailing,
  });

  final String title;
  final String description;

  /// Optional back action.
  ///
  /// If null, no back button is shown.
  final VoidCallback? onBack;

  /// Optional widget displayed on the right side.
  ///
  /// Useful for actions such as:
  /// - Save Draft
  /// - Preview
  /// - More options
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.headlineMedium,
              ),
              const SizedBox(height: 6),
              Text(
                description,
                style: AppTextStyles.formHelper,
              ),
            ],
          ),
        ),

        if (trailing != null) ...[
          const SizedBox(width: 16),
          trailing!,
        ],
      ],
    );
  }
}
