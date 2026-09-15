import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';

import 'country_model.dart';
import 'country_repo.dart';

// ============================================================
// Country Provider
// ============================================================

final countryControllerProvider = Provider<CountryController>((ref) {
  final dioClient = ref.watch(dioProvider);

  return CountryController(dioClient: dioClient);
});

// ============================================================
// Country Controller
// ============================================================

class CountryController {
  CountryController({required DioClient dioClient})
    : _repository = CountryRepository(dioClient);

  final CountryRepository _repository;

  // ==========================================================
  // Get Countries
  // ==========================================================

  Future<CountryModel> getCountries() async {
    try {
      final result = await _repository.getCountries();

      return result;
    } on ApiException {
      // Existing API exception ko as-is UI tak jane dein.
      //
      // Is se statusCode, code aur validation/error details
      // preserve rehti hain.

      rethrow;
    } catch (error) {
      // Unexpected errors ko standard ApiException mein
      // convert kar rahe hain.

      throw ApiException(
        message: 'Something went wrong. Please try again.',
        code: 'UNKNOWN_ERROR',
        originalError: error,
      );
    }
  }
}
