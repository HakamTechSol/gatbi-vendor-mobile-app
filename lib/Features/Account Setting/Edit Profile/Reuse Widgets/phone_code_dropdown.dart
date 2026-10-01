import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../../../Authentication/Registration/Country Code/country_controller.dart';
import '../../../Authentication/Registration/Country Code/country_model.dart';

class PhoneCodeDropdown extends ConsumerStatefulWidget {
  const PhoneCodeDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    this.onCountryChanged,
    this.initialDialCode,
    this.initialPhone,
  });

  // ============================================================
  // CURRENT SELECTED COUNTRY
  // ============================================================

  final String? value;

  // ============================================================
  // INITIAL DIAL CODE
  // ============================================================

  final String? initialDialCode;

  // ============================================================
  // INITIAL FULL PHONE
  // Example:
  // +923625147536
  // +971501234567
  // ============================================================

  final String? initialPhone;

  // ============================================================
  // COUNTRY CODE CALLBACK
  // Example:
  // PK
  // AE
  // SA
  // ============================================================

  final ValueChanged<String?> onChanged;

  // ============================================================
  // FULL COUNTRY OBJECT CALLBACK
  // ============================================================

  final ValueChanged<CountryItemModel?>? onCountryChanged;

  @override
  ConsumerState<PhoneCodeDropdown> createState() => _PhoneCodeDropdownState();
}

class _PhoneCodeDropdownState extends ConsumerState<PhoneCodeDropdown> {
  // ============================================================
  // COUNTRIES FUTURE
  // ============================================================

  late final Future<CountryModel> _future;

  // ============================================================
  // INITIAL CALLBACK FLAG
  // ============================================================

