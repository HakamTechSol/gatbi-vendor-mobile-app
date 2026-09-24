import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_project/Routes/app_route.dart';

import '../../../../Services/api_exception.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../../Attributes/Get Attributes/Controllers/get_attributes_controller.dart';
import '../../Attributes/Get Attributes/Models/get_attributes_model.dart';

import '../Add Product/Product Option/Controller/product_option_controller.dart';
import '../Add Product/Product Option/Models/product_option_brand_model.dart';
import '../Add Product/Product Option/Models/product_option_category_model.dart';

import '../Add Product/Reuse Widgets/arabic_translation_section.dart';
import '../Add Product/Reuse Widgets/basic_information_section.dart';
import '../Add Product/Reuse Widgets/category_brand_section.dart';
import '../Add Product/Reuse Widgets/pricing_inventory_section.dart';
import '../Add Product/Reuse Widgets/product_dropdown_field.dart';
import '../Add Product/Reuse Widgets/product_form_header.dart';
import '../Add Product/Reuse Widgets/product_form_notice.dart';
import '../Add Product/Reuse Widgets/product_images_section.dart';
import '../Add Product/Reuse Widgets/product_submit_section.dart';
import '../Add Product/Reuse Widgets/seo_settings_section.dart';
import '../Add Product/Reuse Widgets/variants_section.dart';
import '../Add Product/Reuse Widgets/variant_builder.dart';

import '../Arabic Translator/product_arabic_translation_controller.dart';

import '../My Product/Models/my_product_model.dart';

import 'Get Edit Product/Controller/get_edit_product_controller.dart';
import 'Get Edit Product/Models/get_edit_product_model.dart';
import 'Update Product/Controller/update_product_controller.dart';
import 'Update Product/Models/update_product_request_model.dart';

class EditProductScreen extends ConsumerStatefulWidget {
  const EditProductScreen({super.key, required this.product});

  final MyProductModel product;

