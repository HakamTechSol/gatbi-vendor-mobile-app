import 'package:flutter/material.dart';

import '../../../../../Theme/app_colors.dart';
import '../../../../../Theme/app_text_styles.dart';
import '../../../Attributes/Get Attributes/Models/get_attributes_model.dart';

// ============================================================
// VARIANT ATTRIBUTE
// ============================================================

class VariantAttribute {
  VariantAttribute({required this.name, this.id, List<String>? values})
    : values = values ?? <String>[];

  final int? id;
  String name;
  List<String> values;
}

// ============================================================
// VARIANT DATA
// ============================================================

class VariantData {
  VariantData({
    required this.attributes,
    this.price = '',
    this.compareAtPrice = '',
    this.stockQuantity = '',
    this.sku = '',
    this.attributeValueIds = const {},
    this.isNew = true,
  });

  final Map<String, String> attributes;

  String price;
  String compareAtPrice;
  String stockQuantity;
  String sku;

  final Map<int, int> attributeValueIds;

  final bool isNew;

  String get stock => stockQuantity;

  set stock(String value) {
    stockQuantity = value;
  }

  String get displayName {
    if (attributes.isEmpty) {
      return 'Default Variant';
    }

    return attributes.entries
        .map((entry) => '${entry.key}: ${entry.value}')
        .join(' • ');
  }

  VariantData copyWith({
    Map<String, String>? attributes,
    String? price,
    String? compareAtPrice,
    String? stockQuantity,
    String? sku,
    Map<int, int>? attributeValueIds,
  }) {
    return VariantData(
      attributes: attributes ?? Map<String, String>.from(this.attributes),
      price: price ?? this.price,
      compareAtPrice: compareAtPrice ?? this.compareAtPrice,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      sku: sku ?? this.sku,
      attributeValueIds:
          attributeValueIds ?? Map<int, int>.from(this.attributeValueIds),
    );
  }
}

// ============================================================
// VARIANT BUILDER
// ============================================================

class VariantBuilder extends StatefulWidget {
  const VariantBuilder({
    super.key,
    required this.attributes,
    required this.onAttributesChanged,
    required this.variants,
    required this.onVariantsChanged,
    this.availableAttributes = const <GetAttributeModel>[],
    this.enabled = true,

    // ----------------------------------------------------------
    // PRICING DEFAULTS
    // ----------------------------------------------------------
    //
    // These values come from the main Product Pricing section.
    //
    // They are used ONLY when a NEW variant is created.
    // Existing variants are never overwritten automatically.
    //
    this.defaultPrice = '',
    this.defaultCompareAtPrice = '',
    this.defaultStockQuantity = '',
    this.defaultSku = '',
  });

  final List<VariantAttribute> attributes;

  final ValueChanged<List<VariantAttribute>> onAttributesChanged;

  final List<VariantData> variants;

  final ValueChanged<List<VariantData>> onVariantsChanged;

  /// Full API attributes.
  final List<GetAttributeModel> availableAttributes;

  final bool enabled;

  // ==========================================================
  // PRICING DEFAULT VALUES
  // ==========================================================

  final String defaultPrice;

  final String defaultCompareAtPrice;

  final String defaultStockQuantity;

  final String defaultSku;

  @override
  State<VariantBuilder> createState() => _VariantBuilderState();
}

// ============================================================
// VARIANT BUILDER STATE
// ============================================================

class _VariantBuilderState extends State<VariantBuilder> {
  late List<GetAttributeModel> _availableAttributes;

  /// Local state.
  ///
  /// This is important because Add Variant should immediately
  /// render the card without waiting for another interaction.
  late List<VariantData> _variants;

  @override
  void initState() {
    super.initState();

    _availableAttributes = List<GetAttributeModel>.from(
      widget.availableAttributes,
    );

    _variants = List<VariantData>.from(widget.variants);
  }

  @override
  void didUpdateWidget(covariant VariantBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);

    // ----------------------------------------------------------
    // Available API attributes changed
    // ----------------------------------------------------------

    if (!_sameAttributeList(
      oldWidget.availableAttributes,
      widget.availableAttributes,
    )) {
      _availableAttributes = List<GetAttributeModel>.from(
        widget.availableAttributes,
      );
    }

    // ----------------------------------------------------------
    // Parent variants changed externally
    //
    // Do NOT blindly replace local variants on every rebuild.
    // Only synchronize when the actual content changed.
    // ----------------------------------------------------------

    if (!_sameVariantList(oldWidget.variants, widget.variants)) {
      _variants = List<VariantData>.from(widget.variants);
    }

    // ----------------------------------------------------------
    // Selected attributes changed
    // ----------------------------------------------------------

