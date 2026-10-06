
import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';
import '../Models/get_business_change_model.dart';

class GetBusinessChangeRepository {
  const GetBusinessChangeRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Get Business Change Settings
  // ============================================================

  Future<GetBusinessChangeModel> getBusinessChange() async {
    final response =
        await _dioClient.get<Map<String, dynamic>>(
      ApiUrls.businessChange,
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
    // Convert API Response -> Model
    // ----------------------------------------------------------

    final result = GetBusinessChangeModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Logs
    // ----------------------------------------------------------

    if (kDebugMode) {
      debugPrint('');
      debugPrint(
        '========== GET BUSINESS CHANGE RESULT ==========',
      );

      // --------------------------------------------------------
      // General
      // --------------------------------------------------------

      debugPrint('SUCCESS: ${result.success}');

      // --------------------------------------------------------
      // Locked Fields
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- LOCKED FIELDS ----------');

      debugPrint(
        'LOCKED FIELDS COUNT: '
        '${result.lockedFields.length}',
      );

      result.lockedFields.forEach((fieldName, field) {
        debugPrint('');
        debugPrint('FIELD NAME: $fieldName');
        debugPrint(
          'FIELD LABEL: ${field.label ?? 'N/A'}',
        );
        debugPrint(
          'CURRENT VALUE: '
          '${field.currentValue ?? 'N/A'}',
        );
        debugPrint(
          'OPTIONS: ${field.options}',
        );
        debugPrint(
          'DOCUMENT REQUIRED: '
          '${field.documentRequired}',
        );
      });

      // --------------------------------------------------------
      // Changeable Fields
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- CHANGEABLE FIELDS ----------');

      debugPrint(
        'CHANGEABLE FIELDS: '
        '${result.changeableFields}',
      );

      // --------------------------------------------------------
      // File Configuration
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- FILE CONFIGURATION ----------');

      debugPrint(
        'ALLOWED FILE TYPES: '
        '${result.allowedFileTypes}',
      );

      debugPrint(
        'MAX FILE SIZE: '
        '${result.maxFileSize ?? 0} bytes',
      );

      if (result.maxFileSize != null) {
        final maxSizeMb =
            result.maxFileSize! / (1024 * 1024);

        debugPrint(
          'MAX FILE SIZE MB: '
          '${maxSizeMb.toStringAsFixed(2)} MB',
        );
      }

      // --------------------------------------------------------
      // Previous Requests
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- BUSINESS CHANGE REQUESTS ----------');

      debugPrint(
        'REQUESTS COUNT: ${result.requests.length}',
      );

      if (result.requests.isNotEmpty) {
        for (final request in result.requests) {
          debugPrint(
            'REQUEST: '
            'ID: ${request.id ?? 'N/A'} | '
            'FIELD: ${request.fieldName ?? 'N/A'} | '
            'LABEL: ${request.fieldLabel ?? 'N/A'} | '
            'CURRENT: ${request.currentValue ?? 'N/A'} | '
            'REQUESTED: ${request.requestedValue ?? 'N/A'} | '
            'STATUS: ${request.status ?? 'N/A'} | '
            'DOCUMENT: ${request.hasDocument} | '
            'CREATED: ${request.createdAt ?? 'N/A'}',
          );
        }
      }

      // --------------------------------------------------------
      // End
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('===============================================');
      debugPrint('');
    }

    return result;
  }
}