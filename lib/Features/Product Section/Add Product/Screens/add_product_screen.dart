import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../Routes/app_route.dart';
import '../../../../Services/api_exception.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../../../Attributes/Get Attributes/Controllers/get_attributes_controller.dart';
import '../../../Attributes/Get Attributes/Models/get_attributes_model.dart';

import '../../Arabic Translator/product_arabic_translation_controller.dart';

import '../Controller/add_product_controller.dart';
import '../Models/add_product_request_model.dart';
import '../Product Option/Controller/product_option_controller.dart';
import '../Product Option/Models/product_option_brand_model.dart';
import '../Product Option/Models/product_option_category_model.dart';

import '../Reuse Widgets/arabic_translation_section.dart';
import '../Reuse Widgets/basic_information_section.dart';
import '../Reuse Widgets/category_brand_section.dart';
import '../Reuse Widgets/pricing_inventory_section.dart';
import '../Reuse Widgets/product_dropdown_field.dart';
import '../Reuse Widgets/product_form_header.dart';
import '../Reuse Widgets/product_form_notice.dart';
import '../Reuse Widgets/product_images_section.dart';
import '../Reuse Widgets/product_submit_section.dart';
import '../Reuse Widgets/seo_settings_section.dart';
import '../Reuse Widgets/variants_section.dart';

