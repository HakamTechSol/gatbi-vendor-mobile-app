import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';

import '../Models/add_product_model.dart';
import '../Models/add_product_request_model.dart';

class AddProductRepository {
  const AddProductRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Add Product
  // ============================================================

  Future<AddProductModel> addProduct(AddProductRequestModel request) async {
    // ==========================================================
    // Hero Image
    // ==========================================================

    final heroImage = await MultipartFile.fromFile(
      request.heroImage.path,
      filename: _fileName(request.heroImage.path),
    );

    // ==========================================================
    // Gallery Images
    // ==========================================================

    final galleryImages = <MultipartFile>[];

    for (final file in request.galleryImages) {
      galleryImages.add(
        await MultipartFile.fromFile(file.path, filename: _fileName(file.path)),
      );
    }

    // ==========================================================
    // Form Data
    // ==========================================================

    final formData = FormData();

    // ==========================================================
    // Basic Required Fields
    // ==========================================================

    formData.fields.add(MapEntry('name', request.name));

    formData.fields.add(MapEntry('category_id', request.categoryId.toString()));

    formData.fields.add(MapEntry('price', request.price.toString()));

    formData.fields.add(MapEntry('stock_qty', request.stockQty.toString()));

    // ==========================================================
    // PRODUCT STATUS
    //
    // API:
    // is_active = "1"
    //
    // request.isActive default = 1
    // ==========================================================

    formData.fields.add(MapEntry('is_active', request.isActive.toString()));

    // ==========================================================
    // Hero Image
    // ==========================================================

    formData.files.add(MapEntry('hero_image', heroImage));

    // ==========================================================
    // Gallery Images
    // ==========================================================

    for (final image in galleryImages) {
      formData.files.add(MapEntry('gallery_images[]', image));
    }

    // ==========================================================
    // Optional Pricing
    // ==========================================================

    if (request.priceOld != null) {
      formData.fields.add(MapEntry('price_old', request.priceOld.toString()));
    }

    // ==========================================================
    // SKU
    // ==========================================================

    if (_hasValue(request.sku)) {
      formData.fields.add(MapEntry('sku', request.sku!.trim()));
    }

    // ==========================================================
    // Brand
    // ==========================================================

    if (request.brandId != null) {
      formData.fields.add(MapEntry('brand_id', request.brandId.toString()));
    } else if (_hasValue(request.brand)) {
      formData.fields.add(MapEntry('brand', request.brand!.trim()));
    }

    // ==========================================================
    // Description
    // ==========================================================

    if (_hasValue(request.description)) {
      formData.fields.add(MapEntry('description', request.description!));
    }

    if (_hasValue(request.shortDescription)) {
      formData.fields.add(
        MapEntry('short_description', request.shortDescription!),
      );
    }

    // ==========================================================
    // Affiliate
    // ==========================================================

    formData.fields.add(
      MapEntry('allow_affiliate', request.allowAffiliate ? '1' : '0'),
    );

    // ==========================================================
    // Variants
    // ==========================================================

    formData.fields.add(
      MapEntry('has_variants', request.hasVariants ? '1' : '0'),
    );

    // ==========================================================
    // Variant Attributes
    //
    // Example:
    //
    // variant_attributes[] = 4
    // variant_attributes[] = 3
    // ==========================================================

    for (final attributeId in request.variantAttributes) {
      formData.fields.add(
        MapEntry('variant_attributes[]', attributeId.toString()),
      );
    }

    // ==========================================================
    // Attribute Values
    //
    // Example:
    //
    // attribute_values[4][] = 9
    // attribute_values[4][] = 12
    // attribute_values[3][] = 6
    // ==========================================================

    request.attributeValues.forEach((attributeId, valueIds) {
      for (final valueId in valueIds) {
        formData.fields.add(
          MapEntry('attribute_values[$attributeId][]', valueId.toString()),
        );
      }
    });

    // ==========================================================
    // Attribute Value Modifiers
    //
    // Example:
    //
    // attribute_value_modifiers[9] = 10
    //
    // Normally this map may be empty.
    // ==========================================================

    request.attributeValueModifiers.forEach((valueId, modifier) {
      formData.fields.add(
        MapEntry('attribute_value_modifiers[$valueId]', modifier.toString()),
      );
    });

    // ==========================================================
    // Variants Matrix
    //
    // Example:
    //
    // variants[0][sku]
    // variants[0][price]
    // variants[0][price_old]
    // variants[0][stock_qty]
    // variants[0][is_active]
    // variants[0][attribute_values][4]
    // variants[0][attribute_values][3]
    // ==========================================================

    for (var index = 0; index < request.variants.length; index++) {
      final variant = request.variants[index];

      // --------------------------------------------------------
      // Variant SKU
      // --------------------------------------------------------

      if (_hasValue(variant.sku)) {
        formData.fields.add(
          MapEntry('variants[$index][sku]', variant.sku!.trim()),
        );
      }

      // --------------------------------------------------------
      // Variant Price
      // --------------------------------------------------------

      formData.fields.add(
        MapEntry('variants[$index][price]', variant.price.toString()),
      );

      // --------------------------------------------------------
      // Variant Compare / Old Price
      // --------------------------------------------------------

      if (variant.priceOld != null) {
        formData.fields.add(
          MapEntry('variants[$index][price_old]', variant.priceOld.toString()),
        );
      }

      // --------------------------------------------------------
      // Variant Stock
      // --------------------------------------------------------

      formData.fields.add(
        MapEntry('variants[$index][stock_qty]', variant.stockQty.toString()),
      );

      // --------------------------------------------------------
      // Variant Status
      //
      // API:
      //
      // variants[0][is_active] = "1"
      //
      // Default:
      // 1
      // --------------------------------------------------------

      formData.fields.add(
        MapEntry('variants[$index][is_active]', variant.isActive.toString()),
      );

      // --------------------------------------------------------
      // Variant Attribute Values
      //
      // Example:
      //
      // variants[0][attribute_values][4] = 9
      // variants[0][attribute_values][3] = 6
      // --------------------------------------------------------

      variant.attributeValues.forEach((attributeId, valueId) {
        formData.fields.add(
          MapEntry(
            'variants[$index][attribute_values][$attributeId]',
            valueId.toString(),
          ),
        );
      });
    }

    // ==========================================================
    // Arabic Fields
    // ==========================================================

    if (_hasValue(request.nameAr)) {
      formData.fields.add(MapEntry('name_ar', request.nameAr!));
    }

    if (_hasValue(request.shortDescriptionAr)) {
      formData.fields.add(
        MapEntry('short_description_ar', request.shortDescriptionAr!),
      );
    }

    if (_hasValue(request.descriptionAr)) {
      formData.fields.add(MapEntry('description_ar', request.descriptionAr!));
    }

    // ==========================================================
    // SEO Fields
    // ==========================================================

    if (_hasValue(request.metaTitle)) {
      formData.fields.add(MapEntry('meta_title', request.metaTitle!));
    }

    if (_hasValue(request.metaDescription)) {
      formData.fields.add(
        MapEntry('meta_description', request.metaDescription!),
      );
    }

    if (_hasValue(request.metaKeywords)) {
      formData.fields.add(MapEntry('meta_keywords', request.metaKeywords!));
    }

    if (_hasValue(request.metaTitleAr)) {
      formData.fields.add(MapEntry('meta_title_ar', request.metaTitleAr!));
    }

    if (_hasValue(request.metaDescriptionAr)) {
      formData.fields.add(
        MapEntry('meta_description_ar', request.metaDescriptionAr!),
      );
    }

    if (_hasValue(request.metaKeywordsAr)) {
      formData.fields.add(
        MapEntry('meta_keywords_ar', request.metaKeywordsAr!),
      );
    }

    // ==========================================================
    // Debug Logs
    // ==========================================================

    if (kDebugMode) {
      debugPrint('');
      debugPrint('========== ADD PRODUCT REQUEST ==========');

      debugPrint('NAME: ${request.name}');
      debugPrint('CATEGORY ID: ${request.categoryId}');
      debugPrint('PRICE: ${request.price}');
      debugPrint('PRICE OLD: ${request.priceOld ?? 'N/A'}');
      debugPrint('STOCK QTY: ${request.stockQty}');
      debugPrint('IS ACTIVE: ${request.isActive}');
      debugPrint('SKU: ${request.sku ?? 'AUTO'}');
      debugPrint('BRAND ID: ${request.brandId ?? 'N/A'}');
      debugPrint('BRAND: ${request.brand ?? 'N/A'}');

      debugPrint(
        'DESCRIPTION: '
        '${request.description?.isNotEmpty == true ? 'YES' : 'NO'}',
      );

      debugPrint(
        'SHORT DESCRIPTION: '
        '${request.shortDescription?.isNotEmpty == true ? 'YES' : 'NO'}',
      );

      debugPrint('ALLOW AFFILIATE: ${request.allowAffiliate}');

      debugPrint('HAS VARIANTS: ${request.hasVariants}');

      debugPrint('HERO IMAGE: ${request.heroImage.path}');

      debugPrint('GALLERY IMAGES: ${request.galleryImages.length}');

      debugPrint('VARIANT ATTRIBUTES: ${request.variantAttributes}');

      debugPrint('ATTRIBUTE VALUES: ${request.attributeValues}');

      debugPrint(
        'ATTRIBUTE MODIFIERS: '
        '${request.attributeValueModifiers}',
      );

      debugPrint('VARIANTS COUNT: ${request.variants.length}');

      // --------------------------------------------------------
      // Variant Logs
      // --------------------------------------------------------

      for (var index = 0; index < request.variants.length; index++) {
        final variant = request.variants[index];

        debugPrint(
          'VARIANT [$index] | '
          'SKU: ${variant.sku ?? 'AUTO'} | '
          'PRICE: ${variant.price} | '
          'PRICE OLD: ${variant.priceOld ?? 'N/A'} | '
          'STOCK: ${variant.stockQty} | '
          'IS ACTIVE: ${variant.isActive} | '
          'ATTRIBUTES: ${variant.attributeValues}',
        );
      }

      // --------------------------------------------------------
      // Arabic Logs
      // --------------------------------------------------------

      debugPrint('ARABIC NAME: ${request.nameAr ?? 'N/A'}');

      debugPrint(
        'ARABIC SHORT DESCRIPTION: '
        '${request.shortDescriptionAr ?? 'N/A'}',
      );

      debugPrint(
        'ARABIC DESCRIPTION: '
        '${request.descriptionAr ?? 'N/A'}',
      );

      // --------------------------------------------------------
      // SEO Logs
      // --------------------------------------------------------

      debugPrint('META TITLE: ${request.metaTitle ?? 'N/A'}');

      debugPrint(
        'META DESCRIPTION: '
        '${request.metaDescription ?? 'N/A'}',
      );

      debugPrint('META KEYWORDS: ${request.metaKeywords ?? 'N/A'}');

      debugPrint('=========================================');

      debugPrint('');
    }

    // ==========================================================
    // API Request
    // ==========================================================

    final response = await _dioClient.post<Map<String, dynamic>>(
      ApiUrls.products,
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );

    final data = response.data;

    // ==========================================================
    // Validate Response
    // ==========================================================

    if (data == null) {
      throw const ApiException(
        message: 'Invalid response received from server.',
        code: 'INVALID_RESPONSE',
      );
    }

    // ==========================================================
    // Convert Response -> Model
    // ==========================================================

    final result = AddProductModel.fromJson(data);

    // ==========================================================
    // Response Logs
    // ==========================================================

    if (kDebugMode) {
      final product = result.product;

      debugPrint('');
      debugPrint('========== ADD PRODUCT RESULT ==========');

      debugPrint('SUCCESS: ${result.success}');

      debugPrint('MESSAGE: ${result.message ?? 'N/A'}');

      debugPrint('');
      debugPrint('---------- PRODUCT ----------');

      debugPrint('PRODUCT ID: ${product?.id ?? 'N/A'}');

      debugPrint('PRODUCT NAME: ${product?.name ?? 'N/A'}');

      debugPrint('SLUG: ${product?.slug ?? 'N/A'}');

      debugPrint(
        'PRICE: '
        '${product?.price ?? 0} '
        '${product?.currency ?? ''}',
      );

      debugPrint('REGULAR PRICE: ${product?.regularPrice ?? 0}');

      debugPrint('SALE PRICE: ${product?.salePrice ?? 0}');

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

      debugPrint('IMAGE: ${product?.image ?? 'N/A'}');

      debugPrint(
        'VARIANTS COUNT: '
        '${product?.variants.length ?? 0}',
      );

      if (product?.variants.isNotEmpty == true) {
        for (final variant in product!.variants) {
          debugPrint(
            'VARIANT: '
            '${variant.sku ?? 'N/A'} | '
            'PRICE: ${variant.price ?? 0} | '
            'STOCK: ${variant.stockQty ?? 0} | '
            'ATTRIBUTES: ${variant.attributes}',
          );
        }
      }

      debugPrint(
        'ATTRIBUTE GROUPS: '
        '${product?.attributeGroups.length ?? 0}',
      );

      debugPrint(
        'ATTRIBUTES: '
        '${product?.attributes.length ?? 0}',
      );

      debugPrint(
        'CAMPAIGNS: '
        '${product?.campaigns.length ?? 0}',
      );

      debugPrint('');
      debugPrint('========================================');

      debugPrint('');
    }

    return result;
  }

  // ============================================================
  // Helpers
  // ============================================================

  static bool _hasValue(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  static String _fileName(String path) {
    final normalizedPath = path.replaceAll('\\', '/');

    final index = normalizedPath.lastIndexOf('/');

    if (index == -1) {
      return normalizedPath;
    }

    return normalizedPath.substring(index + 1);
  }
}
