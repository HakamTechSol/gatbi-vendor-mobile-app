
import 'package:flutter/material.dart';

import '../../../../Core/Custom Widgets/custom_textfield.dart';

class TicketMessageField extends StatelessWidget {
  const TicketMessageField({
    super.key,
    this.controller,
    this.onChanged,
    this.validator,
    this.enabled = true,
  });

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller ?? TextEditingController(),
      label: 'Message',
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      textCapitalization: TextCapitalization.sentences,
      minLines: 5,
      maxLines: 8,
      enabled: enabled,
      onChanged: onChanged,
      validator: validator,
    );
  }
}
