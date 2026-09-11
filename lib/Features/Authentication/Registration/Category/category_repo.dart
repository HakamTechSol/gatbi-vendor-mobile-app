import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';

import 'category_model.dart';

class CategoryRepository {
  const CategoryRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Get Categories
  // ============================================================

  Future<CategoryModel> getCategories({
    bool includeChildren = true,
  }) async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      ApiUrls.catagery,
      queryParameters: {
        'include_children': includeChildren,
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
    // Convert API Response -> Category Model
    // ----------------------------------------------------------

    final result = CategoryModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Logs
    // ----------------------------------------------------------

    if (kDebugMode) {
      debugPrint('');

      debugPrint('========== CATEGORIES RESULT ==========');

      // --------------------------------------------------------
      // General
      // --------------------------------------------------------

      debugPrint('SUCCESS: ${result.success}');

      // --------------------------------------------------------
      // Categories
      // --------------------------------------------------------

      debugPrint('');

      debugPrint('---------- CATEGORIES ----------');

      debugPrint(
        'CATEGORIES COUNT: ${result.categories.length}',
      );

      if (result.categories.isNotEmpty) {
        for (final category in result.categories) {
          debugPrint(
            'CATEGORY: '
            '${category.name ?? 'N/A'} | '
            'ID: ${category.id ?? 'N/A'} | '
            'SLUG: ${category.slug ?? 'N/A'} | '
            'DESCRIPTION: '
            '${category.description ?? 'N/A'} | '
            'ICON: ${category.icon ?? 'N/A'} | '
            'IMAGE: ${category.image ?? 'N/A'} | '
            'PARENT ID: ${category.parentId ?? 'N/A'} | '
            'PRODUCT COUNT: ${category.productCount ?? 0} | '
            'CREATED AT: ${category.createdAt ?? 'N/A'} | '
            'UPDATED AT: ${category.updatedAt ?? 'N/A'}',
          );
        }
      }

      // --------------------------------------------------------
      // End
      // --------------------------------------------------------

      debugPrint('');

      debugPrint('=======================================');

      debugPrint('');
    }

    return result;
  }
}