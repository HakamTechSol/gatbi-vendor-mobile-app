import 'package:flutter/material.dart';

import '../../../../Core/Custom Widgets/custom_textfield.dart';


class TicketSubjectField extends StatelessWidget {
  const TicketSubjectField({
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
      label: 'Subject',
      prefixIcon: Icons.subject_rounded,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      textCapitalization: TextCapitalization.sentences,
      enabled: enabled,
      onChanged: onChanged,
      validator: validator,
    );
  }
}
