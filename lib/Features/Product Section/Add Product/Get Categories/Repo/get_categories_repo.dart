import 'package:flutter/foundation.dart';

import '../../../../../Services/api_exception.dart';
import '../../../../../Services/api_url.dart';
import '../../../../../Services/dio_client.dart';
import '../Models/get_categories_model.dart';

class GetCategoriesRepository {
  const GetCategoriesRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Get Categories
  // ============================================================

  Future<GetCategoriesModel> getCategories() async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      ApiUrls.categoryOptions,
      queryParameters: {'include_children': true},
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

    final result = GetCategoriesModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Logs
    // ----------------------------------------------------------

    if (kDebugMode) {
      debugPrint('');
      debugPrint('========== Get CATEGORIES RESULT ==========');

      // --------------------------------------------------------
      // General
      // --------------------------------------------------------

      debugPrint('SUCCESS: ${result.success}');
      debugPrint('CATEGORIES COUNT: ${result.categories.length}');

      // --------------------------------------------------------
      // Categories
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- CATEGORIES ----------');

      for (final category in result.categories) {
        _logCategory(category, level: 0);
      }

      debugPrint('');
      debugPrint('=====================================================');
      debugPrint('');
    }

    return result;
  }

  // ============================================================
  // Recursive Category Logger
  // ============================================================

  void _logCategory(GetCategoryModel category, {required int level}) {
    final indent = '  ' * level;

    debugPrint(
      '$indent'
      'CATEGORY: '
      '${category.name ?? 'N/A'} | '
      'ID: ${category.id ?? 'N/A'} | '
      'SLUG: ${category.slug ?? 'N/A'} | '
      'PARENT ID: ${category.parentId ?? 'N/A'} | '
      'CHILDREN: ${category.children.length}',
    );

    for (final child in category.children) {
      _logCategory(child, level: level + 1);
    }
  }
}
