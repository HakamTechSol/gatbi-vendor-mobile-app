import 'package:flutter/material.dart';

import 'product_dropdown_field.dart';
import 'product_form_section.dart';
import 'product_section_header.dart';

class CategoryBrandSection extends StatelessWidget {
  const CategoryBrandSection({
    super.key,
    required this.categoryId,
    required this.brandId,
    required this.categories,
    required this.brands,
    required this.onCategoryChanged,
    required this.onBrandChanged,
    this.categoryLabel = 'Category',
    this.brandLabel = 'Brand',
    this.categoryHint = 'Select category',
    this.brandHint = 'Select brand',
    this.categoryRequired = true,
    this.brandRequired = false,
    this.isLoadingCategories = false,
    this.isLoadingBrands = false,
  });

  final String? categoryId;
  final String? brandId;

  final List<ProductDropdownItem<String>> categories;
  final List<ProductDropdownItem<String>> brands;

  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<String?> onBrandChanged;

  final String categoryLabel;
  final String brandLabel;

  final String categoryHint;
  final String brandHint;

  final bool categoryRequired;
  final bool brandRequired;

  final bool isLoadingCategories;
  final bool isLoadingBrands;

  @override
  Widget build(BuildContext context) {
    return ProductFormSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProductSectionHeader(
            title: 'Category & Brand',
            description:
                'Organize your product by selecting its category and brand.',
          ),

          const SizedBox(height: 24),

          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 700;

              if (isWide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildCategoryDropdown()),

                    const SizedBox(width: 16),

                    Expanded(child: _buildBrandDropdown()),
                  ],
                );
              }

              return Column(
                children: [
                  _buildCategoryDropdown(),

                  const SizedBox(height: 20),

                  _buildBrandDropdown(),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return ProductDropdownField<String>(
      label: categoryRequired ? '$categoryLabel *' : categoryLabel,
      hintText: categoryHint,
      value: categoryId,
      items: categories,
      onChanged: isLoadingCategories ? null : onCategoryChanged,
      emptyMessage: isLoadingCategories
          ? 'Loading categories...'
          : 'No categories available',
    );
  }

  Widget _buildBrandDropdown() {
    return ProductDropdownField<String>(
      label: brandRequired ? '$brandLabel *' : brandLabel,
      hintText: brandHint,
      value: brandId,
      items: brands,
      onChanged: isLoadingBrands ? null : onBrandChanged,
      emptyMessage: isLoadingBrands
          ? 'Loading brands...'
          : 'No brands available',
    );
  }
}