  @override
  ConsumerState<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends ConsumerState<EditProductScreen> {
  // ═══════════════════════════════════════════════════════════════════════════
  // WIZARD
  // ═══════════════════════════════════════════════════════════════════════════

  int _currentStep = 0;

  static const int _totalSteps = 7;

  final List<String> _stepTitles = const [
    'Basic',
    'Arabic',
    'Category',
    'Images',
    'Pricing',
    'Variants',
    'SEO',
  ];

  final List<String> _stepDescriptions = const [
    'Product information',
    'Arabic translation',
    'Category and brand',
    'Product images',
    'Price and inventory',
    'Options and variants',
    'SEO and update',
  ];

  final List<GlobalKey<FormState>> _stepFormKeys = List.generate(
    7,
    (_) => GlobalKey<FormState>(),
  );

  final _formKey = GlobalKey<FormState>();

  // ═══════════════════════════════════════════════════════════════════════════
  // API STATE
  // ═══════════════════════════════════════════════════════════════════════════

  bool _isLoadingProduct = true;

  GetEditProductItemModel? _editProduct;

  String? _loadProductError;

  // ═══════════════════════════════════════════════════════════════════════════
  // IMAGE PICKER
  // ═══════════════════════════════════════════════════════════════════════════

  final ImagePicker _imagePicker = ImagePicker();

  File? _primaryImage;

  final List<File> _galleryImages = <File>[];

  String? _existingPrimaryImage;

  final List<String> _existingGalleryImages = <String>[];

  // ═══════════════════════════════════════════════════════════════════════════
  // BASIC INFORMATION
  // ═══════════════════════════════════════════════════════════════════════════

  late final TextEditingController _productNameController;

  late final TextEditingController _shortDescriptionController;

  late final TextEditingController _fullDescriptionController;

  bool _allowAffiliates = false;

  // ═══════════════════════════════════════════════════════════════════════════
  // ARABIC
  // ═══════════════════════════════════════════════════════════════════════════

  late final TextEditingController _arabicNameController;

  late final TextEditingController _arabicShortDescriptionController;

  late final TextEditingController _arabicFullDescriptionController;

  late final TextEditingController _arabicMetaTitleController;

  late final TextEditingController _arabicMetaKeywordsController;

  late final TextEditingController _arabicMetaDescriptionController;

  bool _isTranslating = false;

  // ═══════════════════════════════════════════════════════════════════════════
  // PRICING & INVENTORY
  // ═══════════════════════════════════════════════════════════════════════════

  late final TextEditingController _priceController;

  late final TextEditingController _compareAtPriceController;

  late final TextEditingController _costPriceController;

  late final TextEditingController _stockController;

  late final TextEditingController _skuController;

  String _inventoryType = 'track';

  // ═══════════════════════════════════════════════════════════════════════════
  // CATEGORY & BRAND
  // ═══════════════════════════════════════════════════════════════════════════

  String? _categoryId;

  String? _brandId;

  // ═══════════════════════════════════════════════════════════════════════════
  // PRODUCT OPTIONS API
  // ═══════════════════════════════════════════════════════════════════════════

  bool _isLoadingProductOptions = false;

  List<ProductOptionCategoryModel> _categories = <ProductOptionCategoryModel>[];

  List<ProductOptionBrandModel> _brands = <ProductOptionBrandModel>[];

  // ═══════════════════════════════════════════════════════════════════════════
  // ATTRIBUTE API
  // ═══════════════════════════════════════════════════════════════════════════

  bool _isLoadingAttributes = false;

  List<GetAttributeModel> _availableAttributes = <GetAttributeModel>[];

  // ═══════════════════════════════════════════════════════════════════════════
  // VARIANTS
  // ═══════════════════════════════════════════════════════════════════════════

  bool _enableVariants = false;

  List<GetAttributeModel> _attributes = <GetAttributeModel>[];

  List<VariantData> _variants = <VariantData>[];

  // ═══════════════════════════════════════════════════════════════════════════
  // SEO
  // ═══════════════════════════════════════════════════════════════════════════

  late final TextEditingController _slugController;

  late final TextEditingController _metaTitleController;

  late final TextEditingController _metaDescriptionController;

  late final TextEditingController _metaKeywordsController;

  // ═══════════════════════════════════════════════════════════════════════════
  // STATUS
  // ═══════════════════════════════════════════════════════════════════════════

  bool _isActive = true;

  // ═══════════════════════════════════════════════════════════════════════════
  // SUBMIT
  // ═══════════════════════════════════════════════════════════════════════════

  bool _isSubmitting = false;

  String? _formNotice;

  // ═══════════════════════════════════════════════════════════════════════════
  // INIT
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  void initState() {
    super.initState();

    _initializeControllers();

    unawaited(_loadEditProduct());

    unawaited(_loadProductOptions());

    unawaited(_loadAttributes());
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // INITIALIZE CONTROLLERS
  // ═══════════════════════════════════════════════════════════════════════════

  void _initializeControllers() {
    _productNameController = TextEditingController();

    _shortDescriptionController = TextEditingController();

    _fullDescriptionController = TextEditingController();

    _arabicNameController = TextEditingController();

    _arabicShortDescriptionController = TextEditingController();

    _arabicFullDescriptionController = TextEditingController();

    _arabicMetaTitleController = TextEditingController();

    _arabicMetaKeywordsController = TextEditingController();

    _arabicMetaDescriptionController = TextEditingController();

    _priceController = TextEditingController();

    _compareAtPriceController = TextEditingController();

    _costPriceController = TextEditingController();

    _stockController = TextEditingController(text: '0');

    _skuController = TextEditingController();

    _slugController = TextEditingController();

    _metaTitleController = TextEditingController();

    _metaDescriptionController = TextEditingController();

    _metaKeywordsController = TextEditingController();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // GET EDIT PRODUCT API
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _loadEditProduct() async {
    if (_isLoadingProduct == false) {
      return;
    }

    if (mounted) {
      setState(() {
        _isLoadingProduct = true;
        _loadProductError = null;
      });
    }

    try {
      final productId = widget.product.id;

      if (productId == null) {
        throw const ApiException(
          message: 'Product ID is missing.',
          code: 'PRODUCT_ID_MISSING',
        );
      }

      debugPrint('');
      debugPrint('==================================================');
      debugPrint('EDIT PRODUCT SCREEN');
      debugPrint('GET EDIT PRODUCT STARTED');
      debugPrint('PRODUCT ID: $productId');
      debugPrint('==================================================');

      final result = await ref
          .read(getEditProductControllerProvider)
          .getEditProduct(productId);

      if (!mounted) {
        return;
      }

      final product = result.product;

      if (product == null) {
        setState(() {
          _isLoadingProduct = false;
          _loadProductError =
              'Product information was not received from server.';
        });

        return;
      }

      _editProduct = product;

      _populateProductData(product: product, translation: result.translation);

      setState(() {
        _isLoadingProduct = false;
        _loadProductError = null;
      });

      _restoreVariantAttributes();

      debugPrint('');
      debugPrint('GET EDIT PRODUCT SUCCESS');
      debugPrint('PRODUCT: ${product.name}');
      debugPrint('CATEGORY: ${product.category?.name}');
      debugPrint('BRAND: ${product.brand}');
      debugPrint('VARIANTS: ${product.variants.length}');
      debugPrint('GALLERY: ${product.gallery.length}');
      debugPrint('==================================================');
      debugPrint('');
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      debugPrint('GET EDIT PRODUCT API ERROR: ${error.message}');

      setState(() {
        _isLoadingProduct = false;
        _loadProductError = error.message;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      debugPrint('GET EDIT PRODUCT UNEXPECTED ERROR: $error');

      setState(() {
        _isLoadingProduct = false;
        _loadProductError = 'Unable to load product. Please try again.';
      });
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // POPULATE PRODUCT DATA
  // ═══════════════════════════════════════════════════════════════════════════

  void _populateProductData({
    required GetEditProductItemModel product,
    required GetEditProductTranslationModel? translation,
  }) {
    // ═══════════════════════════════════════════════════════════════════════════
    // BASIC INFORMATION
    // ═══════════════════════════════════════════════════════════════════════════

    _productNameController.text = product.name ?? '';

    _shortDescriptionController.text = product.shortDescription ?? '';

    _fullDescriptionController.text = product.description ?? '';

    // ═══════════════════════════════════════════════════════════════════════════
    // ARABIC TRANSLATION
    // ═══════════════════════════════════════════════════════════════════════════

    _arabicNameController.text = translation?.nameAr ?? '';

    _arabicShortDescriptionController.text =
        translation?.shortDescriptionAr ?? '';

    _arabicFullDescriptionController.text = translation?.descriptionAr ?? '';

    _arabicMetaTitleController.text = translation?.metaTitleAr ?? '';

    _arabicMetaKeywordsController.text = translation?.metaKeywordsAr ?? '';

    _arabicMetaDescriptionController.text =
        translation?.metaDescriptionAr ?? '';

    // ═══════════════════════════════════════════════════════════════════════════
    // PRICING
    // ═══════════════════════════════════════════════════════════════════════════

    _priceController.text = _formatNumber(product.price);

    _compareAtPriceController.text = _formatNumber(
      product.priceOld ?? product.regularPrice,
    );

    _costPriceController.text = '';

    // ═══════════════════════════════════════════════════════════════════════════
    // INVENTORY
    // ═══════════════════════════════════════════════════════════════════════════

    _stockController.text = product.stockQuantity?.toString() ?? '0';

    _skuController.text = product.sku ?? '';

    _inventoryType = 'track';

    // ═══════════════════════════════════════════════════════════════════════════
    // CATEGORY
    // ═══════════════════════════════════════════════════════════════════════════

    _categoryId = product.category?.id?.toString();

    // ═══════════════════════════════════════════════════════════════════════════
    // BRAND
    // ═══════════════════════════════════════════════════════════════════════════

    _brandId = null;

    _setBrandFromProductName(product.brand);

    // ═══════════════════════════════════════════════════════════════════════════
    // VARIANTS
    // ═══════════════════════════════════════════════════════════════════════════

    _enableVariants = product.hasVariants || product.variants.isNotEmpty;

    debugPrint('');
    debugPrint('==================================================');
    debugPrint('EDIT PRODUCT - VARIANT RESTORE');
    debugPrint('==================================================');

    debugPrint('API hasVariants: ${product.hasVariants}');

    debugPrint('API variant count: ${product.variants.length}');

    debugPrint('API attribute groups: ${product.attributeGroups.length}');

    debugPrint('FINAL variants enabled: $_enableVariants');

    _variants = product.variants
        .map((variant) {
          final attributeValueIds = <int, int>{};

          for (final option in variant.optionValues) {
            final attributeId = option.attributeId;

            final valueId = option.attributeValueId;

            if (attributeId == null || valueId == null) {
              continue;
            }

            attributeValueIds[attributeId] = valueId;

            debugPrint(
              'VARIANT OPTION: '
              'attributeId=$attributeId -> '
              'attributeValueId=$valueId '
              '(${option.attribute}: ${option.value})',
            );
          }

          if (attributeValueIds.isEmpty) {
            for (final entry in variant.attributes.entries) {
              final attrId = int.tryParse(entry.key.toString());

              final valId = entry.value is int
                  ? entry.value as int
                  : int.tryParse(entry.value.toString());

              if (attrId != null && valId != null) {
                attributeValueIds[attrId] = valId;
              }
            }
          }

          final mappedAttributes = <String, String>{};

          for (final option in variant.optionValues) {
            final name = option.attribute?.trim();

            final value = option.value?.trim();

            if (name != null &&
                name.isNotEmpty &&
                value != null &&
                value.isNotEmpty) {
              mappedAttributes[name] = value;
            }
          }

          return VariantData(
            attributes: mappedAttributes,
            attributeValueIds: attributeValueIds,
            price: variant.price != null ? _formatNumber(variant.price) : '',
            compareAtPrice: variant.priceOld != null
                ? _formatNumber(variant.priceOld)
                : '',
            stockQuantity: variant.stockQty?.toString() ?? '',
            sku: variant.sku ?? '',
          );
        })
        .toList(growable: false);

    _attributes = <GetAttributeModel>[];

    // ═══════════════════════════════════════════════════════════════════════════
    // SEO
    // ═══════════════════════════════════════════════════════════════════════════

    _slugController.text = product.slug ?? _slugify(product.name ?? '');

    _metaTitleController.text = '';

    _metaDescriptionController.text = '';

    _metaKeywordsController.text = '';

    // ═══════════════════════════════════════════════════════════════════════════
    // STATUS
    // ═══════════════════════════════════════════════════════════════════════════

    _isActive = product.isActive;

    // ═══════════════════════════════════════════════════════════════════════════
    // SERVER IMAGES
    // ═══════════════════════════════════════════════════════════════════════════

    _existingPrimaryImage = product.image;

    _existingGalleryImages
      ..clear()
      ..addAll(
        product.gallery
            .map((item) => item.image)
            .whereType<String>()
            .where((url) => url.trim().isNotEmpty),
      );

    debugPrint('');
    debugPrint('========== PRODUCT DATA POPULATED ==========');

    debugPrint('PRODUCT: ${product.name}');

    debugPrint('HAS VARIANTS: $_enableVariants');

    debugPrint('VARIANTS: ${_variants.length}');

    for (int i = 0; i < _variants.length; i++) {
      final variant = _variants[i];

      debugPrint(
        'VARIANT[$i] '
        'attributes=${variant.attributes} '
        'valueIds=${variant.attributeValueIds} '
        'price=${variant.price} '
        'compare=${variant.compareAtPrice} '
        'stock=${variant.stockQuantity} '
        'sku=${variant.sku}',
      );
    }

    debugPrint(
      'ATTRIBUTE GROUPS: '
      '${product.attributeGroups.length}',
    );

    for (final group in product.attributeGroups) {
      debugPrint(
        'GROUP: '
        'id=${group.attributeId} '
        'name=${group.name} '
        'values=${group.values.length}',
      );

      for (final value in group.values) {
        debugPrint(
          '   VALUE: '
          'id=${value.attributeValueId} '
          'name=${value.value}',
        );
      }
    }

    debugPrint('============================================');
    debugPrint('');
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // RESTORE VARIANT ATTRIBUTES
  // ═══════════════════════════════════════════════════════════════════════════

  void _restoreVariantAttributes() {
    // ═══════════════════════════════════════════════════════════════════════════
    // VARIANTS DISABLED → clear attributes
    // ═══════════════════════════════════════════════════════════════════════════

    if (!_enableVariants) {
      if (!mounted) return;

      if (_attributes.isNotEmpty) {
        setState(() {
          _attributes = <GetAttributeModel>[];
        });
      }
      return;
    }

    final product = _editProduct;

    if (product == null) {
      debugPrint('RESTORE ATTRIBUTES: product is null.');
      return;
    }

    if (_availableAttributes.isEmpty) {
      debugPrint('RESTORE ATTRIBUTES: available attributes not loaded yet.');
      return;
    }

    debugPrint('');
    debugPrint('==================================================');
    debugPrint('RESTORE PRODUCT ATTRIBUTES');
    debugPrint('==================================================');
    debugPrint('product.attributeGroups: ${product.attributeGroups.length}');
    debugPrint('product.attributes:      ${product.attributes.length}');
    debugPrint('availableAttributes:     ${_availableAttributes.length}');

    // ═══════════════════════════════════════════════════════════════════════════
    // BUILD LOOKUPS FROM GET ATTRIBUTES API
    // ═══════════════════════════════════════════════════════════════════════════

    final availableById = <int, GetAttributeModel>{};

    for (final attribute in _availableAttributes) {
      final id = attribute.id;
      if (id != null) {
        availableById[id] = attribute;
      }
    }

    final availableValuesById = <int, GetAttributeValueModel>{};

    for (final attribute in _availableAttributes) {
      for (final value in attribute.values) {
        final valueId = value.id;
        if (valueId != null) {
          availableValuesById[valueId] = value;
        }
      }
    }

    // ═══════════════════════════════════════════════════════════════════════════
    // DECIDE SOURCE OF ATTRIBUTES
    //
    // Priority:
    //   1) product.attributeGroups  (has attributeId + selected values)
    //   2) product.attributes       (fallback when attributeGroups is empty)
    // ═══════════════════════════════════════════════════════════════════════════

    final bool useGroups = product.attributeGroups.isNotEmpty;

    debugPrint(
      'SOURCE: ${useGroups ? "attribute_groups" : "attributes (fallback)"}',
    );

    final restoredAttributes = <GetAttributeModel>[];

    // ═══════════════════════════════════════════════════════════════════════════
    // PATH A — Use attributeGroups
    // ═══════════════════════════════════════════════════════════════════════════

    if (useGroups) {
      for (final group in product.attributeGroups) {
        final attributeId = group.attributeId;

        if (attributeId == null) {
          continue;
        }

        final fullAttribute = availableById[attributeId];

        if (fullAttribute == null) {
          debugPrint('SKIP GROUP: attribute id=$attributeId not found in API.');
          continue;
        }

        final selectedValueIds = <int>{};

        for (final groupValue in group.values) {
          final valueId = groupValue.attributeValueId;
          if (valueId != null) {
            selectedValueIds.add(valueId);
          }
        }

        final selectedValues = <GetAttributeValueModel>[];

        for (final valueId in selectedValueIds) {
          final fullValue = availableValuesById[valueId];

          if (fullValue != null) {
            selectedValues.add(fullValue);
            continue;
          }

          // Fallback: build from group value directly.
          final fallbackName = group.values
              .firstWhere(
                (v) => v.attributeValueId == valueId,
                orElse: () => const GetEditProductAttributeGroupValueModel(),
              )
              .value
              ?.trim();

          if (fallbackName != null && fallbackName.isNotEmpty) {
            selectedValues.add(
              GetAttributeValueModel(id: valueId, value: fallbackName),
            );
          }
        }

        if (selectedValues.isEmpty) {
          continue;
        }

        restoredAttributes.add(
          GetAttributeModel(
            id: fullAttribute.id,
            name: fullAttribute.name,
            adminLabel: fullAttribute.adminLabel,
            slug: fullAttribute.slug,
            inputType: fullAttribute.inputType,
            isOwn: fullAttribute.isOwn,
            values: selectedValues,
          ),
        );

        debugPrint(
          'RESTORED (group): ${fullAttribute.name} '
          '(ID: $attributeId) '
          'values=${selectedValues.length}',
        );
      }
    }

    // ═══════════════════════════════════════════════════════════════════════════
    // PATH B — Fallback to product.attributes
    //
    // Used when attribute_groups is empty.
    //
    // product.attributes already contains:
    //   - attribute_id
    //   - name
    //   - input_type
    //   - values (with attribute_value_id + value)
    // ═══════════════════════════════════════════════════════════════════════════

    if (!useGroups) {
      for (final productAttribute in product.attributes) {
        final attributeId = productAttribute.attributeId;

        if (attributeId == null) {
          continue;
        }

        // Try to enrich from GET ATTRIBUTES API.
        final fullAttribute = availableById[attributeId];

        // ─────────────────────────────────────────────────────────────
        // Build selected values from product.attributes.values
        // ─────────────────────────────────────────────────────────────

        final selectedValues = <GetAttributeValueModel>[];

        for (final productValue in productAttribute.values) {
          final valueId = productValue.attributeValueId;

          if (valueId == null) {
            continue;
          }

          // Prefer full value from API (has code + sortOrder).
          final fullValue = availableValuesById[valueId];

          if (fullValue != null) {
            selectedValues.add(fullValue);
            continue;
          }

          // Fallback: build from product.attributes value.
          final name = productValue.value?.trim();

          if (name != null && name.isNotEmpty) {
            selectedValues.add(
              GetAttributeValueModel(
                id: valueId,
                value: name,
                code: productValue.code,
              ),
            );
          }
        }

        if (selectedValues.isEmpty) {
          debugPrint(
            'SKIP ATTRIBUTE: '
            '${productAttribute.name} has no values.',
          );
          continue;
        }

        // ─────────────────────────────────────────────────────────────
        // Build final attribute.
        //
        // Prefer full metadata from GET ATTRIBUTES API when available.
        // Otherwise use product.attributes metadata.
        // ─────────────────────────────────────────────────────────────

        restoredAttributes.add(
          GetAttributeModel(
            id: fullAttribute?.id ?? attributeId,
            name: fullAttribute?.name ?? productAttribute.name,
            adminLabel: fullAttribute?.adminLabel,
            slug: fullAttribute?.slug,
            inputType: fullAttribute?.inputType ?? productAttribute.inputType,
            isOwn: fullAttribute?.isOwn ?? false,
            values: selectedValues,
          ),
        );

        debugPrint(
          'RESTORED (fallback): '
          '${productAttribute.name} '
          '(ID: $attributeId) '
          'values=${selectedValues.length}',
        );
      }
    }

    // ═══════════════════════════════════════════════════════════════════════════
    // APPLY
    // ═══════════════════════════════════════════════════════════════════════════

    if (!mounted) return;

    setState(() {
      _attributes = restoredAttributes;
    });

    debugPrint('');
    debugPrint('FINAL ATTRIBUTES RESTORED: ${_attributes.length}');
    for (final attribute in _attributes) {
      debugPrint(
        '  → ${attribute.name} (ID: ${attribute.id}) '
        'inputType=${attribute.inputType} '
        'values=${attribute.values.length}',
      );
    }
    debugPrint('==================================================');
    debugPrint('');
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // FORMAT NUMBER
  // ═══════════════════════════════════════════════════════════════════════════

  String _formatNumber(num? value) {
    if (value == null) {
      return '';
    }

    if (value % 1 == 0) {
      return value.toInt().toString();
    }

    return value.toString();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SET BRAND FROM PRODUCT NAME
  // ═══════════════════════════════════════════════════════════════════════════

  void _setBrandFromProductName(String? brandName) {
    final name = brandName?.trim();

    if (name == null || name.isEmpty) {
      return;
    }

    for (final brand in _brands) {
      final id = brand.id;

      final currentName = brand.name?.trim();

      if (id == null || currentName == null || currentName.isEmpty) {
        continue;
      }

      if (currentName.toLowerCase() == name.toLowerCase()) {
        _brandId = id.toString();

        return;
      }
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SLUG HELPER
  // ═══════════════════════════════════════════════════════════════════════════

  String _slugify(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PRODUCT OPTIONS
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _loadProductOptions() async {
    if (_isLoadingProductOptions) {
      return;
    }

    if (mounted) {
      setState(() {
        _isLoadingProductOptions = true;
      });
    }

    try {
      debugPrint('');
      debugPrint('========== EDIT PRODUCT ==========');
      debugPrint('GET PRODUCT OPTIONS STARTED');

      final result = await ref
          .read(productOptionControllerProvider)
          .getProductOptions();

      if (!mounted) {
        return;
      }

      setState(() {
        _categories = result.categories;
        _brands = result.brands;
        _isLoadingProductOptions = false;
      });

      if (_editProduct != null) {
        _setBrandFromProductName(_editProduct!.brand);
      }

      debugPrint(
        'GET PRODUCT OPTIONS SUCCESS: '
        '${result.success}',
      );

      debugPrint(
        'CATEGORIES COUNT: '
        '${result.categories.length}',
      );

      debugPrint(
        'BRANDS COUNT: '
        '${result.brands.length}',
      );

      debugPrint('==================================');
      debugPrint('');
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoadingProductOptions = false;

        _categories = <ProductOptionCategoryModel>[];

        _brands = <ProductOptionBrandModel>[];
      });

      _showNotice(error.message, isError: true);
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoadingProductOptions = false;

        _categories = <ProductOptionCategoryModel>[];

        _brands = <ProductOptionBrandModel>[];
      });

      debugPrint(
        'Get product options unexpected error: '
        '$error',
      );

      _showNotice(
        'Unable to load categories and brands. '
        'Please try again.',
        isError: true,
      );
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CATEGORY DROPDOWN
  // ═══════════════════════════════════════════════════════════════════════════

  List<ProductDropdownItem<String>> _buildCategoryDropdownItems() {
    final items = <ProductDropdownItem<String>>[];

    final childrenByParent = <int, List<ProductOptionCategoryModel>>{};

    final roots = <ProductOptionCategoryModel>[];

    final allIds = <int>{};

    for (final category in _categories) {
      final id = category.id;

      if (id != null) {
        allIds.add(id);
      }
    }

    for (final category in _categories) {
      final id = category.id;

      if (id == null) {
        continue;
      }

      final parentId = category.parentId;

      if (parentId != null && parentId != 0 && allIds.contains(parentId)) {
        childrenByParent
            .putIfAbsent(parentId, () => <ProductOptionCategoryModel>[])
            .add(category);
      } else {
        roots.add(category);
      }
    }

    final addedIds = <int>{};

    void addCategory(ProductOptionCategoryModel category, int level) {
      final id = category.id;

      if (id == null || addedIds.contains(id)) {
        return;
      }

      addedIds.add(id);

      final name = category.name?.trim();

      if (name != null && name.isNotEmpty) {
        final prefix = level == 0 ? '' : '  ' * level;

        items.add(
          ProductDropdownItem<String>(
            value: id.toString(),
            label: '$prefix$name',
          ),
        );
      }

      final children = childrenByParent[id];

      if (children == null || children.isEmpty) {
        return;
      }

      for (final child in children) {
        addCategory(child, level + 1);
      }
    }

    for (final root in roots) {
      addCategory(root, 0);
    }

    for (final category in _categories) {
      addCategory(category, 0);
    }

    return items;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BRAND DROPDOWN
  // ═══════════════════════════════════════════════════════════════════════════

  List<ProductDropdownItem<String>> _buildBrandDropdownItems() {
    final items = <ProductDropdownItem<String>>[];

    for (final brand in _brands) {
      final id = brand.id;

      if (id == null) {
        continue;
      }

      final name = brand.name?.trim();

      if (name == null || name.isEmpty) {
        continue;
      }

      items.add(ProductDropdownItem<String>(value: id.toString(), label: name));
    }

    return items;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ATTRIBUTES
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _loadAttributes() async {
    if (_isLoadingAttributes) {
      return;
    }

    if (mounted) {
      setState(() {
        _isLoadingAttributes = true;
      });
    }

    try {
      debugPrint('');
      debugPrint('============================================');
      debugPrint('EDIT PRODUCT - GET ATTRIBUTES');
      debugPrint('============================================');

      final result = await ref
          .read(getAttributesControllerProvider)
          .getAttributes();

      if (!mounted) {
        return;
      }

      setState(() {
        _availableAttributes = result.attributes;

        _isLoadingAttributes = false;
      });

      _restoreVariantAttributes();

      debugPrint(
        'GET ATTRIBUTES SUCCESS: '
        '${result.success}',
      );

      debugPrint(
        'AVAILABLE ATTRIBUTES: '
        '${result.attributes.length}',
      );

      debugPrint('============================================');
      debugPrint('');
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoadingAttributes = false;

        _availableAttributes = <GetAttributeModel>[];
      });

      _showNotice(error.message, isError: true);
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoadingAttributes = false;

        _availableAttributes = <GetAttributeModel>[];
      });

      debugPrint(
        'GET ATTRIBUTES UNEXPECTED ERROR: '
        '$error',
      );

      _showNotice(
        'Unable to load product attributes. '
        'Please try again.',
        isError: true,
      );
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // IMAGE PICKER
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _pickPrimaryImage() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (pickedFile == null || !mounted) {
        return;
      }

      setState(() {
        _primaryImage = File(pickedFile.path);
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showNotice('Unable to select primary image.', isError: true);
    }
  }

  void _removePrimaryImage() {
    setState(() {
      _primaryImage = null;
      _existingPrimaryImage = null;
    });
  }

  Future<void> _addGalleryImages() async {
    try {
      const int maxImages = 5;

      final int existingCount = _existingGalleryImages.length;

      final int remaining = maxImages - existingCount - _galleryImages.length;

      if (remaining <= 0) {
        _showNotice(
          'You can upload a maximum of '
          '$maxImages gallery images.',
        );

        return;
      }

      final List<XFile> pickedFiles = await _imagePicker.pickMultiImage(
        imageQuality: 85,
      );

      if (pickedFiles.isEmpty || !mounted) {
        return;
      }

      final files = pickedFiles
          .take(remaining)
          .map((file) => File(file.path))
          .toList();

      setState(() {
        _galleryImages.addAll(files);
      });

      if (pickedFiles.length > remaining) {
        _showNotice(
          'Only $remaining image(s) were added. '
          'Maximum is $maxImages.',
        );
      }
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showNotice('Unable to select gallery images.', isError: true);
    }
  }

  void _removeGalleryImage(int index) {
    if (index < 0 || index >= _galleryImages.length) {
      return;
    }

    setState(() {
      _galleryImages.removeAt(index);
    });
  }

  void _removeExistingGalleryImage(int index) {
    if (index < 0 || index >= _existingGalleryImages.length) {
      return;
    }

    setState(() {
      _existingGalleryImages.removeAt(index);
    });
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // AUTO TRANSLATE
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _autoTranslateArabic() async {
    final name = _productNameController.text.trim();

    final shortDescription = _shortDescriptionController.text.trim();

    final description = _fullDescriptionController.text.trim();

    final metaTitle = _metaTitleController.text.trim();

    final metaKeywords = _metaKeywordsController.text.trim();

    final metaDescription = _metaDescriptionController.text.trim();

    if (name.isEmpty) {
      _showNotice(
        'Please enter the product name before translating.',
        isError: true,
      );

      return;
    }

    if (shortDescription.isEmpty) {
      _showNotice(
        'Please enter the short description before translating.',
        isError: true,
      );

      return;
    }

    if (description.isEmpty) {
      _showNotice(
        'Please enter the full description before translating.',
        isError: true,
      );

      return;
    }

    setState(() {
      _isTranslating = true;
    });

    try {
      final result = await ref
          .read(productArabicTranslatorControllerProvider)
          .translateProduct(
            name: name,
            shortDescription: shortDescription,
            description: description,
            metaTitle: metaTitle,
            metaKeywords: metaKeywords,
            metaDescription: metaDescription,
            sourceLocale: 'en',
            targetLocale: 'ar',
          );

      if (!mounted) {
        return;
      }

      if (!result.success) {
        _showNotice(
          result.message ?? 'Unable to translate product to Arabic.',
          isError: true,
        );

        return;
      }

      final translation = result.translation;

      if (translation == null) {
        _showNotice('Translation response is empty.', isError: true);

        return;
      }

      final translated = translation.translated;

      if (translated == null) {
        _showNotice('Translated product data was not received.', isError: true);

        return;
      }

      if (translated.name != null && translated.name!.trim().isNotEmpty) {
        _arabicNameController.text = translated.name!.trim();
      }

      if (translated.shortDescription != null &&
          translated.shortDescription!.trim().isNotEmpty) {
        _arabicShortDescriptionController.text = translated.shortDescription!
            .trim();
      }

      if (translated.description != null &&
          translated.description!.trim().isNotEmpty) {
        _arabicFullDescriptionController.text = translated.description!.trim();
      }

      if (translated.metaTitle != null &&
          translated.metaTitle!.trim().isNotEmpty) {
        _arabicMetaTitleController.text = translated.metaTitle!.trim();
      }

      if (translated.metaKeywords != null &&
          translated.metaKeywords!.trim().isNotEmpty) {
        _arabicMetaKeywordsController.text = translated.metaKeywords!.trim();
      }

      if (translated.metaDescription != null &&
          translated.metaDescription!.trim().isNotEmpty) {
        _arabicMetaDescriptionController.text = translated.metaDescription!
            .trim();
      }

      _showNotice(result.message ?? 'Arabic translation completed.');
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      _showNotice(error.message, isError: true);
    } catch (error) {
      if (!mounted) {
        return;
      }

      debugPrint('Arabic translation error: $error');

      _showNotice(
        'Unable to translate product to Arabic. '
        'Please try again.',
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isTranslating = false;
        });
      }
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // VALIDATE CURRENT STEP
  // ═══════════════════════════════════════════════════════════════════════════

  bool _validateCurrentStep() {
    final form = _stepFormKeys[_currentStep].currentState;

    if (form == null) {
      return true;
    }

    return form.validate();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // NEXT STEP
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _nextStep() async {
    FocusScope.of(context).unfocus();

    final valid = _validateCurrentStep();

    if (!valid) {
      _showNotice(
        'Please complete the required fields before continuing.',
        isError: true,
      );

      return;
    }

    if (!mounted) {
      return;
    }

    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });

      _scrollToTop();
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PREVIOUS STEP
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _previousStep() async {
    FocusScope.of(context).unfocus();

    if (!mounted) {
      return;
    }

    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });

      _scrollToTop();
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // JUMP TO STEP
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _goToStep(int step) async {
    if (step < 0 || step >= _totalSteps) {
      return;
    }

    if (step > _currentStep) {
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _currentStep = step;
    });

    _scrollToTop();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SCROLL TOP
  // ═══════════════════════════════════════════════════════════════════════════

  void _scrollToTop() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 250),
        alignment: 0,
      );
    });
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BUILD UPDATE REQUEST
  // ═══════════════════════════════════════════════════════════════════════════

  UpdateProductRequestModel _buildUpdateRequest() {
    final name = _productNameController.text.trim();

    final shortDescription = _shortDescriptionController.text.trim();

    final description = _fullDescriptionController.text.trim();

    final sku = _skuController.text.trim();

    final price = num.tryParse(_priceController.text.trim());

    final priceOld = num.tryParse(_compareAtPriceController.text.trim());

    final stockQty = int.tryParse(_stockController.text.trim());

    final categoryId = int.tryParse(_categoryId?.trim() ?? '');

    final brandId = int.tryParse(_brandId?.trim() ?? '');

    // ═════════════════════════════════════════════════════════════════════════
    // PRODUCT ATTRIBUTES
    // ═════════════════════════════════════════════════════════════════════════

    final variantAttributeIds = <int>[];

    final attributeValues = <int, List<int>>{};

    for (final attribute in _attributes) {
      final attributeId = attribute.id;

      if (attributeId == null) {
        continue;
      }

      variantAttributeIds.add(attributeId);

      final valueIds = <int>[];

      for (final value in attribute.values) {
        final valueId = value.id;

        if (valueId != null) {
          valueIds.add(valueId);
        }
      }

      if (valueIds.isNotEmpty) {
        attributeValues[attributeId] = valueIds;
      }
    }

    // ═════════════════════════════════════════════════════════════════════════
    // VARIANT MATRIX
    // ═════════════════════════════════════════════════════════════════════════

    final updateVariants = <UpdateProductVariantRequestModel>[];

    if (_enableVariants) {
      for (final variant in _variants) {
        final variantSku = variant.sku.trim();

        final variantPrice = num.tryParse(variant.price.trim());

        final variantPriceOld = num.tryParse(variant.compareAtPrice.trim());

        final variantStockQty = int.tryParse(variant.stockQuantity.trim());

        updateVariants.add(
          UpdateProductVariantRequestModel(
            sku: variantSku.isEmpty ? null : variantSku,
            price: variantPrice,
            priceOld: variantPriceOld,
            stockQty: variantStockQty,

            // ═══════════════════════════════════════════════════════
            // Always 1
            //
            // - Existing variant → 1 (stays active)
            // - New variant added by user → 1 (created active)
            //
            // Never send 0.
            // ═══════════════════════════════════════════════════════
            isActive: 1,

            attributeValues: variant.attributeValueIds.isEmpty
                ? null
                : Map<int, int>.from(variant.attributeValueIds),
          ),
        );
      }
    }

    debugPrint('');
    debugPrint('==================================================');
    debugPrint('BUILD UPDATE PRODUCT REQUEST');
    debugPrint('==================================================');

    debugPrint('NAME: $name');

    debugPrint(
      'SHORT DESCRIPTION: '
      '${shortDescription.length} chars',
    );

    debugPrint(
      'DESCRIPTION: '
      '${description.length} chars',
    );

    debugPrint('PRICE: $price');

    debugPrint('PRICE OLD: $priceOld');

    debugPrint('STOCK QTY: $stockQty');

    debugPrint('CATEGORY ID: $categoryId');

    debugPrint('BRAND ID: $brandId');

    debugPrint('SKU: $sku');

    debugPrint('ALLOW AFFILIATE: $_allowAffiliates');

    debugPrint('HAS VARIANTS: $_enableVariants');

    debugPrint(
      'VARIANT ATTRIBUTES: '
      '$variantAttributeIds',
    );

    debugPrint(
      'ATTRIBUTE VALUES: '
      '$attributeValues',
    );

    debugPrint(
      'VARIANTS COUNT: '
      '${updateVariants.length}',
    );

    debugPrint(
      'NEW PRIMARY IMAGE: '
      '${_primaryImage?.path}',
    );

    debugPrint(
      'NEW GALLERY IMAGES: '
      '${_galleryImages.length}',
    );

    debugPrint(
      'PRODUCT IS ACTIVE: $_isActive '
      '(NOT SENT TO UPDATE API)',
    );

    debugPrint('==================================================');
    debugPrint('');

    return UpdateProductRequestModel(
      name: name.isEmpty ? null : name,

      shortDescription: shortDescription.isEmpty ? null : shortDescription,

      description: description.isEmpty ? null : description,

      sku: sku.isEmpty ? null : sku,

      heroImage: _primaryImage,

      galleryImages: _galleryImages.isEmpty
          ? null
          : List<File>.from(_galleryImages),

      price: price,

      priceOld: priceOld,

      stockQty: stockQty,

      categoryId: categoryId,

      brandId: brandId,

      // User-selected brand name is not required
      // when brand_id is available.
      brand: null,

      // Current Edit UI does not have a weight field.
      weight: null,

      allowAffiliate: _allowAffiliates,

      hasVariants: _enableVariants,

      variantAttributes: _enableVariants && variantAttributeIds.isNotEmpty
          ? variantAttributeIds
          : null,

      attributeValues: _enableVariants && attributeValues.isNotEmpty
          ? attributeValues
          : null,

      // Current Edit UI does not maintain
      // attribute value price modifiers.
      attributeValueModifiers: null,

      variants: _enableVariants && updateVariants.isNotEmpty
          ? updateVariants
          : null,

      // Product-level is_active is intentionally
      // NOT included in UpdateProductRequestModel.
      isFeatured: null,

      // ═══════════════════════════════════════════════════════════════════════
      // ARABIC
      // ═══════════════════════════════════════════════════════════════════════
      nameAr: _arabicNameController.text.trim().isEmpty
          ? null
          : _arabicNameController.text.trim(),

      shortDescriptionAr: _arabicShortDescriptionController.text.trim().isEmpty
          ? null
          : _arabicShortDescriptionController.text.trim(),

      descriptionAr: _arabicFullDescriptionController.text.trim().isEmpty
          ? null
          : _arabicFullDescriptionController.text.trim(),

      // ═══════════════════════════════════════════════════════════════════════
      // SEO
      // ═══════════════════════════════════════════════════════════════════════
      metaTitle: _metaTitleController.text.trim().isEmpty
          ? null
          : _metaTitleController.text.trim(),

      metaDescription: _metaDescriptionController.text.trim().isEmpty
          ? null
          : _metaDescriptionController.text.trim(),

      metaKeywords: _metaKeywordsController.text.trim().isEmpty
          ? null
          : _metaKeywordsController.text.trim(),

      metaTitleAr: _arabicMetaTitleController.text.trim().isEmpty
          ? null
          : _arabicMetaTitleController.text.trim(),

      metaDescriptionAr: _arabicMetaDescriptionController.text.trim().isEmpty
          ? null
          : _arabicMetaDescriptionController.text.trim(),

      metaKeywordsAr: _arabicMetaKeywordsController.text.trim().isEmpty
          ? null
          : _arabicMetaKeywordsController.text.trim(),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // UPDATE PRODUCT API
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _updateProduct() async {
    FocusScope.of(context).unfocus();

    _clearNotice();

    // Current step validation.
    final valid = _validateCurrentStep();

    if (!valid) {
      _showNotice('Please complete the required fields.', isError: true);

      return;
    }

    if (!mounted) {
      return;
    }

    final productId = widget.product.id;

    if (productId == null) {
      _showNotice('Product ID is missing.', isError: true);

      return;
    }

    // Prevent duplicate requests.
    if (_isSubmitting) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      debugPrint('');
      debugPrint('##################################################');
      debugPrint('# UPDATE PRODUCT API STARTED');
      debugPrint('# PRODUCT ID: $productId');
      debugPrint('##################################################');

      final request = _buildUpdateRequest();

      final result = await ref
          .read(updateProductControllerProvider)
          .updateProduct(productId: productId, request: request);

      if (!mounted) {
        return;
      }

      debugPrint('');
      debugPrint('##################################################');
      debugPrint('# UPDATE PRODUCT API SUCCESS');
      debugPrint('# SUCCESS: ${result.success}');
      debugPrint('# MESSAGE: ${result.message}');
      debugPrint('# PRODUCT: ${result.product?.name}');
      debugPrint('# PRODUCT ID: ${result.product?.id}');
      debugPrint('##################################################');
      debugPrint('');

      if (!result.success) {
        _showNotice(
          result.message ?? 'Product could not be updated.',
          isError: true,
        );

        return;
      }

      _showNotice(result.message ?? 'Product updated successfully.');

      // Small delay so user can see success message.
      await Future<void>.delayed(const Duration(milliseconds: 500));

      if (!mounted) {
        return;
      }

      context.push(AppRoutes.products);
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      debugPrint('');
      debugPrint('##################################################');
      debugPrint('# UPDATE PRODUCT API ERROR');
      debugPrint('# CODE: ${error.code}');
      debugPrint('# MESSAGE: ${error.message}');
      debugPrint('# ORIGINAL ERROR: ${error.originalError}');
      debugPrint('##################################################');
      debugPrint('');

      _showNotice(error.message, isError: true);
    } catch (error) {
      if (!mounted) {
        return;
      }

      debugPrint('');
      debugPrint('##################################################');
      debugPrint('# UPDATE PRODUCT UNEXPECTED ERROR');
      debugPrint('# ERROR: $error');
      debugPrint('##################################################');
      debugPrint('');

      _showNotice(
        'Unable to update product. '
        'Please try again.',
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CLOSE SCREEN
  // ═══════════════════════════════════════════════════════════════════════════

  void _closeScreen() {
    FocusScope.of(context).unfocus();

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // NOTICE
  // ═══════════════════════════════════════════════════════════════════════════

  void _showNotice(String message, {bool isError = false}) {
    if (!mounted) {
      return;
    }

    setState(() {
      _formNotice = message;
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: isError ? AppColors.error : AppColors.primary,
        ),
      );
  }

  void _clearNotice() {
    if (!mounted) {
      return;
    }

    setState(() {
      _formNotice = null;
    });
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CURRENT STEP
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return Form(
          key: _stepFormKeys[0],
          child: BasicInformationSection(
            productNameController: _productNameController,
            shortDescriptionController: _shortDescriptionController,
            fullDescriptionController: _fullDescriptionController,
            allowAffiliates: _allowAffiliates,
            onAllowAffiliatesChanged: (value) {
              setState(() {
                _allowAffiliates = value;
              });
            },
          ),
        );

      case 1:
        return Form(
          key: _stepFormKeys[1],
          child: ArabicTranslationSection(
            arabicNameController: _arabicNameController,
            arabicShortDescriptionController: _arabicShortDescriptionController,
            arabicFullDescriptionController: _arabicFullDescriptionController,
            arabicMetaTitleController: _arabicMetaTitleController,
            arabicMetaKeywordsController: _arabicMetaKeywordsController,
            arabicMetaDescriptionController: _arabicMetaDescriptionController,
            isTranslating: _isTranslating,
            onAutoTranslate: _autoTranslateArabic,
          ),
        );

      case 2:
        return Form(
          key: _stepFormKeys[2],
          child: CategoryBrandSection(
            categoryId: _categoryId,
            brandId: _brandId,
            categories: _buildCategoryDropdownItems(),
            brands: _buildBrandDropdownItems(),
            onCategoryChanged: (value) {
              setState(() {
                _categoryId = value;
              });
            },
            onBrandChanged: (value) {
              setState(() {
                _brandId = value;
              });
            },
            isLoadingCategories: _isLoadingProductOptions,
            isLoadingBrands: _isLoadingProductOptions,
          ),
        );

      case 3:
        return ProductImagesSection(
          primaryImage: _primaryImage,
          primaryImageUrl: _existingPrimaryImage,
          galleryImages: _galleryImages,
          galleryImageUrls: _existingGalleryImages,
          onPickPrimaryImage: _pickPrimaryImage,
          onRemovePrimaryImage: _removePrimaryImage,
          onAddGalleryImage: _addGalleryImages,
          onRemoveGalleryImage: _removeGalleryImage,
          onRemoveGalleryImageUrl: _removeExistingGalleryImage,
        );

      case 4:
        return Form(
          key: _stepFormKeys[4],
          child: PricingInventorySection(
            priceController: _priceController,
            compareAtPriceController: _compareAtPriceController,
            stockController: _stockController,
            skuController: _skuController,
            inventoryType: _inventoryType,
            onInventoryTypeChanged: (value) {
              if (value == null) {
                return;
              }

              setState(() {
                _inventoryType = value;
              });
            },
          ),
        );

      case 5:
        return VariantsSection(
          attributes: _attributes,
          variants: _variants,
          onAttributesChanged: (value) {
            setState(() {
              _attributes = List<GetAttributeModel>.from(value);
            });
          },
          onVariantsChanged: (value) {
            setState(() {
              _variants = List<VariantData>.from(value);
            });
          },
          enabledVariants: _enableVariants,
          onVariantsEnabledChanged: (value) {
            setState(() {
              _enableVariants = value;
            });
          },
          availableAttributes: _availableAttributes,
          defaultPrice: _priceController.text.trim(),
          defaultCompareAtPrice: _compareAtPriceController.text.trim(),
          defaultStockQuantity: _stockController.text.trim(),
          defaultSku: _skuController.text.trim(),
          enabled: true,
        );

      case 6:
        return Form(
          key: _stepFormKeys[6],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SeoSettingsSection(
                slugController: _slugController,
                metaTitleController: _metaTitleController,
                metaDescriptionController: _metaDescriptionController,
                metaKeywordsController: _metaKeywordsController,
              ),

              const SizedBox(height: 24),

              _buildFinalSummary(),

              const SizedBox(height: 24),

              ProductSubmitSection(
                isSubmitting: _isSubmitting,
                onSubmit: _updateProduct,
                onCancel: _closeScreen,
                submitLabel: 'Update Product',
                submittingLabel: 'Updating Product...',
              ),
            ],
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // FINAL SUMMARY
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildFinalSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.edit_note_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Ready to update product',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          _SummaryRow(
            label: 'Product',
            value: _productNameController.text.trim().isEmpty
                ? 'Not provided'
                : _productNameController.text.trim(),
          ),

          _SummaryRow(label: 'Category', value: _getSelectedCategoryName()),

          _SummaryRow(label: 'Brand', value: _getSelectedBrandName()),

          _SummaryRow(
            label: 'Price',
            value: _priceController.text.trim().isEmpty
                ? 'Not provided'
                : _priceController.text.trim(),
          ),

          _SummaryRow(
            label: 'Stock',
            value: _stockController.text.trim().isEmpty
                ? '0'
                : _stockController.text.trim(),
          ),

          _SummaryRow(
            label: 'Variants',
            value: _enableVariants
                ? '${_variants.length} variant(s)'
                : 'Disabled',
          ),

          _SummaryRow(
            label: 'Attributes',
            value: _attributes.isEmpty
                ? 'None'
                : '${_attributes.length} attribute(s)',
          ),

          _SummaryRow(
            label: 'Images',
            value:
                '${(_primaryImage != null ? 1 : 0) + _galleryImages.length + (_existingPrimaryImage != null ? 1 : 0) + _existingGalleryImages.length} image(s)',
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SELECTED CATEGORY NAME
  // ═══════════════════════════════════════════════════════════════════════════

  String _getSelectedCategoryName() {
    if (_categoryId == null || _categoryId!.trim().isEmpty) {
      return 'Not selected';
    }

    final selectedId = int.tryParse(_categoryId!);

    if (selectedId == null) {
      return 'Not selected';
    }

    for (final category in _categories) {
      if (category.id == selectedId) {
        final name = category.name?.trim();

        if (name != null && name.isNotEmpty) {
          return name;
        }
      }
    }

    if (_editProduct?.category?.id == selectedId) {
      return _editProduct?.category?.name ?? 'Not selected';
    }

    return 'Not selected';
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SELECTED BRAND NAME
  // ═══════════════════════════════════════════════════════════════════════════

  String _getSelectedBrandName() {
    if (_brandId == null || _brandId!.trim().isEmpty) {
      return _editProduct?.brand?.trim().isNotEmpty == true
          ? _editProduct!.brand!.trim()
          : 'Not selected';
    }

    final selectedId = int.tryParse(_brandId!);

    if (selectedId == null) {
      return 'Not selected';
    }

    for (final brand in _brands) {
      if (brand.id == selectedId) {
        final name = brand.name?.trim();

        if (name != null && name.isNotEmpty) {
          return name;
        }
      }
    }

    return _editProduct?.brand?.trim().isNotEmpty == true
        ? _editProduct!.brand!.trim()
        : 'Not selected';
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // STEP PROGRESS
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildStepProgress() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Step ${_currentStep + 1} of $_totalSteps',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Text(
                '${((_currentStep + 1) / _totalSteps * 100).round()}%',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: (_currentStep + 1) / _totalSteps,
              minHeight: 7,
              backgroundColor: AppColors.inputBackground,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),

          const SizedBox(height: 16),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_totalSteps, (index) {
                final isCurrent = index == _currentStep;

                final isCompleted = index < _currentStep;

                return Row(
                  children: [
                    InkWell(
                      onTap: index <= _currentStep
                          ? () => _goToStep(index)
                          : null,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isCurrent
                              ? AppColors.primary.withValues(alpha: 0.10)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: isCompleted || isCurrent
                                    ? AppColors.primary
                                    : AppColors.inputBackground,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: isCompleted
                                    ? const Icon(
                                        Icons.check_rounded,
                                        size: 17,
                                        color: Colors.white,
                                      )
                                    : Text(
                                        '${index + 1}',
                                        style: AppTextStyles.caption.copyWith(
                                          color: isCurrent
                                              ? Colors.white
                                              : AppColors.textMuted,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                              ),
                            ),

                            const SizedBox(width: 7),

                            Text(
                              _stepTitles[index],
                              style: AppTextStyles.caption.copyWith(
                                color: isCurrent
                                    ? AppColors.primary
                                    : AppColors.textMuted,
                                fontWeight: isCurrent
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    if (index < _totalSteps - 1)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          Icons.chevron_right_rounded,
                          size: 18,
                          color: AppColors.iconMuted,
                        ),
                      ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BOTTOM NAVIGATION
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildBottomNavigation() {
    final isFirst = _currentStep == 0;

    final isLast = _currentStep == _totalSteps - 1;

    if (isLast) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            if (!isFirst) ...[
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _isSubmitting ? null : _previousStep,
                  icon: const Icon(Icons.arrow_back_rounded, size: 19),
                  label: const Text('Back'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),
            ],

            Expanded(
              flex: isFirst ? 1 : 2,
              child: FilledButton.icon(
                onPressed: _isSubmitting ? null : _nextStep,
                icon: const Icon(Icons.arrow_forward_rounded, size: 19),
                label: const Text('Next'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DISPOSE
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  void dispose() {
    _productNameController.dispose();

    _shortDescriptionController.dispose();

    _fullDescriptionController.dispose();

    _arabicNameController.dispose();

    _arabicShortDescriptionController.dispose();

    _arabicFullDescriptionController.dispose();

    _arabicMetaTitleController.dispose();

    _arabicMetaKeywordsController.dispose();

    _arabicMetaDescriptionController.dispose();

    _priceController.dispose();

    _compareAtPriceController.dispose();

    _costPriceController.dispose();

    _stockController.dispose();

    _skuController.dispose();

    _slugController.dispose();

    _metaTitleController.dispose();

    _metaDescriptionController.dispose();

    _metaKeywordsController.dispose();

    super.dispose();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }

        _closeScreen();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            onPressed: _closeScreen,
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          title: Text('Edit Product', style: AppTextStyles.headlineMedium),
        ),
        body: _buildBody(),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BODY
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildBody() {
    if (_isLoadingProduct) {
      return _buildLoadingState();
    }

    if (_loadProductError != null) {
      return _buildErrorState();
    }

    return Column(
      children: [
        Expanded(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ProductFormHeader(
                        title: _stepTitles[_currentStep],
                        description: _stepDescriptions[_currentStep],
                      ),

                      const SizedBox(height: 20),

                      _buildStepProgress(),

                      const SizedBox(height: 20),

                      if (_formNotice != null) ...[
                        ProductFormNotice(
                          message: _formNotice!,
                          type: ProductFormNoticeType.info,
                          onClose: _clearNotice,
                        ),

                        const SizedBox(height: 20),
                      ],

                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 220),
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position:
                                  Tween<Offset>(
                                    begin: const Offset(0.03, 0),
                                    end: Offset.zero,
                                  ).animate(
                                    CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.easeOut,
                                    ),
                                  ),
                              child: child,
                            ),
                          );
                        },
                        child: KeyedSubtree(
                          key: ValueKey(_currentStep),
                          child: _buildCurrentStep(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        _buildBottomNavigation(),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // LOADING STATE
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildLoadingState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(18),
                  child: CircularProgressIndicator(strokeWidth: 3),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                'Loading Product',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Please wait while we load '
                'the product information.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ERROR STATE
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 450),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.10),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.error_outline_rounded,
                    color: AppColors.error,
                    size: 30,
                  ),
                ),

                const SizedBox(height: 18),

                Text(
                  'Unable to Load Product',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.headlineSmall.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  _loadProductError ?? 'Something went wrong.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () {
                      unawaited(_loadEditProduct());
                    },
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Try Again'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// SUMMARY ROW
// ═════════════════════════════════════════════════════════════════════════════

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;

  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 95,
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
