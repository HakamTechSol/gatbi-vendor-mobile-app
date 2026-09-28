import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';
import '../Models/support_model.dart';


class SupportRepository {
  const SupportRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Create Support Request
  // ============================================================

  Future<SupportModel> createSupportRequest({
    required String subject,
    required String category,
    required String priority,
    required String message,
  }) async {
    final response = await _dioClient.post<Map<String, dynamic>>(
      ApiUrls.createSupport,
      data: {
        'subject': subject,
        'category': category,
        'priority': priority,
        'message': message,
      },
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
    // Convert API Response -> Support Model
    // ----------------------------------------------------------

    final result = SupportModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Logs
    // ----------------------------------------------------------

    if (kDebugMode) {
      debugPrint('');
      debugPrint('========== CREATE SUPPORT RESULT ==========');

      // --------------------------------------------------------
      // General
      // --------------------------------------------------------

      debugPrint('SUCCESS: ${result.success}');
      debugPrint('MESSAGE: ${result.message ?? 'N/A'}');

      // --------------------------------------------------------
      // Request Details
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- SUPPORT REQUEST ----------');

      debugPrint('SUBJECT: $subject');
      debugPrint('CATEGORY: $category');
      debugPrint('PRIORITY: $priority');
      debugPrint('MESSAGE: $message');

      // --------------------------------------------------------
      // End
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('============================================');
      debugPrint('');
    }

    return result;
  }
}
