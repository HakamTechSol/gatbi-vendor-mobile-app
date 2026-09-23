import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../Services/api_exception.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../../../Attributes/Get Attributes/Controllers/get_attributes_controller.dart';
import '../../../Attributes/Get Attributes/Models/get_attributes_model.dart';

import '../../Arabic Translator/product_arabic_translation_controller.dart';
import '../Get Categories/Controller/categories_controller.dart';
import '../Get Categories/Models/get_categories_model.dart';

import '../Models/product_attribute_model.dart';
import '../Models/product_form_model.dart';
import '../Models/product_variant_model.dart';

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
  // CATEGORY API
  // ═══════════════════════════════════════════════════════════════════════════

  bool _isLoadingCategories = false;

  List<GetCategoryModel> _categories = <GetCategoryModel>[];

  // ═══════════════════════════════════════════════════════════════════════════
  // ATTRIBUTE API
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // IMPORTANT:
  // This list contains the REAL API model.
  //
  // GET /api/mobile/vendor/attributes
  //        ↓
  // GetAttributeModel
  //        ↓
  // VariantsSection
  //
  // No ProductAttributeModel is used here.
  // ProductAttributeModel is only used for selected attributes.
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

  final List<File> _galleryImages = [];

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

  // Selected attributes used by product form.
  //
  // These are DIFFERENT from _availableAttributes.
  //
  // _availableAttributes = API GetAttributeModel
  // _attributes          = selected ProductAttributeModel
  //
  List<ProductAttributeModel> _attributes = <ProductAttributeModel>[];

  List<ProductVariantModel> _variants = <ProductVariantModel>[];

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

    _loadCategories();

    _loadAttributes();

    _restoreDraft();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // INITIAL DATA
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // IMPORTANT:
  // No dummy product data.
  // No dummy category data.
  // No dummy attribute data.
  //
  // Only normal empty/default form values are initialized here.
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

    _attributes = <ProductAttributeModel>[];

    _variants = <ProductVariantModel>[];

    _availableAttributes = <GetAttributeModel>[];

    _slugController.clear();

    _metaTitleController.clear();

    _metaDescriptionController.clear();

    _metaKeywordsController.clear();

    _isActive = true;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // GET CATEGORIES API
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _loadCategories() async {
    if (_isLoadingCategories) {
      return;
    }

    if (mounted) {
      setState(() {
        _isLoadingCategories = true;
      });
    }

    try {
      debugPrint('');
      debugPrint('========== ADD PRODUCT ==========');
      debugPrint('GET CATEGORIES STARTED');

      final result = await ref
          .read(getCategoriesControllerProvider)
          .getCategories();

      if (!mounted) {
        return;
      }

      setState(() {
        _categories = result.categories;
        _isLoadingCategories = false;
      });

      final dropdownItems = _buildCategoryDropdownItems();

      debugPrint('GET CATEGORIES SUCCESS: ${result.success}');
      debugPrint('ROOT CATEGORIES: ${result.categories.length}');
      debugPrint('DROPDOWN CATEGORIES: ${dropdownItems.length}');

      for (final category in dropdownItems) {
        debugPrint('CATEGORY: ${category.label} | VALUE: ${category.value}');
      }

      debugPrint('================================');
      debugPrint('');
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoadingCategories = false;
        _categories = <GetCategoryModel>[];
      });

      debugPrint('Get categories API error: ${error.message}');

      _showNotice(error.message, isError: true);
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoadingCategories = false;
        _categories = <GetCategoryModel>[];
      });

      debugPrint('Get categories unexpected error: $error');

      _showNotice(
        'Unable to load categories. Please try again.',
        isError: true,
      );
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // GET ATTRIBUTES API
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // REAL API:
  //
  // GET /api/mobile/vendor/attributes
  //
  // Response:
  //
  // {
  //   "success": true,
  //   "attributes": [...]
  // }
  //
  // The API models are passed directly to VariantsSection.
  // No dummy data.
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

      debugPrint(
        'ATTRIBUTES COUNT: '
        '${result.attributes.length}',
      );

      for (final attribute in result.attributes) {
        debugPrint('');
        debugPrint('ATTRIBUTE ID: ${attribute.id}');
        debugPrint('ATTRIBUTE NAME: ${attribute.name}');
        debugPrint('ATTRIBUTE SLUG: ${attribute.slug}');
        debugPrint(
          'ATTRIBUTE INPUT TYPE: '
          '${attribute.inputType}',
        );
        debugPrint('ATTRIBUTE IS OWN: ${attribute.isOwn}');
        debugPrint(
          'ATTRIBUTE VALUES: '
          '${attribute.values.length}',
        );

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

      debugPrint(
        'Get attributes API error: '
        '${error.message}',
      );

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
  // FLATTEN CATEGORY TREE
  // ═══════════════════════════════════════════════════════════════════════════

  List<ProductDropdownItem<String>> _buildCategoryDropdownItems() {
    final items = <ProductDropdownItem<String>>[];

    void addCategories(List<GetCategoryModel> categories, int level) {
      for (final category in categories) {
        final id = category.id;

        if (id == null) {
          continue;
        }

        final name = category.name?.trim();

        if (name == null || name.isEmpty) {
          continue;
        }

        final prefix = level == 0 ? '' : '  ' * level;

        items.add(
          ProductDropdownItem<String>(
            value: id.toString(),
            label: '$prefix$name',
          ),
        );

        if (category.children.isNotEmpty) {
          addCategories(category.children, level + 1);
        }
      }
    }

    addCategories(_categories, 0);

    return items;
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
        final Map<String, dynamic> data =
            jsonDecode(raw) as Map<String, dynamic>;

        _restoreFromJson(data);
      }

      _draftReady = true;

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      debugPrint('Draft restore error: $e');

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
    // SAVED ATTRIBUTES
    // ============================================================

    final attributes = data['attributes'];

    if (attributes is List) {
      _attributes = attributes
          .whereType<Map>()
          .map(
            (item) =>
                ProductAttributeModel.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList();
    }

    // ============================================================
    // SAVED VARIANTS
    // ============================================================

    final variants = data['variants'];

    if (variants is List) {
      _variants = variants
          .whereType<Map>()
          .map(
            (item) => ProductVariantModel(
              id: item['id'] is num ? (item['id'] as num).toInt() : null,
              sku: item['sku']?.toString() ?? '',
              price: item['price'] is num
                  ? (item['price'] as num).toDouble()
                  : double.tryParse(item['price']?.toString() ?? ''),
              compareAtPrice: item['compare_at_price'] is num
                  ? (item['compare_at_price'] as num).toDouble()
                  : double.tryParse(item['compare_at_price']?.toString() ?? ''),
              stockQuantity: item['stock_quantity'] is num
                  ? (item['stock_quantity'] as num).toInt()
                  : int.tryParse(item['stock_quantity']?.toString() ?? '') ?? 0,
              image: item['image']?.toString(),
              attributes: item['attributes'] is Map
                  ? Map<String, String>.from(
                      (item['attributes'] as Map).map(
                        (key, value) =>
                            MapEntry(key.toString(), value.toString()),
                      ),
                    )
                  : <String, String>{},
              isActive: item['is_active'] as bool? ?? true,
            ),
          )
          .toList();
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

        // Basic.
        'product_name': _productNameController.text,
        'short_description': _shortDescriptionController.text,
        'full_description': _fullDescriptionController.text,
        'allow_affiliates': _allowAffiliates,

        // Arabic.
        'arabic_name': _arabicNameController.text,
        'arabic_short_description': _arabicShortDescriptionController.text,
        'arabic_full_description': _arabicFullDescriptionController.text,
        'arabic_meta_title': _arabicMetaTitleController.text,
        'arabic_meta_keywords': _arabicMetaKeywordsController.text,
        'arabic_meta_description': _arabicMetaDescriptionController.text,

        // Pricing.
        'price': _priceController.text,
        'compare_at_price': _compareAtPriceController.text,
        'cost_price': _costPriceController.text,
        'stock': _stockController.text,
        'sku': _skuController.text,
        'inventory_type': _inventoryType,

        // Category.
        'category_id': _categoryId,
        'brand_id': _brandId,

        // Images.
        'primary_image': _primaryImage?.path,
        'gallery_images': _galleryImages.map((e) => e.path).toList(),

        // Variants.
        'enable_variants': _enableVariants,

        'attributes': _attributes
            .map(
              (attribute) => {
                'id': attribute.id,
                'name': attribute.name,
                'name_ar': attribute.nameAr,
                'values': attribute.values,
              },
            )
            .toList(),

        'variants': _variants
            .map(
              (variant) => {
                'id': variant.id,
                'sku': variant.sku,
                'price': variant.price,
                'compare_at_price': variant.compareAtPrice,
                'stock_quantity': variant.stockQuantity,
                'image': variant.image,
                'attributes': variant.attributes,
                'is_active': variant.isActive,
              },
            )
            .toList(),

        // SEO.
        'slug': _slugController.text,
        'meta_title': _metaTitleController.text,
        'meta_description': _metaDescriptionController.text,
        'meta_keywords': _metaKeywordsController.text,

        // Status.
        'is_active': _isActive,
      };

      await prefs.setString(_draftKey, jsonEncode(data));
    } catch (e) {
      debugPrint('Draft save error: $e');
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
    } catch (e) {
      debugPrint('Draft clear error: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PARSERS
  // ═══════════════════════════════════════════════════════════════════════════

  double? _parseDouble(String value) {
    final text = value.trim();

    if (text.isEmpty) {
      return null;
    }

    return double.tryParse(text);
  }

  int _parseInt(String value) {
    final text = value.trim();

    if (text.isEmpty) {
      return 0;
    }

    return int.tryParse(text) ?? 0;
  }

  int? _parseNullableInt(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    return int.tryParse(value.trim());
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
    } catch (e) {
      if (!mounted) return;

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
      const int maxImages = 8;

      final int remaining = maxImages - _galleryImages.length;

      if (remaining <= 0) {
        _showNotice(
          'You can upload a maximum of $maxImages additional images.',
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

      await _saveDraft();

      if (pickedFiles.length > remaining) {
        _showNotice(
          'Only $remaining additional image(s) were added. '
          'Maximum is $maxImages.',
        );
      }
    } catch (e) {
      if (!mounted) return;

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
// AUTO TRANSLATE ARABIC
// ═══════════════════════════════════════════════════════════════════════════

Future<void> _autoTranslateArabic() async {
  // ============================================================
  // READ ENGLISH FIELDS
  // ============================================================

  final name = _productNameController.text.trim();

  final shortDescription =
      _shortDescriptionController.text.trim();

  final description =
      _fullDescriptionController.text.trim();

  final metaTitle =
      _metaTitleController.text.trim();

  final metaKeywords =
      _metaKeywordsController.text.trim();

  final metaDescription =
      _metaDescriptionController.text.trim();

  // ============================================================
  // VALIDATION
  // ============================================================

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

  // ============================================================
  // START TRANSLATION
  // ============================================================

  if (mounted) {
    setState(() {
      _isTranslating = true;
    });
  }

  try {
    // ============================================================
    // DEBUG
    // ============================================================

    debugPrint('');
    debugPrint(
      '========== ADD PRODUCT - AUTO TRANSLATE ==========',
    );

    debugPrint('Starting Arabic translation...');

    debugPrint('English Name: $name');

    debugPrint(
      'English Short Description: '
      '$shortDescription',
    );

    debugPrint(
      'English Description: '
      '$description',
    );

    debugPrint(
      'English Meta Title: '
      '$metaTitle',
    );

    debugPrint(
      'English Meta Keywords: '
      '$metaKeywords',
    );

    debugPrint(
      'English Meta Description: '
      '$metaDescription',
    );

    debugPrint('Source Locale: en');

    debugPrint('Target Locale: ar');

    debugPrint(
      '==================================================',
    );

    // ============================================================
    // CALL TRANSLATION API
    // ============================================================

    final result = await ref
        .read(
          productArabicTranslatorControllerProvider,
        )
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

    // ============================================================
    // MOUNT CHECK
    // ============================================================

    if (!mounted) {
      return;
    }

    // ============================================================
    // API SUCCESS CHECK
    // ============================================================

    if (!result.success) {
      _showNotice(
        result.message ??
            'Unable to translate product to Arabic.',
        isError: true,
      );

      return;
    }

    // ============================================================
    // TRANSLATION OBJECT
    // ============================================================

    final translation = result.translation;

    if (translation == null) {
      _showNotice(
        'Translation response is empty.',
        isError: true,
      );

      return;
    }

    // ============================================================
    // TRANSLATED FIELDS
    // ============================================================

    final translated = translation.translated;

    if (translated == null) {
      _showNotice(
        'Translated product data was not received.',
        isError: true,
      );

      return;
    }

    // ============================================================
    // SET ARABIC NAME
    // ============================================================

    if (translated.name != null &&
        translated.name!.trim().isNotEmpty) {
      _arabicNameController.text =
          translated.name!.trim();
    }

    // ============================================================
    // SET ARABIC SHORT DESCRIPTION
    // ============================================================

    if (translated.shortDescription != null &&
        translated.shortDescription!.trim().isNotEmpty) {
      _arabicShortDescriptionController.text =
          translated.shortDescription!.trim();
    }

    // ============================================================
    // SET ARABIC FULL DESCRIPTION
    // ============================================================

    if (translated.description != null &&
        translated.description!.trim().isNotEmpty) {
      _arabicFullDescriptionController.text =
          translated.description!.trim();
    }

    // ============================================================
    // SET ARABIC META TITLE
    // ============================================================

    if (translated.metaTitle != null &&
        translated.metaTitle!.trim().isNotEmpty) {
      _arabicMetaTitleController.text =
          translated.metaTitle!.trim();
    }

    // ============================================================
    // SET ARABIC META KEYWORDS
    // ============================================================

    if (translated.metaKeywords != null &&
        translated.metaKeywords!.trim().isNotEmpty) {
      _arabicMetaKeywordsController.text =
          translated.metaKeywords!.trim();
    }

    // ============================================================
    // SET ARABIC META DESCRIPTION
    // ============================================================

    if (translated.metaDescription != null &&
        translated.metaDescription!.trim().isNotEmpty) {
      _arabicMetaDescriptionController.text =
          translated.metaDescription!.trim();
    }

    // ============================================================
    // SAVE DRAFT
    // ============================================================

    await _saveDraft();

    // ============================================================
    // SUCCESS LOG
    // ============================================================

    debugPrint('');
    debugPrint(
      '========== ARABIC TRANSLATION APPLIED ==========',
    );

    debugPrint(
      'Arabic Name: '
      '${_arabicNameController.text}',
    );

    debugPrint(
      'Arabic Short Description: '
      '${_arabicShortDescriptionController.text}',
    );

    debugPrint(
      'Arabic Full Description: '
      '${_arabicFullDescriptionController.text}',
    );

    debugPrint(
      'Arabic Meta Title: '
      '${_arabicMetaTitleController.text}',
    );

    debugPrint(
      'Arabic Meta Keywords: '
      '${_arabicMetaKeywordsController.text}',
    );

    debugPrint(
      'Arabic Meta Description: '
      '${_arabicMetaDescriptionController.text}',
    );

    debugPrint(
      '================================================',
    );

    // ============================================================
    // SUCCESS NOTICE
    // ============================================================

    _showNotice(
      result.message ?? 'Arabic translation completed.',
    );
  } on ApiException catch (error) {
    if (!mounted) {
      return;
    }

    debugPrint('');
    debugPrint(
      '========== ARABIC TRANSLATION API ERROR ==========',
    );

    debugPrint(
      'MESSAGE: ${error.message}',
    );

    debugPrint(
      'CODE: ${error.code}',
    );

    debugPrint(
      '==================================================',
    );

    _showNotice(
      error.message,
      isError: true,
    );
  } catch (error) {
    if (!mounted) {
      return;
    }

    debugPrint('');
    debugPrint(
      '========== ARABIC TRANSLATION ERROR ==========',
    );

    debugPrint('ERROR: $error');

    debugPrint(
      '===============================================',
    );

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
  // BUILD PRODUCT MODEL
  // ═══════════════════════════════════════════════════════════════════════════

  ProductFormModel _buildProductFormModel() {
    return ProductFormModel(
      name: _productNameController.text.trim(),

      shortDescription: _shortDescriptionController.text.trim(),

      description: _fullDescriptionController.text.trim(),

      allowAffiliates: _allowAffiliates,

      nameAr: _arabicNameController.text.trim(),

      shortDescriptionAr: _arabicShortDescriptionController.text.trim(),

      descriptionAr: _arabicFullDescriptionController.text.trim(),

      arabicMetaTitle: _arabicMetaTitleController.text.trim(),

      arabicMetaKeywords: _arabicMetaKeywordsController.text.trim(),

      arabicMetaDescription: _arabicMetaDescriptionController.text.trim(),

      price: _parseDouble(_priceController.text),

      compareAtPrice: _parseDouble(_compareAtPriceController.text),

      costPrice: _parseDouble(_costPriceController.text),

      sku: _skuController.text.trim(),

      stockQuantity: _parseInt(_stockController.text),

      categoryId: _parseNullableInt(_categoryId),

      brandId: _parseNullableInt(_brandId),

      mainImage: _primaryImage?.path,

      galleryImages: _galleryImages.map((e) => e.path).toList(),

      hasVariants: _enableVariants,

      attributes: List<ProductAttributeModel>.from(_attributes),

      variants: List<ProductVariantModel>.from(_variants),

      metaTitle: _metaTitleController.text.trim(),

      metaDescription: _metaDescriptionController.text.trim(),

      metaKeywords: _metaKeywordsController.text.trim(),

      isActive: _isActive,
    );
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

    if (!mounted) return;

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

    if (!mounted) return;

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

    if (!mounted) return;

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
  // SUBMIT
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _submitProduct() async {
    FocusScope.of(context).unfocus();

    _clearNotice();

    if (!_validateCurrentStep()) {
      _showNotice('Please complete the required fields.', isError: true);
      return;
    }

    await _saveDraft();

    if (!mounted) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final ProductFormModel product = _buildProductFormModel();

      debugPrint(
        'Creating product: '
        '${product.toJson()}',
      );

      // ============================================================
      // CREATE PRODUCT API
      // ============================================================
      // Will be connected separately.
      // ============================================================

      await Future<void>.delayed(const Duration(milliseconds: 900));

      if (!mounted) return;

      await _clearDraft();

      _showNotice('Product created successfully.');

      await Future<void>.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;

      debugPrint('Create product error: $e');

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
  // CLOSE
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _closeScreen() async {
    FocusScope.of(context).unfocus();

    await _saveDraft();

    if (!mounted) return;

    Navigator.of(context).pop();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // NOTICE
  // ═══════════════════════════════════════════════════════════════════════════

  void _showNotice(String message, {bool isError = false}) {
    if (!mounted) return;

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
    if (!mounted) return;

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
      // CATEGORY
      // ============================================================

      case 2:
        return Form(
          key: _stepFormKeys[2],
          child: CategoryBrandSection(
            categoryId: _categoryId,
            brandId: _brandId,

            // ======================================================
            // REAL API CATEGORIES
            // ======================================================
            categories: _buildCategoryDropdownItems(),

            // ======================================================
            // BRAND API WILL BE CONNECTED LATER
            // ======================================================
            brands: const [],

            onCategoryChanged: (value) {
              setState(() {
                _categoryId = value;
              });

              debugPrint(
                'Selected category ID: '
                '$value',
              );

              _scheduleDraftSave();
            },

            onBrandChanged: (value) {
              setState(() {
                _brandId = value;
              });

              _scheduleDraftSave();
            },

            isLoadingCategories: _isLoadingCategories,

            isLoadingBrands: false,
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
          // ========================================================
          // SELECTED PRODUCT ATTRIBUTES
          // ========================================================
          attributes: _attributes,

          onAttributesChanged: (value) {
            setState(() {
              _attributes = List<ProductAttributeModel>.from(value);
            });

            _scheduleDraftSave();
          },

          // ========================================================
          // PRODUCT VARIANTS
          // ========================================================
          variants: _variants,

          onVariantsChanged: (value) {
            setState(() {
              _variants = List<ProductVariantModel>.from(value);
            });

            _scheduleDraftSave();
          },

          // ========================================================
          // ENABLE VARIANTS
          // ========================================================
          enabledVariants: _enableVariants,

          onVariantsEnabledChanged: (value) {
            setState(() {
              _enableVariants = value;
            });

            _scheduleDraftSave();
          },

          // ========================================================
          // REAL API ATTRIBUTES
          //
          // IMPORTANT:
          // This is List<GetAttributeModel>
          //
          // NOT:
          // List<ProductAttributeModel>
          // ========================================================
          availableAttributes: _availableAttributes,

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
                : _attributes.map((e) => e.name).join(', '),
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
    if (_categoryId == null || _categoryId!.trim().isEmpty) {
      return 'Not selected';
    }

    final category = _findCategoryById(_categories, int.tryParse(_categoryId!));

    return category?.name?.trim().isNotEmpty == true
        ? category!.name!.trim()
        : 'Not selected';
  }

  GetCategoryModel? _findCategoryById(
    List<GetCategoryModel> categories,
    int? id,
  ) {
    if (id == null) {
      return null;
    }

    for (final category in categories) {
      if (category.id == id) {
        return category;
      }

      if (category.children.isNotEmpty) {
        final result = _findCategoryById(category.children, id);

        if (result != null) {
          return result;
        }
      }
    }

    return null;
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
