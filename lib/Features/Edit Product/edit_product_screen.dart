import 'package:flutter/material.dart';

import '../../../Theme/app_colors.dart';
import '../../../Theme/app_text_styles.dart';

import '../Add Product/Data/dummy_product_form_data.dart';
import '../Add Product/Models/product_attribute_model.dart';
import '../Add Product/Models/product_form_model.dart';
import '../Add Product/Models/product_variant_model.dart';

import '../Add Product/Reuse Widgets/arabic_translation_section.dart';
import '../Add Product/Reuse Widgets/basic_information_section.dart';
import '../Add Product/Reuse Widgets/category_brand_section.dart';
import '../Add Product/Reuse Widgets/pricing_inventory_section.dart';
import '../Add Product/Reuse Widgets/product_form_header.dart';
import '../Add Product/Reuse Widgets/product_form_notice.dart';
import '../Add Product/Reuse Widgets/product_images_section.dart';
import '../Add Product/Reuse Widgets/product_submit_section.dart';
import '../Add Product/Reuse Widgets/seo_settings_section.dart';
import '../Add Product/Reuse Widgets/variants_section.dart';

import '../My Product/Models/my_product_model.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key, required this.product});

  final MyProductModel product;

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
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
  // VARIANTS
  // ═══════════════════════════════════════════════════════════════════════════
  //
  // IMPORTANT:
  // _enableVariants is the single source of truth.
  //
  // Do NOT maintain another _hasVariants variable.
  // ═══════════════════════════════════════════════════════════════════════════

  bool _enableVariants = false;

  List<ProductAttributeModel> _attributes = <ProductAttributeModel>[];

  List<ProductVariantModel> _variants = <ProductVariantModel>[];

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
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // INITIALIZE CONTROLLERS
  // ═══════════════════════════════════════════════════════════════════════════

  void _initializeControllers() {
    final product = widget.product;

    // ─────────────────────────────────────────────────────────────────────────
    // BASIC
    // ─────────────────────────────────────────────────────────────────────────

    _productNameController = TextEditingController(text: product.name);

    _shortDescriptionController = TextEditingController();

    _fullDescriptionController = TextEditingController();

    // If your MyProductModel later contains allow_affiliates,
    // replace this with product.allowAffiliates.
    _allowAffiliates = false;

    // ─────────────────────────────────────────────────────────────────────────
    // ARABIC
    // ─────────────────────────────────────────────────────────────────────────

    _arabicNameController = TextEditingController();

    _arabicShortDescriptionController = TextEditingController();

    _arabicFullDescriptionController = TextEditingController();

    _arabicMetaTitleController = TextEditingController();

    _arabicMetaKeywordsController = TextEditingController();

    _arabicMetaDescriptionController = TextEditingController();

    // ─────────────────────────────────────────────────────────────────────────
    // PRICING
    // ─────────────────────────────────────────────────────────────────────────

    _priceController = TextEditingController(text: product.price.toString());

    _compareAtPriceController = TextEditingController(
      text: product.originalPrice?.toString() ?? '',
    );

    _costPriceController = TextEditingController();

    _stockController = TextEditingController(
      text: product.stockQuantity.toString(),
    );

    _skuController = TextEditingController(text: product.sku ?? '');

    // ─────────────────────────────────────────────────────────────────────────
    // INVENTORY
    // ─────────────────────────────────────────────────────────────────────────

    _inventoryType = 'track';

    // ─────────────────────────────────────────────────────────────────────────
    // CATEGORY / BRAND
    // ─────────────────────────────────────────────────────────────────────────
    //
    // Current MyProductModel contains category name but not category ID.
    // API integration ke time actual IDs yahan assign kar sakte hain.
    // ─────────────────────────────────────────────────────────────────────────

    _categoryId = null;

    _brandId = null;

    // ─────────────────────────────────────────────────────────────────────────
    // VARIANTS
    // ─────────────────────────────────────────────────────────────────────────
    //
    // If MyProductModel later provides hasVariants / attributes / variants,
    // initialize them here from API data.
    // ─────────────────────────────────────────────────────────────────────────

    _enableVariants = false;

    _attributes = <ProductAttributeModel>[];

    _variants = <ProductVariantModel>[];

    // ─────────────────────────────────────────────────────────────────────────
    // SEO
    // ─────────────────────────────────────────────────────────────────────────

    _slugController = TextEditingController(text: _slugify(product.name));

    _metaTitleController = TextEditingController(text: product.name);

    _metaDescriptionController = TextEditingController();

    _metaKeywordsController = TextEditingController();

    // ─────────────────────────────────────────────────────────────────────────
    // STATUS
    // ─────────────────────────────────────────────────────────────────────────

    _isActive = product.status.toLowerCase() != 'inactive';
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SLUG
  // ═══════════════════════════════════════════════════════════════════════════

  String _slugify(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');
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

      if (!mounted) {
        return;
      }

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

      _showNotice('Arabic translation completed successfully.');
    } catch (e) {
      if (!mounted) {
        return;
      }

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

      mainImage: null,

      galleryImages: const [],

      // IMPORTANT:
      // Variant ON/OFF state comes only from _enableVariants.
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

    // Don't allow jumping into future sections.
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
  // UPDATE PRODUCT
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _updateProduct() async {
    FocusScope.of(context).unfocus();

    _clearNotice();

    final valid = _validateCurrentStep();

    if (!valid) {
      _showNotice('Please complete the required fields.', isError: true);

      return;
    }

    if (!mounted) {
      return;
    }

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
       *     .updateProduct(
       *       widget.product.id,
       *       product,
       *     );
       *
       * API:
       *
       * PUT /api/mobile/vendor/products/{id}
       *
       * ============================================================
       */

      debugPrint('Updating product ID: ${widget.product.id}');

      debugPrint('Updated product: ${product.toJson()}');

      await Future<void>.delayed(const Duration(milliseconds: 900));

      if (!mounted) {
        return;
      }

      _showNotice('Product updated successfully.');

      await Future<void>.delayed(const Duration(milliseconds: 500));

      if (!mounted) {
        return;
      }

      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) {
        return;
      }

      debugPrint('Update product error: $e');

      _showNotice('Unable to update product. Please try again.', isError: true);
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
      // ═══════════════════════════════════════════════════════════════════════
      // STEP 1 — BASIC
      // ═══════════════════════════════════════════════════════════════════════

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

      // ═══════════════════════════════════════════════════════════════════════
      // STEP 2 — ARABIC
      // ═══════════════════════════════════════════════════════════════════════

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

      // ═══════════════════════════════════════════════════════════════════════
      // STEP 3 — CATEGORY / BRAND
      // ═══════════════════════════════════════════════════════════════════════

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
            },

            onBrandChanged: (value) {
              setState(() {
                _brandId = value;
              });
            },
          ),
        );

      // ═══════════════════════════════════════════════════════════════════════
      // STEP 4 — IMAGES
      // ═══════════════════════════════════════════════════════════════════════

      case 3:
        return ProductImagesSection(
          primaryImage: null,

          galleryImages: const [],

          onPickPrimaryImage: () {
            _showNotice('Image editing will be connected with API later.');
          },

          onRemovePrimaryImage: () {
            // API image removal will be added later.
          },

          onAddGalleryImage: () {
            _showNotice('Image editing will be connected with API later.');
          },

          onRemoveGalleryImage: (_) {
            // API image removal will be added later.
          },
        );

      // ═══════════════════════════════════════════════════════════════════════
      // STEP 5 — PRICING & INVENTORY
      // ═══════════════════════════════════════════════════════════════════════

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

      // ═══════════════════════════════════════════════════════════════════════
      // STEP 6 — VARIANTS
      // ═══════════════════════════════════════════════════════════════════════

      case 5:
        return VariantsSection(
          attributes: _attributes,

          onAttributesChanged: (value) {
            setState(() {
              _attributes = List<ProductAttributeModel>.from(value);
            });
          },

          variants: _variants,

          onVariantsChanged: (value) {
            setState(() {
              _variants = List<ProductVariantModel>.from(value);
            });
          },

          // ================================================================
          // VARIANT ENABLE / DISABLE
          // ================================================================
          //
          // User OFF kare:
          //   Variant builder ka UI hide/disable hoga.
          //
          // User ON kare:
          //   Variant builder wapas available hoga.
          //
          // Existing attributes/variants delete nahi honge.
          // ================================================================
          enabledVariants: _enableVariants,

          onVariantsEnabledChanged: (value) {
            setState(() {
              _enableVariants = value;
            });
          },

          enabled: true,
        );

      // ═══════════════════════════════════════════════════════════════════════
      // STEP 7 — SEO & UPDATE
      // ═══════════════════════════════════════════════════════════════════════

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
          // ─────────────────────────────────────────────────────────────────
          // TITLE
          // ─────────────────────────────────────────────────────────────────
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

          // ─────────────────────────────────────────────────────────────────
          // PRODUCT
          // ─────────────────────────────────────────────────────────────────
          _SummaryRow(
            label: 'Product',
            value: _productNameController.text.trim().isEmpty
                ? 'Not provided'
                : _productNameController.text.trim(),
          ),

          // ─────────────────────────────────────────────────────────────────
          // PRICE
          // ─────────────────────────────────────────────────────────────────
          _SummaryRow(
            label: 'Price',
            value: _priceController.text.trim().isEmpty
                ? 'Not provided'
                : _priceController.text.trim(),
          ),

          // ─────────────────────────────────────────────────────────────────
          // STOCK
          // ─────────────────────────────────────────────────────────────────
          _SummaryRow(
            label: 'Stock',
            value: _stockController.text.trim().isEmpty
                ? '0'
                : _stockController.text.trim(),
          ),

          // ─────────────────────────────────────────────────────────────────
          // VARIANTS
          // ─────────────────────────────────────────────────────────────────
          _SummaryRow(
            label: 'Variants',
            value: _enableVariants
                ? '${_variants.length} variant(s)'
                : 'Disabled',
          ),

          // ─────────────────────────────────────────────────────────────────
          // IMAGES
          // ─────────────────────────────────────────────────────────────────
          _SummaryRow(label: 'Images', value: 'Existing images'),
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
          // ─────────────────────────────────────────────────────────────────
          // STEP NUMBER / PERCENTAGE
          // ─────────────────────────────────────────────────────────────────
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

          // ─────────────────────────────────────────────────────────────────
          // PROGRESS BAR
          // ─────────────────────────────────────────────────────────────────
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

          // ─────────────────────────────────────────────────────────────────
          // STEP LIST
          // ─────────────────────────────────────────────────────────────────
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
                            // ─────────────────────────────────────────────
                            // STEP CIRCLE
                            // ─────────────────────────────────────────────
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

                            // ─────────────────────────────────────────────
                            // STEP TITLE
                            // ─────────────────────────────────────────────
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

                    // ─────────────────────────────────────────────────────
                    // CHEVRON
                    // ─────────────────────────────────────────────────────
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
            // ───────────────────────────────────────────────────────────────
            // BACK
            // ───────────────────────────────────────────────────────────────
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

            // ───────────────────────────────────────────────────────────────
            // NEXT
            // ───────────────────────────────────────────────────────────────
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

        // ═════════════════════════════════════════════════════════════════════
        // APP BAR
        // ═════════════════════════════════════════════════════════════════════
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

        // ═════════════════════════════════════════════════════════════════════
        // BODY
        // ═════════════════════════════════════════════════════════════════════
        body: Column(
          children: [
            // ─────────────────────────────────────────────────────────────────
            // MAIN SCROLL AREA
            // ─────────────────────────────────────────────────────────────────
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
                          // ═══════════════════════════════════════════════════
                          // HEADER
                          // ═══════════════════════════════════════════════════
                          ProductFormHeader(
                            title: _stepTitles[_currentStep],

                            description: _stepDescriptions[_currentStep],
                          ),

                          const SizedBox(height: 20),

                          // ═══════════════════════════════════════════════════
                          // PROGRESS
                          // ═══════════════════════════════════════════════════
                          _buildStepProgress(),

                          const SizedBox(height: 20),

                          // ═══════════════════════════════════════════════════
                          // NOTICE
                          // ═══════════════════════════════════════════════════
                          if (_formNotice != null) ...[
                            ProductFormNotice(
                              message: _formNotice!,

                              type: ProductFormNoticeType.info,

                              onClose: _clearNotice,
                            ),

                            const SizedBox(height: 20),
                          ],

                          // ═══════════════════════════════════════════════════
                          // CURRENT STEP
                          // ═══════════════════════════════════════════════════
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

            // ═════════════════════════════════════════════════════════════════
            // BOTTOM NEXT / BACK
            // ═════════════════════════════════════════════════════════════════
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
