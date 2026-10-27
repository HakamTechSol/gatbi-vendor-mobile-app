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
    this.defaultPrice = '',
    this.defaultCompareAtPrice = '',
    this.defaultStockQuantity = '',
    this.defaultSku = '',
  });

  final List<VariantAttribute> attributes;
  final ValueChanged<List<VariantAttribute>> onAttributesChanged;
  final List<VariantData> variants;
  final ValueChanged<List<VariantData>> onVariantsChanged;
  final List<GetAttributeModel> availableAttributes;
  final bool enabled;

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

    if (!_sameAttributeList(
      oldWidget.availableAttributes,
      widget.availableAttributes,
    )) {
      _availableAttributes = List<GetAttributeModel>.from(
        widget.availableAttributes,
      );
    }

    if (!_sameVariantList(oldWidget.variants, widget.variants)) {
      _variants = List<VariantData>.from(widget.variants);
    }

    if (!_sameSelectedAttributeList(oldWidget.attributes, widget.attributes)) {
      _removeUnavailableSelectedAttributes();
    }
  }

  // ============================================================
  // LIST COMPARISON (Same as before)
  // ============================================================

  bool _sameAttributeList(
    List<GetAttributeModel> first,
    List<GetAttributeModel> second,
  ) {
    if (identical(first, second)) return true;
    if (first.length != second.length) return false;
    for (var i = 0; i < first.length; i++) {
      if (first[i].id != second[i].id) return false;
      if ((first[i].name ?? '').trim().toLowerCase() !=
          (second[i].name ?? '').trim().toLowerCase())
        return false;
      if (first[i].values.length != second[i].values.length) return false;
    }
    return true;
  }

  bool _sameSelectedAttributeList(
    List<VariantAttribute> first,
    List<VariantAttribute> second,
  ) {
    if (identical(first, second)) return true;
    if (first.length != second.length) return false;
    for (var i = 0; i < first.length; i++) {
      if (first[i].id != second[i].id) return false;
      if (first[i].name.trim().toLowerCase() !=
          second[i].name.trim().toLowerCase())
        return false;
      if (first[i].values.length != second[i].values.length) return false;
      for (var j = 0; j < first[i].values.length; j++) {
        if (first[i].values[j].trim().toLowerCase() !=
            second[i].values[j].trim().toLowerCase())
          return false;
      }
    }
    return true;
  }

  bool _sameVariantList(List<VariantData> first, List<VariantData> second) {
    if (identical(first, second)) return true;
    if (first.length != second.length) return false;
    for (var i = 0; i < first.length; i++) {
      if (!_sameStringMap(first[i].attributes, second[i].attributes))
        return false;
      if (!_sameIntMap(first[i].attributeValueIds, second[i].attributeValueIds))
        return false;
      if (first[i].price != second[i].price ||
          first[i].compareAtPrice != second[i].compareAtPrice ||
          first[i].stockQuantity != second[i].stockQuantity ||
          first[i].sku != second[i].sku)
        return false;
    }
    return true;
  }

  bool _sameStringMap(Map<String, String> first, Map<String, String> second) {
    if (first.length != second.length) return false;
    for (final entry in first.entries) {
      if (second[entry.key] != entry.value) return false;
    }
    return true;
  }

  bool _sameIntMap(Map<int, int> first, Map<int, int> second) {
    if (first.length != second.length) return false;
    for (final entry in first.entries) {
      if (second[entry.key] != entry.value) return false;
    }
    return true;
  }

  void _removeUnavailableSelectedAttributes() {
    if (widget.attributes.isEmpty || _availableAttributes.isEmpty) return;

    final availableIds = _availableAttributes
        .where((a) => a.id != null)
        .map((a) => a.id)
        .toSet();
    final availableNames = _availableAttributes
        .where((a) => a.name?.trim().isNotEmpty == true)
        .map((a) => a.name!.trim().toLowerCase())
        .toSet();

    final updated = widget.attributes.where((selected) {
      if (selected.id != null) return availableIds.contains(selected.id);
      return availableNames.contains(selected.name.trim().toLowerCase());
    }).toList();

    if (updated.length == widget.attributes.length) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      widget.onAttributesChanged(List<VariantAttribute>.from(updated));
    });
  }

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

  void _toggleAttribute(GetAttributeModel attribute) {
    if (!widget.enabled) return;
    final attributeId = attribute.id;
    final attributeName = attribute.name?.trim();
    if (attributeId == null || attributeName == null || attributeName.isEmpty)
      return;

    final updated = _cloneAttributes(widget.attributes);
    final index = updated.indexWhere(
      (item) =>
          item.id == attributeId ||
          item.name.trim().toLowerCase() == attributeName.toLowerCase(),
    );

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

      setState(() => _variants = List<VariantData>.from(updatedVariants));
      widget.onAttributesChanged(List<VariantAttribute>.from(updated));
      widget.onVariantsChanged(List<VariantData>.from(updatedVariants));
      return;
    }

    updated.add(
      VariantAttribute(
        id: attributeId,
        name: attributeName,
        values: <String>[],
      ),
    );
    widget.onAttributesChanged(List<VariantAttribute>.from(updated));
  }

  void _toggleValue(GetAttributeModel attribute, String value) {
    if (!widget.enabled) return;
    final attributeId = attribute.id;
    final attributeName = attribute.name?.trim();
    if (attributeId == null || attributeName == null || attributeName.isEmpty)
      return;

    final normalizedValue = value.trim();
    if (normalizedValue.isEmpty) return;

    final updated = _cloneAttributes(widget.attributes);
    final attributeIndex = updated.indexWhere(
      (item) =>
          item.id == attributeId ||
          item.name.trim().toLowerCase() == attributeName.toLowerCase(),
    );
    if (attributeIndex < 0) return;

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

  GetAttributeModel? _findApiAttribute(VariantAttribute selected) {
    for (final attribute in _availableAttributes) {
      if (selected.id != null && attribute.id == selected.id) return attribute;
      final apiName = attribute.name?.trim();
      if (apiName != null &&
          apiName.isNotEmpty &&
          apiName.toLowerCase() == selected.name.trim().toLowerCase())
        return attribute;
    }
    return null;
  }

  // ============================================================
  // 🚀 NEW: GENERATE COMBINATIONS LOGIC
  // ============================================================

  void _generateCombinations() {
    if (!widget.enabled) return;

    // 1. Validation
    if (widget.attributes.isEmpty) {
      _showMessage('Please select at least one attribute first.');
      return;
    }

    final attributesWithoutValues = widget.attributes
        .where((a) => a.values.isEmpty)
        .toList();
    if (attributesWithoutValues.isNotEmpty) {
      _showMessage('Please select at least one value for every attribute.');
      return;
    }

    // 2. Generate Cartesian Product
    List<Map<String, String>> combinations = [{}];

    for (final attribute in widget.attributes) {
      final newCombinations = <Map<String, String>>[];
      for (final combo in combinations) {
        for (final value in attribute.values) {
          final newCombo = Map<String, String>.from(combo);
          newCombo[attribute.name] = value;
          newCombinations.add(newCombo);
        }
      }
      combinations = newCombinations;
    }

    // 3. Process Combinations (Filter Duplicates & Create VariantData)
    final List<VariantData> newVariantsToAdd = [];
    int addedCount = 0;

    for (final combo in combinations) {
      // Check if variant already exists
      final exists = _variants.any((v) => _sameStringMap(v.attributes, combo));
      if (exists) continue;

      // Resolve IDs for API
      final Map<int, int> attributeValueIds = {};
      for (final entry in combo.entries) {
        final attributeName = entry.key;
        final valueName = entry.value;

        final apiAttr = _availableAttributes.firstWhere(
          (a) =>
              (a.name ?? '').trim().toLowerCase() ==
              attributeName.trim().toLowerCase(),
          orElse: () => GetAttributeModel(id: null, name: null, values: []),
        );

        if (apiAttr.id != null) {
          final apiValue = apiAttr.values.firstWhere(
            (v) =>
                (v.value ?? '').trim().toLowerCase() ==
                valueName.trim().toLowerCase(),
            orElse: () => GetAttributeValueModel(id: null, value: null),
          );
          if (apiValue.id != null) {
            attributeValueIds[apiAttr.id!] = apiValue.id!;
          }
        }
      }

      // Generate Auto SKU
      final baseSku = widget.defaultSku.isNotEmpty ? widget.defaultSku : 'SKU';
      final skuSuffix = combo.values
          .map((v) => v.toUpperCase().replaceAll(' ', '-'))
          .join('-');
      final generatedSku = '$baseSku-$skuSuffix';

      final newVariant = VariantData(
        attributes: combo,
        price: widget.defaultPrice,
        compareAtPrice: widget.defaultCompareAtPrice,
        stockQuantity: widget.defaultStockQuantity,
        sku: generatedSku,
        attributeValueIds: attributeValueIds,
      );

      newVariantsToAdd.add(newVariant);
      addedCount++;
    }

    // 4. Update State
    if (addedCount > 0) {
      final updatedVariants = <VariantData>[..._variants, ...newVariantsToAdd];
      setState(() {
        _variants = updatedVariants;
      });
      widget.onVariantsChanged(List<VariantData>.from(updatedVariants));
      _showMessage('$addedCount new variant(s) generated successfully!');
    } else {
      _showMessage('All possible combinations are already generated.');
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  void _removeVariant(int index) {
    if (!widget.enabled || index < 0 || index >= _variants.length) return;
    final updatedVariants = <VariantData>[..._variants]..removeAt(index);
    setState(() => _variants = updatedVariants);
    widget.onVariantsChanged(List<VariantData>.from(updatedVariants));
  }

  void _updateVariant(int index, VariantData updatedVariant) {
    if (index < 0 || index >= _variants.length) return;
    final updatedVariants = <VariantData>[..._variants];
    updatedVariants[index] = updatedVariant;
    setState(() => _variants = updatedVariants);
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
            if (apiAttribute == null) return const SizedBox.shrink();

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _AllowedValuesCard(
                attribute: apiAttribute,
                selectedValues: selectedAttribute.values,
                enabled: widget.enabled,
                onToggleValue: (value) => _toggleValue(apiAttribute, value),
              ),
            );
          }),
        ],

        if (widget.attributes.isNotEmpty) ...[
          const SizedBox(height: 16),

          // ======================================================
          // GENERATE BUTTON & ADD VARIANT BUTTON
          // ======================================================
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: widget.enabled ? _generateCombinations : null,
                  icon: const Icon(Icons.auto_awesome_rounded, size: 20),
                  label: const Text('Generate Combinations'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                    backgroundColor: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ],

        // ======================================================
        // VARIANT CARDS LIST
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
                onChanged: (updated) => _updateVariant(index, updated),
                onDelete: () => _removeVariant(index),
              ),
            );
          }),
        ],
      ],
    );
  }
}