    if (!_sameSelectedAttributeList(oldWidget.attributes, widget.attributes)) {
      _removeUnavailableSelectedAttributes();
    }
  }

  // ============================================================
  // LIST COMPARISON
  // ============================================================

  bool _sameAttributeList(
    List<GetAttributeModel> first,
    List<GetAttributeModel> second,
  ) {
    if (identical(first, second)) {
      return true;
    }

    if (first.length != second.length) {
      return false;
    }

    for (var index = 0; index < first.length; index++) {
      final firstItem = first[index];
      final secondItem = second[index];

      if (firstItem.id != secondItem.id) {
        return false;
      }

      final firstName = (firstItem.name ?? '').trim().toLowerCase();
      final secondName = (secondItem.name ?? '').trim().toLowerCase();

      if (firstName != secondName) {
        return false;
      }

      if (firstItem.values.length != secondItem.values.length) {
        return false;
      }
    }

    return true;
  }

  bool _sameSelectedAttributeList(
    List<VariantAttribute> first,
    List<VariantAttribute> second,
  ) {
    if (identical(first, second)) {
      return true;
    }

    if (first.length != second.length) {
      return false;
    }

    for (var index = 0; index < first.length; index++) {
      final firstItem = first[index];
      final secondItem = second[index];

      if (firstItem.id != secondItem.id) {
        return false;
      }

      if (firstItem.name.trim().toLowerCase() !=
          secondItem.name.trim().toLowerCase()) {
        return false;
      }

      if (firstItem.values.length != secondItem.values.length) {
        return false;
      }

      for (
        var valueIndex = 0;
        valueIndex < firstItem.values.length;
        valueIndex++
      ) {
        final firstValue = firstItem.values[valueIndex].trim().toLowerCase();

        final secondValue = secondItem.values[valueIndex].trim().toLowerCase();

        if (firstValue != secondValue) {
          return false;
        }
      }
    }

    return true;
  }

  bool _sameVariantList(List<VariantData> first, List<VariantData> second) {
    if (identical(first, second)) {
      return true;
    }

    if (first.length != second.length) {
      return false;
    }

    for (var index = 0; index < first.length; index++) {
      final firstVariant = first[index];
      final secondVariant = second[index];

      if (!_sameStringMap(firstVariant.attributes, secondVariant.attributes)) {
        return false;
      }

      if (!_sameIntMap(
        firstVariant.attributeValueIds,
        secondVariant.attributeValueIds,
      )) {
        return false;
      }

      if (firstVariant.price != secondVariant.price ||
          firstVariant.compareAtPrice != secondVariant.compareAtPrice ||
          firstVariant.stockQuantity != secondVariant.stockQuantity ||
          firstVariant.sku != secondVariant.sku) {
        return false;
      }
    }

    return true;
  }

  bool _sameStringMap(Map<String, String> first, Map<String, String> second) {
    if (first.length != second.length) {
      return false;
    }

    for (final entry in first.entries) {
      if (second[entry.key] != entry.value) {
        return false;
      }
    }

    return true;
  }

  bool _sameIntMap(Map<int, int> first, Map<int, int> second) {
    if (first.length != second.length) {
      return false;
    }

    for (final entry in first.entries) {
      if (second[entry.key] != entry.value) {
        return false;
      }
    }

    return true;
  }

  // ============================================================
  // REMOVE UNAVAILABLE ATTRIBUTES
  // ============================================================

  void _removeUnavailableSelectedAttributes() {
    if (widget.attributes.isEmpty) {
      return;
    }

    if (_availableAttributes.isEmpty) {
      return;
    }

    final availableIds = _availableAttributes
        .where((attribute) => attribute.id != null)
        .map((attribute) => attribute.id)
        .toSet();

    final availableNames = _availableAttributes
        .where((attribute) => attribute.name?.trim().isNotEmpty == true)
        .map((attribute) => attribute.name!.trim().toLowerCase())
        .toSet();

    final updated = widget.attributes.where((selected) {
      final name = selected.name.trim().toLowerCase();

      if (selected.id != null) {
        return availableIds.contains(selected.id);
      }

      return availableNames.contains(name);
    }).toList();

    if (updated.length == widget.attributes.length) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      widget.onAttributesChanged(List<VariantAttribute>.from(updated));
    });
  }

  // ============================================================
  // CLONE ATTRIBUTES
  // ============================================================

  List<VariantAttribute> _cloneAttributes(List<VariantAttribute> source) {
    return source
        .map(
          (item) => VariantAttribute(
            id: item.id,
            name: item.name,
            values: List<String>.from(item.values),
          ),
        )
        .toList();
  }

  // ============================================================
  // ATTRIBUTE SELECTION
  // ============================================================

  void _toggleAttribute(GetAttributeModel attribute) {
    if (!widget.enabled) {
      return;
    }

    final attributeId = attribute.id;
    final attributeName = attribute.name?.trim();

    if (attributeId == null || attributeName == null || attributeName.isEmpty) {
      return;
    }

    final updated = _cloneAttributes(widget.attributes);

    final index = updated.indexWhere(
      (item) =>
          item.id == attributeId ||
          item.name.trim().toLowerCase() == attributeName.toLowerCase(),
    );

    // ----------------------------------------------------------
    // REMOVE ATTRIBUTE
    // ----------------------------------------------------------

    if (index >= 0) {
      final removedAttribute = updated.removeAt(index);

      final updatedVariants = _variants.where((variant) {
        final hasAttributeByName = variant.attributes.keys.any(
          (key) =>
              key.trim().toLowerCase() ==
              removedAttribute.name.trim().toLowerCase(),
        );

        final hasAttributeById =
            removedAttribute.id != null &&
            variant.attributeValueIds.containsKey(removedAttribute.id);

        return !hasAttributeByName && !hasAttributeById;
      }).toList();

      setState(() {
        _variants = List<VariantData>.from(updatedVariants);
      });

      widget.onAttributesChanged(List<VariantAttribute>.from(updated));

      widget.onVariantsChanged(List<VariantData>.from(updatedVariants));

      return;
    }

    // ----------------------------------------------------------
    // ADD ATTRIBUTE
    // ----------------------------------------------------------

    updated.add(
      VariantAttribute(
        id: attributeId,
        name: attributeName,
        values: <String>[],
      ),
    );

    widget.onAttributesChanged(List<VariantAttribute>.from(updated));
  }

  // ============================================================
  // VALUE SELECTION
  // ============================================================

  void _toggleValue(GetAttributeModel attribute, String value) {
    if (!widget.enabled) {
      return;
    }

    final attributeId = attribute.id;
    final attributeName = attribute.name?.trim();

    if (attributeId == null || attributeName == null || attributeName.isEmpty) {
      return;
    }

    final normalizedValue = value.trim();

    if (normalizedValue.isEmpty) {
      return;
    }

    final updated = _cloneAttributes(widget.attributes);

    final attributeIndex = updated.indexWhere(
      (item) =>
          item.id == attributeId ||
          item.name.trim().toLowerCase() == attributeName.toLowerCase(),
    );

    if (attributeIndex < 0) {
      return;
    }

    final values = updated[attributeIndex].values;

    final existingIndex = values.indexWhere(
      (item) => item.trim().toLowerCase() == normalizedValue.toLowerCase(),
    );

    if (existingIndex >= 0) {
      values.removeAt(existingIndex);
    } else {
      values.add(normalizedValue);
    }

    widget.onAttributesChanged(List<VariantAttribute>.from(updated));
  }

  // ============================================================
  // FIND API ATTRIBUTE
  // ============================================================

  GetAttributeModel? _findApiAttribute(VariantAttribute selected) {
    for (final attribute in _availableAttributes) {
      if (selected.id != null && attribute.id == selected.id) {
        return attribute;
      }

      final apiName = attribute.name?.trim();

      if (apiName != null &&
          apiName.isNotEmpty &&
          apiName.toLowerCase() == selected.name.trim().toLowerCase()) {
        return attribute;
      }
    }

    return null;
  }

  // ============================================================
  // SHOW ADD VARIANT SHEET
  // ============================================================

  void _showAddVariantSheet() {
    if (!widget.enabled) {
      return;
    }

    if (widget.attributes.isEmpty) {
      _showMessage('Please select at least one attribute first.');
      return;
    }

    final attributesWithoutValues = widget.attributes
        .where((attribute) => attribute.values.isEmpty)
        .toList();

    if (attributesWithoutValues.isNotEmpty) {
      _showMessage('Please select at least one value for every attribute.');
      return;
    }

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return _AddVariantSheet(
          attributes: widget.attributes,
          availableAttributes: _availableAttributes,
          existingVariants: _variants,
          onAdd: _addVariant,

          // ----------------------------------------------------
          // MAIN PRODUCT PRICING DEFAULTS
          // ----------------------------------------------------
          defaultPrice: widget.defaultPrice,
          defaultCompareAtPrice: widget.defaultCompareAtPrice,
          defaultStockQuantity: widget.defaultStockQuantity,
          defaultSku: widget.defaultSku,
        );
      },
    );
  }

  // ============================================================
  // ADD VARIANT
  // ============================================================

  void _addVariant(VariantData variant) {
    if (!mounted) {
      return;
    }

    debugPrint('============================================================');
    debugPrint('VARIANT BUILDER: ADD VARIANT');
    debugPrint('Display: ${variant.displayName}');
    debugPrint('Attributes: ${variant.attributes}');
    debugPrint('Attribute Value IDs: ${variant.attributeValueIds}');

    debugPrint('MAIN PRODUCT DEFAULTS');
    debugPrint('Default Price: "${widget.defaultPrice}"');
    debugPrint('Default Compare At Price: "${widget.defaultCompareAtPrice}"');
    debugPrint('Default Stock Quantity: "${widget.defaultStockQuantity}"');
    debugPrint('Default SKU: "${widget.defaultSku}"');

    // ----------------------------------------------------------
    // IMPORTANT
    //
    // Apply pricing defaults ONLY to this NEW variant.
    //
    // Existing variants are never modified here.
    // ----------------------------------------------------------

    final newVariant = variant.copyWith(
      price: widget.defaultPrice,
      compareAtPrice: widget.defaultCompareAtPrice,
      stockQuantity: widget.defaultStockQuantity,
      sku: widget.defaultSku,
    );

    debugPrint('NEW VARIANT DEFAULTED VALUES');
    debugPrint('Price: "${newVariant.price}"');
    debugPrint('Compare At Price: "${newVariant.compareAtPrice}"');
    debugPrint('Stock Quantity: "${newVariant.stockQuantity}"');
    debugPrint('SKU: "${newVariant.sku}"');

    debugPrint('Existing variants before add: ${_variants.length}');

    // ----------------------------------------------------------
    // IMPORTANT
    //
    // Always create a completely NEW list.
    // ----------------------------------------------------------

    final updatedVariants = <VariantData>[..._variants, newVariant];

    setState(() {
      _variants = updatedVariants;
    });

    debugPrint('Updated variants after add: ${updatedVariants.length}');

    // ----------------------------------------------------------
    // Parent gets a NEW LIST instance.
    // ----------------------------------------------------------

    widget.onVariantsChanged(List<VariantData>.from(updatedVariants));

    debugPrint('VARIANT BUILDER: onVariantsChanged fired');
    debugPrint('============================================================');
  }

  // ============================================================
  // SHOW MESSAGE
  // ============================================================

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  // ============================================================
  // REMOVE VARIANT
  // ============================================================

  void _removeVariant(int index) {
    if (!widget.enabled) {
      return;
    }

    if (index < 0 || index >= _variants.length) {
      return;
    }

    final updatedVariants = <VariantData>[..._variants]..removeAt(index);

    setState(() {
      _variants = updatedVariants;
    });

    widget.onVariantsChanged(List<VariantData>.from(updatedVariants));
  }

  // ============================================================
  // UPDATE VARIANT
  // ============================================================

  void _updateVariant(int index, VariantData updatedVariant) {
    if (index < 0 || index >= _variants.length) {
      return;
    }

    final updatedVariants = <VariantData>[..._variants];

    updatedVariants[index] = updatedVariant;

    setState(() {
      _variants = updatedVariants;
    });

    widget.onVariantsChanged(List<VariantData>.from(updatedVariants));
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionTitle(
          title: 'Select attributes',
          subtitle: 'Choose which attributes apply to this product.',
        ),

        const SizedBox(height: 12),

        _AttributeSelectionCard(
          attributes: _availableAttributes,
          selectedAttributes: widget.attributes,
          enabled: widget.enabled,
          onToggle: _toggleAttribute,
        ),

        const SizedBox(height: 24),

        if (widget.attributes.isNotEmpty) ...[
          const _SectionTitle(
            title: 'Allowed values',
            subtitle: 'Select the values that can be used for your variants.',
          ),

          const SizedBox(height: 12),

          ...widget.attributes.map((selectedAttribute) {
            final apiAttribute = _findApiAttribute(selectedAttribute);

            if (apiAttribute == null) {
              return const SizedBox.shrink();
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _AllowedValuesCard(
                attribute: apiAttribute,
                selectedValues: selectedAttribute.values,
                enabled: widget.enabled,
                onToggleValue: (value) {
                  _toggleValue(apiAttribute, value);
                },
              ),
            );
          }),
        ],

        if (widget.attributes.isNotEmpty) ...[
          const SizedBox(height: 12),

          _AddVariantButton(
            enabled: widget.enabled,
            onPressed: _showAddVariantSheet,
          ),
        ],

        // ======================================================
        // VARIANT CARDS
        // ======================================================
        if (_variants.isNotEmpty) ...[
          const SizedBox(height: 28),

          Row(
            children: [
              Expanded(
                child: Text(
                  'Variants',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_variants.length}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          ...List.generate(_variants.length, (index) {
            final variant = _variants[index];

            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _VariantEditor(
                key: ValueKey('variant_card_${index}_${variant.displayName}'),
                variant: variant,
                selectedAttributes: widget.attributes,
                availableAttributes: _availableAttributes,
                enabled: widget.enabled,
                onChanged: (updated) {
                  _updateVariant(index, updated);
                },
                onDelete: () {
                  _removeVariant(index);
                },
              ),
            );
          }),
        ],
      ],
    );
  }
}

