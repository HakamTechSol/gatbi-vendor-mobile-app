import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Theme/app_colors.dart';
import '../../../Theme/app_text_styles.dart';

import '../Data/dummy_product_form_data.dart';

import '../Models/product_attribute_model.dart';
import '../Models/product_form_model.dart';
import '../Models/product_variant_model.dart';

import '../Reuse Widgets/arabic_translation_section.dart';
import '../Reuse Widgets/basic_information_section.dart';
import '../Reuse Widgets/category_brand_section.dart';
import '../Reuse Widgets/pricing_inventory_section.dart';
import '../Reuse Widgets/product_form_header.dart';
import '../Reuse Widgets/product_form_notice.dart';
import '../Reuse Widgets/product_images_section.dart';
import '../Reuse Widgets/product_submit_section.dart';
import '../Reuse Widgets/seo_settings_section.dart';
import '../Reuse Widgets/variants_section.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  // ═══════════════════════════════════════════════════════════════════════════
  // DRAFT STORAGE
  // ═══════════════════════════════════════════════════════════════════════════

  static const String _draftKey = 'add_product_draft_v1';

  SharedPreferences? _prefs;

  bool _draftReady = false;

  Timer? _draftSaveTimer;

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

  // One form key for every wizard step.
  final List<GlobalKey<FormState>> _stepFormKeys = List.generate(
    7,
    (_) => GlobalKey<FormState>(),
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // FORM
  // ═══════════════════════════════════════════════════════════════════════════

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

    _restoreDraft();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // INITIAL DATA
  // ═══════════════════════════════════════════════════════════════════════════

  void _loadInitialData() {
    _productNameController.text = DummyProductFormData.productName;

    _shortDescriptionController.text = DummyProductFormData.shortDescription;

    _fullDescriptionController.text = DummyProductFormData.fullDescription;

    _allowAffiliates = DummyProductFormData.allowAffiliates;

    _arabicNameController.text = DummyProductFormData.arabicName;

    _arabicShortDescriptionController.text =
        DummyProductFormData.arabicShortDescription;

    _arabicFullDescriptionController.text =
        DummyProductFormData.arabicFullDescription;

    _arabicMetaTitleController.text = DummyProductFormData.arabicMetaTitle;

    _arabicMetaKeywordsController.text =
        DummyProductFormData.arabicMetaKeywords;

    _arabicMetaDescriptionController.text =
        DummyProductFormData.arabicMetaDescription;

    _priceController.text = DummyProductFormData.price;

    _compareAtPriceController.text = DummyProductFormData.compareAtPrice;

    _costPriceController.text = DummyProductFormData.costPrice;

    _stockController.text = DummyProductFormData.stock;

    _skuController.text = DummyProductFormData.sku;

    _inventoryType = DummyProductFormData.inventoryType;

    _categoryId = DummyProductFormData.categoryId;

    _brandId = DummyProductFormData.brandId;

    _slugController.text = DummyProductFormData.slug;

    _metaTitleController.text = DummyProductFormData.metaTitle;

    _metaDescriptionController.text = DummyProductFormData.metaDescription;

    _metaKeywordsController.text = DummyProductFormData.metaKeywords;
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

    // Current wizard step.
    final savedStep = data['current_step'];

    if (savedStep is int) {
      _currentStep = savedStep.clamp(0, _totalSteps - 1);
    }

    // Primary image.
    final primaryPath = data['primary_image'];

    if (primaryPath is String &&
        primaryPath.isNotEmpty &&
        File(primaryPath).existsSync()) {
      _primaryImage = File(primaryPath);
    }

    // Gallery.
    final gallery = data['gallery_images'];

    if (gallery is List) {
      _galleryImages.clear();

      for (final item in gallery) {
        if (item is String && item.isNotEmpty && File(item).existsSync()) {
          _galleryImages.add(File(item));
        }
      }
    }

    // Attributes.
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

    // Variants.
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
  // SCHEDULE DRAFT SAVE
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

  // ═══════════════════════════════════════════════════════════════════════════
  // SAVE DRAFT
  // ═══════════════════════════════════════════════════════════════════════════

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
  // AUTO TRANSLATE
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _autoTranslateArabic() async {
    if (_productNameController.text.trim().isEmpty) {
      _showNotice(
        'Please enter the product name before translating.',
        isError: true,
      );
      return;
    }

    setState(() {
      _isTranslating = true;
    });

    try {
      await Future<void>.delayed(const Duration(milliseconds: 700));

      if (!mounted) return;

      setState(() {
        if (_arabicNameController.text.trim().isEmpty) {
          _arabicNameController.text = DummyProductFormData.arabicName;
        }

        if (_arabicShortDescriptionController.text.trim().isEmpty) {
          _arabicShortDescriptionController.text =
              DummyProductFormData.arabicShortDescription;
        }

        if (_arabicFullDescriptionController.text.trim().isEmpty) {
          _arabicFullDescriptionController.text =
              DummyProductFormData.arabicFullDescription;
        }
      });

      if (_arabicMetaTitleController.text.trim().isEmpty) {
        _arabicMetaTitleController.text = DummyProductFormData.arabicMetaTitle;
      }

      if (_arabicMetaKeywordsController.text.trim().isEmpty) {
        _arabicMetaKeywordsController.text =
            DummyProductFormData.arabicMetaKeywords;
      }

      if (_arabicMetaDescriptionController.text.trim().isEmpty) {
        _arabicMetaDescriptionController.text =
            DummyProductFormData.arabicMetaDescription;
      }

      await _saveDraft();

      _showNotice('Arabic translation completed successfully.');
    } catch (e) {
      if (!mounted) return;

      _showNotice('Unable to translate product.', isError: true);
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

      // IMPORTANT:
      // _enableVariants is now the single source of truth.
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

    // Don't allow jumping into future sections.
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
    // The page is recreated around current step.
    // Small delay gives Flutter time to rebuild.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 250),
        alignment: 0,
      );
    });
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SUBMIT PRODUCT
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

      /*
       * ============================================================
       * TODO: API
       * ============================================================
       *
       * Replace this with your repository/API:
       *
       * await ref
       *     .read(productRepositoryProvider)
       *     .createProduct(product);
       *
       */

      debugPrint('Creating product: ${product.toJson()}');

      await Future<void>.delayed(const Duration(milliseconds: 900));

      if (!mounted) return;

      // IMPORTANT:
      // Draft is deleted ONLY after successful product creation.
      await _clearDraft();

      _showNotice('Product created successfully.');

      // Optional:
      // Go back after successful creation.
      await Future<void>.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;

      debugPrint('Create product error: $e');

      // Draft intentionally remains.
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
  // BACK / CANCEL
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
  // CURRENT STEP WIDGET
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      // ============================================================
      // STEP 1
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
      // STEP 2
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
      // STEP 3
      // ============================================================

      case 2:
        return Form(
          key: _stepFormKeys[2],
          child: CategoryBrandSection(
            categoryId: _categoryId,
            brandId: _brandId,
            categories: DummyProductFormData.categories,
            brands: DummyProductFormData.brands,
            onCategoryChanged: (value) {
              setState(() {
                _categoryId = value;
              });

              _scheduleDraftSave();
            },
            onBrandChanged: (value) {
              setState(() {
                _brandId = value;
              });

              _scheduleDraftSave();
            },
          ),
        );

      // ============================================================
      // STEP 4
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
      // STEP 5
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
              if (value == null) return;

              setState(() {
                _inventoryType = value;
              });

              _scheduleDraftSave();
            },
          ),
        );

      // ============================================================
      // STEP 6
      // ============================================================

      case 5:
        return VariantsSection(
          attributes: _attributes,

          onAttributesChanged: (value) {
            setState(() {
              _attributes = List<ProductAttributeModel>.from(value);
            });

            _scheduleDraftSave();
          },

          variants: _variants,

          onVariantsChanged: (value) {
            setState(() {
              _variants = List<ProductVariantModel>.from(value);
            });

            _scheduleDraftSave();
          },

          // IMPORTANT
          enabledVariants: _enableVariants,

          onVariantsEnabledChanged: (value) {
            setState(() {
              _enableVariants = value;

              // When variants are disabled, we don't
              // delete existing data.
              // If user enables it again, previous data
              // is still there.
            });

            _scheduleDraftSave();
          },

          enabled: true,
        );

      // ============================================================
      // STEP 7
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
            label: 'Images',
            value:
                '${(_primaryImage != null ? 1 : 0) + _galleryImages.length} image(s)',
          ),
        ],
      ),
    );
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

          // Horizontal scroll prevents overflow
          // on small/mobile screens.
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

    // Last step already contains ProductSubmitSection.
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
        if (didPop) return;

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
                                // ═══════════════════════════════
                                // HEADER
                                // ═══════════════════════════════
                                ProductFormHeader(
                                  title: _stepTitles[_currentStep],
                                  description: _stepDescriptions[_currentStep],
                                ),

                                const SizedBox(height: 20),

                                // ═══════════════════════════════
                                // PROGRESS
                                // ═══════════════════════════════
                                _buildStepProgress(),

                                const SizedBox(height: 20),

                                // ═══════════════════════════════
                                // NOTICE
                                // ═══════════════════════════════
                                if (_formNotice != null) ...[
                                  ProductFormNotice(
                                    message: _formNotice!,
                                    type: ProductFormNoticeType.info,
                                    onClose: _clearNotice,
                                  ),

                                  const SizedBox(height: 20),
                                ],

                                // ═══════════════════════════════
                                // CURRENT SECTION
                                // ═══════════════════════════════
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

                  // ═══════════════════════════════
                  // BOTTOM NEXT / BACK
                  // ═══════════════════════════════
                  _buildBottomNavigation(),
                ],
              ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SUMMARY ROW
// ═══════════════════════════════════════════════════════════════════════════

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
