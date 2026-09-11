import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../Phone Rule/phone_rules_controller.dart';
import '../Phone Rule/phone_rules_model.dart';

class PhoneCodeDropdown extends ConsumerStatefulWidget {
  const PhoneCodeDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    this.onRuleChanged,
  });

  final String? value;

  final ValueChanged<String?> onChanged;

  /// Returns the complete API rule of the selected country.
  final ValueChanged<PhoneRuleItemModel?>? onRuleChanged;

  @override
  ConsumerState<PhoneCodeDropdown> createState() => _PhoneCodeDropdownState();
}

class _PhoneCodeDropdownState extends ConsumerState<PhoneCodeDropdown> {
  late final Future<PhoneRulesModel> _future;

  @override
  void initState() {
    super.initState();

    _future = ref.read(phoneRulesControllerProvider).getPhoneRules();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PhoneRulesModel>(
      future: _future,
      builder: (context, snapshot) {
        // ======================================================
        // Loading
        // ======================================================

        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoading();
        }

        // ======================================================
        // Error
        // ======================================================

        if (snapshot.hasError) {
          return _buildError('Failed to load phone rules');
        }

        final phoneRules = snapshot.data?.phoneRules ?? [];

        // ======================================================
        // Empty Rules
        // ======================================================

        if (phoneRules.isEmpty) {
          return _buildError('No phone rules available');
        }

        // ======================================================
        // Selected Country
        // ======================================================

        final selectedValue = _getSelectedValue(phoneRules);

        // ======================================================
        // Notify Parent About Initial Rule
        // ======================================================

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;

          final selectedRule = _findRule(phoneRules, selectedValue);

          widget.onRuleChanged?.call(selectedRule);
        });

        // ======================================================
        // Dropdown
        // ======================================================

        return DropdownButtonFormField<String>(
          value: selectedValue,
          isExpanded: true,

          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.draftLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 14,
            ),
          ),

          items: phoneRules
              .where(
                (rule) =>
                    rule.countryCode != null && rule.countryCode!.isNotEmpty,
              )
              .map<DropdownMenuItem<String>>((rule) {
                final countryCode = rule.countryCode!;

                return DropdownMenuItem<String>(
                  value: countryCode,
                  child: Text(
                    countryCode,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                );
              })
              .toList(),

          onChanged: (value) {
            final selectedRule = _findRule(phoneRules, value);

            widget.onChanged(value);

            widget.onRuleChanged?.call(selectedRule);
          },
        );
      },
    );
  }

  // ============================================================
  // Get Selected Value
  // ============================================================

  String? _getSelectedValue(List<PhoneRuleItemModel> phoneRules) {
    // If parent already has a valid selected country.
    if (widget.value != null) {
      final exists = phoneRules.any((rule) => rule.countryCode == widget.value);

      if (exists) {
        return widget.value;
      }
    }

    // Otherwise select first API country.
    return phoneRules.first.countryCode;
  }

  // ============================================================
  // Find Rule
  // ============================================================

  PhoneRuleItemModel? _findRule(
    List<PhoneRuleItemModel> phoneRules,
    String? countryCode,
  ) {
    if (countryCode == null || countryCode.isEmpty) {
      return null;
    }

    for (final rule in phoneRules) {
      if (rule.countryCode == countryCode) {
        return rule;
      }
    }

    return null;
  }

  // ============================================================
  // Loading
  // ============================================================

  Widget _buildLoading() {
    return Container(
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.draftLight),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }

  // ============================================================
  // Error
  // ============================================================

  Widget _buildError(String message) {
    return Container(
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),

          const Icon(
            Icons.error_outline_rounded,
            color: AppColors.error,
            size: 20,
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.error,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
