
import 'package:flutter/foundation.dart';

import '../../../../../Services/api_exception.dart';
import '../../../../../Services/api_url.dart';
import '../../../../../Services/dio_client.dart';
import '../Models/get_edit_product_model.dart';

class GetEditProductRepository {
  const GetEditProductRepository(this._dioClient);

  final DioClient _dioClient;

  Future<GetEditProductModel> getEditProduct(int productId) async {
    if (productId <= 0) {
      throw const ApiException(
        message: 'Invalid product ID.',
        code: 'INVALID_PRODUCT_ID',
      );
    }

    final response = await _dioClient.get<Map<String, dynamic>>(
      '${ApiUrls.products}/$productId/edit',
    );

    final data = response.data;

    if (data == null) {
      throw const ApiException(
        message: 'Invalid response received from server.',
        code: 'INVALID_RESPONSE',
      );
    }

    final result = GetEditProductModel.fromJson(data);

    if (!result.success || result.product == null) {
      throw const ApiException(
        message: 'Unable to load product details.',
        code: 'PRODUCT_NOT_FOUND',
      );
    }

    if (kDebugMode) {
      _printProductDetails(productId, result);
    }

    return result;
  }

  void _printProductDetails(
    int productId,
    GetEditProductModel result,
  ) {
    final product = result.product!;
    final translation = result.translation;

    debugPrint('');
    debugPrint('========== GET EDIT PRODUCT ==========');
    debugPrint('REQUESTED ID: $productId');
    debugPrint('SUCCESS: ${result.success}');

    debugPrint('');
    debugPrint('---------- BASIC INFORMATION ----------');
    debugPrint('ID: ${product.id}');
    debugPrint('NAME: ${product.name}');
    debugPrint('SLUG: ${product.slug}');
    debugPrint('SKU: ${product.sku}');
    debugPrint('BRAND: ${product.brand}');
    debugPrint('BRAND ID: ${product.brandId}');
    debugPrint('CATEGORY: ${product.category?.name}');
    debugPrint('CATEGORY ID: ${product.category?.id}');
    debugPrint('MERCHANT: ${product.merchantName}');
    debugPrint('MERCHANT ID: ${product.merchantId}');
    debugPrint('ACTIVE: ${product.isActive}');

    debugPrint('');
    debugPrint('---------- PRICING & STOCK ----------');
    debugPrint('PRICE: ${product.price}');
    debugPrint('REGULAR PRICE: ${product.regularPrice}');
    debugPrint('SALE PRICE: ${product.salePrice}');
    debugPrint('OLD PRICE: ${product.priceOld}');
    debugPrint('BASE PRICE: ${product.basePrice}');
    debugPrint('BASE OLD PRICE: ${product.basePriceOld}');
    debugPrint('PRICE MIN: ${product.priceMin}');
    debugPrint('PRICE MAX: ${product.priceMax}');
    debugPrint('PRICE FROM: ${product.priceFrom}');
    debugPrint('CURRENCY: ${product.currency}');
    debugPrint('STOCK STATUS: ${product.stockStatus}');
    debugPrint('STOCK QUANTITY: ${product.stockQuantity}');
    debugPrint('HAS VARIANTS: ${product.hasVariants}');
    debugPrint('ON SALE: ${product.onSale}');
    debugPrint('FLASH DEAL: ${product.isFlashDeal}');

    debugPrint('');
    debugPrint('---------- DESCRIPTION ----------');
    debugPrint('SHORT DESCRIPTION: ${product.shortDescription}');
    debugPrint('DESCRIPTION: ${product.description}');

    debugPrint('');
    debugPrint('---------- IMAGES ----------');
    debugPrint('MAIN IMAGE: ${product.image}');
    debugPrint('GALLERY COUNT: ${product.gallery.length}');

    for (final item in product.gallery) {
      debugPrint(
        'GALLERY ID: ${item.id} | '
        'IMAGE: ${item.image} | '
        'ORDER: ${item.sortOrder}',
      );
    }

    debugPrint('');
    debugPrint('---------- VARIANTS ----------');
    debugPrint('VARIANT COUNT: ${product.variants.length}');

    for (final variant in product.variants) {
      debugPrint(
        'VARIANT ID: ${variant.id} | '
        'SKU: ${variant.sku} | '
        'PRICE: ${variant.price} | '
        'OLD PRICE: ${variant.priceOld} | '
        'STOCK: ${variant.stockQty} | '
        'ACTIVE: ${variant.isActive} | '
        'OVERRIDE: ${variant.isPriceOverride}',
      );

      debugPrint('VARIANT ATTRIBUTES: ${variant.attributes}');

      for (final option in variant.optionValues) {
        debugPrint(
          'OPTION: ${option.attribute} | '
          'VALUE: ${option.value} | '
          'ATTRIBUTE ID: ${option.attributeId} | '
          'VALUE ID: ${option.attributeValueId} | '
          'CODE: ${option.code}',
        );
      }
    }

    debugPrint('');
    debugPrint('---------- ATTRIBUTE GROUPS ----------');

    for (final group in product.attributeGroups) {
      debugPrint(
        'GROUP: ${group.name} | '
        'ID: ${group.attributeId} | '
        'TYPE: ${group.inputType}',
      );

      for (final value in group.values) {
        debugPrint(
          'VALUE: ${value.value} | '
          'ID: ${value.attributeValueId} | '
          'CODE: ${value.code} | '
          'MODIFIER: ${value.priceModifier}',
        );
      }
    }

    debugPrint('');
    debugPrint('---------- PRODUCT ATTRIBUTES ----------');

    for (final attribute in product.attributes) {
      debugPrint(
        'ATTRIBUTE: ${attribute.name} | '
        'ID: ${attribute.id} | '
        'ATTRIBUTE ID: ${attribute.attributeId} | '
        'TYPE: ${attribute.inputType} | '
        'REQUIRED: ${attribute.isRequired} | '
        'ORDER: ${attribute.displayOrder}',
      );

      for (final value in attribute.values) {
        debugPrint(
          'VALUE: ${value.value} | '
          'ID: ${value.id} | '
          'VALUE ID: ${value.attributeValueId} | '
          'CODE: ${value.code} | '
          'MODIFIER: ${value.priceModifier}',
        );
      }
    }

    debugPrint('');
    debugPrint('---------- CAMPAIGNS ----------');

    for (final campaign in product.campaigns) {
      debugPrint(
        'ID: ${campaign.id} | '
        'NAME: ${campaign.name} | '
        'TYPE: ${campaign.campaignType} | '
        'STATUS: ${campaign.status} | '
        'START: ${campaign.startDate} | '
        'END: ${campaign.endDate} | '
        'EVENT ID: ${campaign.eventId}',
      );
    }

    debugPrint('');
    debugPrint('---------- AFFILIATE & SEO ----------');
    debugPrint('ALLOW AFFILIATE: ${product.allowAffiliate}');
    debugPrint('META TITLE: ${product.metaTitle}');
    debugPrint('META DESCRIPTION: ${product.metaDescription}');
    debugPrint('META KEYWORDS: ${product.metaKeywords}');
    debugPrint('AFFILIATE META TITLE: ${product.affiliateMetaTitle}');
    debugPrint(
      'AFFILIATE META DESCRIPTION: '
      '${product.affiliateMetaDescription}',
    );
    debugPrint(
      'AFFILIATE META KEYWORDS: ${product.affiliateMetaKeywords}',
    );

    debugPrint('');
    debugPrint('---------- ARABIC TRANSLATION ----------');
    debugPrint('NAME AR: ${translation?.nameAr}');
    debugPrint('SHORT DESCRIPTION AR: ${translation?.shortDescriptionAr}');
    debugPrint('DESCRIPTION AR: ${translation?.descriptionAr}');
    debugPrint('META TITLE AR: ${translation?.metaTitleAr}');
    debugPrint('META DESCRIPTION AR: ${translation?.metaDescriptionAr}');
    debugPrint('META KEYWORDS AR: ${translation?.metaKeywordsAr}');

    debugPrint('');
    debugPrint('=======================================');
  }
}
