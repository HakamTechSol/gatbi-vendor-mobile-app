import 'package:flutter/material.dart';

import 'product_form_section.dart';
import 'product_section_header.dart';
import 'product_text_field.dart';
import 'product_switch_tile.dart';

class BasicInformationSection extends StatelessWidget {
  const BasicInformationSection({
    super.key,
    required this.productNameController,
    required this.shortDescriptionController,
    required this.fullDescriptionController,
    required this.allowAffiliates,
    required this.onAllowAffiliatesChanged,
  });

  final TextEditingController productNameController;
  final TextEditingController shortDescriptionController;
  final TextEditingController fullDescriptionController;

  final bool allowAffiliates;
  final ValueChanged<bool> onAllowAffiliatesChanged;

  @override
  Widget build(BuildContext context) {
    return ProductFormSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProductSectionHeader(
            title: 'Basic Information',
            description: 'Add the main details of your product.',
          ),

          const SizedBox(height: 24),

          ProductTextField(
            controller: productNameController,
            label: 'Product Name',
            hintText: 'Enter product name',
            isRequired: true,
            textInputAction: TextInputAction.next,
          ),

          const SizedBox(height: 20),

          ProductTextField(
            controller: shortDescriptionController,
            label: 'Short Description',
            hintText: 'Enter a short description',
            maxLines: 3,
            textInputAction: TextInputAction.next,
          ),

          const SizedBox(height: 20),

          ProductTextField(
            controller: fullDescriptionController,
            label: 'Full Description',
            hintText: 'Enter the full product description',
            isRequired: true,
            maxLines: 7,
            textInputAction: TextInputAction.newline,
          ),

          const SizedBox(height: 20),

          ProductSwitchTile(
            title: 'Allow affiliates to promote this product',
            subtitle: 'Affiliates can generate links and promote this product.',
            value: allowAffiliates,
            onChanged: onAllowAffiliatesChanged,
          ),
        ],
      ),
    );
  }
}
