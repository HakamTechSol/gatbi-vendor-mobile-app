import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../Routes/app_route.dart';
import '../../../../Services/api_exception.dart';
import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../../Delete Attributes/Controller/delete_attributes_controller.dart';

import '../../Varient/Add Varient/Models/add_variant_model.dart';

import '../../Varient/Delete Varient/Controller/delete_variant_controller.dart';

import '../Controllers/get_attributes_controller.dart';
import '../Models/get_attributes_model.dart';
import '../Reuse Widgets/attribute_card.dart';
import '../Reuse Widgets/attribute_stat_card.dart';
import '../Reuse Widgets/attributes_empty_state.dart';
import '../Reuse Widgets/attributes_error_state.dart';
import '../Reuse Widgets/attributes_loading.dart';
import '../Reuse widgets/attributes_header.dart';

class GetAttributesScreen extends ConsumerStatefulWidget {
  const GetAttributesScreen({super.key});

  @override
  ConsumerState<GetAttributesScreen> createState() =>
      _GetAttributesScreenState();
}

class _GetAttributesScreenState extends ConsumerState<GetAttributesScreen> {
  // ============================================================
  // STATE
  // ============================================================

  GetAttributesModel? _attributesResponse;

  bool _isLoading = false;
  String? _errorMessage;

  // ============================================================
  // ATTRIBUTE DELETE STATE
  // ============================================================

  int? _deletingAttributeId;

  // ============================================================
  // VARIANT DELETE STATE
  // ============================================================

  int? _deletingVariantId;

