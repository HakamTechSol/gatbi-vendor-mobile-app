import 'package:flutter/material.dart';

import '../../../Core/Custom Widgets/custom_button.dart';

class AutoTranslateButton extends StatelessWidget {
  const AutoTranslateButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.label = 'Auto Translate Arabic',
  });

  final VoidCallback? onPressed;
  final bool isLoading;
  final String label;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: isLoading ? 'Translating...' : label,
      onPressed: isLoading ? null : onPressed,
      type: CustomButtonType.outlined,
      isLoading: isLoading,
      isEnabled: onPressed != null,
      height: 46,
      width: null,
      borderRadius: 10,
      icon: Icons.translate_rounded,
      iconPosition: CustomButtonIconPosition.leading,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
    );
  }
}