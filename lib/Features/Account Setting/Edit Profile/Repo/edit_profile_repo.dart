import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';
import '../Models/edit_profile_model.dart';

class EditProfileRepository {
  const EditProfileRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // EDIT VENDOR PROFILE
  // ============================================================

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
      // ========================================================
      // DEBUG REQUEST
      // ========================================================

      if (kDebugMode) {
        debugPrint('');
        debugPrint('==================================================');
        debugPrint('EDIT PROFILE - API REQUEST');
        debugPrint('==================================================');
        debugPrint('URL: ${ApiUrls.editProfile}');
        debugPrint('METHOD: POST');
        debugPrint('CONTENT TYPE: multipart/form-data');
        debugPrint('');
        debugPrint('ABOUT: $about');
        debugPrint('WAREHOUSE ADDRESS: $warehouseAddress');
        debugPrint('PHONE FULL: $phoneFull');
        debugPrint('PHONE COUNTRY: $phoneCountry');
        debugPrint('PRIMARY CATEGORY ID: $primaryCategoryId');
        debugPrint('EXISTING LOGO: ${logo ?? 'NULL'}');
        debugPrint('NEW LOGO FILE: ${logoFile?.path ?? 'NO NEW FILE'}');
        debugPrint('==================================================');
        debugPrint('');
      }

      // ========================================================
      // FORM DATA
      // ========================================================

      final formData = FormData();

      formData.fields.add(MapEntry('about', about));

      formData.fields.add(MapEntry('warehouse_address', warehouseAddress));

      formData.fields.add(MapEntry('phone_full', phoneFull));

      formData.fields.add(MapEntry('phone_country', phoneCountry));

      formData.fields.add(
        MapEntry('primary_category_id', primaryCategoryId.toString()),
      );

      // ========================================================
      // LOGO
      // ========================================================

      if (logoFile != null) {
        final fileName = logoFile.path.split(Platform.pathSeparator).last;

        if (kDebugMode) {
          debugPrint('');
          debugPrint('========== LOGO UPLOAD ==========');
          debugPrint('FILE NAME: $fileName');
          debugPrint('FILE PATH: ${logoFile.path}');
          debugPrint('=================================');
          debugPrint('');
        }

        formData.files.add(
          MapEntry(
            'logo',
            await MultipartFile.fromFile(logoFile.path, filename: fileName),
          ),
        );
      } else {
        // Existing logo / empty logo string.
        formData.fields.add(MapEntry('logo', logo ?? ''));
      }

      // ========================================================
      // DEBUG FORM DATA
      // ========================================================

      if (kDebugMode) {
        debugPrint('');
        debugPrint('========== FORM DATA ==========');

        for (final field in formData.fields) {
          debugPrint('${field.key}: ${field.value}');
        }

        for (final file in formData.files) {
          final multipartFile = file.value;

          debugPrint('FILE FIELD: ${file.key}');

          debugPrint('FILE NAME: ${multipartFile.filename}');

          debugPrint('FILE LENGTH: ${multipartFile.length}');

          debugPrint('FILE CONTENT TYPE: ${multipartFile.contentType}');
        }

        debugPrint('===============================');
        debugPrint('');
      }

      // ========================================================
      // API REQUEST
      // ========================================================

      final response = await _dioClient.post<Map<String, dynamic>>(
        ApiUrls.editProfile,
        data: formData,
      );

      // ========================================================
      // RAW RESPONSE DEBUG
      // ========================================================

      if (kDebugMode) {
        debugPrint('');
        debugPrint('==================================================');
        debugPrint('EDIT PROFILE - RAW API RESPONSE');
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
          debugPrint('EDIT PROFILE ERROR: response.data is NULL');
        }

        throw const ApiException(
          message: 'Invalid response received from server.',
          code: 'INVALID_RESPONSE',
        );
      }

      // ========================================================
      // PARSE RESPONSE
      // ========================================================

      final result = EditProfileModel.fromJson(data);

      // ========================================================
      // PARSED RESPONSE DEBUG
      // ========================================================

      if (kDebugMode) {
        final merchant = result.merchant;

        debugPrint('');
        debugPrint('==================================================');
        debugPrint('EDIT PROFILE - PARSED RESPONSE');
        debugPrint('==================================================');

        debugPrint('SUCCESS: ${result.success}');

        debugPrint('MESSAGE: ${result.message ?? 'N/A'}');

        debugPrint('');
        debugPrint('---------- MERCHANT ----------');

        debugPrint('ID: ${merchant?.id ?? 'N/A'}');

        debugPrint('NAME: ${merchant?.name ?? 'N/A'}');

        debugPrint('EMAIL: ${merchant?.email ?? 'N/A'}');

        debugPrint('PHONE: ${merchant?.phone ?? 'N/A'}');

        debugPrint('LOGO: ${merchant?.logo ?? 'N/A'}');

        debugPrint('ABOUT: ${merchant?.about ?? 'N/A'}');

        debugPrint('STATUS: ${merchant?.status ?? 'N/A'}');

        debugPrint('KYC STATUS: ${merchant?.kycStatus ?? 'N/A'}');

        debugPrint(
          'CATEGORY ID: '
          '${merchant?.primaryCategoryId ?? 'N/A'}',
        );

        debugPrint(
          'WAREHOUSE: '
          '${merchant?.warehouseAddress ?? 'N/A'}',
        );

        debugPrint(
          'BUSINESS TYPE: '
          '${merchant?.businessType ?? 'N/A'}',
        );

        debugPrint(
          'TRADE LICENSE: '
          '${merchant?.tradeLicenseNumber ?? 'N/A'}',
        );

        debugPrint(
          'BANK ACCOUNT NAME: '
          '${merchant?.bankAccountName ?? 'N/A'}',
        );

        debugPrint(
          'BANK ACCOUNT NUMBER: '
          '${merchant?.bankAccountNumber ?? 'N/A'}',
        );

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
        debugPrint('EDIT PROFILE - DIO ERROR');
        debugPrint('==================================================');
        debugPrint('TYPE: ${error.type}');
        debugPrint('MESSAGE: ${error.message}');
        debugPrint('ERROR: ${error.error}');
        debugPrint('STATUS CODE: ${error.response?.statusCode}');
        debugPrint(
          'STATUS MESSAGE: '
          '${error.response?.statusMessage}',
        );
        debugPrint(
          'RESPONSE DATA: '
          '${error.response?.data}',
        );
        debugPrint(
          'REQUEST URL: '
          '${error.requestOptions.uri}',
        );
        debugPrint(
          'REQUEST METHOD: '
          '${error.requestOptions.method}',
        );
        debugPrint('==================================================');
        debugPrint('');
      }

      rethrow;
    } on ApiException catch (error) {
      if (kDebugMode) {
        debugPrint('');
        debugPrint('EDIT PROFILE - API EXCEPTION');
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
        debugPrint('EDIT PROFILE - UNKNOWN ERROR');
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