  // ============================================================
  // LIFECYCLE
  // ============================================================

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAttributes();
    });
  }

  // ============================================================
  // GET ATTRIBUTES
  // ============================================================

  Future<void> _loadAttributes({bool showFullLoading = true}) async {
    if (!mounted) {
      return;
    }

    setState(() {
      if (showFullLoading) {
        _isLoading = true;
      }

      _errorMessage = null;
    });

    try {
      final controller = ref.read(getAttributesControllerProvider);

      final response = await controller.getAttributes();

      if (!mounted) {
        return;
      }

      setState(() {
        _attributesResponse = response;
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage = _extractErrorMessage(error);
      });
    }
  }

  // ============================================================
  // ADD ATTRIBUTE
  // ============================================================

  Future<void> _handleOnAddAttribute() async {
    if (_deletingAttributeId != null || _deletingVariantId != null) {
      return;
    }

    // ----------------------------------------------------------
    // Open Add Attribute Route
    // ----------------------------------------------------------

    final result = await context.push(AppRoutes.addAttributes);

    // ----------------------------------------------------------
    // Screen Closed
    // ----------------------------------------------------------

    if (!mounted) {
      return;
    }

    // ----------------------------------------------------------
    // ALWAYS REFRESH WITH FULL SHIMMER
    // ----------------------------------------------------------

    await _loadAttributes(showFullLoading: true);

    // ----------------------------------------------------------
    // SUCCESS MESSAGE
    // ----------------------------------------------------------

    if (!mounted) {
      return;
    }

    if (result != null) {
      try {
        final dynamic response = result;

        if (response.success == true) {
          _showSuccessSnackBar(
            response.message ?? 'Attribute created successfully.',
          );
        }
      } catch (_) {
        // Ignore invalid route result.
      }
    }
  }

  // ============================================================
  // EDIT ATTRIBUTE
  // ============================================================

  Future<void> _handleOnEdit(GetAttributeModel attribute) async {
    // ----------------------------------------------------------
    // Only Own / Custom Attributes Can Be Edited
    // ----------------------------------------------------------

    if (!attribute.isOwn) {
      _showErrorSnackBar('This system attribute cannot be edited.');
      return;
    }

    // ----------------------------------------------------------
    // Validate Attribute ID
    // ----------------------------------------------------------

    final attributeId = attribute.id;

    if (attributeId == null || attributeId <= 0) {
      _showErrorSnackBar('Unable to edit attribute. Attribute ID is missing.');
      return;
    }

    // ----------------------------------------------------------
    // DEBUG
    // ----------------------------------------------------------

    debugPrint('');
    debugPrint('========== EDIT ATTRIBUTE NAVIGATION ==========');
    debugPrint('ATTRIBUTE ID: $attributeId');
    debugPrint('ATTRIBUTE NAME: ${attribute.name ?? 'N/A'}');
    debugPrint('ATTRIBUTE INPUT TYPE: ${attribute.inputType ?? 'N/A'}');
    debugPrint('ATTRIBUTE IS ACTIVE: ${attribute.isActive}');
    debugPrint('ATTRIBUTE SLUG: ${attribute.slug ?? 'N/A'}');
    debugPrint('================================================');
    debugPrint('');

    // ----------------------------------------------------------
    // OPEN EDIT ATTRIBUTE ROUTE
    // ----------------------------------------------------------

    await context.push(
      AppRoutes.editAttributes,
      extra: {
        'attributeId': attributeId,
        'initialName': attribute.name ?? '',
        'initialInputType': attribute.inputType ?? 'text',
        'initialIsActive': attribute.isActive,
        'initialSlug': attribute.slug,
      },
    );

    // ----------------------------------------------------------
    // Screen Closed
    // Always Refresh With Full Shimmer
    // ----------------------------------------------------------

    if (!mounted) {
      return;
    }

    await _loadAttributes(showFullLoading: true);
  }

  // ============================================================
  // DELETE ATTRIBUTE
  // ============================================================

  Future<void> _handleOnDelete(GetAttributeModel attribute) async {
    // ----------------------------------------------------------
    // Only Own / Custom Attributes Can Be Deleted
    // ----------------------------------------------------------

    if (!attribute.isOwn) {
      _showErrorSnackBar('This system attribute cannot be deleted.');
      return;
    }

    // ----------------------------------------------------------
    // Validate Attribute ID
    // ----------------------------------------------------------

    final attributeId = attribute.id;

    if (attributeId == null || attributeId <= 0) {
      _showErrorSnackBar(
        'Unable to delete attribute. Attribute ID is missing.',
      );
      return;
    }

    // ----------------------------------------------------------
    // Prevent Duplicate Delete
    // ----------------------------------------------------------

    if (_deletingAttributeId != null || _deletingVariantId != null) {
      return;
    }

    // ----------------------------------------------------------
    // Confirmation
    // ----------------------------------------------------------

    final shouldDelete = await _showDeleteConfirmation(
      title: 'Delete Attribute',
      itemName: attribute.name ?? 'this attribute',
      message:
          'Are you sure you want to delete '
          '"${attribute.name ?? 'this attribute'}"?\n\n'
          'All values associated with this attribute may also be '
          'affected.\n\n'
          'This action cannot be undone.',
    );

    if (!mounted || !shouldDelete) {
      return;
    }

    // ----------------------------------------------------------
    // Start Loading
    // ----------------------------------------------------------

    setState(() {
      _deletingAttributeId = attributeId;
    });

    try {
      final controller = ref.read(deleteAttributesControllerProvider);

      // --------------------------------------------------------
      // API CALL
      // --------------------------------------------------------

      final response = await controller.deleteAttribute(id: attributeId);

      if (!mounted) {
        return;
      }

      // --------------------------------------------------------
      // SUCCESS
      // --------------------------------------------------------

      if (response.success) {
        _showSuccessSnackBar(
          response.message ?? 'Attribute deleted successfully.',
        );

        setState(() {
          _deletingAttributeId = null;
        });

        // ------------------------------------------------------
        // Refresh With Shimmer
        // ------------------------------------------------------

        await _loadAttributes(showFullLoading: true);
      } else {
        setState(() {
          _deletingAttributeId = null;
        });

        _showErrorSnackBar(response.message ?? 'Unable to delete attribute.');
      }
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _deletingAttributeId = null;
      });

      _showErrorSnackBar(
        error.message.isNotEmpty
            ? error.message
            : 'Unable to delete attribute.',
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _deletingAttributeId = null;
      });

      _showErrorSnackBar(_extractErrorMessage(error));
    }
  }

  // ============================================================
  // ADD VARIANT
  // ============================================================

  Future<void> _handleOnAddValue(GetAttributeModel attribute) async {
    // ----------------------------------------------------------
    // Validate Attribute ID
    // ----------------------------------------------------------

    if (attribute.id == null || attribute.id! <= 0) {
      _showErrorMessage('Attribute ID is missing.');
      return;
    }

    // ----------------------------------------------------------
    // Only Own Attributes
    // ----------------------------------------------------------

    if (!attribute.isOwn) {
      _showErrorMessage('System attributes cannot be modified.');
      return;
    }

    // ----------------------------------------------------------
    // Prevent Navigation During Delete
    // ----------------------------------------------------------

    if (_deletingAttributeId != null || _deletingVariantId != null) {
      return;
    }

    // ----------------------------------------------------------
    // Open Add Variant
    // ----------------------------------------------------------

    final result = await context.push(AppRoutes.addVariant, extra: attribute);

    // ----------------------------------------------------------
    // Screen Closed
    // ----------------------------------------------------------

    if (!mounted) {
      return;
    }

    // ----------------------------------------------------------
    // Always Refresh After Returning
    // ----------------------------------------------------------

    await _loadAttributes(showFullLoading: true);

    // ----------------------------------------------------------
    // Success Feedback
    // ----------------------------------------------------------

    if (!mounted) {
      return;
    }

    if (result is AddVariantModel && result.success) {
      _showSuccessSnackBar(result.message ?? 'Variant added successfully.');
    }
  }

  // ============================================================
  // EDIT VARIANT
  // ============================================================

  Future<void> _handleOnEditValue(
    GetAttributeModel attribute,
    GetAttributeValueModel variant,
  ) async {
    // ============================================================
    // VALIDATE ATTRIBUTE
    // ============================================================

    if (!attribute.isOwn) {
      _showErrorMessage('System attributes cannot be modified.');
      return;
    }

    // ============================================================
    // VALIDATE ATTRIBUTE ID
    // ============================================================

    final attributeId = attribute.id;

    if (attributeId == null || attributeId <= 0) {
      _showErrorMessage('Attribute ID is missing.');
      return;
    }

    // ============================================================
    // VALIDATE VARIANT ID
    // ============================================================

    final variantId = variant.id;

    if (variantId == null || variantId <= 0) {
      _showErrorMessage('Variant ID is missing.');
      return;
    }

    // ============================================================
    // PREVENT DUPLICATE ACTION
    // ============================================================

    if (_deletingAttributeId != null || _deletingVariantId != null) {
      return;
    }

    // ============================================================
    // DEBUG
    // ============================================================

    debugPrint('');
    debugPrint('========== EDIT VARIANT NAVIGATION ==========');
    debugPrint('ATTRIBUTE ID: $attributeId');
    debugPrint('ATTRIBUTE NAME: ${attribute.name ?? 'N/A'}');
    debugPrint('ATTRIBUTE IS OWN: ${attribute.isOwn}');
    debugPrint('');
    debugPrint('VARIANT ID: $variantId');
    debugPrint('VARIANT VALUE: ${variant.value ?? 'N/A'}');
    debugPrint('VARIANT CODE: ${variant.code ?? 'N/A'}');
    debugPrint('VARIANT SORT ORDER: ${variant.sortOrder ?? 'N/A'}');
    debugPrint('VARIANT IS ACTIVE: ${variant.isActive}');
    debugPrint('=============================================');
    debugPrint('');

    // ============================================================
    // NAVIGATE
    // ============================================================

    final result = await context.push(
      AppRoutes.editVariant,
      extra: {'attribute': attribute, 'variant': variant},
    );

    // ============================================================
    // SCREEN CLOSED
    // ============================================================

    if (!mounted) {
      return;
    }

    // ============================================================
    // ALWAYS REFRESH WITH SHIMMER
    // ============================================================

    await _loadAttributes(showFullLoading: true);

    // ============================================================
    // SUCCESS MESSAGE
    // ============================================================

    if (!mounted) {
      return;
    }

    if (result != null) {
      try {
        final dynamic response = result;

        if (response.success == true) {
          _showSuccessSnackBar(
            response.message ?? 'Variant updated successfully.',
          );
        }
      } catch (_) {
        // Ignore invalid route result.
      }
    }
  }

  // ============================================================
  // DELETE VARIANT
  // ============================================================

  Future<void> _handleOnDeleteValue(
    GetAttributeModel attribute,
    GetAttributeValueModel variant,
  ) async {
    // ============================================================
    // ONLY OWN ATTRIBUTES
    // ============================================================

    if (!attribute.isOwn) {
      _showErrorMessage('System attributes cannot be modified.');
      return;
    }

    // ============================================================
    // VALIDATE ATTRIBUTE ID
    // ============================================================

    final attributeId = attribute.id;

    if (attributeId == null || attributeId <= 0) {
      _showErrorMessage('Attribute ID is missing.');
      return;
    }

    // ============================================================
    // VALIDATE VARIANT ID
    // ============================================================

    final variantId = variant.id;

    if (variantId == null || variantId <= 0) {
      _showErrorMessage('Variant ID is missing.');
      return;
    }

    // ============================================================
    // PREVENT DUPLICATE DELETE
    // ============================================================

    if (_deletingVariantId != null || _deletingAttributeId != null) {
      return;
    }

    // ============================================================
    // CONFIRMATION POPUP
    // ============================================================

    final variantName = variant.value?.trim().isNotEmpty == true
        ? variant.value!.trim()
        : 'this variant';

    final shouldDelete = await _showDeleteConfirmation(
      title: 'Delete Variant',
      itemName: variantName,
      message:
          'Are you sure you want to delete '
          '"$variantName"?\n\n'
          'This variant will be permanently removed from '
          '"${attribute.name ?? 'this attribute'}".\n\n'
          'This action cannot be undone.',
    );

    // ============================================================
    // CANCELLED
    // ============================================================

    if (!mounted || !shouldDelete) {
      return;
    }

    // ============================================================
    // DEBUG
    // ============================================================

    debugPrint('');
    debugPrint('========== DELETE VARIANT START ==========');
    debugPrint('ATTRIBUTE ID: $attributeId');
    debugPrint('ATTRIBUTE NAME: ${attribute.name ?? 'N/A'}');
    debugPrint('VARIANT ID: $variantId');
    debugPrint('VARIANT VALUE: ${variant.value ?? 'N/A'}');
    debugPrint('==========================================');
    debugPrint('');

    // ============================================================
    // START DELETE LOADING
    // ============================================================

    setState(() {
      _deletingVariantId = variantId;
    });

    try {
      // ==========================================================
      // CONTROLLER
      // ==========================================================

      final controller = ref.read(deleteVariantControllerProvider);

      // ==========================================================
      // API CALL
      // ==========================================================

      final response = await controller.deleteVariant(valueId: variantId);

      if (!mounted) {
        return;
      }

      // ==========================================================
      // API SUCCESS
      // ==========================================================

      if (response.success) {
        // --------------------------------------------------------
        // Clear Delete State
        // --------------------------------------------------------

        setState(() {
          _deletingVariantId = null;
        });

        // --------------------------------------------------------
        // SUCCESS MESSAGE
        // --------------------------------------------------------

        _showSuccessSnackBar(
          response.message ?? 'Variant deleted successfully.',
        );

        // --------------------------------------------------------
        // Refresh Get Attributes
        // Full shimmer will be shown.
        // --------------------------------------------------------

        await _loadAttributes(showFullLoading: true);
      } else {
        // --------------------------------------------------------
        // API Returned success = false
        // --------------------------------------------------------

        setState(() {
          _deletingVariantId = null;
        });

        _showErrorSnackBar(response.message ?? 'Unable to delete variant.');
      }
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      // ----------------------------------------------------------
      // Clear Loading
      // ----------------------------------------------------------

      setState(() {
        _deletingVariantId = null;
      });

      // ----------------------------------------------------------
      // API ERROR
      // ----------------------------------------------------------

      _showErrorSnackBar(
        error.message.isNotEmpty ? error.message : 'Unable to delete variant.',
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      // ----------------------------------------------------------
      // Clear Loading
      // ----------------------------------------------------------

      setState(() {
        _deletingVariantId = null;
      });

      // ----------------------------------------------------------
      // UNKNOWN ERROR
      // ----------------------------------------------------------

      _showErrorSnackBar(_extractErrorMessage(error));
    }
  }

  // ============================================================
  // DELETE CONFIRMATION DIALOG
  // ============================================================

  Future<bool> _showDeleteConfirmation({
    required String title,
    required String itemName,
    required String message,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
          actionsPadding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
          title: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.errorLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.errorDark,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: Text(
                'Cancel',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(width: 4),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.errorDark,
                foregroundColor: AppColors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Delete',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  // ============================================================
  // ERROR MESSAGE
  // ============================================================

  void _showErrorMessage(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: AppColors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }

  // ============================================================
  // SUCCESS SNACKBAR
  // ============================================================

  void _showSuccessSnackBar(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.successDark,
          elevation: 6,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Row(
            children: [
              const Icon(
                Icons.check_circle_outline_rounded,
                color: AppColors.white,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  // ============================================================
  // ERROR SNACKBAR
  // ============================================================

  void _showErrorSnackBar(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.errorDark,
          elevation: 6,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Row(
            children: [
              const Icon(
                Icons.error_outline_rounded,
                color: AppColors.white,
                size: 20,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  // ============================================================
  // ERROR MESSAGE EXTRACTOR
  // ============================================================

  String _extractErrorMessage(Object error) {
    if (error is ApiException) {
      return error.message.isNotEmpty
          ? error.message
          : 'Something went wrong. Please try again.';
    }

    final message = error.toString().trim();

    if (message.isEmpty) {
      return 'Something went wrong while loading attributes.';
    }

    if (message.startsWith('Exception: ')) {
      return message.replaceFirst('Exception: ', '');
    }

    return message;
  }

  // ============================================================
  // STATISTICS
  // ============================================================

  int get _totalAttributes {
    return _attributesResponse?.attributes.length ?? 0;
  }

  int get _totalValues {
    final attributes = _attributesResponse?.attributes ?? [];

    return attributes.fold<int>(0, (total, attribute) {
      return total + attribute.values.length;
    });
  }

  int get _customAttributes {
    final attributes = _attributesResponse?.attributes ?? [];

    return attributes.where((attribute) {
      return attribute.isOwn;
    }).length;
  }

  int get _systemAttributes {
    return _totalAttributes - _customAttributes;
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          backgroundColor: AppColors.white,
          onRefresh: () {
            return _loadAttributes(showFullLoading: true);
          },
          child: _buildBody(),
        ),
      ),
    );
  }

  // ============================================================
  // BODY
  // ============================================================

  Widget _buildBody() {
    // ----------------------------------------------------------
    // IMPORTANT:
    // Whenever full loading is requested, show shimmer even if
    // previous API data already exists.
    // ----------------------------------------------------------

    if (_isLoading) {
      return _buildLoadingView();
    }

    // ----------------------------------------------------------
    // Initial Error
    // ----------------------------------------------------------

    if (_errorMessage != null && _attributesResponse == null) {
      return _buildErrorView();
    }

    // ----------------------------------------------------------
    // Content
    // ----------------------------------------------------------

    return _buildContent();
  }

  // ============================================================
  // LOADING VIEW
  // ============================================================

  Widget _buildLoadingView() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight - 40),
            child: const AttributesLoading(),
          ),
        );
      },
    );
  }

  // ============================================================
  // ERROR VIEW
  // ============================================================

  Widget _buildErrorView() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            height: constraints.maxHeight - 40,
            child: AttributesErrorState(
              message:
                  _errorMessage ??
                  'Something went wrong while loading attributes.',
              onRetry: () {
                _loadAttributes(showFullLoading: true);
              },
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // CONTENT
  // ============================================================

  Widget _buildContent() {
    final attributes = _attributesResponse?.attributes ?? [];

    final hasAttributes = attributes.isNotEmpty;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight - 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==================================================
                // HEADER
                // ==================================================
                AttributesHeader(onAddAttribute: _handleOnAddAttribute),

                const SizedBox(height: 20),

                // ==================================================
                // STATISTICS
                // ==================================================
                _buildStats(),

                const SizedBox(height: 24),

                // ==================================================
                // CONTENT
                // ==================================================
                if (!hasAttributes)
                  _buildEmptyState()
                else
                  _buildAttributesList(attributes),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // STATISTICS
  // ============================================================

  Widget _buildStats() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 14.0;

        final cardWidth = (constraints.maxWidth - spacing) / 2;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            SizedBox(
              width: cardWidth,
              child: AttributeStatCard(
                title: 'Total Attributes',
                value: '$_totalAttributes',
                subtitle: 'Available attributes',
                icon: Icons.tune_rounded,
                iconBackgroundColor: AppColors.primaryLight,
                iconColor: AppColors.primary,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: AttributeStatCard(
                title: 'Total Values',
                value: '$_totalValues',
                subtitle: 'Across all attributes',
                icon: Icons.list_alt_rounded,
                iconBackgroundColor: AppColors.purpleLight,
                iconColor: AppColors.purple,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: AttributeStatCard(
                title: 'Custom Attributes',
                value: '$_customAttributes',
                subtitle: 'Vendor created',
                icon: Icons.auto_awesome_rounded,
                iconBackgroundColor: AppColors.successLight,
                iconColor: AppColors.success,
              ),
            ),
            SizedBox(
              width: cardWidth,
              child: AttributeStatCard(
                title: 'System Attributes',
                value: '$_systemAttributes',
                subtitle: 'Platform attributes',
                icon: Icons.settings_suggest_rounded,
                iconBackgroundColor: AppColors.infoLight,
                iconColor: AppColors.info,
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget _buildEmptyState() {
    return const SizedBox(
      width: double.infinity,
      child: AttributesEmptyState(),
    );
  }

  // ============================================================
  // ATTRIBUTES LIST
  // ============================================================

  Widget _buildAttributesList(List<GetAttributeModel> attributes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ========================================================
        // LIST HEADING
        // ========================================================
        _buildListHeading(count: attributes.length),

        const SizedBox(height: 12),

        // ========================================================
        // CARDS
        // ========================================================
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: attributes.length,
          separatorBuilder: (_, __) {
            return const SizedBox(height: 14);
          },
          itemBuilder: (context, index) {
            final attribute = attributes[index];

            final canEdit = attribute.isOwn;

            return AttributeCard(
              attribute: attribute,

              // ==================================================
              // ATTRIBUTE EDIT
              // ==================================================
              onEdit: canEdit ? () => _handleOnEdit(attribute) : null,

              // ==================================================
              // ATTRIBUTE DELETE
              // ==================================================
              onDelete: canEdit ? () => _handleOnDelete(attribute) : null,

              // ==================================================
              // ADD VARIANT
              // ==================================================
              onAddValue: canEdit ? () => _handleOnAddValue(attribute) : null,

              // ==================================================
              // EDIT VARIANT
              // ==================================================
              onEditValue: canEdit
                  ? (variant) {
                      _handleOnEditValue(attribute, variant);
                    }
                  : null,

              // ==================================================
              // DELETE VARIANT
              // ==================================================
              onDeleteValue: canEdit
                  ? (variant) {
                      _handleOnDeleteValue(attribute, variant);
                    }
                  : null,
            );
          },
        ),
      ],
    );
  }

  // ============================================================
  // LIST HEADING
  // ============================================================

  Widget _buildListHeading({required int count}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'All Attributes',
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.surfaceMuted,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '$count '
            '${count == 1 ? 'attribute' : 'attributes'}',
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
