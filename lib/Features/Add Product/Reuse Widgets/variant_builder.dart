import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../Models/product_attribute_model.dart';

class VariantAttribute {
  VariantAttribute({required this.name, this.id, List<String>? values})
    : values = values ?? [];

  final int? id;
  String name;
  List<String> values;
}

class VariantData {
  VariantData({
    required this.attributes,
    this.price = '',
    this.compareAtPrice = '',
    this.stock = '',
    this.sku = '',
  });

  final Map<String, String> attributes;

  String price;
  String compareAtPrice;
  String stock;
  String sku;

  String get displayName {
    if (attributes.isEmpty) {
      return 'Default Variant';
    }

    return attributes.entries
        .map((entry) => '${entry.key}: ${entry.value}')
        .join(' • ');
  }
}

class VariantBuilder extends StatefulWidget {
  const VariantBuilder({
    super.key,
    required this.attributes,
    required this.onAttributesChanged,
    required this.variants,
    required this.onVariantsChanged,
    this.availableAttributes = const [],
    this.enabled = true,
  });

  /// Currently selected attributes.
  final List<VariantAttribute> attributes;

  final ValueChanged<List<VariantAttribute>> onAttributesChanged;

  /// Current variants.
  final List<VariantData> variants;

  final ValueChanged<List<VariantData>> onVariantsChanged;

  /// Attributes that will eventually come from API.
  final List<ProductAttributeModel> availableAttributes;

  final bool enabled;

  @override
  State<VariantBuilder> createState() => _VariantBuilderState();
}

class _VariantBuilderState extends State<VariantBuilder> {
  late List<ProductAttributeModel> _availableAttributes;

  @override
  void initState() {
    super.initState();

    _availableAttributes = widget.availableAttributes.isNotEmpty
        ? List<ProductAttributeModel>.from(widget.availableAttributes)
        : _demoAttributes();
  }