class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({super.key});

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  static const String _draftKey = 'add_product_draft_v1';

  SharedPreferences? _prefs;
  bool _draftReady = false;
  Timer? _draftSaveTimer;

  bool _isLoadingProductOptions = false;
  List<ProductOptionCategoryModel> _categories = <ProductOptionCategoryModel>[];
  List<ProductOptionBrandModel> _brands = <ProductOptionBrandModel>[];

  bool _isLoadingAttributes = false;
  List<GetAttributeModel> _availableAttributes = <GetAttributeModel>[];

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
    'SEO and creation',
  ];

  final List<GlobalKey<FormState>> _stepFormKeys = List.generate(
    7,
    (_) => GlobalKey<FormState>(),
  );

  final _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();

  File? _primaryImage;
  final List<File> _galleryImages = <File>[];

  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _shortDescriptionController =
      TextEditingController();
  final TextEditingController _fullDescriptionController =
      TextEditingController();
  bool _allowAffiliates = false;

  final TextEditingController _arabicNameController = TextEditingController();
  final TextEditingController _arabicShortDescriptionController =
      TextEditingController();
  final TextEditingController _arabicFullDescriptionController =
      TextEditingController();
  final TextEditingController _arabicMetaTitleController =
      TextEditingController();
  final TextEditingController _arabicMetaKeywordsController =
      TextEditingController();
  final TextEditingController _arabicMetaDescriptionController =
      TextEditingController();
  bool _isTranslating = false;

  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _compareAtPriceController =
      TextEditingController();
  final TextEditingController _costPriceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _skuController = TextEditingController();
  String _inventoryType = 'track';

  String? _categoryId;
  String? _brandId;

  bool _enableVariants = false;
  List<GetAttributeModel> _attributes = <GetAttributeModel>[];
  List<dynamic> _variants = <dynamic>[];

  final TextEditingController _slugController = TextEditingController();
  final TextEditingController _metaTitleController = TextEditingController();
  final TextEditingController _metaDescriptionController =
      TextEditingController();
  final TextEditingController _metaKeywordsController = TextEditingController();

  bool _isActive = true;
  bool _isSubmitting = false;
  String? _formNotice;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _loadProductOptions();
    _loadAttributes();
    _restoreDraft();
  }

  void _loadInitialData() {
    _productNameController.clear();
    _shortDescriptionController.clear();
    _fullDescriptionController.clear();
    _allowAffiliates = false;

    _arabicNameController.clear();
    _arabicShortDescriptionController.clear();
    _arabicFullDescriptionController.clear();
    _arabicMetaTitleController.clear();
    _arabicMetaKeywordsController.clear();
    _arabicMetaDescriptionController.clear();

    _priceController.clear();
    _compareAtPriceController.clear();
    _costPriceController.clear();
    _stockController.clear();
    _skuController.clear();
    _inventoryType = 'track';

    _categoryId = null;
    _brandId = null;

    _enableVariants = false;
    _attributes = <GetAttributeModel>[];
    _variants = <dynamic>[];
    _availableAttributes = <GetAttributeModel>[];
    _categories = <ProductOptionCategoryModel>[];
    _brands = <ProductOptionBrandModel>[];

    _slugController.clear();
    _metaTitleController.clear();
    _metaDescriptionController.clear();
    _metaKeywordsController.clear();

    _isActive = true;
    _primaryImage = null;
    _galleryImages.clear();
  }

  Future<void> _loadProductOptions() async {
    if (_isLoadingProductOptions) return;
    if (mounted) setState(() => _isLoadingProductOptions = true);

    try {
      final result = await ref
          .read(productOptionControllerProvider)
          .getProductOptions();
      if (!mounted) return;
      setState(() {
        _categories = result.categories;
        _brands = result.brands;
        _isLoadingProductOptions = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isLoadingProductOptions = false;
        _categories = [];
        _brands = [];
      });
      _showNotice('Unable to load categories and brands.', isError: true);
    }
  }

  List<ProductDropdownItem<String>> _buildCategoryDropdownItems() {
    final items = <ProductDropdownItem<String>>[];
    final childrenByParent = <int, List<ProductOptionCategoryModel>>{};
    final roots = <ProductOptionCategoryModel>[];
    final allIds = <int>{};

    for (final category in _categories) {
      if (category.id != null) allIds.add(category.id!);
    }

    for (final category in _categories) {
      final id = category.id;
      if (id == null) continue;

      final parentId = category.parentId;
      if (parentId != null && parentId != 0 && allIds.contains(parentId)) {
        childrenByParent.putIfAbsent(parentId, () => []).add(category);
      } else {
        roots.add(category);
      }
    }

    final addedIds = <int>{};

    void addCategory(ProductOptionCategoryModel category, int level) {
      final id = category.id;
      if (id == null || addedIds.contains(id)) return;
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
      if (children == null || children.isEmpty) return;
      for (final child in children) {
        addCategory(child, level + 1);
      }
    }

    for (final root in roots) addCategory(root, 0);
    for (final category in _categories) addCategory(category, 0);

    return items;
  }

  List<ProductDropdownItem<String>> _buildBrandDropdownItems() {
    final items = <ProductDropdownItem<String>>[];
    for (final brand in _brands) {
      final id = brand.id;
      if (id == null) continue;
      final name = brand.name?.trim();
      if (name == null || name.isEmpty) continue;
      items.add(ProductDropdownItem<String>(value: id.toString(), label: name));
    }
    return items;
  }

  Future<void> _loadAttributes() async {
    if (_isLoadingAttributes) return;
    if (mounted) setState(() => _isLoadingAttributes = true);

    try {
      final result = await ref
          .read(getAttributesControllerProvider)
          .getAttributes();
      if (!mounted) return;
      setState(() {
        _availableAttributes = result.attributes;
        _isLoadingAttributes = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isLoadingAttributes = false;
        _availableAttributes = [];
      });
      _showNotice('Unable to load product attributes.', isError: true);
    }
  }

  Future<void> _restoreDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _prefs = prefs;
      final raw = prefs.getString(_draftKey);
      if (raw != null && raw.isNotEmpty) {
        final decoded = jsonDecode(raw);
        if (decoded is Map) {
          _restoreFromJson(Map<String, dynamic>.from(decoded));
        }
      }
      _draftReady = true;
      if (mounted) setState(() {});
    } catch (error) {
      _draftReady = true;
      if (mounted) setState(() {});
    }
  }

  void _restoreFromJson(Map<String, dynamic> data) {
    String readString(String key, String fallback) =>
        data[key]?.toString() ?? fallback;
    String? readNullableString(String key) {
      final text = data[key]?.toString();
      return (text == null || text.isEmpty) ? null : text;
    }

    _productNameController.text = readString('product_name', '');
    _shortDescriptionController.text = readString('short_description', '');
    _fullDescriptionController.text = readString('full_description', '');
    _allowAffiliates = data['allow_affiliates'] as bool? ?? false;

    _arabicNameController.text = readString('arabic_name', '');
    _arabicShortDescriptionController.text = readString(
      'arabic_short_description',
      '',
    );
    _arabicFullDescriptionController.text = readString(
      'arabic_full_description',
      '',
    );
    _arabicMetaTitleController.text = readString('arabic_meta_title', '');
    _arabicMetaKeywordsController.text = readString('arabic_meta_keywords', '');
    _arabicMetaDescriptionController.text = readString(
      'arabic_meta_description',
      '',
    );

    _priceController.text = readString('price', '');
    _compareAtPriceController.text = readString('compare_at_price', '');
    _costPriceController.text = readString('cost_price', '');
    _stockController.text = readString('stock', '');
    _skuController.text = readString('sku', '');
    _inventoryType = readString('inventory_type', 'track');

    _categoryId = readNullableString('category_id');
    _brandId = readNullableString('brand_id');
    _enableVariants = data['enable_variants'] as bool? ?? false;
    _isActive = data['is_active'] as bool? ?? true;

    _slugController.text = readString('slug', '');
    _metaTitleController.text = readString('meta_title', '');
    _metaDescriptionController.text = readString('meta_description', '');
    _metaKeywordsController.text = readString('meta_keywords', '');

    final savedStep = data['current_step'];
    if (savedStep is int) _currentStep = savedStep.clamp(0, _totalSteps - 1);

    final primaryPath = data['primary_image'];
    if (primaryPath is String &&
        primaryPath.isNotEmpty &&
        File(primaryPath).existsSync()) {
      _primaryImage = File(primaryPath);
    }

    final gallery = data['gallery_images'];
    if (gallery is List) {
      _galleryImages.clear();
      for (final item in gallery) {
        if (item is String && item.isNotEmpty && File(item).existsSync()) {
          _galleryImages.add(File(item));
        }
      }
    }
  }

  void _scheduleDraftSave() {
    if (!_draftReady) return;
    _draftSaveTimer?.cancel();
    _draftSaveTimer = Timer(const Duration(milliseconds: 400), () {
      unawaited(_saveDraft());
    });
  }

  Future<void> _saveDraft() async {
    try {
      final prefs = _prefs ?? await SharedPreferences.getInstance();
      _prefs = prefs;

      final data = <String, dynamic>{
        'current_step': _currentStep,
        'product_name': _productNameController.text,
        'short_description': _shortDescriptionController.text,
        'full_description': _fullDescriptionController.text,
        'allow_affiliates': _allowAffiliates,
        'arabic_name': _arabicNameController.text,
        'arabic_short_description': _arabicShortDescriptionController.text,
        'arabic_full_description': _arabicFullDescriptionController.text,
        'arabic_meta_title': _arabicMetaTitleController.text,
        'arabic_meta_keywords': _arabicMetaKeywordsController.text,
        'arabic_meta_description': _arabicMetaDescriptionController.text,
        'price': _priceController.text,
        'compare_at_price': _compareAtPriceController.text,
        'cost_price': _costPriceController.text,
        'stock': _stockController.text,
        'sku': _skuController.text,
        'inventory_type': _inventoryType,
        'category_id': _categoryId,
        'brand_id': _brandId,
        'primary_image': _primaryImage?.path,
        'gallery_images': _galleryImages.map((e) => e.path).toList(),
        'enable_variants': _enableVariants,
        'slug': _slugController.text,
        'meta_title': _metaTitleController.text,
        'meta_description': _metaDescriptionController.text,
        'meta_keywords': _metaKeywordsController.text,
        'is_active': _isActive,
      };

      await prefs.setString(_draftKey, jsonEncode(data));
    } catch (error) {
      debugPrint('Draft save error: $error');
    }
  }

  Future<void> _clearDraft() async {
    try {
      _draftSaveTimer?.cancel();
      final prefs = _prefs ?? await SharedPreferences.getInstance();
      _prefs = prefs;
      await prefs.remove(_draftKey);
    } catch (error) {
      debugPrint('Draft clear error: $error');
    }
  }

  Future<void> _clearAllProductData() async {
    _draftSaveTimer?.cancel();
    await _clearDraft();
    if (!mounted) return;

    setState(() {
      _loadInitialData();
      _currentStep = 0;
      _formNotice = null;
    });
  }

  Future<void> _pickPrimaryImage() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (pickedFile == null || !mounted) return;
      setState(() => _primaryImage = File(pickedFile.path));
      await _saveDraft();
    } catch (error) {
      if (mounted)
        _showNotice('Unable to select primary image.', isError: true);
    }
  }

  void _removePrimaryImage() {
    setState(() => _primaryImage = null);
    _scheduleDraftSave();
  }

  Future<void> _addGalleryImages() async {
    try {
      final int remaining = 5 - _galleryImages.length;
      if (remaining <= 0) {
        _showNotice('You can upload a maximum of 5 gallery images.');
        return;
      }

      final List<XFile> pickedFiles = await _imagePicker.pickMultiImage(
        imageQuality: 85,
      );
      if (pickedFiles.isEmpty || !mounted) return;

      final files = pickedFiles
          .take(remaining)
          .map((file) => File(file.path))
          .toList();
      setState(() => _galleryImages.addAll(files));
      await _saveDraft();
    } catch (error) {
      if (mounted)
        _showNotice('Unable to select gallery images.', isError: true);
    }
  }

  void _removeGalleryImage(int index) {
    if (index < 0 || index >= _galleryImages.length) return;
    setState(() => _galleryImages.removeAt(index));
    _scheduleDraftSave();
  }

  Future<void> _autoTranslateArabic() async {
    final name = _productNameController.text.trim();
    final shortDescription = _shortDescriptionController.text.trim();
    final description = _fullDescriptionController.text.trim();
    final metaTitle = _metaTitleController.text.trim();
    final metaKeywords = _metaKeywordsController.text.trim();
    final metaDescription = _metaDescriptionController.text.trim();

    if (name.isEmpty || shortDescription.isEmpty || description.isEmpty) {
      _showNotice(
        'Please fill English Name, Short and Full description first.',
        isError: true,
      );
      return;
    }

    setState(() => _isTranslating = true);

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

      if (!mounted) return;

      if (result.success && result.translation?.translated != null) {
        final t = result.translation!.translated!;
        if (t.name != null) _arabicNameController.text = t.name!.trim();
        if (t.shortDescription != null)
          _arabicShortDescriptionController.text = t.shortDescription!.trim();
        if (t.description != null)
          _arabicFullDescriptionController.text = t.description!.trim();
        if (t.metaTitle != null)
          _arabicMetaTitleController.text = t.metaTitle!.trim();
        if (t.metaKeywords != null)
          _arabicMetaKeywordsController.text = t.metaKeywords!.trim();
        if (t.metaDescription != null)
          _arabicMetaDescriptionController.text = t.metaDescription!.trim();
        await _saveDraft();
        _showNotice('Arabic translation completed.');
      } else {
        _showNotice(result.message ?? 'Translation failed.', isError: true);
      }
    } catch (e) {
      if (mounted) _showNotice('Translation error occurred.', isError: true);
    } finally {
      if (mounted) setState(() => _isTranslating = false);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ✅ FIXED SERIALIZE METHODS (Isme changes kiye gaye hain)
  // ═══════════════════════════════════════════════════════════════════════════

  List<int> _buildVariantAttributesPayload() {
    final result = <int>[];
    for (final attribute in _attributes) {
      final attributeId = attribute.id;
      if (attributeId == null || attributeId <= 0) continue;

      // Check if at least one value is selected
      bool hasSelectedValue = attribute.values.any(
        (v) => v.id != null && v.id! > 0,
      );
      if (hasSelectedValue && !result.contains(attributeId)) {
        result.add(attributeId);
      }
    }
    return result;
  }

  Map<int, List<int>> _buildAttributeValuesPayload() {
    final result = <int, List<int>>{};
    for (final attribute in _attributes) {
      final attributeId = attribute.id;
      if (attributeId == null || attributeId <= 0) continue;

      final values = <int>[];
      for (final value in attribute.values) {
        if (value.id != null && value.id! > 0 && !values.contains(value.id)) {
          values.add(value.id!);
        }
      }
      if (values.isNotEmpty) result[attributeId] = values;
    }
    return result;
  }

  Map<int, num> _buildAttributeValueModifiersPayload() {
    return <int, num>{};
  }

  // 🚨 Yahan actual fix hai!
  List<AddProductVariantRequestModel> _buildVariantsPayload() {
    final result = <AddProductVariantRequestModel>[];

    for (final variant in _variants) {
      try {
        final variantAttributeValues = <int, int>{};

        final dynamic attributes = variant.attributes;

        if (attributes is Map) {
          attributes.forEach((key, value) {
            // key = Attribute Name (e.g., "Color") OR ID if already int
            // value = Value Name (e.g., "Black") OR ID if already int

            // 1. Find Attribute ID
            int? attributeId;
            if (key is int) {
              attributeId = key;
            } else {
              final attrName = key.toString();
              final matchedAttr = _availableAttributes.firstWhere(
                (a) =>
                    (a.name ?? '').trim().toLowerCase() ==
                    attrName.trim().toLowerCase(),
                orElse: () =>
                    GetAttributeModel(id: null, name: null, values: []),
              );
              attributeId = matchedAttr.id;
            }

            if (attributeId == null || attributeId <= 0) return;

            // 2. Find Value ID
            int? valueId;
            if (value is int) {
              valueId = value;
            } else {
              final valName = value.toString();
              final matchedAttr = _availableAttributes.firstWhere(
                (a) => a.id == attributeId,
                orElse: () =>
                    GetAttributeModel(id: null, name: null, values: []),
              );

              final matchedValue = matchedAttr.values.firstWhere(
                (v) =>
                    (v.value ?? '').trim().toLowerCase() ==
                    valName.trim().toLowerCase(),
                orElse: () => GetAttributeValueModel(id: null, value: null),
              );
              valueId = matchedValue.id;
            }

            if (valueId != null && valueId > 0) {
              variantAttributeValues[attributeId] = valueId;
            }
          });
        }

        // Prices & Stock
        final numericPrice = num.tryParse(variant.price?.toString() ?? '') ?? 0;
        final numericCompareAtPrice = num.tryParse(
          variant.compareAtPrice?.toString() ?? '',
        );
        final numericStockQty =
            int.tryParse(variant.stockQuantity?.toString() ?? '') ?? 0;
        final skuText = variant.sku?.toString().trim();
        final nullableSku = (skuText == null || skuText.isEmpty)
            ? null
            : skuText;

        // Request Model
        final requestVariant = AddProductVariantRequestModel(
          sku: nullableSku,
          price: numericPrice,
          priceOld: numericCompareAtPrice,
          stockQty: numericStockQty,
          attributeValues: variantAttributeValues,
          isActive: 1,
        );

        result.add(requestVariant);

        debugPrint(
          'VARIANT SERIALIZED: SKU=$nullableSku | ATTRS=$variantAttributeValues',
        );
      } catch (error) {
        debugPrint('Variant serialization error: $error');
      }
    }

    return result;
  }

  Future<void> _submitProduct() async {
    FocusScope.of(context).unfocus();
    _clearNotice();

    if (!_validateCurrentStep()) {
      _showNotice('Please complete the required fields.', isError: true);
      return;
    }

    final productName = _productNameController.text.trim();
    if (productName.isEmpty) {
      _showNotice('Product name is required.', isError: true);
      return;
    }

    final categoryIdText = _categoryId?.trim();
    final categoryId = int.tryParse(categoryIdText ?? '');
    if (categoryId == null || categoryId <= 0) {
      _showNotice('Please select a valid category.', isError: true);
      return;
    }

    final price = double.tryParse(
      _priceController.text.trim().replaceAll(',', ''),
    );
    if (price == null || price < 0) {
      _showNotice('Please enter a valid product price.', isError: true);
      return;
    }

    if (_primaryImage == null) {
      _showNotice('Please select a primary product image.', isError: true);
      return;
    }

    final stockQty = int.tryParse(
      _stockController.text.trim().isEmpty ? '0' : _stockController.text.trim(),
    );
    if (stockQty == null || stockQty < 0) {
      _showNotice('Please enter a valid stock quantity.', isError: true);
      return;
    }

    await _saveDraft();
    if (!mounted) return;
    setState(() => _isSubmitting = true);

    try {
      final variantAttributes = _buildVariantAttributesPayload();
      final attributeValues = _buildAttributeValuesPayload();
      final attributeValueModifiers = _buildAttributeValueModifiersPayload();
      final variants = _buildVariantsPayload();

      final request = AddProductRequestModel(
        name: productName,
        heroImage: _primaryImage!,
        galleryImages: List<File>.from(_galleryImages),
        categoryId: categoryId,
        price: price,
        priceOld: _parseOptionalDouble(_compareAtPriceController.text),
        stockQty: stockQty,
        sku: _nullableText(_skuController.text),
        brandId: _parseOptionalInt(_brandId),
        brand: null,
        description: _nullableText(_fullDescriptionController.text),
        shortDescription: _nullableText(_shortDescriptionController.text),
        allowAffiliate: _allowAffiliates ? 1 : 0,
        hasVariants: _enableVariants,
        variantAttributes: variantAttributes,
        attributeValues: attributeValues,
        attributeValueModifiers: attributeValueModifiers,
        variants: variants,
        isActive: _isActive ? 1 : 0,
        nameAr: _nullableText(_arabicNameController.text),
        shortDescriptionAr: _nullableText(
          _arabicShortDescriptionController.text,
        ),
        descriptionAr: _nullableText(_arabicFullDescriptionController.text),
        metaTitle: _nullableText(_metaTitleController.text),
        metaDescription: _nullableText(_metaDescriptionController.text),
        metaKeywords: _nullableText(_metaKeywordsController.text),
        metaTitleAr: _nullableText(_arabicMetaTitleController.text),
        metaDescriptionAr: _nullableText(_arabicMetaDescriptionController.text),
        metaKeywordsAr: _nullableText(_arabicMetaKeywordsController.text),
      );

      final result = await ref
          .read(addProductControllerProvider)
          .addProduct(request);

      if (!mounted) return;

      if (!result.success) {
        _showNotice(
          result.message ?? 'Unable to create product.',
          isError: true,
        );
        return;
      }

      await _clearAllProductData();
      if (!mounted) return;

      _showNotice(result.message ?? 'Product created successfully.');
      await Future<void>.delayed(const Duration(milliseconds: 600));

      if (!mounted) return;
      context.push(AppRoutes.products);
    } on ApiException catch (error) {
      if (mounted) _showNotice(error.message, isError: true);
    } catch (error) {
      if (mounted) _showNotice('Unable to create product.', isError: true);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  String? _nullableText(String value) =>
      value.trim().isEmpty ? null : value.trim();
  int? _parseOptionalInt(String? value) =>
      (value == null || value.trim().isEmpty) ? null : int.tryParse(value);
  double? _parseOptionalDouble(String value) =>
      value.trim().isEmpty ? null : double.tryParse(value.replaceAll(',', ''));

  bool _validateCurrentStep() {
    final form = _stepFormKeys[_currentStep].currentState;
    return form?.validate() ?? true;
  }

  Future<void> _nextStep() async {
    FocusScope.of(context).unfocus();
    if (!_validateCurrentStep()) {
      _showNotice(
        'Please complete the required fields before continuing.',
        isError: true,
      );
      return;
    }
    await _saveDraft();
    if (!mounted) return;
    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
      await _saveDraft();
      _scrollToTop();
    }
  }

  Future<void> _previousStep() async {
    FocusScope.of(context).unfocus();
    await _saveDraft();
    if (!mounted) return;
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      await _saveDraft();
      _scrollToTop();
    }
  }

  Future<void> _goToStep(int step) async {
    if (step < 0 || step >= _totalSteps || step > _currentStep) return;
    await _saveDraft();
    if (!mounted) return;
    setState(() => _currentStep = step);
    _scrollToTop();
  }

  void _scrollToTop() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted)
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 250),
          alignment: 0,
        );
    });
  }

  Future<void> _closeScreen() async {
    FocusScope.of(context).unfocus();
    await _saveDraft();
    if (mounted) Navigator.of(context).pop();
  }

  void _showNotice(String message, {bool isError = false}) {
    if (!mounted) return;
    setState(() => _formNotice = message);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? AppColors.error : AppColors.primary,
      ),
    );
  }

  void _clearNotice() {
    if (mounted) setState(() => _formNotice = null);
  }

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
            onAllowAffiliatesChanged: (v) {
              setState(() => _allowAffiliates = v);
              _scheduleDraftSave();
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
            onCategoryChanged: (v) {
              setState(() => _categoryId = v);
              _scheduleDraftSave();
            },
            onBrandChanged: (v) {
              setState(() => _brandId = v);
              _scheduleDraftSave();
            },
            isLoadingCategories: _isLoadingProductOptions,
            isLoadingBrands: _isLoadingProductOptions,
          ),
        );
      case 3:
        return ProductImagesSection(
          primaryImage: _primaryImage,
          galleryImages: _galleryImages,
          onPickPrimaryImage: _pickPrimaryImage,
          onRemovePrimaryImage: _removePrimaryImage,
          onAddGalleryImage: _addGalleryImages,
          onRemoveGalleryImage: _removeGalleryImage,
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
            onInventoryTypeChanged: (v) {
              if (v != null) {
                setState(() => _inventoryType = v);
                _scheduleDraftSave();
              }
            },
          ),
        );
      case 5:
        return VariantsSection(
          attributes: _attributes,
          onAttributesChanged: (v) {
            setState(
              () => _attributes = v.whereType<GetAttributeModel>().toList(),
            );
            _scheduleDraftSave();
          },
          onVariantsChanged: (v) {
            setState(() => _variants = List<dynamic>.from(v));
            _scheduleDraftSave();
          },
          enabledVariants: _enableVariants,
          onVariantsEnabledChanged: (v) {
            setState(() => _enableVariants = v);
            _scheduleDraftSave();
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
                onSubmit: _submitProduct,
                onCancel: _closeScreen,
                submitLabel: 'Create Product',
                submittingLabel: 'Creating Product...',
              ),
            ],
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

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
                  Icons.checklist_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Ready to create product',
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
                '${(_primaryImage != null ? 1 : 0) + _galleryImages.length} image(s)',
          ),
        ],
      ),
    );
  }

  String _getSelectedCategoryName() {
    if (_categoryId == null || _categoryId!.trim().isEmpty)
      return 'Not selected';
    final selectedId = int.tryParse(_categoryId!);
    if (selectedId == null) return 'Not selected';
    for (final category in _categories) {
      if (category.id == selectedId)
        return category.name?.trim() ?? 'Not selected';
    }
    return 'Not selected';
  }

  String _getSelectedBrandName() {
    if (_brandId == null || _brandId!.trim().isEmpty) return 'Not selected';
    final selectedId = int.tryParse(_brandId!);
    if (selectedId == null) return 'Not selected';
    for (final brand in _brands) {
      if (brand.id == selectedId) return brand.name?.trim() ?? 'Not selected';
    }
    return 'Not selected';
  }

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

  Widget _buildBottomNavigation() {
    final isFirst = _currentStep == 0;
    final isLast = _currentStep == _totalSteps - 1;
    if (isLast) return const SizedBox.shrink();

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

  @override
  void dispose() {
    _draftSaveTimer?.cancel();
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

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _closeScreen();
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
          title: Text('Add Product', style: AppTextStyles.headlineMedium),
        ),
        body: !_draftReady
            ? const Center(child: CircularProgressIndicator())
            : Column(
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
                                  transitionBuilder: (child, animation) =>
                                      FadeTransition(
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
                                      ),
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
              ),
      ),
    );
  }
}

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
