import 'package:flutter/material.dart';

import '../../../../../../Theme/app_colors.dart';
import '../../../../../../Theme/app_text_styles.dart';

import '../Models/get_attributes_model.dart';
import 'attribute_value_row.dart';

class AttributeCard extends StatefulWidget {
  const AttributeCard({
    super.key,
    required this.attribute,
    this.onEdit,
    this.onDelete,
    this.onAddValue,
    this.onEditValue,
    this.onDeleteValue,
    this.initiallyExpanded = true,
  });

  final GetAttributeModel attribute;

  // ============================================================
  // CRUD CALLBACKS
  // ============================================================

  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onAddValue;

  final ValueChanged<GetAttributeValueModel>? onEditValue;
  final ValueChanged<GetAttributeValueModel>? onDeleteValue;

  final bool initiallyExpanded;

  @override
  State<AttributeCard> createState() => _AttributeCardState();
}

class _AttributeCardState extends State<AttributeCard> {
  late bool _isExpanded;

  GetAttributeModel get attribute => widget.attribute;

  // ============================================================
  // OWNERSHIP
  // ============================================================

  bool get _isOwnAttribute => attribute.isOwn;

  @override
  void initState() {
    super.initState();

    _isExpanded = widget.initiallyExpanded;
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 18,
            spreadRadius: 0,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(
          children: [_buildHeader(), _buildDivider(), _buildValuesSection()],
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 14, 18),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSmall = constraints.maxWidth < 560;

          if (isSmall) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildAttributeInfo()),

