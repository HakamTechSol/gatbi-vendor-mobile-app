import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';

import '../Model/countries_model.dart';
import '../Repo/countries_repo.dart';

final countriesControllerProvider = Provider<CountriesController>((ref) {
  final dioClient = ref.watch(dioProvider);

  return CountriesController(dioClient: dioClient);
});

class CountriesController {
  CountriesController({required DioClient dioClient})
    : _repository = CountriesRepository(dioClient);

  final CountriesRepository _repository;

  Future<CountriesModel> getCountries() async {
    try {
      return await _repository.getCountries();
    } on ApiException {
      rethrow;
    } catch (error) {
      throw ApiException(
        message: 'Something went wrong. Please try again.',
        code: 'UNKNOWN_ERROR',
        originalError: error,
      );
    }
  }
}