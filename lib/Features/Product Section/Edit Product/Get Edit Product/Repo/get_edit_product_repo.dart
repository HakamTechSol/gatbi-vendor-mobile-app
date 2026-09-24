import 'package:flutter/foundation.dart';

import '../../../../../Services/api_exception.dart';
import '../../../../../Services/api_url.dart';
import '../../../../../Services/dio_client.dart';
import '../Models/get_edit_product_model.dart';

class GetEditProductRepository {
  const GetEditProductRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Get Edit Product
  // ============================================================

  Future<GetEditProductModel> getEditProduct(int productId) async {
    // ----------------------------------------------------------
    // API Request
    // ----------------------------------------------------------

    final response = await _dioClient.get<Map<String, dynamic>>(
      '${ApiUrls.products}/$productId/edit',
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

    final result = GetEditProductModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Logs
    // ----------------------------------------------------------

    if (kDebugMode) {
      final product = result.product;
      final translation = result.translation;

      debugPrint('');
      debugPrint('========== GET EDIT PRODUCT RESULT ==========');

      // --------------------------------------------------------
      // General
      // --------------------------------------------------------

      debugPrint('SUCCESS: ${result.success}');

      // --------------------------------------------------------
      // Request
      // --------------------------------------------------------

      debugPrint('PRODUCT ID: $productId');

      // --------------------------------------------------------
      // Product
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- PRODUCT ----------');

      debugPrint('ID: ${product?.id ?? 'N/A'}');

      debugPrint('NAME: ${product?.name ?? 'N/A'}');

      debugPrint('SLUG: ${product?.slug ?? 'N/A'}');

      debugPrint(
        'PRICE: '
        '${product?.price ?? 0} '
        '${product?.currency ?? ''}',
      );

      debugPrint(
        'REGULAR PRICE: '
        '${product?.regularPrice ?? 0}',
      );

      debugPrint(
        'SALE PRICE: '
        '${product?.salePrice ?? 0}',
      );

      debugPrint(
        'PRICE OLD: '
        '${product?.priceOld ?? 0}',
      );

      debugPrint(
        'BASE PRICE: '
        '${product?.basePrice ?? 0}',
      );

      debugPrint(
        'BASE PRICE OLD: '
        '${product?.basePriceOld ?? 0}',
      );

      debugPrint(
        'PRICE MIN: '
        '${product?.priceMin ?? 0}',
      );

      debugPrint(
        'PRICE MAX: '
        '${product?.priceMax ?? 0}',
      );

      debugPrint(
        'PRICE FROM: '
        '${product?.priceFrom ?? 0}',
      );

      debugPrint(
        'STOCK STATUS: '
        '${product?.stockStatus ?? 'N/A'}',
      );

      debugPrint(
        'STOCK QUANTITY: '
        '${product?.stockQuantity ?? 0}',
      );

      debugPrint(
        'HAS VARIANTS: '
        '${product?.hasVariants ?? false}',
      );

      debugPrint(
        'IS ACTIVE: '
        '${product?.isActive ?? false}',
      );

      // --------------------------------------------------------
      // Basic Information
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- BASIC INFORMATION ----------');

      debugPrint('SKU: ${product?.sku ?? 'N/A'}');

      debugPrint('BRAND: ${product?.brand ?? 'N/A'}');

      debugPrint(
        'CATEGORY: '
        '${product?.category?.name ?? 'N/A'} '
        '(ID: ${product?.category?.id ?? 'N/A'})',
      );

      debugPrint(
        'MERCHANT: '
        '${product?.merchantName ?? 'N/A'} '
        '(ID: ${product?.merchantId ?? 'N/A'})',
      );

      debugPrint(
        'FEATURED: '
        '${product?.featured ?? false}',
      );

      debugPrint(
        'ON SALE: '
        '${product?.onSale ?? false}',
      );

      debugPrint(
        'RATING: '
        '${product?.rating ?? 0}',
      );

      debugPrint(
        'REVIEW COUNT: '
        '${product?.reviewCount ?? 0}',
      );

      // --------------------------------------------------------
      // Images
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- IMAGES ----------');

      debugPrint(
        'MAIN IMAGE: '
        '${product?.image ?? 'N/A'}',
      );

      debugPrint(
        'GALLERY COUNT: '
        '${product?.gallery.length ?? 0}',
      );

      if (product?.gallery.isNotEmpty == true) {
        for (final gallery in product!.gallery) {
          debugPrint(
            'GALLERY: '
            'ID: ${gallery.id ?? 'N/A'} | '
            'IMAGE: ${gallery.image ?? 'N/A'} | '
            'SORT: ${gallery.sortOrder ?? 0}',
          );
        }
      }

      // --------------------------------------------------------
      // Variants
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- VARIANTS ----------');

      debugPrint(
        'VARIANTS COUNT: '
        '${product?.variants.length ?? 0}',
      );

      if (product?.variants.isNotEmpty == true) {
        for (final variant in product!.variants) {
          debugPrint(
            'VARIANT: '
            'ID: ${variant.id ?? 'N/A'} | '
            'SKU: ${variant.sku ?? 'N/A'} | '
            'PRICE: ${variant.price ?? 0} | '
            'PRICE OLD: ${variant.priceOld ?? 0} | '
            'STOCK: ${variant.stockQty ?? 0} | '
            'ACTIVE: ${variant.isActive} | '
            'PRICE OVERRIDE: ${variant.isPriceOverride}',
          );

          debugPrint(
            '  ATTRIBUTES: '
            '${variant.attributes}',
          );

          debugPrint(
            '  OPTION VALUES: '
            '${variant.optionValues.length}',
          );

          for (final option in variant.optionValues) {
            debugPrint(
              '  OPTION: '
              '${option.attribute ?? 'N/A'} | '
              'VALUE: ${option.value ?? 'N/A'} | '
              'VALUE ID: '
              '${option.attributeValueId ?? 'N/A'} | '
              'CODE: ${option.code ?? 'N/A'}',
            );
          }
        }
      }

      // --------------------------------------------------------
      // Attribute Groups
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- ATTRIBUTE GROUPS ----------');

      debugPrint(
        'ATTRIBUTE GROUP COUNT: '
        '${product?.attributeGroups.length ?? 0}',
      );

      if (product?.attributeGroups.isNotEmpty == true) {
        for (final group in product!.attributeGroups) {
          debugPrint(
            'GROUP: '
            '${group.name ?? 'N/A'} | '
            'ATTRIBUTE ID: '
            '${group.attributeId ?? 'N/A'} | '
            'VALUES: ${group.values.length}',
          );

          for (final value in group.values) {
            debugPrint(
              '  VALUE: '
              '${value.value ?? 'N/A'} | '
              'VALUE ID: '
              '${value.attributeValueId ?? 'N/A'} | '
              'MODIFIER: '
              '${value.priceModifier ?? 0}',
            );
          }
        }
      }

      // --------------------------------------------------------
      // Product Attributes
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- PRODUCT ATTRIBUTES ----------');

      debugPrint(
        'ATTRIBUTES COUNT: '
        '${product?.attributes.length ?? 0}',
      );

      if (product?.attributes.isNotEmpty == true) {
        for (final attribute in product!.attributes) {
          debugPrint(
            'ATTRIBUTE: '
            '${attribute.name ?? 'N/A'} | '
            'ID: ${attribute.id ?? 'N/A'} | '
            'ATTRIBUTE ID: '
            '${attribute.attributeId ?? 'N/A'} | '
            'INPUT TYPE: '
            '${attribute.inputType ?? 'N/A'} | '
            'REQUIRED: ${attribute.isRequired}',
          );

          for (final value in attribute.values) {
            debugPrint(
              '  VALUE: '
              '${value.value ?? 'N/A'} | '
              'ID: ${value.id ?? 'N/A'} | '
              'ATTRIBUTE VALUE ID: '
              '${value.attributeValueId ?? 'N/A'} | '
              'CODE: ${value.code ?? 'N/A'} | '
              'MODIFIER: ${value.priceModifier ?? 0}',
            );
          }
        }
      }

      // --------------------------------------------------------
      // Translation
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- ARABIC TRANSLATION ----------');

      debugPrint(
        'NAME AR: '
        '${translation?.nameAr ?? 'N/A'}',
      );

      debugPrint(
        'SHORT DESCRIPTION AR: '
        '${translation?.shortDescriptionAr ?? 'N/A'}',
      );

      debugPrint(
        'DESCRIPTION AR: '
        '${translation?.descriptionAr ?? 'N/A'}',
      );

      debugPrint(
        'META TITLE AR: '
        '${translation?.metaTitleAr ?? 'N/A'}',
      );

      debugPrint(
        'META DESCRIPTION AR: '
        '${translation?.metaDescriptionAr ?? 'N/A'}',
      );

      debugPrint(
        'META KEYWORDS AR: '
        '${translation?.metaKeywordsAr ?? 'N/A'}',
      );

      // --------------------------------------------------------
      // Campaigns
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- CAMPAIGNS ----------');

      debugPrint(
        'CAMPAIGNS COUNT: '
        '${product?.campaigns.length ?? 0}',
      );

      // --------------------------------------------------------
      // End
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('==========================================');
      debugPrint('');
    }

    return result;
  }
}
