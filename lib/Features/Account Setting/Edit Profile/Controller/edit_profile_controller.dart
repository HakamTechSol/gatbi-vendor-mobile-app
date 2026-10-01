import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';

import '../Models/edit_profile_model.dart';
import '../Repo/edit_profile_repo.dart';

final editProfileControllerProvider = Provider<EditProfileController>((ref) {
  final dioClient = ref.watch(dioProvider);

  return EditProfileController(dioClient: dioClient);
});

class EditProfileController {
  EditProfileController({required DioClient dioClient})
    : _repository = EditProfileRepository(dioClient);

  final EditProfileRepository _repository;

  Future<EditProfileModel> editProfile({
    required String about,
    required String warehouseAddress,
    required String phoneFull,
    required String phoneCountry,
    required int primaryCategoryId,
    String? logo,
    File? logoFile,
  }) async {
    try {
      return await _repository.editProfile(
        about: about,
        warehouseAddress: warehouseAddress,
        phoneFull: phoneFull,
        phoneCountry: phoneCountry,
        primaryCategoryId: primaryCategoryId,
        logo: logo,
        logoFile: logoFile,
      );
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
