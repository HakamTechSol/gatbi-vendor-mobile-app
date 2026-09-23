import 'package:flutter/material.dart';

import 'product_form_section.dart';
import 'product_section_header.dart';
import 'product_text_field.dart';

class SeoSettingsSection extends StatelessWidget {
  const SeoSettingsSection({
    super.key,
    required this.metaTitleController,
    required this.metaDescriptionController,
    required this.metaKeywordsController,
    this.slugController,
  });

  final TextEditingController metaTitleController;
  final TextEditingController metaDescriptionController;
  final TextEditingController metaKeywordsController;
  final TextEditingController? slugController;

  @override
  Widget build(BuildContext context) {
    return ProductFormSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProductSectionHeader(
            title: 'SEO Settings',
            description:
                'Optimize your product information for search engines.',
          ),

          const SizedBox(height: 24),

          if (slugController != null) ...[
            ProductTextField(
              controller: slugController!,
              label: 'URL Slug',
              hintText: 'product-name',
              prefixIcon: Icons.link_rounded,
            ),
            const SizedBox(height: 20),
          ],

          ProductTextField(
            controller: metaTitleController,
            label: 'Meta Title',
            hintText: 'Enter SEO meta title',
            maxLength: 60,
            prefixIcon: Icons.title_rounded,
          ),

          const SizedBox(height: 20),

          ProductTextField(
            controller: metaDescriptionController,
            label: 'Meta Description',
            hintText: 'Enter SEO meta description',
            maxLines: 4,
            maxLength: 160,
            prefixIcon: Icons.description_outlined,
          ),

          const SizedBox(height: 20),

          ProductTextField(
            controller: metaKeywordsController,
            label: 'Meta Keywords',
            hintText: 'Enter keywords separated by commas',
            maxLines: 2,
            prefixIcon: Icons.key_rounded,
          ),
        ],
      ),
    );
  }
}
