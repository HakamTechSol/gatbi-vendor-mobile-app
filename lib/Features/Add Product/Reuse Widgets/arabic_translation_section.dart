import 'package:flutter/material.dart';

import 'product_form_section.dart';
import 'product_section_header.dart';
import 'product_text_field.dart';

class ArabicTranslationSection extends StatelessWidget {
  const ArabicTranslationSection({
    super.key,
    required this.arabicNameController,
    required this.arabicShortDescriptionController,
    required this.arabicFullDescriptionController,
    required this.arabicMetaTitleController,
    required this.arabicMetaKeywordsController,
    required this.arabicMetaDescriptionController,
    required this.onAutoTranslate,
    this.isTranslating = false,
  });

  final TextEditingController arabicNameController;
  final TextEditingController arabicShortDescriptionController;
  final TextEditingController arabicFullDescriptionController;

  // New fields
  final TextEditingController arabicMetaTitleController;
  final TextEditingController arabicMetaKeywordsController;
  final TextEditingController arabicMetaDescriptionController;

  final VoidCallback onAutoTranslate;
  final bool isTranslating;

  @override
  Widget build(BuildContext context) {
    return ProductFormSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductSectionHeader(
            title: 'Arabic Translation',
            description: 'Provide the Arabic version of your product details.',
            trailing: OutlinedButton.icon(
              onPressed: isTranslating ? null : onAutoTranslate,
              icon: isTranslating
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.translate_rounded, size: 18),
              label: Text(
                isTranslating ? 'Translating...' : 'Auto Translate Arabic',
                overflow: TextOverflow.ellipsis,
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 48),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Arabic Name
          ProductTextField(
            controller: arabicNameController,
            label: 'Arabic Name',
            hintText: 'أدخل اسم المنتج',
            isRequired: true,
            textDirection: TextDirection.rtl,
            textInputAction: TextInputAction.next,
          ),

          const SizedBox(height: 20),

          // Arabic Short Description
          ProductTextField(
            controller: arabicShortDescriptionController,
            label: 'Arabic Short Description',
            hintText: 'أدخل وصفًا مختصرًا للمنتج',
            maxLines: 3,
            textDirection: TextDirection.rtl,
            textInputAction: TextInputAction.next,
          ),

          const SizedBox(height: 20),

          // Arabic Full Description
          ProductTextField(
            controller: arabicFullDescriptionController,
            label: 'Arabic Full Description',
            hintText: 'أدخل وصف المنتج الكامل',
            isRequired: true,
            maxLines: 7,
            textDirection: TextDirection.rtl,
            textInputAction: TextInputAction.newline,
          ),

          const SizedBox(height: 20),

          // Meta Title + Meta Keywords
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ProductTextField(
                  controller: arabicMetaTitleController,
                  label: 'Arabic Meta Title',
                  hintText: 'أدخل عنوان الميتا',
                  textDirection: TextDirection.rtl,
                  textInputAction: TextInputAction.next,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: ProductTextField(
                  controller: arabicMetaKeywordsController,
                  label: 'Arabic Meta Keywords',
                  hintText: 'أدخل الكلمات المفتاحية',
                  textDirection: TextDirection.rtl,
                  textInputAction: TextInputAction.next,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Meta Description
          ProductTextField(
            controller: arabicMetaDescriptionController,
            label: 'Arabic Meta Description',
            hintText: 'أدخل وصف الميتا',
            maxLines: 4,
            textDirection: TextDirection.rtl,
            textInputAction: TextInputAction.newline,
          ),
        ],
      ),
    );
  }
}
