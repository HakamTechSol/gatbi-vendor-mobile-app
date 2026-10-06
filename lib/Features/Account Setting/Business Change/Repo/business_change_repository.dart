import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';
import '../Models/business_change_model.dart';

class BusinessChangeRepository {
  const BusinessChangeRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Submit Business Change Request
  // ============================================================

  Future<BusinessChangeModel> submitBusinessChange({
    required String fieldName,
    required String requestedValue,
    required String reason,
    File? document,
  }) async {
    // ----------------------------------------------------------
    // Check selected field
    // ----------------------------------------------------------

    final bool isTradeLicense = fieldName == 'trade_license_number';

    // ----------------------------------------------------------
    // Debug Request Information
    // ----------------------------------------------------------

    if (kDebugMode) {
      debugPrint('');
      debugPrint('========== BUSINESS CHANGE REQUEST ==========');
      debugPrint('METHOD: POST');
      debugPrint('ENDPOINT: ${ApiUrls.businessChange}');
      debugPrint('FIELD NAME: $fieldName');
      debugPrint('REQUESTED VALUE: $requestedValue');
      debugPrint('REASON: ${reason.isEmpty ? 'EMPTY' : reason}');
      debugPrint('IS TRADE LICENSE: $isTradeLicense');
      debugPrint('DOCUMENT: ${document?.path ?? 'NO DOCUMENT'}');
      debugPrint('=============================================');
      debugPrint('');
    }

    // ==========================================================
    // TRADE LICENSE
    // ==========================================================
    //
    // Trade license ke liye:
    //
    // field_name
    // requested_value
    // reason
    // document -> actual image/file
    //
    // multipart/form-data use hoga.
    //
    // ==========================================================

    if (isTradeLicense) {
      // --------------------------------------------------------
      // Document Required
      // --------------------------------------------------------

      if (document == null) {
        throw const ApiException(
          message:
              'Please upload a supporting image for trade license number change.',
          code: 'DOCUMENT_REQUIRED',
        );
      }

      // --------------------------------------------------------
      // File Name
      // --------------------------------------------------------

      final String fileName = document.path.split(Platform.pathSeparator).last;

      // --------------------------------------------------------
      // Multipart Form Data
      // --------------------------------------------------------

      final formData = FormData.fromMap({
        'field_name': fieldName,
        'requested_value': requestedValue,
        'reason': reason,
        'document': await MultipartFile.fromFile(
          document.path,
          filename: fileName,
        ),
      });

      // --------------------------------------------------------
      // Debug Multipart
      // --------------------------------------------------------

      if (kDebugMode) {
        debugPrint('REQUEST TYPE: multipart/form-data');
        debugPrint('FILE NAME: $fileName');
        debugPrint('FILE PATH: ${document.path}');
      }

      // --------------------------------------------------------
      // API Call
      // --------------------------------------------------------

      final response = await _dioClient.post<Map<String, dynamic>>(
        ApiUrls.businessChange,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      return _parseResponse(response);
    }

    // ==========================================================
    // BUSINESS TYPE / STORE NAME
    // ==========================================================
    //
    // Business type aur store name ke liye:
    //
    // JSON request jayegi.
    //
    // Document empty string hoga:
    //
    // "document": ""
    //
    // ==========================================================

    final body = <String, dynamic>{
      'field_name': fieldName,
      'requested_value': requestedValue,
      'reason': reason,
      'document': '',
    };

    // ----------------------------------------------------------
    // Debug JSON
    // ----------------------------------------------------------

    if (kDebugMode) {
      debugPrint('REQUEST TYPE: application/json');
      debugPrint('BODY: $body');
    }

    // ----------------------------------------------------------
    // API Call
    // ----------------------------------------------------------

    final response = await _dioClient.post<Map<String, dynamic>>(
      ApiUrls.businessChange,
      data: body,
      options: Options(contentType: 'application/json'),
    );

    return _parseResponse(response);
  }

  // ============================================================
  // Parse API Response
  // ============================================================

  BusinessChangeModel _parseResponse(Response<Map<String, dynamic>> response) {
    final data = response.data;

    // ----------------------------------------------------------
    // Null Response
    // ----------------------------------------------------------

    if (data == null) {
      throw const ApiException(
        message: 'Invalid response received from server.',
        code: 'INVALID_RESPONSE',
      );
    }

    // ----------------------------------------------------------
    // Convert JSON -> Model
    // ----------------------------------------------------------

    final result = BusinessChangeModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Response
    // ----------------------------------------------------------

    if (kDebugMode) {
      final request = result.request;

      debugPrint('');
      debugPrint('========== BUSINESS CHANGE RESULT ==========');

      // --------------------------------------------------------
      // General
      // --------------------------------------------------------

      debugPrint('SUCCESS: ${result.success}');

      debugPrint('MESSAGE: ${result.message ?? 'N/A'}');

      // --------------------------------------------------------
      // Request
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- CHANGE REQUEST ----------');

      debugPrint('REQUEST ID: ${request?.id ?? 'N/A'}');

      debugPrint('FIELD NAME: ${request?.fieldName ?? 'N/A'}');

      debugPrint('FIELD LABEL: ${request?.fieldLabel ?? 'N/A'}');

      debugPrint('CURRENT VALUE: ${request?.currentValue ?? 'N/A'}');

      debugPrint('REQUESTED VALUE: ${request?.requestedValue ?? 'N/A'}');

      debugPrint('REASON: ${request?.reason ?? 'N/A'}');

      debugPrint('STATUS: ${request?.status ?? 'N/A'}');

      debugPrint('ADMIN NOTE: ${request?.adminNote ?? 'N/A'}');

      debugPrint('HAS DOCUMENT: ${request?.hasDocument ?? false}');

      debugPrint('CREATED AT: ${request?.createdAt ?? 'N/A'}');

      debugPrint('REVIEWED AT: ${request?.reviewedAt ?? 'N/A'}');

      debugPrint('');
      debugPrint('=============================================');
      debugPrint('');
    }

    return result;
  }
}