  @override
  void didUpdateWidget(covariant VariantBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.availableAttributes != widget.availableAttributes &&
        widget.availableAttributes.isNotEmpty) {
      _availableAttributes = List<ProductAttributeModel>.from(
        widget.availableAttributes,
      );
    }
  }

  // ============================================================
  // DEMO DATA
  // Later this will come from API.
  // ============================================================

  List<ProductAttributeModel> _demoAttributes() {
    return const [
      ProductAttributeModel(
        id: 1,
        name: 'Color',
        values: [
          'Black (#0a0000)',
          'Blue (#0e29b4)',
          'Green (#08c440)',
          'Red (#f11e1e)',
        ],
      ),
      ProductAttributeModel(
        id: 2,
        name: 'Color, Specs',
        values: ['Black, 8 GB/512 GB (#0a0000)', 'Blue, 12 GB/512GB (#2c37ce)'],
      ),
      ProductAttributeModel(id: 3, name: 'Size', values: ['M', 'S', 'XL']),
    ];
  }

  // ============================================================
  // HELPERS
  // ============================================================

  // bool _isAttributeSelected(ProductAttributeModel attribute) {
  //   return widget.attributes.any(
  //     (item) =>
  //         item.id == attribute.id ||
  //         item.name.toLowerCase() == attribute.name.toLowerCase(),
  //   );
  // }

  // VariantAttribute? _selectedAttribute(
  //   ProductAttributeModel attribute,
  // ) {
  //   for (final item in widget.attributes) {
  //     if (item.id == attribute.id ||
  //         item.name.toLowerCase() == attribute.name.toLowerCase()) {
  //       return item;
  //     }
  //   }

  //   return null;
  // }

  // ============================================================
  // ATTRIBUTE SELECTION
  // ============================================================

  void _toggleAttribute(ProductAttributeModel attribute) {
    if (!widget.enabled) return;

    final updated = widget.attributes
        .map(
          (item) => VariantAttribute(
            id: item.id,
            name: item.name,
            values: List<String>.from(item.values),
          ),
        )
        .toList();

    final index = updated.indexWhere(
      (item) =>
          item.id == attribute.id ||
          item.name.toLowerCase() == attribute.name.toLowerCase(),
    );

    if (index >= 0) {
      updated.removeAt(index);

      // Remove variants which use this attribute.
      final variants = widget.variants.where((variant) {
        return !variant.attributes.containsKey(attribute.name);
      }).toList();

      widget.onAttributesChanged(updated);
      widget.onVariantsChanged(variants);
    } else {
      updated.add(VariantAttribute(id: attribute.id, name: attribute.name));

      widget.onAttributesChanged(updated);
    }
  }

  // ============================================================
  // VALUE SELECTION
  // ============================================================

  void _toggleValue(ProductAttributeModel attribute, String value) {
    if (!widget.enabled) return;

    final updated = widget.attributes
        .map(
          (item) => VariantAttribute(
            id: item.id,
            name: item.name,
            values: List<String>.from(item.values),
          ),
        )
        .toList();

    final attributeIndex = updated.indexWhere(
      (item) =>
          item.id == attribute.id ||
          item.name.toLowerCase() == attribute.name.toLowerCase(),
    );

    if (attributeIndex < 0) return;

    final values = updated[attributeIndex].values;

    if (values.contains(value)) {
      values.remove(value);
    } else {
      values.add(value);
    }

    widget.onAttributesChanged(updated);
  }

  // ============================================================
  // ADD VARIANT
  // ============================================================

  void _showAddVariantSheet() {
    if (!widget.enabled) return;

    if (widget.attributes.isEmpty) {
      _showMessage('Please select at least one attribute first.');
      return;
    }

    final hasValues = widget.attributes.any(
      (attribute) => attribute.values.isNotEmpty,
    );

    if (!hasValues) {
      _showMessage('Please select allowed values first.');
      return;
    }

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _AddVariantSheet(
          attributes: widget.attributes,
          existingVariants: widget.variants,
          onAdd: (variant) {
            final updated = [...widget.variants, variant];

            widget.onVariantsChanged(updated);
          },
        );
      },
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  // ============================================================
  // REMOVE VARIANT
  // ============================================================

  void _removeVariant(int index) {
    final updated = [...widget.variants]..removeAt(index);

    widget.onVariantsChanged(updated);
  }

  // ============================================================
  // UPDATE VARIANT
  // ============================================================

  void _updateVariant(int index, VariantData updatedVariant) {
    final variants = [...widget.variants];

    variants[index] = updatedVariant;

    widget.onVariantsChanged(variants);
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(
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
          _SectionTitle(
            title: 'Allowed values',
            subtitle: 'Select the values that can be used for your variants.',
          ),

          const SizedBox(height: 12),

          ...widget.attributes.map((selectedAttribute) {
            final apiAttribute = _availableAttributes.firstWhere(
              (attribute) =>
                  attribute.id == selectedAttribute.id ||
                  attribute.name.toLowerCase() ==
                      selectedAttribute.name.toLowerCase(),
              orElse: () => ProductAttributeModel(
                id: selectedAttribute.id ?? 0,
                name: selectedAttribute.name,
                values: const [],
              ),
            );

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

        if (widget.variants.isNotEmpty) ...[
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
              Text(
                '${widget.variants.length}',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          ...List.generate(widget.variants.length, (index) {
            final variant = widget.variants[index];

            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _VariantEditor(
                key: ValueKey('${index}_${variant.displayName}'),
                variant: variant,
                selectedAttributes: widget.attributes,
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

  final List<ProductAttributeModel> attributes;
  final List<VariantAttribute> selectedAttributes;
  final bool enabled;
  final ValueChanged<ProductAttributeModel> onToggle;

  bool _isSelected(ProductAttributeModel attribute) {
    return selectedAttributes.any(
      (item) =>
          item.id == attribute.id ||
          item.name.toLowerCase() == attribute.name.toLowerCase(),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                      attribute.name,
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

  final ProductAttributeModel attribute;
  final List<String> selectedValues;
  final bool enabled;
  final ValueChanged<String> onToggleValue;

  @override
  Widget build(BuildContext context) {
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
                  attribute.name,
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

          if (attribute.values.isEmpty)
            Text('No values available.', style: AppTextStyles.caption)
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: attribute.values.map((value) {
                final selected = selectedValues.contains(value);

                return _SelectableValueChip(
                  label: value,
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
// SELECTABLE CHIP
// ============================================================

class _SelectableValueChip extends StatelessWidget {
  const _SelectableValueChip({
    required this.label,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
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
    required this.existingVariants,
    required this.onAdd,
  });

  final List<VariantAttribute> attributes;
  final List<VariantData> existingVariants;
  final ValueChanged<VariantData> onAdd;

  @override
  State<_AddVariantSheet> createState() => _AddVariantSheetState();
}

class _AddVariantSheetState extends State<_AddVariantSheet> {
  late Map<String, String> _selectedValues;

  @override
  void initState() {
    super.initState();

    _selectedValues = {
      for (final attribute in widget.attributes)
        if (attribute.values.isNotEmpty) attribute.name: attribute.values.first,
    };
  }

  bool _alreadyExists() {
    return widget.existingVariants.any(
      (variant) => _sameAttributes(variant.attributes, _selectedValues),
    );
  }

  bool _sameAttributes(Map<String, String> first, Map<String, String> second) {
    if (first.length != second.length) return false;

    for (final entry in first.entries) {
      if (second[entry.key] != entry.value) {
        return false;
      }
    }

    return true;
  }

  void _add() {
    if (_selectedValues.length != widget.attributes.length) {
      return;
    }

    if (_alreadyExists()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This variant already exists.')),
      );
      return;
    }

    widget.onAdd(
      VariantData(attributes: Map<String, String>.from(_selectedValues)),
    );

    Navigator.pop(context);
  }

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
                    onPressed: () => Navigator.pop(context),
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

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: DropdownButtonFormField<String>(
                    value: _selectedValues[attribute.name],

                    // IMPORTANT:
                    // Forces dropdown content to use available width.
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

                        // Prevent long values from expanding the Row.
                        child: Text(
                          value,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                      );
                    }).toList(),

                    onChanged: (value) {
                      if (value == null) return;

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
    required this.enabled,
    required this.onChanged,
    required this.onDelete,
  });

  final VariantData variant;
  final List<VariantAttribute> selectedAttributes;
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

  @override
  void initState() {
    super.initState();

    _attributes = Map<String, String>.from(widget.variant.attributes);

    _priceController = TextEditingController(text: widget.variant.price);

    _compareController = TextEditingController(
      text: widget.variant.compareAtPrice,
    );

    _stockController = TextEditingController(text: widget.variant.stock);

    _skuController = TextEditingController(text: widget.variant.sku);
  }

  @override
  void didUpdateWidget(covariant _VariantEditor oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.variant != widget.variant) {
      _attributes = Map<String, String>.from(widget.variant.attributes);

      _setControllerValue(_priceController, widget.variant.price);

      _setControllerValue(_compareController, widget.variant.compareAtPrice);

      _setControllerValue(_stockController, widget.variant.stock);

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
        stock: _stockController.text,
        sku: _skuController.text,
      ),
    );
  }

  void _changeAttribute(String name, String? value) {
    if (value == null) return;

    setState(() {
      _attributes[name] = value;
    });

    _update();
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

          // ======================================================
          // ATTRIBUTE DROPDOWNS
          // ======================================================
          ...widget.selectedAttributes.map((attribute) {
            if (attribute.values.isEmpty) {
              return const SizedBox.shrink();
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: DropdownButtonFormField<String>(
                value: attribute.values.contains(_attributes[attribute.name])
                    ? _attributes[attribute.name]
                    : attribute.values.first,

                // IMPORTANT:
                // Prevents RenderFlex overflow.
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
                        _changeAttribute(attribute.name, value);
                      }
                    : null,
              ),
            );
          }),

          const SizedBox(height: 4),

          // ======================================================
          // PRICE
          // ======================================================
          _VariantTextField(
            controller: _priceController,
            label: 'Price',
            hint: '0.00',
            enabled: widget.enabled,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => _update(),
          ),

          const SizedBox(height: 12),

          // ======================================================
          // COMPARE AT
          // ======================================================
          _VariantTextField(
            controller: _compareController,
            label: 'Compare at Price',
            hint: '0.00',
            enabled: widget.enabled,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => _update(),
          ),

          const SizedBox(height: 12),

          // ======================================================
          // STOCK
          // ======================================================
          _VariantTextField(
            controller: _stockController,
            label: 'Stock Quantity',
            hint: 'Enter stock quantity',
            enabled: widget.enabled,
            keyboardType: TextInputType.number,
            onChanged: (_) => _update(),
          ),

          const SizedBox(height: 12),

          // ======================================================
          // SKU
          // ======================================================
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
