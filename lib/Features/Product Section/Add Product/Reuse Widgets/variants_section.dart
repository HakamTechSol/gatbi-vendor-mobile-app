import 'package:flutter/material.dart';

import '../../../Attributes/Get Attributes/Models/get_attributes_model.dart';

import 'product_form_section.dart';
import 'product_section_header.dart';
import 'variant_builder.dart';

class VariantsSection extends StatelessWidget {
  const VariantsSection({
    super.key,
    required this.attributes,
    required this.onAttributesChanged,
    this.variants,
    required this.onVariantsChanged,
    required this.enabledVariants,
    required this.onVariantsEnabledChanged,
    this.availableAttributes = const [],
    this.enabled = true,

    // ============================================================
    // PRICING DEFAULTS
    //
    // These values are used ONLY when a NEW variant is created.
    //
    // Existing variants must never be overwritten during rebuild.
    // ============================================================
    this.defaultPrice = '',
    this.defaultCompareAtPrice = '',
    this.defaultStockQuantity = '',
    this.defaultSku = '',
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // SELECTED PRODUCT ATTRIBUTES
  //
  // ProductAttributeModel remove kar diya gaya hai.
  // Ab API ka GetAttributeModel directly use hoga.
  // ═══════════════════════════════════════════════════════════════════════════

  final List<GetAttributeModel> attributes;

  final ValueChanged<List<GetAttributeModel>> onAttributesChanged;

  // ═══════════════════════════════════════════════════════════════════════════
  // PRODUCT VARIANTS
  //
  // VariantBuilder ka VariantData directly use hoga.
  // ═══════════════════════════════════════════════════════════════════════════

  final List<VariantData>? variants;

  final ValueChanged<List<VariantData>> onVariantsChanged;

  // ═══════════════════════════════════════════════════════════════════════════
  // VARIANTS ENABLE / DISABLE
  // ═══════════════════════════════════════════════════════════════════════════

  final bool enabledVariants;

  final ValueChanged<bool> onVariantsEnabledChanged;

  // ═══════════════════════════════════════════════════════════════════════════
  // API AVAILABLE ATTRIBUTES
  // ═══════════════════════════════════════════════════════════════════════════

  final List<GetAttributeModel> availableAttributes;

  final bool enabled;

  // ═══════════════════════════════════════════════════════════════════════════
  // NEW VARIANT PRICING DEFAULTS
  //
  // IMPORTANT:
  // These are passed to VariantBuilder only.
  //
  // VariantBuilder should use them when creating a NEW VariantData.
  // Existing VariantData should remain unchanged.
  // ═══════════════════════════════════════════════════════════════════════════

  final String defaultPrice;

  final String defaultCompareAtPrice;

  final String defaultStockQuantity;

  final String defaultSku;

  // ═══════════════════════════════════════════════════════════════════════════
  // GET ATTRIBUTE VALUES AS STRINGS
  //
  // VariantBuilder works with:
  //
  // VariantAttribute(
  //   id,
  //   name,
  //   values: List<String>
  // )
  //
  // GetAttributeModel contains:
  //
  // values: List<GetAttributeValueModel>
  //
  // Isliye API model ko builder format mein convert karte hain.
  // ═══════════════════════════════════════════════════════════════════════════

  List<VariantAttribute> _toBuilderAttributes() {
    return attributes.map((attribute) {
      return VariantAttribute(
        id: attribute.id,
        name: attribute.name ?? '',
        values: attribute.values
            .map((value) => value.value ?? '')
            .where((value) => value.trim().isNotEmpty)
            .toList(),
      );
    }).toList();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BUILDER ATTRIBUTE → GET ATTRIBUTE MODEL
  // ═══════════════════════════════════════════════════════════════════════════

  List<GetAttributeModel> _fromBuilderAttributes(
    List<VariantAttribute> builderAttributes,
  ) {
    return builderAttributes.map((builderAttribute) {
      // ----------------------------------------------------------
      // Find existing API attribute.
      // ----------------------------------------------------------

      GetAttributeModel? existing;

      for (final item in availableAttributes) {
        final sameId =
            builderAttribute.id != null && item.id == builderAttribute.id;

        final sameName =
            (item.name ?? '').trim().toLowerCase() ==
            builderAttribute.name.trim().toLowerCase();

        if (sameId || sameName) {
          existing = item;
          break;
        }
      }

      // ----------------------------------------------------------
      // Existing API values
      // ----------------------------------------------------------

      final selectedValues = <GetAttributeValueModel>[];

      for (final selectedValue in builderAttribute.values) {
        final normalizedSelected = selectedValue.trim().toLowerCase();

        if (normalizedSelected.isEmpty) {
          continue;
        }

        GetAttributeValueModel? matchedValue;

        if (existing != null) {
          for (final apiValue in existing.values) {
            final valueName = (apiValue.value ?? '').trim().toLowerCase();

            if (valueName == normalizedSelected) {
              matchedValue = apiValue;
              break;
            }
          }
        }

        // --------------------------------------------------------
        // Agar API value mil gayi to usi ko preserve karo.
        // --------------------------------------------------------

        if (matchedValue != null) {
          selectedValues.add(matchedValue);
        } else {
          // ------------------------------------------------------
          // Custom/new value.
          //
          // ID null rahegi.
          // API request mein valid ID wali values hi jayengi.
          // ------------------------------------------------------

          selectedValues.add(
            GetAttributeValueModel(id: null, value: selectedValue),
          );
        }
      }

      // ----------------------------------------------------------
      // Return API model.
      // ----------------------------------------------------------

      return GetAttributeModel(
        id: existing?.id ?? builderAttribute.id,
        name: builderAttribute.name,
        adminLabel: existing?.adminLabel,
        slug: existing?.slug,
        inputType: existing?.inputType,
        isOwn: existing?.isOwn ?? false,
        values: selectedValues,
      );
    }).toList();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    final builderAttributes = _toBuilderAttributes();

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
          // ENABLE VARIANTS
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

              // ----------------------------------------------------------
              // Builder → API attribute model
              // ----------------------------------------------------------
              onAttributesChanged: (value) {
                final updatedAttributes = _fromBuilderAttributes(value);

                onAttributesChanged(updatedAttributes);
              },

              // ----------------------------------------------------------
              // Existing variants
              //
              // IMPORTANT:
              // Existing VariantData ko directly builder mein pass kiya
              // ja raha hai.
              //
              // Isliye parent rebuild hone par existing variant ki
              // pricing overwrite nahi hogi.
              // ----------------------------------------------------------
              variants: variants ?? const [],

              onVariantsChanged: (value) {
                onVariantsChanged(List<VariantData>.from(value));
              },

              // ----------------------------------------------------------
              // API available attributes
              // ----------------------------------------------------------
              availableAttributes: availableAttributes,

              // ----------------------------------------------------------
              // New variant pricing defaults
              //
              // VariantBuilder in values ko sirf NEW variant create
              // karte waqt use karega.
              // ----------------------------------------------------------
              defaultPrice: defaultPrice,
              defaultCompareAtPrice: defaultCompareAtPrice,
              defaultStockQuantity: defaultStockQuantity,
              defaultSku: defaultSku,

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
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colorScheme.surface,
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
                  ? colorScheme.primary.withValues(alpha: 0.10)
                  : colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              Icons.tune_rounded,
              size: 21,
              color: value ? colorScheme.primary : colorScheme.onSurfaceVariant,
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
                    color: colorScheme.onSurfaceVariant,
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