// ============================================================
// UI COMPONENTS (Section Title, Attribute Card, Allowed Values Card)
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
          if (name == null || name.isEmpty) return const SizedBox.shrink();

          return InkWell(
            onTap: enabled ? () => onToggle(attribute) : null,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Row(
                children: [
                  Checkbox(
                    value: selected,
                    onChanged: enabled ? (_) => onToggle(attribute) : null,
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
                  onTap: () => onToggleValue(value),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}

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
    if (color == null) return const SizedBox.shrink();
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
// VARIANT EDITOR (Same as before, handles individual card updates)
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
    if (controller.text == value) return;
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

  void _changeAttribute(VariantAttribute attribute, String? value) {
    if (value == null) return;
    final attributeId = attribute.id;
    final valueId = _findValueId(attribute, value);

    setState(() {
      _attributes[attribute.name] = value;
      if (attributeId != null && valueId != null && valueId > 0) {
        _attributeValueIds[attributeId] = valueId;
      }
    });
    _update();
  }

  int? _findValueId(VariantAttribute attribute, String selectedValue) {
    final normalized = selectedValue.trim().toLowerCase();
    for (final apiAttribute in widget.availableAttributes) {
      final sameId = attribute.id != null && apiAttribute.id == attribute.id;
      final sameName =
          (apiAttribute.name ?? '').trim().toLowerCase() ==
          attribute.name.trim().toLowerCase();
      if (!sameId && !sameName) continue;
      for (final value in apiAttribute.values) {
        if ((value.value ?? '').trim().toLowerCase() == normalized)
          return value.id;
      }
    }
    return null;
  }

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

          ...widget.selectedAttributes.map((attribute) {
            if (attribute.values.isEmpty) return const SizedBox.shrink();
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
                items: attribute.values
                    .map(
                      (value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: widget.enabled
                    ? (value) => _changeAttribute(attribute, value)
                    : null,
              ),
            );
          }),

          const SizedBox(height: 4),

          _VariantTextField(
            controller: _priceController,
            label: 'Price',
            hint: '0.00',
            enabled: widget.enabled,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => _update(),
          ),
          const SizedBox(height: 12),
          _VariantTextField(
            controller: _compareController,
            label: 'Compare at Price',
            hint: '0.00',
            enabled: widget.enabled,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => _update(),
          ),
          const SizedBox(height: 12),
          _VariantTextField(
            controller: _stockController,
            label: 'Stock Quantity',
            hint: 'Enter stock quantity',
            enabled: widget.enabled,
            keyboardType: TextInputType.number,
            onChanged: (_) => _update(),
          ),
          // const SizedBox(height: 12),
          // _VariantTextField(
          //   controller: _skuController,
          //   label: 'SKU',
          //   hint: 'Enter SKU',
          //   enabled: widget.enabled,
          //   onChanged: (_) => _update(),
          // ),
        ],
      ),
    );
  }
}

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
