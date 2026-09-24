import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../../../Routes/app_route.dart';
import '../../../Services/file_download_service.dart';

import '../../KYC/Controller/vendor_kyc_controller.dart';

import '../Delete Product/Controller/delete_product_controller.dart';
import 'Bulk Product/bulk_product_controller.dart';
import 'Edit Stock/add_stock_product_screen.dart';

import 'Models/my_product_model.dart';
import 'Controller/my_products_controller.dart';

import 'Product Export CSV/my_product_export_controller.dart';

import 'Reuse Widgets/my_product_card.dart';
import 'Reuse Widgets/my_products_empty_state.dart';
import 'Reuse Widgets/my_products_filter.dart';
import 'Reuse Widgets/my_products_header.dart';
import 'Reuse Widgets/my_products_kyc_card.dart';
import 'Reuse Widgets/my_products_loading.dart';
import 'Reuse Widgets/my_products_search.dart';

// ============================================================
// Screen
// ============================================================

class MyProductScreen extends ConsumerStatefulWidget {
  const MyProductScreen({
    super.key,
    this.onAddProduct,
    this.onProductTap,
    this.onEditProduct,
    this.onStockEdit,
    this.onDeleteProduct,
  });

  // ============================================================
  // CALLBACKS
  // ============================================================

  final VoidCallback? onAddProduct;

  final ValueChanged<MyProductModel>? onProductTap;

  final ValueChanged<MyProductModel>? onEditProduct;

  final ValueChanged<MyProductModel>? onStockEdit;

  final ValueChanged<MyProductModel>? onDeleteProduct;

  @override
  ConsumerState<MyProductScreen> createState() => MyProductScreenState();
}

// ============================================================
// State
// ============================================================

class MyProductScreenState extends ConsumerState<MyProductScreen> {
  // ============================================================
  // Services
  // ============================================================

  final FileDownloadService _fileDownloadService = const FileDownloadService();

  // ============================================================
  // Controllers
  // ============================================================

  late final TextEditingController _searchController;

  late final ScrollController _scrollController;

  // ============================================================
  // KYC STATE
  // ============================================================

  bool _isKycLoading = true;

  String? _kycStatus;

  String? _kycStatusLabel;

  // ============================================================
  // Export
  // ============================================================

  bool _isExportingCsv = false;

  // ============================================================
  // Search
  // ============================================================

  String _searchQuery = '';

  // ============================================================
  // Bulk Action
  // ============================================================

  String? _selectedAction;

  final Set<int> _selectedProductIds = <int>{};

  bool _isApplyingBulkAction = false;

  // ============================================================
  // Refresh
  // ============================================================

  bool _isRefreshing = false;

  // ============================================================
  // Init
  // ============================================================