                // ------------------------------------------------
                // ACTION MENU
                //
                // Only Custom / Own attributes get the menu.
                // System attributes have no action icon.
                // ------------------------------------------------
                if (_isOwnAttribute) ...[
                  const SizedBox(width: 10),
                  _buildMenuButton(),
                ],
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildAttributeInfo()),

              // ------------------------------------------------
              // ACTION MENU
              // ------------------------------------------------
              if (_isOwnAttribute) ...[
                const SizedBox(width: 18),
                _buildMenuButton(),
              ],
            ],
          );
        },
      ),
    );
  }

  // ============================================================
  // ATTRIBUTE INFO
  // ============================================================

  Widget _buildAttributeInfo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAttributeIcon(),

        const SizedBox(width: 13),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --------------------------------------------------
              // NAME + OWNERSHIP
              // --------------------------------------------------
              Wrap(
                spacing: 8,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    _attributeName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.titleLarge.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  _buildOwnershipBadge(),
                ],
              ),

              const SizedBox(height: 5),

              // --------------------------------------------------
              // ADMIN LABEL
              // --------------------------------------------------
              Text(
                _adminLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 10),

              // --------------------------------------------------
              // METADATA
              // --------------------------------------------------
              _buildMetadata(),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // ATTRIBUTE ICON
  // ============================================================

  Widget _buildAttributeIcon() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryShadow,
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: const Icon(Icons.tune_rounded, color: AppColors.white, size: 23),
    );
  }

  // ============================================================
  // OWNERSHIP BADGE
  // ============================================================

  Widget _buildOwnershipBadge() {
    final isCustom = attribute.isOwn;

    final color = isCustom ? AppColors.success : AppColors.primary;

    final background = isCustom
        ? AppColors.successLight
        : AppColors.primaryLight;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isCustom ? Icons.auto_awesome_rounded : Icons.verified_outlined,
            size: 12,
            color: color,
          ),

          const SizedBox(width: 4),

          Text(
            isCustom ? 'Custom' : 'System',
            style: AppTextStyles.statusBadge.copyWith(color: color),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // METADATA
  // ============================================================

  Widget _buildMetadata() {
    return Wrap(
      spacing: 7,
      runSpacing: 6,
      children: [
        _buildMetaItem(
          icon: Icons.link_rounded,
          label: attribute.slug?.trim().isNotEmpty == true
              ? attribute.slug!.trim()
              : 'No slug',
        ),
        _buildMetaItem(
          icon: Icons.input_rounded,
          label: _formatInputType(attribute.inputType),
        ),
      ],
    );
  }

  Widget _buildMetaItem({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.iconSecondary),

          const SizedBox(width: 5),

          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 180),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.captionMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MORE MENU
  // ============================================================

  Widget _buildMenuButton() {
    return PopupMenuButton<_AttributeMenuAction>(
      tooltip: 'Attribute actions',
      elevation: 8,
      shadowColor: AppColors.shadowStrong,
      color: AppColors.white,
      surfaceTintColor: AppColors.white,
      padding: EdgeInsets.zero,
      offset: const Offset(-8, 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppColors.border),
      ),
      onSelected: _handleMenuAction,
      itemBuilder: (context) {
        return [
          // ====================================================
          // ADD VALUE
          // ====================================================
          PopupMenuItem<_AttributeMenuAction>(
            value: _AttributeMenuAction.addValue,
            enabled: widget.onAddValue != null,
            height: 46,
            child: _buildMenuItem(
              icon: Icons.add_circle_outline_rounded,
              title: 'Add Value',
              color: AppColors.success,
              enabled: widget.onAddValue != null,
            ),
          ),

          // ====================================================
          // EDIT ATTRIBUTE
          // ====================================================
          PopupMenuItem<_AttributeMenuAction>(
            value: _AttributeMenuAction.edit,
            enabled: widget.onEdit != null,
            height: 46,
            child: _buildMenuItem(
              icon: Icons.edit_outlined,
              title: 'Edit Attribute',
              color: AppColors.primary,
              enabled: widget.onEdit != null,
            ),
          ),

          const PopupMenuDivider(height: 1),

          // ====================================================
          // DELETE ATTRIBUTE
          // ====================================================
          PopupMenuItem<_AttributeMenuAction>(
            value: _AttributeMenuAction.delete,
            enabled: widget.onDelete != null,
            height: 46,
            child: _buildMenuItem(
              icon: Icons.delete_outline_rounded,
              title: 'Delete Attribute',
              color: AppColors.error,
              enabled: widget.onDelete != null,
            ),
          ),
        ];
      },

      // --------------------------------------------------------
      // MENU ICON
      // --------------------------------------------------------
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.surfaceSoft,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: AppColors.border),
        ),
        child: const Icon(
          Icons.more_vert_rounded,
          size: 21,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  // ============================================================
  // MENU ITEM
  // ============================================================

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required Color color,
    required bool enabled,
  }) {
    final itemColor = enabled ? color : AppColors.iconMuted;

    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: enabled
                ? color.withValues(alpha: 0.10)
                : AppColors.surfaceMuted,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: itemColor),
        ),

        const SizedBox(width: 10),

        Text(
          title,
          style: AppTextStyles.bodySmall.copyWith(
            color: enabled ? AppColors.textPrimary : AppColors.textMuted,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // MENU ACTION HANDLER
  // ============================================================

  void _handleMenuAction(_AttributeMenuAction action) {
    switch (action) {
      case _AttributeMenuAction.addValue:
        widget.onAddValue?.call();
        break;

      case _AttributeMenuAction.edit:
        widget.onEdit?.call();
        break;

      case _AttributeMenuAction.delete:
        widget.onDelete?.call();
        break;
    }
  }

  // ============================================================
  // DIVIDER
  // ============================================================

  Widget _buildDivider() {
    return const Divider(height: 1, thickness: 1, color: AppColors.divider);
  }

  // ============================================================
  // VALUES SECTION
  // ============================================================

  Widget _buildValuesSection() {
    return AnimatedSize(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      child: Column(
        children: [
          _buildValuesHeader(),
          if (_isExpanded) _buildValuesContent(),
        ],
      ),
    );
  }

  // ============================================================
  // VALUES HEADER
  // ============================================================

  Widget _buildValuesHeader() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 14, 14, 14),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(
                  Icons.list_rounded,
                  size: 18,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  'Available Values',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              _buildValueCount(),

              const SizedBox(width: 7),

              AnimatedRotation(
                turns: _isExpanded ? 0 : 0.5,
                duration: const Duration(milliseconds: 180),
                child: const Icon(
                  Icons.keyboard_arrow_up_rounded,
                  color: AppColors.iconSecondary,
                  size: 22,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // VALUE COUNT
  // ============================================================

  Widget _buildValueCount() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '${attribute.values.length}',
        style: AppTextStyles.statusBadge.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // ============================================================
  // VALUES CONTENT
  // ============================================================

  Widget _buildValuesContent() {
    if (attribute.values.isEmpty) {
      return _buildNoValues();
    }

    return Container(
      width: double.infinity,
      color: AppColors.surfaceSoft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...attribute.values.map(
            (value) => AttributeValueRow(
              value: value,

              // ------------------------------------------------
              // Value Edit
              //
              // System attribute:
              // callback = null -> button hidden
              //
              // Custom attribute:
              // callback available -> button shown
              // ------------------------------------------------
              onEdit: !_isOwnAttribute || widget.onEditValue == null
                  ? null
                  : () => widget.onEditValue?.call(value),

              // ------------------------------------------------
              // Value Delete
              // ------------------------------------------------
              onDelete: !_isOwnAttribute || widget.onDeleteValue == null
                  ? null
                  : () => widget.onDeleteValue?.call(value),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // NO VALUES
  // ============================================================

  Widget _buildNoValues() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(18, 0, 18, 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              color: AppColors.warningLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.info_outline_rounded,
              size: 19,
              color: AppColors.warningDark,
            ),
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Text(
              'No values have been added '
              'to this attribute yet.',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HELPERS
  // ============================================================

  String get _attributeName {
    final name = attribute.name?.trim();

    if (name == null || name.isEmpty) {
      return 'Unnamed Attribute';
    }

    return name;
  }

  String get _adminLabel {
    final label = attribute.adminLabel?.trim();

    if (label == null || label.isEmpty) {
      return 'No admin label';
    }

    return label;
  }

  String _formatInputType(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Unknown type';
    }

    return value
        .trim()
        .replaceAll('_', ' ')
        .split(' ')
        .map(
          (word) => word.isEmpty
              ? word
              : '${word[0].toUpperCase()}'
                    '${word.substring(1).toLowerCase()}',
        )
        .join(' ');
  }
}

// ================================================================
// MENU ACTIONS
// ================================================================

enum _AttributeMenuAction { addValue, edit, delete }