  bool _initialCountryNotified = false;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    _future = ref.read(countryControllerProvider).getCountries();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CountryModel>(
      future: _future,
      builder: (context, snapshot) {
        // ======================================================
        // LOADING
        // ======================================================

        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoading();
        }

        // ======================================================
        // ERROR
        // ======================================================

        if (snapshot.hasError) {
          return _buildError('Failed to load countries');
        }

        // ======================================================
        // COUNTRIES
        // ======================================================

        final countries = snapshot.data?.countries ?? [];

        if (countries.isEmpty) {
          return _buildError('No countries available');
        }

        // ======================================================
        // SELECTED VALUE
        // ======================================================

        final selectedValue = _getSelectedValue(countries);

        // ======================================================
        // SELECTED COUNTRY
        // ======================================================

        final selectedCountry = _findCountry(countries, selectedValue);

        // ======================================================
        // INITIAL CALLBACK
        // ======================================================

        if (!_initialCountryNotified && selectedCountry != null) {
          _initialCountryNotified = true;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) {
              return;
            }

            final code = selectedCountry.code?.trim().toUpperCase();

            if (code == null || code.isEmpty) {
              return;
            }

            debugPrint('');
            debugPrint('==================================================');
            debugPrint('PHONE COUNTRY - INITIAL RESOLUTION');
            debugPrint('==================================================');
            debugPrint(
              'INITIAL PHONE: '
              '${widget.initialPhone ?? 'N/A'}',
            );
            debugPrint(
              'INITIAL DIAL CODE: '
              '${widget.initialDialCode ?? 'N/A'}',
            );
            debugPrint('RESOLVED COUNTRY: $code');
            debugPrint(
              'RESOLVED DIAL CODE: '
              '${selectedCountry.dialCode ?? 'N/A'}',
            );
            debugPrint('==================================================');
            debugPrint('');

            // Parent ISO country code.
            widget.onChanged(code);

            // Parent complete country object.
            widget.onCountryChanged?.call(selectedCountry);
          });
        }

        // ======================================================
        // DROPDOWN
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

          // ====================================================
          // ITEMS
          // ====================================================
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

          // ====================================================
          // MANUAL CHANGE
          // ====================================================
          onChanged: (value) {
            final selectedCountry = _findCountry(countries, value);

            final normalizedValue = value?.trim().toUpperCase();

            debugPrint('');
            debugPrint('==================================================');
            debugPrint('PHONE COUNTRY - USER CHANGED');
            debugPrint('==================================================');
            debugPrint(
              'COUNTRY: '
              '${normalizedValue ?? 'N/A'}',
            );
            debugPrint(
              'DIAL CODE: '
              '${selectedCountry?.dialCode ?? 'N/A'}',
            );
            debugPrint('==================================================');
            debugPrint('');

            widget.onChanged(normalizedValue);

            widget.onCountryChanged?.call(selectedCountry);
          },
        );
      },
    );
  }

  // ============================================================
  // GET SELECTED VALUE
  // ============================================================

  String? _getSelectedValue(List<CountryItemModel> countries) {
    // ==========================================================
    // 1. PARENT VALUE HAS HIGHEST PRIORITY
    // ==========================================================

    final currentValue = widget.value?.trim().toUpperCase();

    if (currentValue != null && currentValue.isNotEmpty) {
      final exists = countries.any(
        (country) => country.code?.trim().toUpperCase() == currentValue,
      );

      if (exists) {
        return currentValue;
      }
    }

    // ==========================================================
    // 2. RESOLVE FROM FULL PHONE
    // ==========================================================
    //
    // Example:
    //
    // +923625147536
    //
    // Country dial codes:
    // +9
    // +92
    //
    // Longest match:
    // +92
    //
    // Result:
    // PK
    //
    // ==========================================================

    final initialPhone = widget.initialPhone?.trim();

    if (initialPhone != null && initialPhone.isNotEmpty) {
      final phoneCountry = _findCountryByPhone(countries, initialPhone);

      if (phoneCountry != null) {
        return phoneCountry.code?.trim().toUpperCase();
      }
    }

    // ==========================================================
    // 3. FALLBACK TO INITIAL DIAL CODE
    // ==========================================================

    final initialDialCode = widget.initialDialCode?.trim();

    if (initialDialCode != null && initialDialCode.isNotEmpty) {
      final normalizedDialCode = _normalizeDialCode(initialDialCode);

      if (normalizedDialCode.isNotEmpty) {
        CountryItemModel? matchedCountry;

        for (final country in countries) {
          final countryDialCode = _normalizeDialCode(country.dialCode);

          if (countryDialCode == normalizedDialCode) {
            matchedCountry = country;
            break;
          }
        }

        if (matchedCountry != null) {
          return matchedCountry.code?.trim().toUpperCase();
        }
      }
    }

    // ==========================================================
    // 4. FINAL FALLBACK
    // ==========================================================

    for (final country in countries) {
      final code = country.code?.trim();

      if (code != null && code.isNotEmpty) {
        return code.toUpperCase();
      }
    }

    return null;
  }

  // ============================================================
  // FIND COUNTRY BY FULL PHONE
  // ============================================================
  //
  // Longest dial-code prefix match.
  //
  // +923625147536
  //
  // +9
  // +92
  //
  // +92 wins.
  //
  // +971501234567
  //
  // +9
  // +97
  // +971
  //
  // +971 wins.
  //
  // ============================================================

  CountryItemModel? _findCountryByPhone(
    List<CountryItemModel> countries,
    String phone,
  ) {
    final normalizedPhone = _normalizePhone(phone);

    if (normalizedPhone.isEmpty) {
      return null;
    }

    CountryItemModel? matchedCountry;

    int longestDialCodeLength = 0;

    for (final country in countries) {
      final normalizedDialCode = _normalizeDialCode(country.dialCode);

      if (normalizedDialCode.isEmpty) {
        continue;
      }

      if (!normalizedPhone.startsWith(normalizedDialCode)) {
        continue;
      }

      if (normalizedDialCode.length > longestDialCodeLength) {
        longestDialCodeLength = normalizedDialCode.length;

        matchedCountry = country;
      }
    }

    return matchedCountry;
  }

  // ============================================================
  // FIND COUNTRY BY ISO CODE
  // ============================================================

  CountryItemModel? _findCountry(
    List<CountryItemModel> countries,
    String? code,
  ) {
    if (code == null || code.trim().isEmpty) {
      return null;
    }

    final normalizedCode = code.trim().toUpperCase();

    for (final country in countries) {
      if (country.code?.trim().toUpperCase() == normalizedCode) {
        return country;
      }
    }

    return null;
  }

  // ============================================================
  // NORMALIZE PHONE
  // ============================================================

  String _normalizePhone(String value) {
    return value.replaceAll(RegExp(r'\D'), '');
  }

  // ============================================================
  // NORMALIZE DIAL CODE
  // ============================================================

  String _normalizeDialCode(String? value) {
    if (value == null) {
      return '';
    }

    return value.replaceAll(RegExp(r'\D'), '');
  }

  // ============================================================
  // LOADING
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
  // ERROR
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

          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
