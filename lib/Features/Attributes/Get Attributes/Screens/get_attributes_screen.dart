import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../../Delete Attributes/Controller/delete_attributes_controller.dart';
import '../../Edit Attributes/Screens/edit_attribute_screen.dart';
import '../Controllers/get_attributes_controller.dart';
import '../Models/get_attributes_model.dart';
import '../Reuse Widgets/attribute_card.dart';
import '../Reuse Widgets/attribute_stat_card.dart';
import '../Reuse Widgets/attributes_empty_state.dart';
import '../Reuse Widgets/attributes_error_state.dart';
import '../Reuse Widgets/attributes_loading.dart';
import '../Reuse widgets/attributes_header.dart';

class GetAttributesScreen extends ConsumerStatefulWidget {
  const GetAttributesScreen({super.key, required this.onAddAttribute});

  // ============================================================
  // Future CRUD Hook
  // ============================================================

  final VoidCallback onAddAttribute;

  @override
  ConsumerState<GetAttributesScreen> createState() =>
      _GetAttributesScreenState();
}

class _GetAttributesScreenState extends ConsumerState<GetAttributesScreen> {
  // ============================================================
  // State
  // ============================================================

  GetAttributesModel? _attributesResponse;

  bool _isLoading = false;
  String? _errorMessage;

  // ============================================================
  // Delete State
  // ============================================================

  int? _deletingAttributeId;

  // ============================================================
  // Lifecycle
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
    if (!mounted) return;

    setState(() {
      if (showFullLoading) {
        _isLoading = true;
      }

      _errorMessage = null;
    });

    try {
      final controller = ref.read(getAttributesControllerProvider);

      final response = await controller.getAttributes();

      if (!mounted) return;

      setState(() {
        _attributesResponse = response;
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = _extractErrorMessage(error);
      });
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

    if (attributeId == null) {
      _showErrorSnackBar('Unable to edit attribute. Attribute ID is missing.');
      return;
    }

    // ----------------------------------------------------------
    // Open Edit Screen
    // ----------------------------------------------------------

    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EditAttributeScreen(
          attributeId: attributeId,
          initialName: attribute.name ?? '',
          initialInputType: attribute.inputType ?? 'text',
          initialIsActive: attribute.isActive,
          initialSlug: attribute.slug,
        ),
      ),
    );

    // ----------------------------------------------------------
    // Refresh List After Successful Update
    // ----------------------------------------------------------

    if (!mounted) {
      return;
    }

    if (result != null) {
      await _loadAttributes(showFullLoading: false);
    }
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

    if (attributeId == null) {
      _showErrorSnackBar(
        'Unable to delete attribute. Attribute ID is missing.',
      );
      return;
    }

    // ----------------------------------------------------------
    // Prevent Duplicate Delete
    // ----------------------------------------------------------

    if (_deletingAttributeId != null) {
      return;
    }

    // ----------------------------------------------------------
    // Show Confirmation Dialog
    // ----------------------------------------------------------

    final shouldDelete = await _showDeleteConfirmation(
      attributeName: attribute.name ?? 'this attribute',
    );

    if (!mounted || !shouldDelete) {
      return;
    }

    // ----------------------------------------------------------
    // Start Delete Loading
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
      // API SUCCESS
      // --------------------------------------------------------

      if (response.success) {
        _showSuccessSnackBar(
          response.message ?? 'Attribute deleted successfully.',
        );

        setState(() {
          _deletingAttributeId = null;
        });

        // ------------------------------------------------------
        // Refresh Attributes
        // ------------------------------------------------------

        await _loadAttributes(showFullLoading: false);
      } else {
        // ------------------------------------------------------
        // API returned success = false
        // ------------------------------------------------------

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
  // DELETE CONFIRMATION
  // ============================================================

  Future<bool> _showDeleteConfirmation({required String attributeName}) async {
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
                  'Delete Attribute',
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to delete '
            '"$attributeName"?\n\n'
            'This action cannot be undone.',
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
  // SUCCESS SNACKBAR
  // ============================================================

  void _showSuccessSnackBar(String message) {
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
  // ERROR MESSAGE
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
            return _loadAttributes(showFullLoading: false);
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
    // Initial Loading
    // ----------------------------------------------------------

    if (_isLoading && _attributesResponse == null) {
      return _buildLoadingView();
    }

    // ----------------------------------------------------------
    // Initial Error
    // ----------------------------------------------------------

    if (_errorMessage != null && _attributesResponse == null) {
      return _buildErrorView();
    }

    // ----------------------------------------------------------
    // Loaded Content
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderSkeleton(),

                const SizedBox(height: 20),

                _buildStatsSkeleton(),

                const SizedBox(height: 20),

                const AttributesLoading(),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // HEADER SKELETON
  // ============================================================

  Widget _buildHeaderSkeleton() {
    return Container(
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.shimmerCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
    );
  }

  // ============================================================
  // STATS SKELETON
  // ============================================================

  Widget _buildStatsSkeleton() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        int columns;

        if (width >= 1100) {
          columns = 4;
        } else if (width >= 650) {
          columns = 2;
        } else {
          columns = 1;
        }

        const spacing = 14.0;

        final itemWidth = columns == 1
            ? width
            : (width - ((columns - 1) * spacing)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: List.generate(4, (_) {
            return Container(
              width: itemWidth,
              height: 126,
              decoration: BoxDecoration(
                color: AppColors.shimmerCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
            );
          }),
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
              onRetry: _loadAttributes,
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
                AttributesHeader(onAddAttribute: widget.onAddAttribute),

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
    return SizedBox(
      width: double.infinity,
      child: const AttributesEmptyState(),
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

            // ----------------------------------------------------
            // IMPORTANT
            //
            // isOwn = true
            //   -> Vendor/custom attribute
            //   -> Edit/Delete available
            //
            // isOwn = false
            //   -> System/platform attribute
            //   -> Edit/Delete hidden
            // ----------------------------------------------------

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
              // ATTRIBUTE VALUE / VARIANT ACTIONS
              // ==================================================
              //
              // Currently no value CRUD handlers are implemented
              // on this screen.
              //
              // Once Add/Edit/Delete Value APIs are implemented,
              // use:
              //
              // onAddValue: canEdit ? handler : null
              // onEditValue: canEdit ? handler : null
              // onDeleteValue: canEdit ? handler : null
              //
              // This ensures system attributes can never modify
              // their variants/values.
              // ==================================================
              onAddValue: null,
              onEditValue: null,
              onDeleteValue: null,
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
