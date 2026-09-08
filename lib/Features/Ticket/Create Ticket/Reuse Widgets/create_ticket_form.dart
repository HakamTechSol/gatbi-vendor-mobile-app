import 'package:flutter/material.dart';

import 'ticket_category_dropdown.dart';
import 'ticket_subject_field.dart';

class CreateTicketForm extends StatelessWidget {
  const CreateTicketForm({
    super.key,
    this.subjectController,
    this.selectedCategory,
    this.onCategoryChanged,
    this.onSubjectChanged,
    this.subjectValidator,
    this.categoryValidator,
    this.enabled = true,
  });

  final TextEditingController? subjectController;

  final String? selectedCategory;

  final ValueChanged<String?>? onCategoryChanged;

  final ValueChanged<String>? onSubjectChanged;

  final String? Function(String?)? subjectValidator;

  final String? Function(String?)? categoryValidator;

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TicketSubjectField(
          controller: subjectController,
          onChanged: onSubjectChanged,
          validator: subjectValidator,
          enabled: enabled,
        ),

        const SizedBox(height: 18),

        TicketCategoryDropdown(
          value: selectedCategory,
          onChanged: onCategoryChanged,
          validator: categoryValidator,
          enabled: enabled,
        ),
      ],
    );
  }
}
