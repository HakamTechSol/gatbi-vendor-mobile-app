import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';

import 'country_model.dart';

class CountryRepository {
  const CountryRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Get Countries
  // ============================================================

  Future<CountryModel> getCountries() async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      ApiUrls.countries,
    );

    final data = response.data;

    // ----------------------------------------------------------
    // Validate Response
    // ----------------------------------------------------------

    if (data == null) {
      throw const ApiException(
        message: 'Invalid response received from server.',
        code: 'INVALID_RESPONSE',
      );
    }

    // ----------------------------------------------------------
    // Convert API Response -> Country Model
    // ----------------------------------------------------------

    final result = CountryModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Logs
    // ----------------------------------------------------------

    if (kDebugMode) {
      debugPrint('');

      debugPrint('========== COUNTRIES RESULT ==========');

      // --------------------------------------------------------
      // General
      // --------------------------------------------------------

      debugPrint('SUCCESS: ${result.success}');

      debugPrint('TOTAL: ${result.total ?? 0}');

      // --------------------------------------------------------
      // Countries
      // --------------------------------------------------------

      debugPrint('');

      debugPrint('---------- COUNTRIES ----------');

      debugPrint('COUNTRIES COUNT: ${result.countries.length}');

      if (result.countries.isNotEmpty) {
        for (final country in result.countries) {
          debugPrint(
            'COUNTRY: '
            '${country.id ?? 'N/A'} | '
            'CODE: ${country.code ?? 'N/A'} | '
            'NAME: ${country.name ?? 'N/A'} | '
            'NAME AR: ${country.nameAr ?? 'N/A'} | '
            'DIAL CODE: ${country.dialCode ?? 'N/A'} | '
            'EMOJI: ${country.emoji ?? 'N/A'} | '
            'CURRENCY: ${country.currencyCode ?? 'N/A'} | '
            'REGION: ${country.region ?? 'N/A'} | '
            'SORT ORDER: ${country.sortOrder ?? 'N/A'}',
          );
        }
      }

      // --------------------------------------------------------
      // End
      // --------------------------------------------------------

      debugPrint('');

      debugPrint('======================================');

      debugPrint('');
    }

    return result;
  }
}