// ============================================================
// SECTION TITLE
// ============================================================

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
        ),
      ],
    );
  }
}

// ============================================================
// ATTRIBUTE SELECTION
// ============================================================

class _AttributeSelectionCard extends StatelessWidget {
  const _AttributeSelectionCard({
    required this.attributes,
    required this.selectedAttributes,
    required this.enabled,
    required this.onToggle,
  });

  final List<GetAttributeModel> attributes;
  final List<VariantAttribute> selectedAttributes;
  final bool enabled;
  final ValueChanged<GetAttributeModel> onToggle;

  bool _isSelected(GetAttributeModel attribute) {
    return selectedAttributes.any(
      (item) =>
          (item.id != null && item.id == attribute.id) ||
          item.name.trim().toLowerCase() ==
              (attribute.name ?? '').trim().toLowerCase(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (attributes.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(Icons.tune_rounded, size: 32, color: AppColors.iconMuted),
            const SizedBox(height: 10),
            Text(
              'No attributes available.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Attributes will appear here when available.',
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: attributes.map((attribute) {
          final selected = _isSelected(attribute);
          final name = attribute.name?.trim();

          if (name == null || name.isEmpty) {
            return const SizedBox.shrink();
          }

          return InkWell(
            onTap: enabled
                ? () {
                    onToggle(attribute);
                  }
                : null,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Row(
                children: [
                  Checkbox(
                    value: selected,
                    onChanged: enabled
                        ? (_) {
                            onToggle(attribute);
                          }
                        : null,
                    activeColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),

                  const SizedBox(width: 4),

                  Expanded(
                    child: Text(
                      name,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                    ),
                  ),

                  Text(
                    '${attribute.values.length} values',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ============================================================
// ALLOWED VALUES
// ============================================================

class _AllowedValuesCard extends StatelessWidget {
  const _AllowedValuesCard({
    required this.attribute,
    required this.selectedValues,
    required this.enabled,
    required this.onToggleValue,
  });

  final GetAttributeModel attribute;
  final List<String> selectedValues;
  final bool enabled;
  final ValueChanged<String> onToggleValue;

  @override
  Widget build(BuildContext context) {
    final attributeName = attribute.name?.trim();

    final values = attribute.values
        .where((item) => item.value?.trim().isNotEmpty == true)
        .toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  attributeName?.isNotEmpty == true
                      ? attributeName!
                      : 'Attribute',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Text(
                '${selectedValues.length} selected',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          if (values.isEmpty)
            Text(
              'No values available.',
              style: AppTextStyles.caption.copyWith(color: AppColors.textMuted),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: values.map((attributeValue) {
                final value = attributeValue.value!.trim();

                final selected = selectedValues.any(
                  (item) => item.trim().toLowerCase() == value.toLowerCase(),
                );

                return _SelectableValueChip(
                  label: value,
                  code: attributeValue.code,
                  selected: selected,
                  enabled: enabled,
                  onTap: () {
                    onToggleValue(value);
                  },
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}

// ============================================================
// SELECTABLE VALUE CHIP
// ============================================================

class _SelectableValueChip extends StatelessWidget {
  const _SelectableValueChip({
    required this.label,
    required this.code,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  final String label;
  final String? code;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorCode = code?.trim() ?? '';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primary.withValues(alpha: 0.10)
                : AppColors.inputBackground,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (colorCode.isNotEmpty) ...[
                _ColorPreview(colorCode: colorCode),
                const SizedBox(width: 6),
              ],

              Icon(
                selected
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                size: 17,
                color: selected ? AppColors.primary : AppColors.iconSecondary,
              ),

              const SizedBox(width: 6),

              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: AppTextStyles.caption.copyWith(
                    color: selected ? AppColors.primary : AppColors.textPrimary,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// COLOR PREVIEW
// ============================================================

class _ColorPreview extends StatelessWidget {
  const _ColorPreview({required this.colorCode});

  final String colorCode;

  @override
  Widget build(BuildContext context) {
    Color? color;

    try {
      final normalized = colorCode.startsWith('#')
          ? colorCode.substring(1)
          : colorCode;

      if (normalized.length == 6) {
        color = Color(int.parse('FF$normalized', radix: 16));
      } else if (normalized.length == 8) {
        color = Color(int.parse(normalized, radix: 16));
      }
    } catch (_) {
      color = null;
    }

    if (color == null) {
      return const SizedBox.shrink();
    }

    return Container(
      width: 17,
      height: 17,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.border),
      ),
    );
  }
}

// ============================================================
// ADD VARIANT BUTTON
// ============================================================

class _AddVariantButton extends StatelessWidget {
  const _AddVariantButton({required this.enabled, required this.onPressed});

  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: enabled ? onPressed : null,
        icon: const Icon(Icons.add_rounded, size: 20),
        label: const Text('Add Variant'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide(color: AppColors.primary.withValues(alpha: 0.55)),
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// ADD VARIANT BOTTOM SHEET
// ============================================================

class _AddVariantSheet extends StatefulWidget {
  const _AddVariantSheet({
    required this.attributes,
    required this.availableAttributes,
    required this.existingVariants,
    required this.onAdd,

    // ----------------------------------------------------------
    // PRICING DEFAULTS
    // ----------------------------------------------------------
    required this.defaultPrice,
    required this.defaultCompareAtPrice,
    required this.defaultStockQuantity,
    required this.defaultSku,
  });

  final List<VariantAttribute> attributes;

  final List<GetAttributeModel> availableAttributes;

  final List<VariantData> existingVariants;

  final ValueChanged<VariantData> onAdd;

  final String defaultPrice;

  final String defaultCompareAtPrice;

  final String defaultStockQuantity;

  final String defaultSku;

  @override
  State<_AddVariantSheet> createState() => _AddVariantSheetState();
}

// ============================================================
// ADD VARIANT SHEET STATE
// ============================================================

class _AddVariantSheetState extends State<_AddVariantSheet> {
  late Map<String, String> _selectedValues;

  @override
  void initState() {
    super.initState();

    _selectedValues = <String, String>{
      for (final attribute in widget.attributes)
        if (attribute.values.isNotEmpty) attribute.name: attribute.values.first,
    };
  }

  // ============================================================
  // FIND API ATTRIBUTE
  // ============================================================

  GetAttributeModel? _findApiAttribute(VariantAttribute selected) {
    for (final attribute in widget.availableAttributes) {
      if (selected.id != null && attribute.id == selected.id) {
        return attribute;
      }

      final apiName = attribute.name?.trim();

      if (apiName != null &&
          apiName.isNotEmpty &&
          apiName.toLowerCase() == selected.name.trim().toLowerCase()) {
        return attribute;
      }
    }

    return null;
  }

  // ============================================================
  // FIND VALUE ID
  // ============================================================

  int? _findValueId(VariantAttribute selectedAttribute, String selectedValue) {
    final apiAttribute = _findApiAttribute(selectedAttribute);

    if (apiAttribute == null) {
      return null;
    }

    final normalizedValue = selectedValue.trim().toLowerCase();

    for (final value in apiAttribute.values) {
      final apiValue = value.value?.trim().toLowerCase();

      if (apiValue == normalizedValue && value.id != null && value.id! > 0) {
        return value.id;
      }
    }

    return null;
  }

  // ============================================================
  // BUILD ATTRIBUTE VALUE IDS
  // ============================================================

  Map<int, int> _buildAttributeValueIds() {
    final result = <int, int>{};

    for (final attribute in widget.attributes) {
      final attributeId = attribute.id;

      if (attributeId == null || attributeId <= 0) {
        continue;
      }

      final selectedValue = _selectedValues[attribute.name];

      if (selectedValue == null || selectedValue.trim().isEmpty) {
        continue;
      }

      final valueId = _findValueId(attribute, selectedValue);

      if (valueId != null && valueId > 0) {
        result[attributeId] = valueId;
      }
    }

    return result;
  }

  // ============================================================
  // DUPLICATE CHECK
  // ============================================================

  bool _alreadyExists(Map<int, int> currentIds) {
    if (currentIds.isEmpty) {
      return widget.existingVariants.any(
        (variant) => _sameAttributes(variant.attributes, _selectedValues),
      );
    }

    return widget.existingVariants.any((variant) {
      if (variant.attributeValueIds.isEmpty) {
        return false;
      }

      return _sameIdAttributes(variant.attributeValueIds, currentIds);
    });
  }

  bool _sameIdAttributes(Map<int, int> first, Map<int, int> second) {
    if (first.length != second.length) {
      return false;
    }

    for (final entry in first.entries) {
      if (second[entry.key] != entry.value) {
        return false;
      }
    }

    return true;
  }

  bool _sameAttributes(Map<String, String> first, Map<String, String> second) {
    if (first.length != second.length) {
      return false;
    }

    for (final firstEntry in first.entries) {
      String? matchingKey;

      for (final secondKey in second.keys) {
        if (secondKey.trim().toLowerCase() ==
            firstEntry.key.trim().toLowerCase()) {
          matchingKey = secondKey;
          break;
        }
      }

      if (matchingKey == null) {
        return false;
      }

      final secondValue = second[matchingKey];

      if (secondValue == null) {
        return false;
      }

      if (secondValue.trim().toLowerCase() !=
          firstEntry.value.trim().toLowerCase()) {
        return false;
      }
    }

    return true;
  }

  // ============================================================
  // ADD
  // ============================================================

  void _add() {
    // ----------------------------------------------------------
    // Validate
    // ----------------------------------------------------------

    for (final attribute in widget.attributes) {
      final selectedValue = _selectedValues[attribute.name];

      if (selectedValue == null || selectedValue.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select a value for ${attribute.name}.'),
          ),
        );

        return;
      }
    }

    // ----------------------------------------------------------
    // Resolve IDs
    // ----------------------------------------------------------

    final attributeValueIds = _buildAttributeValueIds();

    debugPrint('============================================================');
    debugPrint('ADD VARIANT SHEET');
    debugPrint('Selected values: $_selectedValues');
    debugPrint('Resolved attribute/value IDs: $attributeValueIds');

    debugPrint('PRICING DEFAULTS');
    debugPrint('Price: "${widget.defaultPrice}"');
    debugPrint('Compare At Price: "${widget.defaultCompareAtPrice}"');
    debugPrint('Stock Quantity: "${widget.defaultStockQuantity}"');
    debugPrint('SKU: "${widget.defaultSku}"');
    debugPrint('============================================================');

    // ----------------------------------------------------------
    // API attributes exist
    //
    // Then IDs are required.
    // ----------------------------------------------------------

    if (widget.availableAttributes.isNotEmpty &&
        attributeValueIds.length != widget.attributes.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to resolve attribute values. '
            'Please refresh attributes and try again.',
          ),
        ),
      );

      return;
    }

    // ----------------------------------------------------------
    // Duplicate
    // ----------------------------------------------------------

    if (_alreadyExists(attributeValueIds)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This variant already exists.')),
      );

      return;
    }

    // ----------------------------------------------------------
    // CREATE VARIANT
    //
    // Pricing values are copied from the main Pricing section.
    // ----------------------------------------------------------

    final variant = VariantData(
      attributes: Map<String, String>.from(_selectedValues),

      // --------------------------------------------------------
      // AUTO-FILL MAIN PRODUCT PRICING
      // --------------------------------------------------------
      price: widget.defaultPrice,
      compareAtPrice: widget.defaultCompareAtPrice,
      stockQuantity: widget.defaultStockQuantity,
      sku: widget.defaultSku,

      attributeValueIds: Map<int, int>.from(attributeValueIds),
    );

    debugPrint('CREATED VARIANT: ${variant.displayName}');

    debugPrint('CREATED VARIANT IDS: ${variant.attributeValueIds}');

    debugPrint('CREATED VARIANT PRICE: "${variant.price}"');
    debugPrint('CREATED VARIANT COMPARE PRICE: "${variant.compareAtPrice}"');
    debugPrint('CREATED VARIANT STOCK: "${variant.stockQuantity}"');
    debugPrint('CREATED VARIANT SKU: "${variant.sku}"');

    // ----------------------------------------------------------
    // SEND TO BUILDER
    // ----------------------------------------------------------

    widget.onAdd(variant);

    // ----------------------------------------------------------
    // CLOSE
    // ----------------------------------------------------------

    Navigator.of(context).pop();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 70),
        padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomInset),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Add Variant',
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              Text(
                'Select the attribute values for this variant.',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textMuted,
                ),
              ),

              const SizedBox(height: 20),

              ...widget.attributes.map((attribute) {
                final values = attribute.values;

                if (values.isEmpty) {
                  return const SizedBox.shrink();
                }

                final currentValue = _selectedValues[attribute.name];

                final safeInitialValue =
                    currentValue != null && values.contains(currentValue)
                    ? currentValue
                    : values.first;

                if (!_selectedValues.containsKey(attribute.name)) {
                  _selectedValues[attribute.name] = values.first;
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: DropdownButtonFormField<String>(
                    initialValue: safeInitialValue,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: attribute.name,
                      filled: true,
                      fillColor: AppColors.inputBackground,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                        borderSide: BorderSide(
                          color: AppColors.primary,
                          width: 1.5,
                        ),
                      ),
                    ),
                    items: values.map((value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }

                      setState(() {
                        _selectedValues[attribute.name] = value;
                      });
                    },
                  ),
                );
              }),

              const SizedBox(height: 8),

              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _add,
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Add Variant'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// VARIANT EDITOR
// ============================================================

class _VariantEditor extends StatefulWidget {
  const _VariantEditor({
    super.key,
    required this.variant,
    required this.selectedAttributes,
    required this.availableAttributes,
    required this.enabled,
    required this.onChanged,
    required this.onDelete,
  });

  final VariantData variant;

  final List<VariantAttribute> selectedAttributes;

  final List<GetAttributeModel> availableAttributes;

  final bool enabled;

  final ValueChanged<VariantData> onChanged;

  final VoidCallback onDelete;

  @override
  State<_VariantEditor> createState() => _VariantEditorState();
}

// ============================================================
// VARIANT EDITOR STATE
// ============================================================

class _VariantEditorState extends State<_VariantEditor> {
  late final TextEditingController _priceController;

  late final TextEditingController _compareController;

  late final TextEditingController _stockController;

  late final TextEditingController _skuController;

  late Map<String, String> _attributes;

  late Map<int, int> _attributeValueIds;

  @override
  void initState() {
    super.initState();

    _attributes = Map<String, String>.from(widget.variant.attributes);

    _attributeValueIds = Map<int, int>.from(widget.variant.attributeValueIds);

    _priceController = TextEditingController(text: widget.variant.price);

    _compareController = TextEditingController(
      text: widget.variant.compareAtPrice,
    );

    _stockController = TextEditingController(
      text: widget.variant.stockQuantity,
    );

    _skuController = TextEditingController(text: widget.variant.sku);
  }

  @override
  void didUpdateWidget(covariant _VariantEditor oldWidget) {
    super.didUpdateWidget(oldWidget);

    // ----------------------------------------------------------
    // Sync only when the actual variant object changes.
    // ----------------------------------------------------------

    if (!identical(oldWidget.variant, widget.variant)) {
      _attributes = Map<String, String>.from(widget.variant.attributes);

      _attributeValueIds = Map<int, int>.from(widget.variant.attributeValueIds);

      _setControllerValue(_priceController, widget.variant.price);

      _setControllerValue(_compareController, widget.variant.compareAtPrice);

      _setControllerValue(_stockController, widget.variant.stockQuantity);

      _setControllerValue(_skuController, widget.variant.sku);
    }
  }

  void _setControllerValue(TextEditingController controller, String value) {
    if (controller.text == value) {
      return;
    }

    controller.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }

  @override
  void dispose() {
    _priceController.dispose();
    _compareController.dispose();
    _stockController.dispose();
    _skuController.dispose();

    super.dispose();
  }

  // ============================================================
  // UPDATE
  // ============================================================

  void _update() {
    widget.onChanged(
      VariantData(
        attributes: Map<String, String>.from(_attributes),
        price: _priceController.text,
        compareAtPrice: _compareController.text,
        stockQuantity: _stockController.text,
        sku: _skuController.text,
        attributeValueIds: Map<int, int>.from(_attributeValueIds),
      ),
    );
  }

  // ============================================================
  // CHANGE ATTRIBUTE
  // ============================================================

  void _changeAttribute(VariantAttribute attribute, String? value) {
    if (value == null) {
      return;
    }

    final attributeId = attribute.id;

    final valueId = _findValueId(attribute, value);

    setState(() {
      _attributes[attribute.name] = value;

      if (attributeId != null && valueId != null && valueId > 0) {
        _attributeValueIds[attributeId] = valueId;
      }
    });

    debugPrint(
      'VARIANT EDITOR: '
      '${attribute.name} changed to $value',
    );

    debugPrint('Updated IDs: $_attributeValueIds');

    _update();
  }

  // ============================================================
  // FIND VALUE ID
  // ============================================================

  int? _findValueId(VariantAttribute attribute, String selectedValue) {
    final normalized = selectedValue.trim().toLowerCase();

    for (final apiAttribute in widget.availableAttributes) {
      final sameId = attribute.id != null && apiAttribute.id == attribute.id;

      final sameName =
          (apiAttribute.name ?? '').trim().toLowerCase() ==
          attribute.name.trim().toLowerCase();

      if (!sameId && !sameName) {
        continue;
      }

      for (final value in apiAttribute.values) {
        if ((value.value ?? '').trim().toLowerCase() == normalized) {
          return value.id;
        }
      }
    }

    return null;
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ====================================================
          // HEADER
          // ====================================================
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(
                  Icons.inventory_2_outlined,
                  size: 18,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  'Variant ${widget.variant.displayName}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),

              IconButton(
                onPressed: widget.enabled ? widget.onDelete : null,
                tooltip: 'Remove variant',
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color: widget.enabled ? AppColors.error : AppColors.iconMuted,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ====================================================
          // ATTRIBUTE DROPDOWNS
          // ====================================================
          ...widget.selectedAttributes.map((attribute) {
            if (attribute.values.isEmpty) {
              return const SizedBox.shrink();
            }

            final storedValue = _attributes[attribute.name];

            final currentValue =
                storedValue != null && attribute.values.contains(storedValue)
                ? storedValue
                : attribute.values.first;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: DropdownButtonFormField<String>(
                initialValue: currentValue,
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: attribute.name,
                  filled: true,
                  fillColor: AppColors.inputBackground,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                    borderSide: BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                  ),
                ),
                items: attribute.values.map((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  );
                }).toList(),
                onChanged: widget.enabled
                    ? (value) {
                        _changeAttribute(attribute, value);
                      }
                    : null,
              ),
            );
          }),

          const SizedBox(height: 4),

          // ====================================================
          // PRICE
          // ====================================================
          _VariantTextField(
            controller: _priceController,
            label: 'Price',
            hint: '0.00',
            enabled: widget.enabled,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => _update(),
          ),

          const SizedBox(height: 12),

          // ====================================================
          // COMPARE PRICE
          // ====================================================
          _VariantTextField(
            controller: _compareController,
            label: 'Compare at Price',
            hint: '0.00',
            enabled: widget.enabled,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => _update(),
          ),

          const SizedBox(height: 12),

          // ====================================================
          // STOCK
          // ====================================================
          _VariantTextField(
            controller: _stockController,
            label: 'Stock Quantity',
            hint: 'Enter stock quantity',
            enabled: widget.enabled,
            keyboardType: TextInputType.number,
            onChanged: (_) => _update(),
          ),

          const SizedBox(height: 12),

          // ====================================================
          // SKU
          // ====================================================
          _VariantTextField(
            controller: _skuController,
            label: 'SKU',
            hint: 'Enter SKU',
            enabled: widget.enabled,
            onChanged: (_) => _update(),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// TEXT FIELD
// ============================================================

class _VariantTextField extends StatelessWidget {
  const _VariantTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.enabled,
    required this.onChanged,
    this.keyboardType,
  });

  final TextEditingController controller;

  final String label;
  final String hint;
  final bool enabled;

  final ValueChanged<String> onChanged;

  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: AppColors.inputBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: BorderSide(color: AppColors.border),
        ),
      ),
    );
  }
}