  @override
  void initState() {
    super.initState();

    _searchController = TextEditingController();

    _scrollController = ScrollController();

    _scrollController.addListener(_handleScroll);

    // ----------------------------------------------------------
    // IMPORTANT:
    // API calls are started after first frame.
    // ----------------------------------------------------------

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      unawaited(_loadKycStatus());

      unawaited(_loadInitialProducts());
    });
  }

  // ============================================================
  // KYC
  // ============================================================

  Future<void> _loadKycStatus() async {
    if (!mounted) {
      return;
    }

    try {
      debugPrint('');
      debugPrint(
        '============================================================',
      );
      debugPrint('[MyProductScreen] KYC STATUS REQUEST START');
      debugPrint(
        '============================================================',
      );

      final result = await ref.read(vendorKycControllerProvider).getVendorKyc();

      if (!mounted) {
        return;
      }

      final kyc = result.kyc;

      // --------------------------------------------------------
      // Normalize API values immediately.
      // --------------------------------------------------------

      final status = kyc?.status?.trim().toLowerCase();

      final statusLabel = kyc?.statusLabel?.trim().toLowerCase();

      debugPrint('');
      debugPrint(
        '============================================================',
      );
      debugPrint('[MyProductScreen] KYC STATUS RESPONSE');
      debugPrint('[MyProductScreen] Status: $status');
      debugPrint('[MyProductScreen] Status Label: $statusLabel');
      debugPrint(
        '============================================================',
      );

      // --------------------------------------------------------
      // Update only local KYC state.
      //
      // IMPORTANT:
      // KYC card is now OUTSIDE CustomScrollView/slivers.
      // --------------------------------------------------------

      setState(() {
        _kycStatus = status;
        _kycStatusLabel = statusLabel;
        _isKycLoading = false;
      });
    } on ApiException catch (error) {
      debugPrint('');
      debugPrint(
        '============================================================',
      );
      debugPrint('[MyProductScreen] KYC API ERROR');
      debugPrint('[MyProductScreen] Code: ${error.code}');
      debugPrint('[MyProductScreen] Message: ${error.message}');
      debugPrint(
        '============================================================',
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _isKycLoading = false;
      });
    } catch (error) {
      debugPrint('');
      debugPrint(
        '============================================================',
      );
      debugPrint('[MyProductScreen] KYC UNKNOWN ERROR');
      debugPrint('[MyProductScreen] Error: $error');
      debugPrint(
        '============================================================',
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _isKycLoading = false;
      });
    }
  }

  // ============================================================
  // KYC Visibility
  // ============================================================

  bool get _shouldShowKycCard {
    final status = (_kycStatus ?? '').trim().toLowerCase();

    final statusLabel = (_kycStatusLabel ?? '').trim().toLowerCase();

    // ============================================================
    // APPROVED
    // ============================================================

    if (status == 'approved' || status == 'verified' || status == 'accepted') {
      return false;
    }

    // ============================================================
    // REJECTED
    // ============================================================

    if (status == 'rejected' || status == 'declined' || status == 'denied') {
      return true;
    }

    // ============================================================
    // PENDING
    // ============================================================

    if (status == 'pending') {
      return true;
    }

    // ============================================================
    // UNDER REVIEW
    // ============================================================

    if (status == 'under_review' ||
        status == 'underreview' ||
        status == 'review' ||
        status == 'in_review' ||
        status == 'in review') {
      return true;
    }

    // ============================================================
    // NOT SUBMITTED
    // ============================================================

    if (statusLabel == 'not_submitted' ||
        statusLabel == 'not-submitted' ||
        statusLabel == 'not submitted' ||
        statusLabel == 'not submitted yet' ||
        statusLabel == 'not submitted yet.') {
      return true;
    }

    return false;
  }

  // ============================================================
  // Open KYC
  // ============================================================

  Future<void> _openKycScreen() async {
    FocusScope.of(context).unfocus();

    debugPrint('');
    debugPrint('============================================================');
    debugPrint('[MyProductScreen] OPENING KYC SCREEN');
    debugPrint('============================================================');

    // ----------------------------------------------------------
    // Wait until KYC screen is completely closed.
    // ----------------------------------------------------------

    await context.push(AppRoutes.kyc);

    if (!mounted) {
      return;
    }

    // ----------------------------------------------------------
    // IMPORTANT:
    // Wait one frame after route transition before changing
    // KYC/products state.
    // ----------------------------------------------------------

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      debugPrint('');
      debugPrint(
        '============================================================',
      );
      debugPrint('[MyProductScreen] RETURNED FROM KYC SCREEN');
      debugPrint('[MyProductScreen] Refreshing KYC + Products');
      debugPrint(
        '============================================================',
      );

      unawaited(_loadKycStatus());

      unawaited(_refreshProductsAfterKyc());
    });
  }

  // ============================================================
  // Refresh After KYC
  // ============================================================

  Future<void> _refreshProductsAfterKyc() async {
    if (!mounted) {
      return;
    }

    try {
      await ref.read(myProductsControllerProvider.notifier).refresh();

      if (!mounted) {
        return;
      }

      _cleanupSelectedProductIds();

      debugPrint('[MyProductScreen] PRODUCTS REFRESHED AFTER KYC');
    } on ApiException catch (error) {
      debugPrint(
        '[MyProductScreen] PRODUCTS REFRESH AFTER KYC ERROR: '
        '${error.message}',
      );
    } catch (error) {
      debugPrint(
        '[MyProductScreen] PRODUCTS REFRESH AFTER KYC UNKNOWN ERROR: '
        '$error',
      );
    }
  }

  // ============================================================
  // Initial API Load
  // ============================================================

  Future<void> _loadInitialProducts() async {
    try {
      await ref.read(myProductsControllerProvider.notifier).getProducts();
    } on ApiException catch (error) {
      debugPrint(
        '[MyProductScreen] INITIAL PRODUCTS API ERROR: '
        '${error.message}',
      );
    } catch (error) {
      debugPrint('[MyProductScreen] INITIAL PRODUCTS UNKNOWN ERROR: $error');
    }
  }

  // ============================================================
  // Dispose
  // ============================================================

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);

    _scrollController.dispose();

    _searchController.dispose();

    super.dispose();
  }

  // ============================================================
  // Scroll / Pagination
  // ============================================================

  void _handleScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final position = _scrollController.position;

    if (position.pixels >= position.maxScrollExtent - 300) {
      unawaited(_loadMore());
    }
  }

  Future<void> _loadMore() async {
    final controller = ref.read(myProductsControllerProvider.notifier);

    final state = ref.read(myProductsControllerProvider);

    if (state.isLoading || state.isLoadingMore || !state.hasMore) {
      return;
    }

    try {
      await controller.loadNextPage();
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      _showMessage(error.message, isError: true);
    } catch (error) {
      debugPrint('[MyProductScreen] LOAD MORE ERROR: $error');

      if (!mounted) {
        return;
      }

      _showMessage('Unable to load more products.', isError: true);
    }
  }

  // ============================================================
  // Public Refresh
  // ============================================================

  Future<void> refresh() async {
    if (!mounted) {
      return;
    }

    if (_isRefreshing) {
      debugPrint('[MyProductScreen] REFRESH SKIPPED: Already refreshing.');

      return;
    }

    debugPrint('');
    debugPrint('════════════════════════════════════════════════════════════');
    debugPrint('[MyProductScreen] PUBLIC REFRESH START');
    debugPrint('════════════════════════════════════════════════════════════');

    setState(() {
      _isRefreshing = true;
    });

    try {
      // --------------------------------------------------------
      // Refresh products.
      // --------------------------------------------------------

      await ref.read(myProductsControllerProvider.notifier).refresh();

      if (!mounted) {
        return;
      }

      _cleanupSelectedProductIds();

      // --------------------------------------------------------
      // Also refresh KYC status.
      // --------------------------------------------------------

      try {
        final result = await ref
            .read(vendorKycControllerProvider)
            .getVendorKyc();

        if (!mounted) {
          return;
        }

        final kyc = result.kyc;

        final status = kyc?.status?.trim().toLowerCase();

        final statusLabel = kyc?.statusLabel?.trim().toLowerCase();

        setState(() {
          _kycStatus = status;
          _kycStatusLabel = statusLabel;
          _isKycLoading = false;
        });

        debugPrint('[MyProductScreen] REFRESHED KYC STATUS: $status');

        debugPrint('[MyProductScreen] REFRESHED KYC LABEL: $statusLabel');
      } on ApiException catch (error) {
        debugPrint(
          '[MyProductScreen] KYC REFRESH ERROR: '
          '${error.message}',
        );
      } catch (error) {
        debugPrint('[MyProductScreen] KYC REFRESH UNKNOWN ERROR: $error');
      }

      final state = ref.read(myProductsControllerProvider);

      debugPrint('');
      debugPrint(
        '════════════════════════════════════════════════════════════',
      );
      debugPrint('[MyProductScreen] PUBLIC REFRESH SUCCESS');
      debugPrint(
        '[MyProductScreen] Products: '
        '${state.products.length}',
      );
      debugPrint(
        '[MyProductScreen] Current Page: '
        '${state.currentPage}',
      );
      debugPrint(
        '[MyProductScreen] Total Pages: '
        '${state.totalPages}',
      );
      debugPrint(
        '[MyProductScreen] Total Items: '
        '${state.totalItems}',
      );
      debugPrint(
        '════════════════════════════════════════════════════════════',
      );
    } on ApiException catch (error) {
      debugPrint('[MyProductScreen] PUBLIC REFRESH API ERROR');

      debugPrint('CODE: ${error.code}');

      debugPrint('MESSAGE: ${error.message}');

      if (!mounted) {
        return;
      }

      _showMessage(error.message, isError: true);
    } catch (error) {
      debugPrint('[MyProductScreen] PUBLIC REFRESH ERROR: $error');

      if (!mounted) {
        return;
      }

      _showMessage('Unable to refresh products.', isError: true);
    } finally {
      if (!mounted) {
        return;
      }

      // --------------------------------------------------------
      // Defer final refresh-state update.
      // --------------------------------------------------------

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }

        if (!_isRefreshing) {
          return;
        }

        setState(() {
          _isRefreshing = false;
        });
      });
    }
  }

  // ============================================================
  // Search
  // ============================================================

  void _onSearchChanged(String value) {
    if (!mounted) {
      return;
    }

    final query = value.trim().toLowerCase();

    if (_searchQuery == query) {
      return;
    }

    setState(() {
      _searchQuery = query;
    });
  }

  // ============================================================
  // Bulk Action
  // ============================================================

  void _onActionChanged(String? action) {
    if (!mounted) {
      return;
    }

    setState(() {
      _selectedAction = action;
      _selectedProductIds.clear();
    });
  }

  // ============================================================
  // Product Selection
  // ============================================================

  void _onProductSelectionChanged(MyProductModel product, bool isSelected) {
    final productId = product.id;

    if (productId == null || productId <= 0) {
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      if (isSelected) {
        _selectedProductIds.add(productId);
      } else {
        _selectedProductIds.remove(productId);
      }
    });
  }

  // ============================================================
  // Clear Bulk Selection
  // ============================================================

  void _clearBulkSelection() {
    if (!mounted) {
      return;
    }

    setState(() {
      _selectedAction = null;
      _selectedProductIds.clear();
    });
  }

  // ============================================================
  // Cleanup Selection
  // ============================================================

  void _cleanupSelectedProductIds() {
    if (!mounted) {
      return;
    }

    final state = ref.read(myProductsControllerProvider);

    final availableIds = state.products
        .map((product) => product.id)
        .whereType<int>()
        .where((id) => id > 0)
        .toSet();

    final invalidIds = _selectedProductIds
        .where((id) => !availableIds.contains(id))
        .toList();

    if (invalidIds.isEmpty) {
      return;
    }

    _selectedProductIds.removeAll(invalidIds);
  }

  // ============================================================
  // Apply Bulk Action
  // ============================================================

  Future<void> _applyBulkAction() async {
    final action = _selectedAction;

    if (action == null || action.trim().isEmpty) {
      _showMessage('Please select an action.', isError: true);

      return;
    }

    if (_selectedProductIds.isEmpty) {
      _showMessage('Please select at least one product.', isError: true);

      return;
    }

    if (action == 'delete') {
      final shouldDelete = await _showBulkDeleteConfirmation(
        _selectedProductIds.length,
      );

      if (!shouldDelete || !mounted) {
        return;
      }
    }

    if (_isApplyingBulkAction) {
      return;
    }

    setState(() {
      _isApplyingBulkAction = true;
    });

    try {
      final productIds = _selectedProductIds.toList();

      debugPrint('');
      debugPrint(
        '============================================================',
      );
      debugPrint('[MyProductScreen] BULK ACTION');
      debugPrint('[MyProductScreen] Action: $action');
      debugPrint('[MyProductScreen] Product IDs: $productIds');
      debugPrint(
        '[MyProductScreen] Selected count: '
        '${productIds.length}',
      );
      debugPrint(
        '============================================================',
      );

      final result = await ref
          .read(bulkProductControllerProvider)
          .bulkProductAction(action: action, productIds: productIds);

      if (!mounted) {
        return;
      }

      if (result.success) {
        _showMessage(
          result.message ?? '${_formatAction(action)} applied successfully.',
        );

        setState(() {
          _selectedAction = null;
          _selectedProductIds.clear();
        });

        await ref.read(myProductsControllerProvider.notifier).refresh();
      } else {
        _showMessage(
          result.message ?? 'Unable to apply bulk action.',
          isError: true,
        );
      }
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      _showMessage(error.message, isError: true);
    } catch (error) {
      debugPrint('[MyProductScreen] BULK ACTION ERROR: $error');

      if (!mounted) {
        return;
      }

      _showMessage(
        'Unable to apply bulk action. Please try again.',
        isError: true,
      );
    } finally {
      if (!mounted) {
        return;
      }

      setState(() {
        _isApplyingBulkAction = false;
      });
    }
  }

  // ============================================================
  // Bulk Delete Confirmation
  // ============================================================

  Future<bool> _showBulkDeleteConfirmation(int selectedCount) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Delete Products?',
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.navy,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: Text(
            'Are you sure you want to delete '
            '$selectedCount selected product'
            '${selectedCount == 1 ? '' : 's'}? '
            'This action cannot be undone.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: Text(
                'Cancel',
                style: AppTextStyles.buttonText.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: Text(
                'Delete',
                style: AppTextStyles.buttonText.copyWith(
                  color: AppColors.errorDark,
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
  // Action Label
  // ============================================================

  String _formatAction(String action) {
    switch (action) {
      case 'activate':
        return 'Activate';

      case 'deactivate':
        return 'Deactivate';

      case 'delete':
        return 'Delete';

      default:
        return action;
    }
  }

  // ============================================================
  // Delete Product
  // ============================================================

  Future<void> _handleDeleteProduct(MyProductModel product) async {
    final productId = product.id;

    if (productId == null || productId <= 0) {
      _showMessage('Invalid product ID.', isError: true);

      return;
    }

    final shouldDelete = await _showDeleteConfirmation(product);

    if (!shouldDelete || !mounted) {
      return;
    }

    if (widget.onDeleteProduct != null) {
      widget.onDeleteProduct!(product);
      return;
    }

    try {
      debugPrint('');
      debugPrint(
        '============================================================',
      );
      debugPrint('[MyProductScreen] DELETE PRODUCT START');
      debugPrint('[MyProductScreen] Product ID: $productId');
      debugPrint(
        '[MyProductScreen] Product Name: '
        '${product.name ?? 'Unnamed Product'}',
      );
      debugPrint(
        '============================================================',
      );

      final result = await ref
          .read(deleteProductControllerProvider)
          .deleteProduct(productId: productId);

      if (!mounted) {
        return;
      }

      if (result.success) {
        debugPrint('');
        debugPrint(
          '============================================================',
        );
        debugPrint('[MyProductScreen] DELETE PRODUCT SUCCESS');
        debugPrint('[MyProductScreen] Product ID: $productId');
        debugPrint(
          '[MyProductScreen] Message: '
          '${result.message ?? 'Product deleted successfully.'}',
        );
        debugPrint(
          '============================================================',
        );

        _showMessage(result.message ?? 'Product deleted successfully.');

        if (_selectedProductIds.contains(productId)) {
          setState(() {
            _selectedProductIds.remove(productId);
          });
        }

        try {
          debugPrint('');
          debugPrint('========== REFRESH PRODUCTS AFTER DELETE ==========');

          await ref.read(myProductsControllerProvider.notifier).refresh();

          if (!mounted) {
            return;
          }

          _cleanupSelectedProductIds();

          final state = ref.read(myProductsControllerProvider);

          debugPrint(
            '[MyProductScreen] Products: '
            '${state.products.length}',
          );

          debugPrint('===================================================');
        } on ApiException catch (error) {
          if (!mounted) {
            return;
          }

          _showMessage(
            'Product deleted, but products could not be '
            'refreshed: ${error.message}',
            isError: true,
          );
        } catch (error) {
          debugPrint('[MyProductScreen] DELETE REFRESH ERROR: $error');

          if (!mounted) {
            return;
          }

          _showMessage(
            'Product deleted, but products could not be refreshed.',
            isError: true,
          );
        }

        return;
      }

      _showMessage(
        result.message ?? 'Unable to delete product.',
        isError: true,
      );
    } on ApiException catch (error) {
      debugPrint('[MyProductScreen] DELETE PRODUCT API ERROR');

      debugPrint('[MyProductScreen] Product ID: $productId');

      debugPrint('[MyProductScreen] Code: ${error.code}');

      debugPrint('[MyProductScreen] Message: ${error.message}');

      if (!mounted) {
        return;
      }

      _showMessage(
        error.message.isNotEmpty ? error.message : 'Unable to delete product.',
        isError: true,
      );
    } catch (error) {
      debugPrint('[MyProductScreen] DELETE PRODUCT UNKNOWN ERROR: $error');

      if (!mounted) {
        return;
      }

      _showMessage(
        'Unable to delete product. Please try again.',
        isError: true,
      );
    }
  }

  // ============================================================
  // Delete Confirmation
  // ============================================================

  Future<bool> _showDeleteConfirmation(MyProductModel product) async {
    final productName = (product.name ?? 'Unnamed Product').trim();

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Delete Product?',
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.navy,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: Text(
            'Are you sure you want to delete '
            '"$productName"? '
            'This action cannot be undone.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: Text(
                'Cancel',
                style: AppTextStyles.buttonText.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: Text(
                'Delete',
                style: AppTextStyles.buttonText.copyWith(
                  color: AppColors.errorDark,
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
  // Stock Edit
  // ============================================================

  Future<void> _handleStockEdit(MyProductModel product) async {
    if (widget.onStockEdit != null) {
      widget.onStockEdit!(product);
      return;
    }

    final updatedProduct = await showDialog<MyProductModel>(
      context: context,
      builder: (_) {
        return StockEditDialog(product: product);
      },
    );

    if (updatedProduct == null || !mounted) {
      return;
    }

    debugPrint('');
    debugPrint('========== STOCK UPDATED IN PARENT ==========');
    debugPrint('PRODUCT ID: ${updatedProduct.id}');
    debugPrint('PRODUCT NAME: ${updatedProduct.name}');
    debugPrint('OLD STOCK: ${product.stockQuantity}');
    debugPrint('NEW STOCK: ${updatedProduct.stockQuantity}');
    debugPrint('STOCK STATUS: ${updatedProduct.stockStatus}');
    debugPrint('============================================');

    _showMessage(
      updatedProduct.stockQuantity != null
          ? 'Stock updated successfully. New stock: '
                '${updatedProduct.stockQuantity}'
          : 'Stock updated successfully.',
    );

    try {
      await ref.read(myProductsControllerProvider.notifier).refresh();

      if (!mounted) {
        return;
      }

      debugPrint('[MyProductScreen] STOCK REFRESH COMPLETE');
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      _showMessage(
        'Stock updated, but products could not be refreshed: '
        '${error.message}',
        isError: true,
      );
    } catch (error) {
      debugPrint('[MyProductScreen] STOCK REFRESH ERROR: $error');

      if (!mounted) {
        return;
      }

      _showMessage(
        'Stock updated, but products could not be refreshed.',
        isError: true,
      );
    }
  }

  // ============================================================
  // Product Tap
  // ============================================================

  void _handleProductTap(MyProductModel product) {
    if (_selectedAction != null) {
      final productId = product.id;

      if (productId == null || productId <= 0) {
        _showMessage('Invalid product ID.', isError: true);

        return;
      }

      final isSelected = _selectedProductIds.contains(productId);

      _onProductSelectionChanged(product, !isSelected);

      return;
    }

    if (widget.onProductTap != null) {
      widget.onProductTap!(product);
      return;
    }

    final productId = product.id;

    if (productId == null || productId <= 0) {
      _showMessage('Invalid product ID.', isError: true);

      return;
    }

    context.push(AppRoutes.productDetail, extra: productId);
  }

  // ============================================================
  // Edit Product
  // ============================================================

  void _handleEditProduct(MyProductModel product) {
    if (widget.onEditProduct != null) {
      widget.onEditProduct!(product);
      return;
    }

    context.push(AppRoutes.editProduct, extra: product);
  }

  // ============================================================
  // Add Product
  // ============================================================

  void _handleAddProduct() {
    if (widget.onAddProduct != null) {
      widget.onAddProduct!();
      return;
    }

    context.push(AppRoutes.addProduct);
  }

  // ============================================================
  // Export CSV
  // ============================================================

  Future<void> _handleOnExportCsv() async {
    if (_isExportingCsv) {
      return;
    }

    setState(() {
      _isExportingCsv = true;
    });

    try {
      debugPrint('');
      debugPrint(
        '============================================================',
      );
      debugPrint('[MyProductScreen] EXPORT CSV');
      debugPrint(
        '============================================================',
      );

      final controller = ref.read(myProductExportControllerProvider);

      final result = await controller.exportProductsCsv();

      if (result.isEmpty) {
        throw const ApiException(
          message: 'No product data available to export.',
          code: 'EMPTY_CSV',
        );
      }

      final fileName =
          'gatbi_products_'
          '${DateTime.now().millisecondsSinceEpoch}.csv';

      debugPrint('CSV LENGTH: ${result.csvContent.length}');

      debugPrint('FILE NAME: $fileName');

      final file = await _fileDownloadService.saveTextFile(
        content: result.csvContent,
        fileName: fileName,
      );

      debugPrint('FILE SAVED: ${file.path}');

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Products CSV exported successfully.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
    } on ApiException catch (error) {
      debugPrint('[MyProductScreen] EXPORT CSV API ERROR');

      debugPrint('CODE: ${error.code}');

      debugPrint('MESSAGE: ${error.message}');

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              error.message.isNotEmpty
                  ? error.message
                  : 'Unable to export products.',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
    } on FileSystemException catch (error) {
      debugPrint('[MyProductScreen] FILE SAVE ERROR');

      debugPrint('MESSAGE: ${error.message}');

      debugPrint('PATH: ${error.path}');

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              error.message.isNotEmpty
                  ? error.message
                  : 'Unable to save CSV file.',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
    } catch (error) {
      debugPrint('[MyProductScreen] EXPORT CSV UNKNOWN ERROR');

      debugPrint('ERROR: $error');

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Something went wrong while exporting products.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
    } finally {
      if (!mounted) {
        return;
      }

      setState(() {
        _isExportingCsv = false;
      });
    }
  }

  // ============================================================
  // Message
  // ============================================================

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message, maxLines: 2, overflow: TextOverflow.ellipsis),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          backgroundColor: isError ? AppColors.errorDark : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }

  // ============================================================
  // Build
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myProductsControllerProvider);

    final filteredProducts = _getFilteredProducts(state.products);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: _buildScreenContent(
          state: state,
          filteredProducts: filteredProducts,
        ),
      ),
    );
  }

  // ============================================================
  // Screen Content
  // ============================================================

  Widget _buildScreenContent({
    required MyProductsState state,
    required List<MyProductModel> filteredProducts,
  }) {
    // ============================================================
    // KYC LOADING
    // ============================================================
    //
    // KYC status abhi API se aa raha hai.
    // Is waqt products screen show nahi hogi.
    // ============================================================

    if (_isKycLoading) {
      return const Center(
        child: SizedBox(
          width: 28,
          height: 28,
          child: CircularProgressIndicator(strokeWidth: 2.5),
        ),
      );
    }

    // ============================================================
    // KYC PENDING / NOT COMPLETED
    // ============================================================
    //
    // Agar KYC card show hona chahiye:
    //
    // ONLY KYC CARD
    //
    // Header
    // Search
    // Filter
    // Products
    // Empty State
    // Pagination
    //
    // sab hide.
    // ============================================================

    if (_shouldShowKycCard) {
      return Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: MyProductsKycCard(
              status: _kycStatus,
              statusLabel: _kycStatusLabel,
              onPressed: _openKycScreen,
            ),
          ),
        ),
      );
    }

    // ============================================================
    // NORMAL PRODUCTS SCREEN
    // ============================================================

    return Column(
      children: [
        // ==================================================
        // HEADER
        // ==================================================
        _buildHeader(),

        // ==================================================
        // SCROLLABLE CONTENT
        // ==================================================
        Expanded(
          child: RefreshIndicator(
            color: AppColors.primary,
            backgroundColor: AppColors.white,
            onRefresh: refresh,
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                // ==========================================
                // SEARCH + BULK ACTION
                // ==========================================
                SliverToBoxAdapter(child: _buildSearchSection()),

                // ==========================================
                // CONTENT
                // ==========================================
                if (state.isLoading)
                  SliverToBoxAdapter(child: _buildLoading())
                else if (state.errorMessage != null && state.products.isEmpty)
                  SliverToBoxAdapter(
                    child: _buildErrorState(state.errorMessage!),
                  )
                else
                  _buildProductsContent(products: filteredProducts),

                // ==========================================
                // PAGINATION LOADER
                // ==========================================
                if (state.isLoadingMore)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 22),
                      child: Center(
                        child: SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.2),
                        ),
                      ),
                    ),
                  ),

                // ==========================================
                // BOTTOM SPACING
                // ==========================================
                const SliverToBoxAdapter(child: SizedBox(height: 30)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // Header
  // ============================================================

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
      child: MyProductsHeader(
        onAddProduct: _handleAddProduct,
        onExportCsv: _handleOnExportCsv,
      ),
    );
  }

  // ============================================================
  // Search + Bulk Action
  // ============================================================

  Widget _buildSearchSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        children: [
          MyProductsSearch(
            controller: _searchController,
            onChanged: _onSearchChanged,
          ),

          const SizedBox(height: 12),

          MyProductsFilter(
            selectedAction: _selectedAction,
            actions: const ['activate', 'deactivate', 'delete'],
            onActionChanged: _onActionChanged,
            onApply: _applyBulkAction,
            isApplying: _isApplyingBulkAction,
          ),

          if (_selectedAction != null)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: _buildSelectionSummary(),
            ),
        ],
      ),
    );
  }

  // ============================================================
  // Selection Summary
  // ============================================================

  Widget _buildSelectionSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              size: 17,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(width: 9),

          Expanded(
            child: Text(
              _selectedProductIds.isEmpty
                  ? 'Select products to apply '
                        '${_formatAction(_selectedAction!)}'
                  : '${_selectedProductIds.length} product'
                        '${_selectedProductIds.length == 1 ? '' : 's'} selected',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          if (_selectedProductIds.isNotEmpty)
            GestureDetector(
              onTap: _clearBulkSelection,
              child: Text(
                'Clear',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ============================================================
  // Filter Products
  // ============================================================

  List<MyProductModel> _getFilteredProducts(List<MyProductModel> products) {
    final query = _searchQuery;

    return products.where((product) {
      final name = (product.name ?? '').trim().toLowerCase();

      final category = (product.category?.name ?? '').trim().toLowerCase();

      final sku = (product.sku ?? '').trim().toLowerCase();

      final matchesSearch =
          query.isEmpty ||
          name.contains(query) ||
          category.contains(query) ||
          sku.contains(query);

      return matchesSearch;
    }).toList();
  }

  // ============================================================
  // Loading
  // ============================================================

  Widget _buildLoading() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: MyProductsLoading(itemCount: 4),
    );
  }

  // ============================================================
  // Error
  // ============================================================

  Widget _buildErrorState(String message) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.errorDark.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: AppColors.errorDark,
                size: 28,
              ),
            ),

            const SizedBox(height: 14),

            Text(
              'Unable to Load Products',
              textAlign: TextAlign.center,
              style: AppTextStyles.titleSmall.copyWith(
                color: AppColors.navy,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              height: 40,
              child: ElevatedButton.icon(
                onPressed: () {
                  final state = ref.read(myProductsControllerProvider);

                  unawaited(_retryProducts(limit: state.limit));
                },
                icon: const Icon(Icons.refresh_rounded, size: 17),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // Retry
  // ============================================================

  Future<void> _retryProducts({required int limit}) async {
    try {
      await ref
          .read(myProductsControllerProvider.notifier)
          .getProducts(limit: limit);
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      _showMessage(error.message, isError: true);
    } catch (error) {
      debugPrint('[MyProductScreen] RETRY ERROR: $error');

      if (!mounted) {
        return;
      }

      _showMessage('Unable to load products.', isError: true);
    }
  }

  // ============================================================
  // Products Content
  // ============================================================

  Widget _buildProductsContent({required List<MyProductModel> products}) {
    if (products.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          child: MyProductsEmptyState(onAddProduct: _handleAddProduct),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList.separated(
        itemCount: products.length,
        separatorBuilder: (_, _) {
          return const SizedBox(height: 12);
        },
        itemBuilder: (context, index) {
          final product = products[index];

          final productId = product.id;

          final isSelected =
              productId != null && _selectedProductIds.contains(productId);

          return MyProductCard(
            product: product,

            // --------------------------------------------------
            // Selection
            // --------------------------------------------------
            selectionMode: _selectedAction != null,

            isSelected: isSelected,

            onSelectionChanged: (selected) {
              _onProductSelectionChanged(product, selected);
            },

            // --------------------------------------------------
            // Product Detail
            // --------------------------------------------------
            onTap: () {
              _handleProductTap(product);
            },

            // --------------------------------------------------
            // Edit
            // --------------------------------------------------
            onEdit: () {
              _handleEditProduct(product);
            },

            // --------------------------------------------------
            // Stock
            // --------------------------------------------------
            onStockEdit: () {
              _handleStockEdit(product);
            },

            // --------------------------------------------------
            // Delete
            // --------------------------------------------------
            onDelete: () {
              unawaited(_handleDeleteProduct(product));
            },
          );
        },
      ),
    );
  }
}
