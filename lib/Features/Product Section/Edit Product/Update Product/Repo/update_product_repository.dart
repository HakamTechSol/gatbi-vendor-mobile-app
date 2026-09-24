import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../../Services/api_exception.dart';
import '../../../../../Services/api_url.dart';
import '../../../../../Services/dio_client.dart';
import '../Models/update_product_model.dart';
import '../Models/update_product_request_model.dart';

class UpdateProductRepository {
  const UpdateProductRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Update Product
  // ============================================================

  Future<UpdateProductModel> updateProduct({
    required int productId,
    required UpdateProductRequestModel request,
  }) async {
    // ==========================================================
    // Form Data
    // ==========================================================

    final formData = FormData();

    // ==========================================================
    // Basic Product Information
    // ==========================================================

    if (_hasValue(request.name)) {
      formData.fields.add(MapEntry('name', request.name!.trim()));
    }

    if (_hasValue(request.shortDescription)) {
      formData.fields.add(
        MapEntry('short_description', request.shortDescription!.trim()),
      );
    }

    if (_hasValue(request.description)) {
      formData.fields.add(MapEntry('description', request.description!.trim()));
    }

    // ==========================================================
    // Pricing
    // ==========================================================

    if (request.price != null) {
      formData.fields.add(MapEntry('price', request.price.toString()));
    }

    if (request.priceOld != null) {
      formData.fields.add(MapEntry('price_old', request.priceOld.toString()));
    }

    // ==========================================================
    // Inventory
    // ==========================================================

    if (request.stockQty != null) {
      formData.fields.add(MapEntry('stock_qty', request.stockQty.toString()));
    }

    // ==========================================================
    // Category
    // ==========================================================

    if (request.categoryId != null) {
      formData.fields.add(
        MapEntry('category_id', request.categoryId.toString()),
      );
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
    // SKU
    // ==========================================================

    if (_hasValue(request.sku)) {
      formData.fields.add(MapEntry('sku', request.sku!.trim()));
    }

    // ==========================================================
    // Weight
    // ==========================================================

    if (request.weight != null) {
      formData.fields.add(MapEntry('weight', request.weight.toString()));
    }

    // ==========================================================
    // Affiliate
    // ==========================================================

    if (request.allowAffiliate != null) {
      formData.fields.add(
        MapEntry('allow_affiliate', request.allowAffiliate! ? '1' : '0'),
      );
    }

    // ==========================================================
    // Featured
    // ==========================================================

    if (request.isFeatured != null) {
      formData.fields.add(
        MapEntry('is_featured', request.isFeatured! ? '1' : '0'),
      );
    }

    // ==========================================================
    // IMPORTANT
    //
    // Product is_active is intentionally NOT sent.
    // ==========================================================

    // ==========================================================
    // Hero Image
    //
    // Only send when a NEW image is selected.
    // ==========================================================

    if (request.heroImage != null) {
      final heroImage = await MultipartFile.fromFile(
        request.heroImage!.path,
        filename: _fileName(request.heroImage!.path),
      );

      formData.files.add(MapEntry('hero_image', heroImage));
    }

    // ==========================================================
    // Gallery Images
    //
    // Update API:
    //
    // images[]
    // ==========================================================

    if (request.galleryImages != null) {
      for (final file in request.galleryImages!) {
        final image = await MultipartFile.fromFile(
          file.path,
          filename: _fileName(file.path),
        );

        formData.files.add(MapEntry('images[]', image));
      }
    }

    // ==========================================================
    // Has Variants
    //
    // Only send when explicitly provided.
    // ==========================================================

    if (request.hasVariants != null) {
      formData.fields.add(
        MapEntry('has_variants', request.hasVariants! ? '1' : '0'),
      );
    }

    // ==========================================================
    // Variant Attributes
    // ==========================================================

    if (request.variantAttributes != null) {
      for (final attributeId in request.variantAttributes!) {
        formData.fields.add(
          MapEntry('variant_attributes[]', attributeId.toString()),
        );
      }
    }

    // ==========================================================
    // Attribute Values
    // ==========================================================

    if (request.attributeValues != null) {
      request.attributeValues!.forEach((attributeId, valueIds) {
        for (final valueId in valueIds) {
          formData.fields.add(
            MapEntry('attribute_values[$attributeId][]', valueId.toString()),
          );
        }
      });
    }

    // ==========================================================
    // Attribute Value Modifiers
    // ==========================================================

    if (request.attributeValueModifiers != null) {
      request.attributeValueModifiers!.forEach((valueId, modifier) {
        formData.fields.add(
          MapEntry('attribute_value_modifiers[$valueId]', modifier.toString()),
        );
      });
    }

    // ==========================================================
    // Variants Matrix
    //
    // Existing variant matrix remains untouched if variants
    // are omitted completely.
    // ==========================================================

    if (request.variants != null) {
      for (var index = 0; index < request.variants!.length; index++) {
        final variant = request.variants![index];

        // ------------------------------------------------------
        // Variant SKU
        // ------------------------------------------------------

        if (_hasValue(variant.sku)) {
          formData.fields.add(
            MapEntry('variants[$index][sku]', variant.sku!.trim()),
          );
        }

        // ------------------------------------------------------
        // Variant Price
        // ------------------------------------------------------

        if (variant.price != null) {
          formData.fields.add(
            MapEntry('variants[$index][price]', variant.price.toString()),
          );
        }

        // ------------------------------------------------------
        // Variant Old Price
        // ------------------------------------------------------

        if (variant.priceOld != null) {
          formData.fields.add(
            MapEntry(
              'variants[$index][price_old]',
              variant.priceOld.toString(),
            ),
          );
        }

        // ------------------------------------------------------
        // Variant Stock
        // ------------------------------------------------------

        if (variant.stockQty != null) {
          formData.fields.add(
            MapEntry(
              'variants[$index][stock_qty]',
              variant.stockQty.toString(),
            ),
          );
        }

        // ------------------------------------------------------
        // Variant Active Status
        //
        // Only send when explicitly provided.
        // ------------------------------------------------------

        if (variant.isActive != null) {
          formData.fields.add(
            MapEntry(
              'variants[$index][is_active]',
              variant.isActive.toString(),
            ),
          );
        }

        // ------------------------------------------------------
        // Variant Attribute Values
        // ------------------------------------------------------

        if (variant.attributeValues != null) {
          variant.attributeValues!.forEach((attributeId, valueId) {
            formData.fields.add(
              MapEntry(
                'variants[$index][attribute_values][$attributeId]',
                valueId.toString(),
              ),
            );
          });
        }
      }
    }

    // ==========================================================
    // Arabic Fields
    // ==========================================================

    if (_hasValue(request.nameAr)) {
      formData.fields.add(MapEntry('name_ar', request.nameAr!.trim()));
    }

    if (_hasValue(request.shortDescriptionAr)) {
      formData.fields.add(
        MapEntry('short_description_ar', request.shortDescriptionAr!.trim()),
      );
    }

    if (_hasValue(request.descriptionAr)) {
      formData.fields.add(
        MapEntry('description_ar', request.descriptionAr!.trim()),
      );
    }

    // ==========================================================
    // SEO
    // ==========================================================

    if (_hasValue(request.metaTitle)) {
      formData.fields.add(MapEntry('meta_title', request.metaTitle!.trim()));
    }

    if (_hasValue(request.metaDescription)) {
      formData.fields.add(
        MapEntry('meta_description', request.metaDescription!.trim()),
      );
    }

    if (_hasValue(request.metaKeywords)) {
      formData.fields.add(
        MapEntry('meta_keywords', request.metaKeywords!.trim()),
      );
    }

    if (_hasValue(request.metaTitleAr)) {
      formData.fields.add(
        MapEntry('meta_title_ar', request.metaTitleAr!.trim()),
      );
    }

    if (_hasValue(request.metaDescriptionAr)) {
      formData.fields.add(
        MapEntry('meta_description_ar', request.metaDescriptionAr!.trim()),
      );
    }

    if (_hasValue(request.metaKeywordsAr)) {
      formData.fields.add(
        MapEntry('meta_keywords_ar', request.metaKeywordsAr!.trim()),
      );
    }

    // ==========================================================
    // Debug Logs
    // ==========================================================

    if (kDebugMode) {
      debugPrint('');
      debugPrint('========== UPDATE PRODUCT REQUEST ==========');

      debugPrint('PRODUCT ID: $productId');

      debugPrint('NAME: ${request.name ?? 'OMITTED'}');

      debugPrint(
        'SHORT DESCRIPTION: '
        '${_hasValue(request.shortDescription) ? 'YES' : 'OMITTED'}',
      );

      debugPrint(
        'DESCRIPTION: '
        '${_hasValue(request.description) ? 'YES' : 'OMITTED'}',
      );

      debugPrint('PRICE: ${request.price ?? 'OMITTED'}');

      debugPrint('PRICE OLD: ${request.priceOld ?? 'OMITTED'}');

      debugPrint('STOCK QTY: ${request.stockQty ?? 'OMITTED'}');

      debugPrint('CATEGORY ID: ${request.categoryId ?? 'OMITTED'}');

      debugPrint('BRAND ID: ${request.brandId ?? 'OMITTED'}');

      debugPrint('BRAND: ${request.brand ?? 'OMITTED'}');

      debugPrint('SKU: ${request.sku ?? 'OMITTED'}');

      debugPrint('WEIGHT: ${request.weight ?? 'OMITTED'}');

      debugPrint(
        'ALLOW AFFILIATE: '
        '${request.allowAffiliate ?? 'OMITTED'}',
      );

      debugPrint(
        'IS FEATURED: '
        '${request.isFeatured ?? 'OMITTED'}',
      );

      debugPrint(
        'HAS VARIANTS: '
        '${request.hasVariants ?? 'OMITTED'}',
      );

      debugPrint(
        'HERO IMAGE: '
        '${request.heroImage?.path ?? 'OMITTED'}',
      );

      debugPrint(
        'GALLERY IMAGES: '
        '${request.galleryImages?.length ?? 'OMITTED'}',
      );

      debugPrint(
        'VARIANT ATTRIBUTES: '
        '${request.variantAttributes ?? 'OMITTED'}',
      );

      debugPrint(
        'ATTRIBUTE VALUES: '
        '${request.attributeValues ?? 'OMITTED'}',
      );

      debugPrint(
        'ATTRIBUTE MODIFIERS: '
        '${request.attributeValueModifiers ?? 'OMITTED'}',
      );

      debugPrint(
        'VARIANTS COUNT: '
        '${request.variants?.length ?? 'OMITTED'}',
      );

      // --------------------------------------------------------
      // Variant Logs
      // --------------------------------------------------------

      if (request.variants != null) {
        for (var index = 0; index < request.variants!.length; index++) {
          final variant = request.variants![index];

          debugPrint(
            'VARIANT [$index] | '
            'SKU: ${variant.sku ?? 'OMITTED'} | '
            'PRICE: ${variant.price ?? 'OMITTED'} | '
            'PRICE OLD: ${variant.priceOld ?? 'OMITTED'} | '
            'STOCK: ${variant.stockQty ?? 'OMITTED'} | '
            'IS ACTIVE: ${variant.isActive ?? 'OMITTED'} | '
            'ATTRIBUTES: '
            '${variant.attributeValues ?? 'OMITTED'}',
          );
        }
      }

      debugPrint(
        'ARABIC NAME: '
        '${request.nameAr ?? 'OMITTED'}',
      );

      debugPrint(
        'ARABIC SHORT DESCRIPTION: '
        '${request.shortDescriptionAr ?? 'OMITTED'}',
      );

      debugPrint(
        'ARABIC DESCRIPTION: '
        '${request.descriptionAr ?? 'OMITTED'}',
      );

      debugPrint(
        'META TITLE: '
        '${request.metaTitle ?? 'OMITTED'}',
      );

      debugPrint(
        'META DESCRIPTION: '
        '${request.metaDescription ?? 'OMITTED'}',
      );

      debugPrint(
        'META KEYWORDS: '
        '${request.metaKeywords ?? 'OMITTED'}',
      );

      debugPrint('============================================');

      debugPrint('');
    }

    // ==========================================================
    // API URL
    // ==========================================================

    final path = '${ApiUrls.products}/$productId/update';

    // ==========================================================
    // API Request
    // ==========================================================

    final response = await _dioClient.post<Map<String, dynamic>>(
      path,
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

    final result = UpdateProductModel.fromJson(data);

    // ==========================================================
    // Response Logs
    // ==========================================================

    if (kDebugMode) {
      final product = result.product;

      debugPrint('');
      debugPrint('========== UPDATE PRODUCT RESULT ==========');

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

      debugPrint(
        'REGULAR PRICE: '
        '${product?.regularPrice ?? 0}',
      );

      debugPrint(
        'SALE PRICE: '
        '${product?.salePrice ?? 0}',
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
            'IS ACTIVE: ${variant.isActive} | '
            'ATTRIBUTES: ${variant.attributes}',
          );
        }
      }

      debugPrint(
        'GALLERY COUNT: '
        '${product?.gallery.length ?? 0}',
      );

      debugPrint(
        'ATTRIBUTES COUNT: '
        '${product?.attributes.length ?? 0}',
      );

      debugPrint(
        'CAMPAIGNS COUNT: '
        '${product?.campaigns.length ?? 0}',
      );

      debugPrint('');
      debugPrint('===========================================');
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
