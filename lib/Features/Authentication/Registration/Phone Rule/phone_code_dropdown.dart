import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../Country Code/country_controller.dart';
import '../Country Code/country_model.dart';

class PhoneCodeDropdown extends ConsumerStatefulWidget {
  const PhoneCodeDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    this.onCountryChanged,
  });

  /// Selected country ISO code.
  ///
  /// Example:
  /// PK
  /// AE
  final String? value;

  /// Returns selected country code.
  final ValueChanged<String?> onChanged;

  /// Returns complete selected country.
  final ValueChanged<CountryItemModel?>? onCountryChanged;

  @override
  ConsumerState<PhoneCodeDropdown> createState() => _PhoneCodeDropdownState();
}

class _PhoneCodeDropdownState extends ConsumerState<PhoneCodeDropdown> {
  late final Future<CountryModel> _future;

  @override
  void initState() {
    super.initState();

    _future = ref.read(countryControllerProvider).getCountries();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CountryModel>(
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
          return _buildError('Failed to load countries');
        }

        final countries = snapshot.data?.countries ?? [];

        // ======================================================
        // Empty Countries
        // ======================================================

        if (countries.isEmpty) {
          return _buildError('No countries available');
        }

        // ======================================================
        // Selected Country
        // ======================================================

        final selectedValue = _getSelectedValue(countries);

        // ======================================================
        // Selected Country
        // ======================================================

        final selectedCountry = _findCountry(countries, selectedValue);

        // ======================================================
        // Notify Parent About Initial Country
        // ======================================================

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;

          widget.onCountryChanged?.call(selectedCountry);
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

          items: countries
              .where(
                (country) =>
                    country.code != null && country.code!.trim().isNotEmpty,
              )
              .map<DropdownMenuItem<String>>((country) {
                final code = country.code!.trim();

                final dialCode = country.dialCode?.trim();

                return DropdownMenuItem<String>(
                  value: code,
                  child: Text(
                    dialCode != null && dialCode.isNotEmpty
                        ? '$code $dialCode'
                        : code,
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
            final selectedCountry = _findCountry(countries, value);

            widget.onChanged(value);

            widget.onCountryChanged?.call(selectedCountry);
          },
        );
      },
    );
  }

  // ============================================================
  // Get Selected Value
  // ============================================================

  String? _getSelectedValue(List<CountryItemModel> countries) {
    // Parent already has selected country.
    if (widget.value != null) {
      final exists = countries.any((country) => country.code == widget.value);

      if (exists) {
        return widget.value;
      }
    }

    // Otherwise select first country from API.
    return countries.first.code;
  }

  // ============================================================
  // Find Country
  // ============================================================

  CountryItemModel? _findCountry(
    List<CountryItemModel> countries,
    String? code,
  ) {
    if (code == null || code.trim().isEmpty) {
      return null;
    }

    for (final country in countries) {
      if (country.code == code) {
        return country;
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
