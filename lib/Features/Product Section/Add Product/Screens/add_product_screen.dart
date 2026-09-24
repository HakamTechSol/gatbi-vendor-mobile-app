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
  // ═══════════════════════════════════════════════════════════════════════════
  // DRAFT STORAGE
  // ═══════════════════════════════════════════════════════════════════════════

  static const String _draftKey = 'add_product_draft_v1';

  SharedPreferences? _prefs;

  bool _draftReady = false;

  Timer? _draftSaveTimer;

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
    'SEO and creation',
  ];

  final List<GlobalKey<FormState>> _stepFormKeys = List.generate(
    7,
    (_) => GlobalKey<FormState>(),
  );

  final _formKey = GlobalKey<FormState>();

  // ═══════════════════════════════════════════════════════════════════════════
  // IMAGE PICKER
  // ═══════════════════════════════════════════════════════════════════════════

  final ImagePicker _imagePicker = ImagePicker();

  File? _primaryImage;

  final List<File> _galleryImages = <File>[];

  // ═══════════════════════════════════════════════════════════════════════════
  // BASIC INFORMATION
  // ═══════════════════════════════════════════════════════════════════════════

  final TextEditingController _productNameController = TextEditingController();

  final TextEditingController _shortDescriptionController =
      TextEditingController();

  final TextEditingController _fullDescriptionController =
      TextEditingController();

  bool _allowAffiliates = false;

  // ═══════════════════════════════════════════════════════════════════════════
  // ARABIC
  // ═══════════════════════════════════════════════════════════════════════════

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

  // ═══════════════════════════════════════════════════════════════════════════
  // PRICING & INVENTORY
  // ═══════════════════════════════════════════════════════════════════════════

  final TextEditingController _priceController = TextEditingController();

  final TextEditingController _compareAtPriceController =
      TextEditingController();

  final TextEditingController _costPriceController = TextEditingController();

  final TextEditingController _stockController = TextEditingController();

  final TextEditingController _skuController = TextEditingController();

  String _inventoryType = 'track';

  // ═══════════════════════════════════════════════════════════════════════════
  // CATEGORY & BRAND
  // ═══════════════════════════════════════════════════════════════════════════

  String? _categoryId;

  String? _brandId;

  // ═══════════════════════════════════════════════════════════════════════════
  // VARIANTS
  // ═══════════════════════════════════════════════════════════════════════════

  bool _enableVariants = false;

  List<GetAttributeModel> _attributes = <GetAttributeModel>[];

  List<dynamic> _variants = <dynamic>[];

  // ═══════════════════════════════════════════════════════════════════════════
  // SEO
  // ═══════════════════════════════════════════════════════════════════════════

  final TextEditingController _slugController = TextEditingController();

  final TextEditingController _metaTitleController = TextEditingController();

  final TextEditingController _metaDescriptionController =
      TextEditingController();

  final TextEditingController _metaKeywordsController = TextEditingController();

  // ═══════════════════════════════════════════════════════════════════════════
  // STATUS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Product active state.
  ///
  /// Default is true.
  /// API payload will send:
  /// true  -> is_active = 1
  /// false -> is_active = 0
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

    _loadInitialData();

    _loadProductOptions();

    _loadAttributes();

    _restoreDraft();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // INITIAL DATA
  // ═══════════════════════════════════════════════════════════════════════════

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

    // New product default = active.
    _isActive = true;

    _primaryImage = null;
    _galleryImages.clear();
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
      debugPrint('========== ADD PRODUCT ==========');
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

      debugPrint('GET PRODUCT OPTIONS SUCCESS: ${result.success}');
      debugPrint('CATEGORIES COUNT: ${result.categories.length}');

      for (final category in result.categories) {
        debugPrint(
          'CATEGORY: ${category.name} | '
          'ID: ${category.id} | '
          'PARENT ID: ${category.parentId}',
        );
      }

      debugPrint('BRANDS COUNT: ${result.brands.length}');

      for (final brand in result.brands) {
        debugPrint(
          'BRAND: ${brand.name} | '
          'ID: ${brand.id}',
        );
      }

      debugPrint('================================');
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

      debugPrint('Get product options API error: ${error.message}');

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

      debugPrint('Get product options unexpected error: $error');

      _showNotice(
        'Unable to load categories and brands. Please try again.',
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
        childrenByParent.putIfAbsent(
          parentId,
          () => <ProductOptionCategoryModel>[],
        );

        childrenByParent[parentId]!.add(category);
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

    // Fallback for orphaned categories.
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
      debugPrint('========== ADD PRODUCT ==========');
      debugPrint('GET ATTRIBUTES STARTED');

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

      debugPrint('GET ATTRIBUTES SUCCESS: ${result.success}');

      debugPrint('ATTRIBUTES COUNT: ${result.attributes.length}');

      for (final attribute in result.attributes) {
        debugPrint('');
        debugPrint('ATTRIBUTE ID: ${attribute.id}');
        debugPrint('ATTRIBUTE NAME: ${attribute.name}');
        debugPrint('ATTRIBUTE SLUG: ${attribute.slug}');
        debugPrint('ATTRIBUTE INPUT TYPE: ${attribute.inputType}');
        debugPrint('ATTRIBUTE IS OWN: ${attribute.isOwn}');
        debugPrint('ATTRIBUTE VALUES: ${attribute.values.length}');

        for (final value in attribute.values) {
          debugPrint(
            '  VALUE ID: ${value.id} | '
            'VALUE: ${value.value} | '
            'CODE: ${value.code} | '
            'SORT: ${value.sortOrder}',
          );
        }
      }

      debugPrint('');
      debugPrint('================================');
      debugPrint('');
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoadingAttributes = false;
        _availableAttributes = <GetAttributeModel>[];
      });

      debugPrint('Get attributes API error: ${error.message}');

      _showNotice(error.message, isError: true);
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoadingAttributes = false;
        _availableAttributes = <GetAttributeModel>[];
      });

      debugPrint('Get attributes unexpected error: $error');

      _showNotice(
        'Unable to load product attributes. Please try again.',
        isError: true,
      );
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // RESTORE DRAFT
  // ═══════════════════════════════════════════════════════════════════════════

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

      if (mounted) {
        setState(() {});
      }
    } catch (error) {
      debugPrint('Draft restore error: $error');

      _draftReady = true;

      if (mounted) {
        setState(() {});
      }
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // RESTORE JSON
  // ═══════════════════════════════════════════════════════════════════════════

  void _restoreFromJson(Map<String, dynamic> data) {
    String readString(String key, String fallback) {
      final value = data[key];

      if (value == null) {
        return fallback;
      }

      return value.toString();
    }

    String? readNullableString(String key) {
      final value = data[key];

      if (value == null) {
        return null;
      }

      final text = value.toString();

      return text.isEmpty ? null : text;
    }

    _productNameController.text = readString(
      'product_name',
      _productNameController.text,
    );

    _shortDescriptionController.text = readString(
      'short_description',
      _shortDescriptionController.text,
    );

    _fullDescriptionController.text = readString(
      'full_description',
      _fullDescriptionController.text,
    );

    _allowAffiliates = data['allow_affiliates'] as bool? ?? _allowAffiliates;

    _arabicNameController.text = readString(
      'arabic_name',
      _arabicNameController.text,
    );

    _arabicShortDescriptionController.text = readString(
      'arabic_short_description',
      _arabicShortDescriptionController.text,
    );

    _arabicFullDescriptionController.text = readString(
      'arabic_full_description',
      _arabicFullDescriptionController.text,
    );

    _arabicMetaTitleController.text = readString(
      'arabic_meta_title',
      _arabicMetaTitleController.text,
    );

    _arabicMetaKeywordsController.text = readString(
      'arabic_meta_keywords',
      _arabicMetaKeywordsController.text,
    );

    _arabicMetaDescriptionController.text = readString(
      'arabic_meta_description',
      _arabicMetaDescriptionController.text,
    );

    _priceController.text = readString('price', _priceController.text);

    _compareAtPriceController.text = readString(
      'compare_at_price',
      _compareAtPriceController.text,
    );

    _costPriceController.text = readString(
      'cost_price',
      _costPriceController.text,
    );

    _stockController.text = readString('stock', _stockController.text);

    _skuController.text = readString('sku', _skuController.text);

    _inventoryType = readString('inventory_type', _inventoryType);

    _categoryId = readNullableString('category_id');

    _brandId = readNullableString('brand_id');

    _enableVariants = data['enable_variants'] as bool? ?? false;

    _isActive = data['is_active'] as bool? ?? true;

    _slugController.text = readString('slug', _slugController.text);

    _metaTitleController.text = readString(
      'meta_title',
      _metaTitleController.text,
    );

    _metaDescriptionController.text = readString(
      'meta_description',
      _metaDescriptionController.text,
    );

    _metaKeywordsController.text = readString(
      'meta_keywords',
      _metaKeywordsController.text,
    );

    // ============================================================
    // CURRENT STEP
    // ============================================================

    final savedStep = data['current_step'];

    if (savedStep is int) {
      _currentStep = savedStep.clamp(0, _totalSteps - 1);
    }

    // ============================================================
    // PRIMARY IMAGE
    // ============================================================

    final primaryPath = data['primary_image'];

    if (primaryPath is String &&
        primaryPath.isNotEmpty &&
        File(primaryPath).existsSync()) {
      _primaryImage = File(primaryPath);
    }

    // ============================================================
    // GALLERY
    // ============================================================

    final gallery = data['gallery_images'];

    if (gallery is List) {
      _galleryImages.clear();

      for (final item in gallery) {
        if (item is String && item.isNotEmpty && File(item).existsSync()) {
          _galleryImages.add(File(item));
        }
      }
    }

    // ============================================================
    // ATTRIBUTES
    // ============================================================
    //
    // Runtime model instances cannot be restored directly from JSON.
    // Keep this intentionally unchanged.
    // ============================================================

    final attributes = data['attributes'];

    if (attributes is List) {
      _attributes = attributes.whereType<GetAttributeModel>().toList(
        growable: false,
      );
    }

    // ============================================================
    // VARIANTS
    // ============================================================

    final variants = data['variants'];

    if (variants is List) {
      _variants = List<dynamic>.from(variants);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DRAFT SAVE
  // ═══════════════════════════════════════════════════════════════════════════

  void _scheduleDraftSave() {
    if (!_draftReady) {
      return;
    }

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

        // ========================================================
        // BASIC
        // ========================================================
        'product_name': _productNameController.text,
        'short_description': _shortDescriptionController.text,
        'full_description': _fullDescriptionController.text,
        'allow_affiliates': _allowAffiliates,

        // ========================================================
        // ARABIC
        // ========================================================
        'arabic_name': _arabicNameController.text,
        'arabic_short_description': _arabicShortDescriptionController.text,
        'arabic_full_description': _arabicFullDescriptionController.text,
        'arabic_meta_title': _arabicMetaTitleController.text,
        'arabic_meta_keywords': _arabicMetaKeywordsController.text,
        'arabic_meta_description': _arabicMetaDescriptionController.text,

        // ========================================================
        // PRICING
        // ========================================================
        'price': _priceController.text,
        'compare_at_price': _compareAtPriceController.text,
        'cost_price': _costPriceController.text,
        'stock': _stockController.text,
        'sku': _skuController.text,
        'inventory_type': _inventoryType,

        // ========================================================
        // CATEGORY / BRAND
        // ========================================================
        'category_id': _categoryId,
        'brand_id': _brandId,

        // ========================================================
        // IMAGES
        // ========================================================
        'primary_image': _primaryImage?.path,

        'gallery_images': _galleryImages.map((e) => e.path).toList(),

        // ========================================================
        // VARIANTS
        // ========================================================
        'enable_variants': _enableVariants,

        // Runtime variant objects are intentionally not persisted.
        // They remain available during the current session.

        // ========================================================
        // SEO
        // ========================================================
        'slug': _slugController.text,
        'meta_title': _metaTitleController.text,
        'meta_description': _metaDescriptionController.text,
        'meta_keywords': _metaKeywordsController.text,

        // ========================================================
        // STATUS
        // ========================================================
        'is_active': _isActive,
      };

      await prefs.setString(_draftKey, jsonEncode(data));
    } catch (error) {
      debugPrint('Draft save error: $error');
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CLEAR DRAFT
  // ═══════════════════════════════════════════════════════════════════════════

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

  // ═══════════════════════════════════════════════════════════════════════════
  // CLEAR FORM AFTER SUCCESS
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _clearAllProductData() async {
    _draftSaveTimer?.cancel();

    await _clearDraft();

    if (!mounted) {
      return;
    }

    setState(() {
      // ============================================================
      // BASIC
      // ============================================================

      _productNameController.clear();
      _shortDescriptionController.clear();
      _fullDescriptionController.clear();

      _allowAffiliates = false;

      // ============================================================
      // ARABIC
      // ============================================================

      _arabicNameController.clear();
      _arabicShortDescriptionController.clear();
      _arabicFullDescriptionController.clear();
      _arabicMetaTitleController.clear();
      _arabicMetaKeywordsController.clear();
      _arabicMetaDescriptionController.clear();

      // ============================================================
      // PRICING
      // ============================================================

      _priceController.clear();
      _compareAtPriceController.clear();
      _costPriceController.clear();
      _stockController.clear();
      _skuController.clear();

      _inventoryType = 'track';

      // ============================================================
      // CATEGORY / BRAND
      // ============================================================

      _categoryId = null;
      _brandId = null;

      // ============================================================
      // IMAGES
      // ============================================================

      _primaryImage = null;
      _galleryImages.clear();

      // ============================================================
      // VARIANTS
      // ============================================================

      _enableVariants = false;
      _attributes = <GetAttributeModel>[];
      _variants = <dynamic>[];

      // ============================================================
      // SEO
      // ============================================================

      _slugController.clear();
      _metaTitleController.clear();
      _metaDescriptionController.clear();
      _metaKeywordsController.clear();

      // ============================================================
      // STATUS
      // ============================================================

      _isActive = true;

      // ============================================================
      // WIZARD
      // ============================================================

      _currentStep = 0;

      _formNotice = null;
    });

    debugPrint('ADD PRODUCT FORM CLEARED AFTER SUCCESS');
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

      await _saveDraft();
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
    });

    _scheduleDraftSave();
  }

  Future<void> _addGalleryImages() async {
    try {
      const int maxImages = 5;

      final int remaining = maxImages - _galleryImages.length;

      if (remaining <= 0) {
        _showNotice('You can upload a maximum of $maxImages gallery images.');

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

      await _saveDraft();

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

    _scheduleDraftSave();
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

    if (mounted) {
      setState(() {
        _isTranslating = true;
      });
    }

    try {
      debugPrint('========== ADD PRODUCT - AUTO TRANSLATE ==========');

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

      await _saveDraft();

      _showNotice(result.message ?? 'Arabic translation completed.');
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      debugPrint('Arabic translation API error: ${error.message}');

      _showNotice(error.message, isError: true);
    } catch (error) {
      if (!mounted) {
        return;
      }

      debugPrint('Arabic translation error: $error');

      _showNotice(
        'Unable to translate product to Arabic. Please try again.',
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
  // SERIALIZE ATTRIBUTES
  // ═══════════════════════════════════════════════════════════════════════════

  List<int> _buildVariantAttributesPayload() {
    final result = <int>[];

    for (final attribute in _attributes) {
      try {
        final dynamic attributeIdValue = attribute.id;

        if (attributeIdValue == null) {
          continue;
        }

        final attributeId = attributeIdValue is int
            ? attributeIdValue
            : int.tryParse(attributeIdValue.toString());

        if (attributeId == null || attributeId <= 0) {
          continue;
        }

        final values = attribute.values;

        var hasSelectedValue = false;

        for (final value in values) {
          final dynamic valueIdValue = value.id;

          if (valueIdValue == null) {
            continue;
          }

          final valueId = valueIdValue is int
              ? valueIdValue
              : int.tryParse(valueIdValue.toString());

          if (valueId != null && valueId > 0) {
            hasSelectedValue = true;
            break;
          }
        }

        if (hasSelectedValue && !result.contains(attributeId)) {
          result.add(attributeId);
        }
      } catch (error) {
        debugPrint('Variant attribute serialization error: $error');
      }
    }

    return result;
  }

  Map<int, List<int>> _buildAttributeValuesPayload() {
    final result = <int, List<int>>{};

    for (final attribute in _attributes) {
      final dynamic attributeIdValue = attribute.id;

      if (attributeIdValue == null) {
        continue;
      }

      final attributeId = attributeIdValue is int
          ? attributeIdValue
          : int.tryParse(attributeIdValue.toString());

      if (attributeId == null || attributeId <= 0) {
        continue;
      }

      final values = <int>[];

      final dynamic attributeValues = attribute.values;

      if (attributeValues is Iterable) {
        for (final value in attributeValues) {
          final dynamic valueIdValue = value.id;

          if (valueIdValue == null) {
            continue;
          }

          final valueId = valueIdValue is int
              ? valueIdValue
              : int.tryParse(valueIdValue.toString());

          if (valueId != null && valueId > 0 && !values.contains(valueId)) {
            values.add(valueId);
          }
        }
      }

      if (values.isNotEmpty) {
        result[attributeId] = values;
      }
    }

    return result;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ATTRIBUTE VALUE MODIFIERS
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // GetAttributeValueModel does NOT contain a modifier property.
  //
  // Therefore this must remain an empty map unless the API/model is later
  // extended with an actual modifier field.
  // ═══════════════════════════════════════════════════════════════════════════

  Map<int, num> _buildAttributeValueModifiersPayload() {
    return <int, num>{};
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SERIALIZE VARIANTS
  // ═══════════════════════════════════════════════════════════════════════════

  List<AddProductVariantRequestModel> _buildVariantsPayload() {
    final result = <AddProductVariantRequestModel>[];

    for (final variant in _variants) {
      try {
        final variantAttributeValues = <int, int>{};

        final dynamic attributes = variant.attributes;

        if (attributes is Map) {
          attributes.forEach((key, value) {
            final attributeId = key is int ? key : int.tryParse(key.toString());

            final dynamic normalizedValue = value is Map
                ? value['id'] ?? value['value']
                : value;

            final valueId = normalizedValue is int
                ? normalizedValue
                : int.tryParse(normalizedValue?.toString() ?? '');

            if (attributeId != null &&
                attributeId > 0 &&
                valueId != null &&
                valueId > 0) {
              variantAttributeValues[attributeId] = valueId;
            }
          });
        }

        // ==========================================================
        // PRICE
        // ==========================================================

        final dynamic variantPrice = variant.price;

        final numericPrice = variantPrice is num
            ? variantPrice
            : num.tryParse(variantPrice?.toString() ?? '') ?? 0;

        // ==========================================================
        // COMPARE / OLD PRICE
        // ==========================================================

        final dynamic variantCompareAtPrice = variant.compareAtPrice;

        final numericCompareAtPrice = variantCompareAtPrice == null
            ? null
            : variantCompareAtPrice is num
            ? variantCompareAtPrice
            : num.tryParse(variantCompareAtPrice.toString());

        // ==========================================================
        // STOCK
        // ==========================================================

        final dynamic variantStock = variant.stockQuantity;

        final numericStockQty = variantStock is int
            ? variantStock
            : int.tryParse(variantStock?.toString() ?? '') ?? 0;

        // ==========================================================
        // SKU
        // ==========================================================

        final dynamic variantSku = variant.sku;

        final skuText = variantSku?.toString().trim();

        final nullableSku = skuText == null || skuText.isEmpty ? null : skuText;

        // ==========================================================
        // REQUEST MODEL
        // ==========================================================

        final requestVariant = AddProductVariantRequestModel(
          sku: nullableSku,
          price: numericPrice,
          priceOld: numericCompareAtPrice,
          stockQty: numericStockQty,
          attributeValues: variantAttributeValues,
        );

        result.add(requestVariant);

        // ==========================================================
        // DEBUG
        // ==========================================================

        debugPrint(
          'VARIANT SERIALIZED: '
          'SKU=${requestVariant.sku ?? 'AUTO'} | '
          'PRICE=${requestVariant.price} | '
          'PRICE_OLD=${requestVariant.priceOld ?? 'N/A'} | '
          'STOCK=${requestVariant.stockQty} | '
          'ATTRIBUTES=${requestVariant.attributeValues}',
        );
      } catch (error) {
        debugPrint('Variant serialization error: $error');
      }
    }

    return result;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SUBMIT PRODUCT
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _submitProduct() async {
    FocusScope.of(context).unfocus();

    _clearNotice();

    // ============================================================
    // CURRENT STEP VALIDATION
    // ============================================================

    if (!_validateCurrentStep()) {
      _showNotice('Please complete the required fields.', isError: true);

      return;
    }

    // ============================================================
    // REQUIRED PRODUCT VALIDATION
    // ============================================================

    final productName = _productNameController.text.trim();

    if (productName.isEmpty) {
      _showNotice('Product name is required.', isError: true);

      return;
    }

    final categoryIdText = _categoryId?.trim();

    if (categoryIdText == null || categoryIdText.isEmpty) {
      _showNotice('Please select a category.', isError: true);

      return;
    }

    final categoryId = int.tryParse(categoryIdText);

    if (categoryId == null || categoryId <= 0) {
      _showNotice('Please select a valid category.', isError: true);

      return;
    }

    final priceText = _priceController.text.trim();

    if (priceText.isEmpty) {
      _showNotice('Product price is required.', isError: true);

      return;
    }

    final price = double.tryParse(priceText.replaceAll(',', ''));

    if (price == null || price < 0) {
      _showNotice('Please enter a valid product price.', isError: true);

      return;
    }

    if (_primaryImage == null) {
      _showNotice('Please select a primary product image.', isError: true);

      return;
    }

    // ============================================================
    // STOCK
    // ============================================================

    final stockText = _stockController.text.trim();

    final stockQty = int.tryParse(stockText.isEmpty ? '0' : stockText);

    if (stockQty == null || stockQty < 0) {
      _showNotice('Please enter a valid stock quantity.', isError: true);

      return;
    }

    // ============================================================
    // SAVE DRAFT BEFORE API REQUEST
    // ============================================================

    await _saveDraft();

    if (!mounted) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // ==========================================================
      // BUILD VARIANT PAYLOAD
      // ==========================================================

      final variantAttributes = _buildVariantAttributesPayload();

      final attributeValues = _buildAttributeValuesPayload();

      final attributeValueModifiers = _buildAttributeValueModifiersPayload();

      final variants = _buildVariantsPayload();

      // ==========================================================
      // ACTIVE STATUS
      // ==========================================================
      //
      // Backend expects integer:
      // 1 = active
      // 0 = inactive
      //
      // Default _isActive = true, therefore a new product sends 1.
      // ==========================================================

      final int isActive = _isActive ? 1 : 0;

      // ==========================================================
      // BUILD REQUEST MODEL
      // ==========================================================

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
        allowAffiliate: _allowAffiliates,
        hasVariants: _enableVariants,
        variantAttributes: variantAttributes,
        attributeValues: attributeValues,
        attributeValueModifiers: attributeValueModifiers,
        variants: variants,

        // ========================================================
        // ACTIVE STATUS
        // ========================================================
        isActive: isActive,

        // ========================================================
        // ARABIC
        // ========================================================
        nameAr: _nullableText(_arabicNameController.text),
        shortDescriptionAr: _nullableText(
          _arabicShortDescriptionController.text,
        ),
        descriptionAr: _nullableText(_arabicFullDescriptionController.text),

        // ========================================================
        // SEO
        // ========================================================
        metaTitle: _nullableText(_metaTitleController.text),
        metaDescription: _nullableText(_metaDescriptionController.text),
        metaKeywords: _nullableText(_metaKeywordsController.text),
        metaTitleAr: _nullableText(_arabicMetaTitleController.text),
        metaDescriptionAr: _nullableText(_arabicMetaDescriptionController.text),
        metaKeywordsAr: _nullableText(_arabicMetaKeywordsController.text),
      );

      // ==========================================================
      // DEBUG REQUEST
      // ==========================================================

      debugPrint('');
      debugPrint('══════════════════════════════════════════');
      debugPrint('        CREATE PRODUCT REQUEST');
      debugPrint('══════════════════════════════════════════');

      debugPrint('NAME: ${request.name}');

      debugPrint('CATEGORY ID: ${request.categoryId}');

      debugPrint('BRAND ID: ${request.brandId ?? 'N/A'}');

      debugPrint('PRICE: ${request.price}');

      debugPrint('PRICE OLD: ${request.priceOld ?? 'N/A'}');

      debugPrint('STOCK QTY: ${request.stockQty}');

      debugPrint('SKU: ${request.sku ?? 'AUTO'}');

      debugPrint('ALLOW AFFILIATE: ${request.allowAffiliate}');

      debugPrint('HAS VARIANTS: ${request.hasVariants}');

      debugPrint('IS ACTIVE: ${request.isActive}');

      debugPrint('HERO IMAGE: ${request.heroImage.path}');

      debugPrint('GALLERY IMAGES: ${request.galleryImages.length}');

      debugPrint(
        'VARIANT ATTRIBUTES: '
        '${request.variantAttributes}',
      );

      debugPrint(
        'ATTRIBUTE VALUES: '
        '${request.attributeValues}',
      );

      debugPrint(
        'ATTRIBUTE VALUE MODIFIERS: '
        '${request.attributeValueModifiers}',
      );

      debugPrint('VARIANTS: ${request.variants.length}');

      for (var i = 0; i < request.variants.length; i++) {
        final variant = request.variants[i];

        debugPrint(
          'VARIANT[$i] '
          'SKU=${variant.sku ?? 'AUTO'} '
          'PRICE=${variant.price} '
          'PRICE_OLD=${variant.priceOld ?? 'N/A'} '
          'STOCK=${variant.stockQty} '
          'ATTRIBUTES=${variant.attributeValues}',
        );
      }

      debugPrint(
        'ARABIC NAME: '
        '${request.nameAr ?? 'N/A'}',
      );

      debugPrint(
        'ARABIC SHORT DESCRIPTION: '
        '${request.shortDescriptionAr ?? 'N/A'}',
      );

      debugPrint(
        'ARABIC DESCRIPTION: '
        '${request.descriptionAr ?? 'N/A'}',
      );

      debugPrint(
        'META TITLE: '
        '${request.metaTitle ?? 'N/A'}',
      );

      debugPrint(
        'META DESCRIPTION: '
        '${request.metaDescription ?? 'N/A'}',
      );

      debugPrint(
        'META KEYWORDS: '
        '${request.metaKeywords ?? 'N/A'}',
      );

      debugPrint('══════════════════════════════════════════');
      debugPrint('');

      // ==========================================================
      // API CALL
      // ==========================================================

      final result = await ref
          .read(addProductControllerProvider)
          .addProduct(request);

      if (!mounted) {
        return;
      }

      // ==========================================================
      // RESPONSE LOG
      // ==========================================================

      debugPrint('');
      debugPrint('══════════════════════════════════════════');
      debugPrint('        CREATE PRODUCT RESPONSE');
      debugPrint('══════════════════════════════════════════');

      debugPrint('SUCCESS: ${result.success}');

      debugPrint('MESSAGE: ${result.message ?? 'N/A'}');

      debugPrint('PRODUCT ID: ${result.product?.id ?? 'N/A'}');

      debugPrint('PRODUCT NAME: ${result.product?.name ?? 'N/A'}');

      debugPrint('══════════════════════════════════════════');
      debugPrint('');

      // ==========================================================
      // API FAILED
      // ==========================================================

      if (!result.success) {
        _showNotice(
          result.message ?? 'Unable to create product.',
          isError: true,
        );

        // Draft intentionally preserved.
        return;
      }

      // ==========================================================
      // API SUCCESS
      // ==========================================================

      await _clearAllProductData();

      if (!mounted) {
        return;
      }

      _showNotice(result.message ?? 'Product created successfully.');

      await Future<void>.delayed(const Duration(milliseconds: 600));

      if (!mounted) {
        return;
      }

      context.push(AppRoutes.products);
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      debugPrint('');
      debugPrint('══════════════════════════════════════════');
      debugPrint('        CREATE PRODUCT API ERROR');
      debugPrint('══════════════════════════════════════════');

      debugPrint('MESSAGE: ${error.message}');

      debugPrint('CODE: ${error.code}');

      debugPrint('══════════════════════════════════════════');
      debugPrint('');

      // Draft intentionally preserved.
      _showNotice(error.message, isError: true);
    } catch (error) {
      if (!mounted) {
        return;
      }

      debugPrint('');
      debugPrint('CREATE PRODUCT UNEXPECTED ERROR: $error');

      // Draft intentionally preserved.
      _showNotice(
        'Unable to create product. Your draft has been saved.',
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
  // REQUEST HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  String? _nullableText(String value) {
    final text = value.trim();

    if (text.isEmpty) {
      return null;
    }

    return text;
  }

  int? _parseOptionalInt(String? value) {
    if (value == null) {
      return null;
    }

    final text = value.trim();

    if (text.isEmpty) {
      return null;
    }

    return int.tryParse(text);
  }

  double? _parseOptionalDouble(String value) {
    final text = value.trim();

    if (text.isEmpty) {
      return null;
    }

    return double.tryParse(text.replaceAll(',', ''));
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // VALIDATE
  // ═══════════════════════════════════════════════════════════════════════════

  bool _validateCurrentStep() {
    final form = _stepFormKeys[_currentStep].currentState;

    if (form == null) {
      return true;
    }

    return form.validate();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // NEXT
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

    await _saveDraft();

    if (!mounted) {
      return;
    }

    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });

      await _saveDraft();

      _scrollToTop();
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PREVIOUS
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _previousStep() async {
    FocusScope.of(context).unfocus();

    await _saveDraft();

    if (!mounted) {
      return;
    }

    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });

      await _saveDraft();

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

    await _saveDraft();

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
  // CLOSE
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _closeScreen() async {
    FocusScope.of(context).unfocus();

    await _saveDraft();

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
      // ============================================================
      // BASIC
      // ============================================================

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

              _scheduleDraftSave();
            },
          ),
        );

      // ============================================================
      // ARABIC
      // ============================================================

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

      // ============================================================
      // CATEGORY & BRAND
      // ============================================================

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

              debugPrint('Selected category ID: $value');

              _scheduleDraftSave();
            },
            onBrandChanged: (value) {
              setState(() {
                _brandId = value;
              });

              debugPrint('Selected brand ID: $value');

              _scheduleDraftSave();
            },
            isLoadingCategories: _isLoadingProductOptions,
            isLoadingBrands: _isLoadingProductOptions,
          ),
        );

      // ============================================================
      // IMAGES
      // ============================================================

      case 3:
        return ProductImagesSection(
          primaryImage: _primaryImage,
          galleryImages: _galleryImages,
          onPickPrimaryImage: _pickPrimaryImage,
          onRemovePrimaryImage: _removePrimaryImage,
          onAddGalleryImage: _addGalleryImages,
          onRemoveGalleryImage: _removeGalleryImage,
        );

      // ============================================================
      // PRICING
      // ============================================================

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

              _scheduleDraftSave();
            },
          ),
        );

      // ============================================================
      // VARIANTS
      // ============================================================

      case 5:
        return VariantsSection(
          attributes: _attributes,

          onAttributesChanged: (value) {
            final updatedAttributes = value
                .whereType<GetAttributeModel>()
                .toList(growable: false);

            setState(() {
              _attributes = updatedAttributes;
            });

            _scheduleDraftSave();
          },

          onVariantsChanged: (value) {
            setState(() {
              _variants = List<dynamic>.from(value);
            });

            _scheduleDraftSave();
          },

          enabledVariants: _enableVariants,

          onVariantsEnabledChanged: (value) {
            setState(() {
              _enableVariants = value;
            });

            _scheduleDraftSave();
          },

          availableAttributes: _availableAttributes,

          // ========================================================
          // PRICING DEFAULTS FOR NEW VARIANTS
          // ========================================================
          //
          // These values are passed only when creating a NEW variant.
          //
          // Existing VariantData objects must keep their own values.
          // VariantBuilder handles that behavior.
          // ========================================================
          defaultPrice: _priceController.text.trim(),

          defaultCompareAtPrice: _compareAtPriceController.text.trim(),

          defaultStockQuantity: _stockController.text.trim(),

          defaultSku: _skuController.text.trim(),

          enabled: true,
        );

      // ============================================================
      // SEO
      // ============================================================

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

  // ═══════════════════════════════════════════════════════════════════════════
  // SELECTED CATEGORY
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

    return 'Not selected';
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SELECTED BRAND
  // ═══════════════════════════════════════════════════════════════════════════

  String _getSelectedBrandName() {
    if (_brandId == null || _brandId!.trim().isEmpty) {
      return 'Not selected';
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

    return 'Not selected';
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
