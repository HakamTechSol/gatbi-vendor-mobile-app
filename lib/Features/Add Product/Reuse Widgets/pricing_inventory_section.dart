import 'package:flutter/material.dart';

import 'product_dropdown_field.dart';
import 'product_form_section.dart';
import 'product_section_header.dart';
import 'product_text_field.dart';

class PricingInventorySection extends StatelessWidget {
  const PricingInventorySection({
    super.key,
    required this.priceController,
    required this.compareAtPriceController,
    required this.stockController,
    required this.skuController,
    required this.inventoryType,
    required this.onInventoryTypeChanged,
    this.currency = 'AED',
  });

  final TextEditingController priceController;
  final TextEditingController compareAtPriceController;
  final TextEditingController stockController;
  final TextEditingController skuController;

  final String inventoryType;
  final ValueChanged<String?> onInventoryTypeChanged;

  final String currency;

  @override
  Widget build(BuildContext context) {
    return ProductFormSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProductSectionHeader(
            title: 'Pricing & Inventory',
            description: 'Set your product price, stock and inventory details.',
          ),

          const SizedBox(height: 24),

          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 700;

              if (!isWide) {
                return _buildMobileLayout();
              }

              return _buildWideLayout();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        ProductTextField(
          controller: priceController,
          label: 'Price',
          hintText: '0.00',
          isRequired: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          prefixText: '$currency ',
        ),

        const SizedBox(height: 20),

        ProductTextField(
          controller: compareAtPriceController,
          label: 'Compare at Price',
          hintText: '0.00',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          prefixText: '$currency ',
        ),

        const SizedBox(height: 20),

        ProductTextField(
          controller: stockController,
          label: 'Stock Quantity',
          hintText: 'Enter stock quantity',
          isRequired: true,
          keyboardType: TextInputType.number,
        ),

        const SizedBox(height: 20),

        ProductTextField(
          controller: skuController,
          label: 'SKU',
          hintText: 'Enter SKU',
        ),

        const SizedBox(height: 20),

        _buildInventoryDropdown(),
      ],
    );
  }

  Widget _buildWideLayout() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ProductTextField(
                controller: priceController,
                label: 'Price',
                hintText: '0.00',
                isRequired: true,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                prefixText: '$currency ',
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: ProductTextField(
                controller: compareAtPriceController,
                label: 'Compare at Price',
                hintText: '0.00',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                prefixText: '$currency ',
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ProductTextField(
                controller: stockController,
                label: 'Stock Quantity',
                hintText: 'Enter stock quantity',
                isRequired: true,
                keyboardType: TextInputType.number,
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: ProductTextField(
                controller: skuController,
                label: 'SKU',
                hintText: 'Enter SKU',
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        _buildInventoryDropdown(),
      ],
    );
  }

  Widget _buildInventoryDropdown() {
    return ProductDropdownField<String>(
      label: 'Inventory Type',
      value: inventoryType,
      items: const [
        ProductDropdownItem<String>(
          value: 'track',
          label: 'Track Inventory',
          subtitle: 'Track available product stock.',
        ),
        ProductDropdownItem<String>(
          value: 'unlimited',
          label: 'Unlimited',
          subtitle: 'Product can be purchased without stock limits.',
        ),
      ],
      onChanged: onInventoryTypeChanged,
    );
  }
}
