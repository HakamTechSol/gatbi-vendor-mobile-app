import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';
import '../Model/countries_model.dart';

class CountriesRepository {
  const CountriesRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // GET COUNTRIES
  // ============================================================

  Future<CountriesModel> getCountries() async {
    try {
      // ========================================================
      // DEBUG REQUEST
      // ========================================================

      if (kDebugMode) {
        debugPrint('');
        debugPrint('==================================================');
        debugPrint('GET COUNTRIES - API REQUEST');
        debugPrint('==================================================');
        debugPrint('URL: ${ApiUrls.countries}');
        debugPrint('METHOD: GET');
        debugPrint('==================================================');
        debugPrint('');
      }

      // ========================================================
      // API REQUEST
      // ========================================================

      final response = await _dioClient.get<Map<String, dynamic>>(
        ApiUrls.countries,
      );

      // ========================================================
      // RAW RESPONSE DEBUG
      // ========================================================

      if (kDebugMode) {
        debugPrint('');
        debugPrint('==================================================');
        debugPrint('GET COUNTRIES - RAW API RESPONSE');
        debugPrint('==================================================');
        debugPrint('STATUS CODE: ${response.statusCode}');
        debugPrint('STATUS MESSAGE: ${response.statusMessage}');
        debugPrint('RESPONSE DATA: ${response.data}');
        debugPrint('==================================================');
        debugPrint('');
      }

      // ========================================================
      // RESPONSE DATA
      // ========================================================

      final data = response.data;

      if (data == null) {
        if (kDebugMode) {
          debugPrint('GET COUNTRIES ERROR: response.data is NULL');
        }

        throw const ApiException(
          message: 'Invalid response received from server.',
          code: 'INVALID_RESPONSE',
        );
      }

      // ========================================================
      // PARSE RESPONSE
      // ========================================================

      final result = CountriesModel.fromJson(data);

      // ========================================================
      // PARSED RESPONSE DEBUG
      // ========================================================

      if (kDebugMode) {
        debugPrint('');
        debugPrint('==================================================');
        debugPrint('GET COUNTRIES - PARSED RESPONSE');
        debugPrint('==================================================');
        debugPrint('SUCCESS: ${result.success}');
        debugPrint('TOTAL (from API): ${result.total ?? 'N/A'}');
        debugPrint('PARSED COUNT: ${result.countries.length}');
        debugPrint('');
        debugPrint('---------- FIRST 5 COUNTRIES ----------');

        for (final country in result.countries.take(5)) {
          debugPrint(
            'ID: ${country.id ?? 'N/A'} | '
            'CODE: ${country.code ?? 'N/A'} | '
            'NAME: ${country.name ?? 'N/A'} | '
            'DIAL: ${country.dialCode ?? 'N/A'} | '
            'EMOJI: ${country.emoji ?? 'N/A'} | '
            'CURRENCY: ${country.currencyCode ?? 'N/A'} | '
            'REGION: ${country.region ?? 'N/A'} | '
            'SORT: ${country.sortOrder ?? 'N/A'}',
          );
        }

        debugPrint('==================================================');
        debugPrint('');
      }

      return result;
    } on DioException catch (error) {
      // ========================================================
      // DIO ERROR
      // ========================================================

      if (kDebugMode) {
        debugPrint('');
        debugPrint('==================================================');
        debugPrint('GET COUNTRIES - DIO ERROR');
        debugPrint('==================================================');
        debugPrint('TYPE: ${error.type}');
        debugPrint('MESSAGE: ${error.message}');
        debugPrint('ERROR: ${error.error}');
        debugPrint('STATUS CODE: ${error.response?.statusCode}');
        debugPrint('STATUS MESSAGE: ${error.response?.statusMessage}');
        debugPrint('RESPONSE DATA: ${error.response?.data}');
        debugPrint('REQUEST URL: ${error.requestOptions.uri}');
        debugPrint('REQUEST METHOD: ${error.requestOptions.method}');
        debugPrint('==================================================');
        debugPrint('');
      }

      rethrow;
    } on ApiException catch (error) {
      if (kDebugMode) {
        debugPrint('');
        debugPrint('GET COUNTRIES - API EXCEPTION');
        debugPrint('CODE: ${error.code}');
        debugPrint('MESSAGE: ${error.message}');
        debugPrint('==================================================');
        debugPrint('');
      }

      rethrow;
    } catch (error, stackTrace) {
      // ========================================================
      // UNKNOWN ERROR
      // ========================================================

      if (kDebugMode) {
        debugPrint('');
        debugPrint('==================================================');
        debugPrint('GET COUNTRIES - UNKNOWN ERROR');
        debugPrint('==================================================');
        debugPrint('ERROR: $error');
        debugPrint('STACK TRACE:');
        debugPrint('$stackTrace');
        debugPrint('==================================================');
        debugPrint('');
      }

      rethrow;
    }
  }
}
