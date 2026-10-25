import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../Model/countries_model.dart';
import '../controller/countries_controller.dart';     // Adjust path to your CountriesModel

class WarehouseCountryDropdown extends ConsumerStatefulWidget {
  const WarehouseCountryDropdown({
    super.key,
    this.value,
    required this.onChanged,
    this.validator,
  });

  /// The selected 2-letter country code (e.g., "AE", "PK").
  final String? value;

  /// Callback when a country is selected.
  final ValueChanged<String?> onChanged;

  /// Optional form validator.
  final String? Function(String?)? validator;

  @override
  ConsumerState<WarehouseCountryDropdown> createState() =>
      _WarehouseCountryDropdownState();
}

class _WarehouseCountryDropdownState
    extends ConsumerState<WarehouseCountryDropdown> {
  late Future<CountriesModel> _countriesFuture;
  List<CountryModel> _countries = [];

  @override
  void initState() {
    super.initState();
    _countriesFuture = _loadCountries();
  }

  Future<CountriesModel> _loadCountries() async {
    try {
      final result =
          await ref.read(countriesControllerProvider).getCountries();

      if (result.success) {
        // Only keep countries that have a valid 2-letter code
        _countries = result.countries
            .where((c) => c.code != null && c.code!.trim().isNotEmpty)
            .toList();
      }
      return result;
    } catch (e) {
      debugPrint('WarehouseCountryDropdown load error: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CountriesModel>(
      future: _countriesFuture,
      builder: (context, snapshot) {
        // 1. Loading State
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Warehouse Country', style: AppTextStyles.formLabel),
              const SizedBox(height: 8),
              Container(
                height: 54,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                alignment: Alignment.center,
                child: const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ],
          );
        }

        // 2. Error State
        if (snapshot.hasError) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Warehouse Country', style: AppTextStyles.formLabel),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.errorLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.errorBorder),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: AppColors.error),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Failed to load countries.',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.errorDark,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _countriesFuture = _loadCountries();
                        });
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ],
          );
        }

        // 3. Ready State (Dropdown)
        return DropdownButtonFormField<String>(
          value: widget.value,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: 'Warehouse Country',
            hintText: 'Select country',
            prefixIcon: const Icon(
              Icons.public_outlined,
              color: AppColors.textMuted,
            ),
            filled: true,
            fillColor: AppColors.surface,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.error, width: 1.5),
            ),
          ),
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          validator: widget.validator,
          // Uses your App's styling for the dropdown
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
          items: _countries.map((country) {
            return DropdownMenuItem<String>(
              value: country.code,
              child: Text(
                '${country.name} (${country.code})',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: widget.onChanged,
        );
      },
    );
  }
}