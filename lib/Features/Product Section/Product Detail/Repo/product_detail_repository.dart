import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';
import '../Model/product_detail_model.dart';

class ProductDetailRepository {
  const ProductDetailRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Get Product Detail
  // ============================================================

  Future<ProductDetailModel> getProductDetail({required int productId}) async {
    // ----------------------------------------------------------
    // Request
    // ----------------------------------------------------------

    if (kDebugMode) {
      debugPrint('');
      debugPrint('========== PRODUCT DETAIL REQUEST ==========');
      debugPrint('PRODUCT ID: $productId');
      debugPrint('ENDPOINT: ${ApiUrls.product(productId)}');
      debugPrint('METHOD: GET');
      debugPrint('============================================');
      debugPrint('');
    }

    final response = await _dioClient.get<Map<String, dynamic>>(
      ApiUrls.product(productId),
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
    // Convert API Response -> Product Detail Model
    // ----------------------------------------------------------

    final result = ProductDetailModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Logs
    // ----------------------------------------------------------

    if (kDebugMode) {
      final product = result.product;

      debugPrint('');
      debugPrint('========== PRODUCT DETAIL RESULT ==========');

      // --------------------------------------------------------
      // General
      // --------------------------------------------------------

      debugPrint('SUCCESS: ${result.success}');

      // --------------------------------------------------------
      // Product Basic Information
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- PRODUCT ----------');

      debugPrint('PRODUCT ID: ${product?.id ?? 'N/A'}');
      debugPrint('PRODUCT NAME: ${product?.name ?? 'N/A'}');
      debugPrint('SLUG: ${product?.slug ?? 'N/A'}');
      debugPrint('SKU: ${product?.sku ?? 'N/A'}');

      debugPrint(
        'DESCRIPTION: '
        '${product?.description ?? 'N/A'}',
      );

      debugPrint(
        'SHORT DESCRIPTION: '
        '${product?.shortDescription ?? 'N/A'}',
      );

      // --------------------------------------------------------
      // Pricing
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- PRICING ----------');

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
        'DEAL RATE: '
        '${product?.dealRate ?? 0}',
      );

      debugPrint(
        'CURRENCY: '
        '${product?.currency ?? 'N/A'}',
      );

      debugPrint(
        'CURRENCY SYMBOL: '
        '${product?.currencySymbol ?? 'N/A'}',
      );

      // --------------------------------------------------------
      // Stock
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- STOCK ----------');

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

      // --------------------------------------------------------
      // Product Status
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- STATUS ----------');

      debugPrint(
        'IS ACTIVE: '
        '${product?.isActive ?? false}',
      );

      debugPrint(
        'ON SALE: '
        '${product?.onSale ?? false}',
      );

      debugPrint(
        'FEATURED: '
        '${product?.featured ?? false}',
      );

      debugPrint(
        'IS FLASH DEAL: '
        '${product?.isFlashDeal ?? false}',
      );

      // --------------------------------------------------------
      // Rating
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- RATING ----------');

      debugPrint(
        'RATING: '
        '${product?.rating ?? 0}',
      );

      debugPrint(
        'REVIEW COUNT: '
        '${product?.reviewCount ?? 0}',
      );

      // --------------------------------------------------------
      // Merchant
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- MERCHANT ----------');

      debugPrint(
        'MERCHANT ID: '
        '${product?.merchantId ?? 'N/A'}',
      );

      debugPrint(
        'MERCHANT NAME: '
        '${product?.merchantName ?? 'N/A'}',
      );

      // --------------------------------------------------------
      // Category
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- CATEGORY ----------');

      debugPrint(
        'CATEGORY ID: '
        '${product?.category?.id ?? 'N/A'}',
      );

      debugPrint(
        'CATEGORY NAME: '
        '${product?.category?.name ?? 'N/A'}',
      );

      // --------------------------------------------------------
      // Variants
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- VARIANTS ----------');

      debugPrint(
        'VARIANTS COUNT: '
        '${product?.variants.length ?? 0}',
      );

      if (product?.variants.isNotEmpty ?? false) {
        for (final variant in product!.variants) {
          debugPrint(
            'VARIANT: '
            'ID=${variant.id ?? 'N/A'} | '
            'SKU=${variant.sku ?? 'N/A'} | '
            'PRICE=${variant.price ?? 0} | '
            'OLD PRICE=${variant.priceOld ?? 0} | '
            'STOCK=${variant.stockQty ?? 0} | '
            'ACTIVE=${variant.isActive}',
          );

          if (variant.optionValues.isNotEmpty) {
            for (final option in variant.optionValues) {
              debugPrint(
                '  OPTION: '
                '${option.attribute ?? 'N/A'} = '
                '${option.value ?? 'N/A'} | '
                'ATTRIBUTE ID=${option.attributeId ?? 'N/A'} | '
                'VALUE ID=${option.attributeValueId ?? 'N/A'} | '
                'CODE=${option.code ?? 'N/A'}',
              );
            }
          }
        }
      }

      // --------------------------------------------------------
      // Attribute Groups
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- ATTRIBUTE GROUPS ----------');

      debugPrint(
        'ATTRIBUTE GROUPS COUNT: '
        '${product?.attributeGroups.length ?? 0}',
      );

      if (product?.attributeGroups.isNotEmpty ?? false) {
        for (final group in product!.attributeGroups) {
          debugPrint(
            'GROUP: '
            '${group.name ?? 'N/A'} | '
            'ATTRIBUTE ID=${group.attributeId ?? 'N/A'} | '
            'VALUES=${group.values.length}',
          );

          for (final value in group.values) {
            debugPrint(
              '  VALUE: '
              '${value.value ?? 'N/A'} | '
              'VALUE ID=${value.attributeValueId ?? 'N/A'} | '
              'MODIFIER=${value.priceModifier ?? 0}',
            );
          }
        }
      }

      // --------------------------------------------------------
      // Attributes
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- ATTRIBUTES ----------');

      debugPrint(
        'ATTRIBUTES COUNT: '
        '${product?.attributes.length ?? 0}',
      );

      if (product?.attributes.isNotEmpty ?? false) {
        for (final attribute in product!.attributes) {
          debugPrint(
            'ATTRIBUTE: '
            '${attribute.name ?? 'N/A'} | '
            'ID=${attribute.id ?? 'N/A'} | '
            'ATTRIBUTE ID=${attribute.attributeId ?? 'N/A'} | '
            'TYPE=${attribute.inputType ?? 'N/A'} | '
            'REQUIRED=${attribute.isRequired}',
          );

          for (final value in attribute.values) {
            debugPrint(
              '  VALUE: '
              '${value.value ?? 'N/A'} | '
              'ID=${value.id ?? 'N/A'} | '
              'VALUE ID=${value.attributeValueId ?? 'N/A'} | '
              'CODE=${value.code ?? 'N/A'} | '
              'MODIFIER=${value.priceModifier ?? 0}',
            );
          }
        }
      }

      // --------------------------------------------------------
      // Gallery
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- GALLERY ----------');

      debugPrint(
        'GALLERY COUNT: '
        '${product?.gallery.length ?? 0}',
      );

      if (product?.gallery.isNotEmpty ?? false) {
        for (final image in product!.gallery) {
          debugPrint('GALLERY IMAGE: $image');
        }
      }

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
      // Dates
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- DATES ----------');

      debugPrint(
        'CREATED AT: '
        '${product?.createdAt ?? 'N/A'}',
      );

      debugPrint(
        'UPDATED AT: '
        '${product?.updatedAt ?? 'N/A'}',
      );

      // --------------------------------------------------------
      // End
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('===========================================');
      debugPrint('');
    }

    return result;
  }
}
