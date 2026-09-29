import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';
import '../Models/delete_attributes_model.dart';

class DeleteAttributesRepository {
  const DeleteAttributesRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Delete Attribute
  // ============================================================

  Future<DeleteAttributesModel> deleteAttribute({required int id}) async {
    final response = await _dioClient.post<Map<String, dynamic>>(
      '${ApiUrls.vendorAttributes}/$id/delete',
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
    // Convert API Response -> Delete Attributes Model
    // ----------------------------------------------------------

    final result = DeleteAttributesModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Logs
    // ----------------------------------------------------------

    if (kDebugMode) {
      debugPrint('');
      debugPrint('========== DELETE ATTRIBUTE RESULT ==========');

      // --------------------------------------------------------
      // General
      // --------------------------------------------------------

      debugPrint('SUCCESS: ${result.success}');
      debugPrint('MESSAGE: ${result.message ?? 'N/A'}');

      // --------------------------------------------------------
      // End
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('=============================================');
      debugPrint('');
    }

    return result;
  }
}
