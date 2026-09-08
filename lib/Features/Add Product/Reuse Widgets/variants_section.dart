import 'package:flutter/material.dart';

import '../Models/product_attribute_model.dart';
import '../Models/product_variant_model.dart';
import 'product_form_section.dart';
import 'product_section_header.dart';
import 'variant_builder.dart';

class VariantsSection extends StatelessWidget {
  const VariantsSection({
    super.key,
    required this.attributes,
    required this.onAttributesChanged,
    required this.variants,
    required this.onVariantsChanged,
    required this.enabledVariants,
    required this.onVariantsEnabledChanged,
    this.availableAttributes = const [],
    this.enabled = true,
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // PRODUCT FORM MODELS
  // ═══════════════════════════════════════════════════════════════════════════

  final List<ProductAttributeModel> attributes;

  final ValueChanged<List<ProductAttributeModel>> onAttributesChanged;

  final List<ProductVariantModel> variants;

  final ValueChanged<List<ProductVariantModel>> onVariantsChanged;

  /// Whether product variants are enabled.
  final bool enabledVariants;

  /// Called when user turns variants ON/OFF.
  final ValueChanged<bool> onVariantsEnabledChanged;

  final List<ProductAttributeModel> availableAttributes;

  final bool enabled;

  // ═══════════════════════════════════════════════════════════════════════════
  // PRODUCT ATTRIBUTE → VARIANT ATTRIBUTE
  // ═══════════════════════════════════════════════════════════════════════════

  List<VariantAttribute> _toBuilderAttributes() {
    return attributes
        .map(
          (attribute) => VariantAttribute(
            id: attribute.id,
            name: attribute.name,
            values: List<String>.from(attribute.values),
          ),
        )
        .toList();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PRODUCT VARIANT → VARIANT DATA
  // ═══════════════════════════════════════════════════════════════════════════

  List<VariantData> _toBuilderVariants() {
    return variants
        .map(
          (variant) => VariantData(
            attributes: Map<String, String>.from(variant.attributes),
            price: variant.price?.toString() ?? '',
            compareAtPrice: variant.compareAtPrice?.toString() ?? '',
            stock: variant.stockQuantity.toString(),
            sku: variant.sku,
          ),
        )
        .toList();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // VARIANT ATTRIBUTE → PRODUCT ATTRIBUTE
  // ═══════════════════════════════════════════════════════════════════════════

  List<ProductAttributeModel> _fromBuilderAttributes(
    List<VariantAttribute> value,
  ) {
    return value.asMap().entries.map((entry) {
      final index = entry.key;
      final attribute = entry.value;

      final existing = attributes.cast<ProductAttributeModel?>().firstWhere(
        (item) =>
            item?.id == attribute.id ||
            item?.name.toLowerCase() == attribute.name.toLowerCase(),
        orElse: () => null,
      );

      return ProductAttributeModel(
        id: existing?.id ?? attribute.id ?? (index + 1),
        name: attribute.name,
        nameAr: existing?.nameAr,
        values: List<String>.from(attribute.values),
      );
    }).toList();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // VARIANT DATA → PRODUCT VARIANT
  // ═══════════════════════════════════════════════════════════════════════════

  List<ProductVariantModel> _fromBuilderVariants(List<VariantData> value) {
    return value.asMap().entries.map((entry) {
      final index = entry.key;
      final variant = entry.value;

      final existing = index < variants.length ? variants[index] : null;

      return ProductVariantModel(
        id: existing?.id,
        sku: variant.sku.trim(),
        price: _parseDouble(variant.price),
        compareAtPrice: _parseDouble(variant.compareAtPrice),
        stockQuantity: _parseInt(variant.stock),
        image: existing?.image,
        attributes: Map<String, String>.from(variant.attributes),
        isActive: existing?.isActive ?? true,
      );
    }).toList();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PARSERS
  // ═══════════════════════════════════════════════════════════════════════════

  double? _parseDouble(String value) {
    final text = value.trim();

    if (text.isEmpty) {
      return null;
    }

    return double.tryParse(text);
  }

  int _parseInt(String value) {
    final text = value.trim();

    if (text.isEmpty) {
      return 0;
    }

    return int.tryParse(text) ?? 0;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    final builderAttributes = _toBuilderAttributes();
    final builderVariants = _toBuilderVariants();

    return ProductFormSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProductSectionHeader(
            title: 'Product Variants',
            description:
                'Create variants such as size, color or other product options.',
          ),

          const SizedBox(height: 20),

          // ═══════════════════════════════════════════════════════════════════
          // ENABLE VARIANTS TOGGLE
          // ═══════════════════════════════════════════════════════════════════
          _EnableVariantsCard(
            value: enabledVariants,
            enabled: enabled,
            onChanged: onVariantsEnabledChanged,
          ),

          // ═══════════════════════════════════════════════════════════════════
          // VARIANT BUILDER
          // ═══════════════════════════════════════════════════════════════════
          if (enabledVariants) ...[
            const SizedBox(height: 24),

            VariantBuilder(
              attributes: builderAttributes,
              onAttributesChanged: (value) {
                onAttributesChanged(_fromBuilderAttributes(value));
              },
              variants: builderVariants,
              onVariantsChanged: (value) {
                onVariantsChanged(_fromBuilderVariants(value));
              },
              availableAttributes: availableAttributes,
              enabled: enabled,
            ),
          ],
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// ENABLE VARIANTS CARD
// ═════════════════════════════════════════════════════════════════════════════

class _EnableVariantsCard extends StatelessWidget {
  const _EnableVariantsCard({
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  final bool value;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: value
                  ? Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.10)
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              Icons.tune_rounded,
              size: 21,
              color: value
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enable variants',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                ),

                const SizedBox(height: 3),

                Text(
                  'Color, size, specs and other product options',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Switch.adaptive(value: value, onChanged: enabled ? onChanged : null),
        ],
      ),
    );
  }
}
