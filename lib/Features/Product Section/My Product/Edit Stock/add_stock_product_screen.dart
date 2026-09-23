import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../Models/my_product_model.dart';
import 'Controller/add_stock_product_controller.dart';

class StockEditDialog extends ConsumerStatefulWidget {
  const StockEditDialog({super.key, required this.product});

  final MyProductModel product;

  @override
  ConsumerState<StockEditDialog> createState() => _StockEditDialogState();
}

class _StockEditDialogState extends ConsumerState<StockEditDialog> {
  late final TextEditingController _stockController;
  late final TextEditingController _thresholdController;

  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();

    _stockController = TextEditingController(
      text: (widget.product.stockQuantity ?? 0).toString(),
    );

    _thresholdController = TextEditingController(text: '3');
  }

  @override
  void dispose() {
    _stockController.dispose();
    _thresholdController.dispose();

    super.dispose();
  }

  // ============================================================
  // UPDATE STOCK
  // ============================================================

  Future<void> _updateStock() async {
    if (_isUpdating) {
      return;
    }

    final stockQuantity = int.tryParse(_stockController.text.trim());

    final lowStockThreshold = int.tryParse(_thresholdController.text.trim());

    final productId = widget.product.id;

    // ----------------------------------------------------------
    // Validate Product ID
    // ----------------------------------------------------------

    if (productId == null || productId <= 0) {
      _showError('Invalid product ID.');
      return;
    }

    // ----------------------------------------------------------
    // Validate Stock Quantity
    // ----------------------------------------------------------

    if (stockQuantity == null || stockQuantity < 0) {
      _showError('Please enter a valid stock quantity.');
      return;
    }

    // ----------------------------------------------------------
    // Validate Low Stock Threshold
    // ----------------------------------------------------------

    if (lowStockThreshold == null || lowStockThreshold < 0) {
      _showError('Please enter a valid low stock threshold.');
      return;
    }

    // ----------------------------------------------------------
    // In Stock
    // ----------------------------------------------------------

    final inStock = stockQuantity > 0 ? '1' : '0';

    setState(() {
      _isUpdating = true;
    });

    try {
      if (mounted) {
        FocusScope.of(context).unfocus();
      }

      // --------------------------------------------------------
      // Debug
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('========== STOCK UPDATE FROM DIALOG ==========');
      debugPrint('PRODUCT ID: $productId');
      debugPrint('PRODUCT NAME: ${widget.product.name}');
      debugPrint('STOCK QTY: $stockQuantity');
      debugPrint('IN STOCK: $inStock');
      debugPrint('LOW STOCK THRESHOLD: $lowStockThreshold');
      debugPrint('==============================================');

      // --------------------------------------------------------
      // API
      // --------------------------------------------------------

      final controller = ref.read(addStockProductControllerProvider);

      final result = await controller.addStockProduct(
        productId: productId,
        stockQty: stockQuantity,
        inStock: inStock,
        lowStockThreshold: lowStockThreshold,
      );

      // --------------------------------------------------------
      // Validate API Result
      // --------------------------------------------------------

      if (!result.success) {
        throw ApiException(
          message: result.message?.trim().isNotEmpty == true
              ? result.message!
              : 'Unable to update stock.',
          code: 'STOCK_UPDATE_FAILED',
        );
      }

      final updatedProduct = result.product;

      if (updatedProduct == null) {
        throw const ApiException(
          message:
              'Stock was updated, but updated product data was not received.',
          code: 'INVALID_STOCK_RESPONSE',
        );
      }

      // --------------------------------------------------------
      // Success Debug
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('========== STOCK UPDATE SUCCESS ==========');
      debugPrint('MESSAGE: ${result.message ?? 'Stock updated successfully'}');
      debugPrint('PRODUCT ID: ${updatedProduct.id ?? 'N/A'}');
      debugPrint('PRODUCT NAME: ${updatedProduct.name ?? 'N/A'}');
      debugPrint('NEW STOCK: ${updatedProduct.stockQuantity ?? 0}');
      debugPrint('STOCK STATUS: ${updatedProduct.stockStatus ?? 'N/A'}');
      debugPrint('==========================================');

      if (!mounted) {
        return;
      }

      // --------------------------------------------------------
      // Return Updated Product
      // --------------------------------------------------------

      Navigator.of(context).pop(updatedProduct);
    } on ApiException catch (error) {
      debugPrint('');
      debugPrint('========== STOCK UPDATE API ERROR ==========');
      debugPrint('CODE: ${error.code}');
      debugPrint('MESSAGE: ${error.message}');
      debugPrint('============================================');

      if (!mounted) {
        return;
      }

      _showError(
        error.message.trim().isNotEmpty
            ? error.message
            : 'Unable to update stock.',
      );
    } catch (error) {
      debugPrint('');
      debugPrint('========== STOCK UPDATE UNKNOWN ERROR ==========');
      debugPrint('ERROR: $error');
      debugPrint('================================================');

      if (!mounted) {
        return;
      }

      _showError('Something went wrong. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    }
  }

  // ============================================================
  // SHOW ERROR
  // ============================================================

  void _showError(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    final keyboardHeight = mediaQuery.viewInsets.bottom;

    // ----------------------------------------------------------
    // Responsive Width
    // ----------------------------------------------------------

    final dialogWidth = screenWidth >= 600 ? 460.0 : screenWidth - 32.0;

    // ----------------------------------------------------------
    // Responsive Height
    //
    // Leave some space around the dialog.
    // Also subtract keyboard height when keyboard is visible.
    // ----------------------------------------------------------

    final availableHeight = screenHeight - keyboardHeight;

    final maxDialogHeight = (availableHeight * 0.82).clamp(260.0, 620.0);

    return AlertDialog(
      backgroundColor: AppColors.white,
      insetPadding: EdgeInsets.symmetric(
        horizontal: screenWidth < 400 ? 16 : 24,
        vertical: 24,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

      // --------------------------------------------------------
      // TITLE
      // --------------------------------------------------------
      title: Row(
        children: [
          Expanded(
            child: Text(
              'Update Stock',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.navy,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          if (_isUpdating) ...[
            const SizedBox(width: 12),
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ],
        ],
      ),

      // --------------------------------------------------------
      // CONTENT
      // --------------------------------------------------------
      content: SizedBox(
        width: dialogWidth,
        height: maxDialogHeight,
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ------------------------------------------------
              // Product Name
              // ------------------------------------------------
              Text(
                widget.product.name ?? 'Product',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 18),

              // ------------------------------------------------
              // Current Stock
              // ------------------------------------------------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 20,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Current Stock',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      '${widget.product.stockQuantity ?? 0}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.navy,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ------------------------------------------------
              // Stock Quantity
              // ------------------------------------------------
              TextField(
                controller: _stockController,
                enabled: !_isUpdating,
                autofocus: true,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Stock Quantity',
                  hintText: 'Enter quantity',
                  prefixIcon: const Icon(Icons.inventory_2_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // ------------------------------------------------
              // Low Stock Threshold
              // ------------------------------------------------
              TextField(
                controller: _thresholdController,
                enabled: !_isUpdating,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _updateStock(),
                decoration: InputDecoration(
                  labelText: 'Low Stock Threshold',
                  hintText: 'Enter threshold',
                  prefixIcon: const Icon(Icons.warning_amber_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // ------------------------------------------------
              // Info
              // ------------------------------------------------
              Text(
                'Set the quantity and the threshold at which the '
                'product should be considered low stock.',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),

      // --------------------------------------------------------
      // ACTIONS
      // --------------------------------------------------------
      actions: [
        TextButton(
          onPressed: _isUpdating
              ? null
              : () {
                  FocusScope.of(context).unfocus();
                  Navigator.of(context).pop();
                },
          child: Text(
            'Cancel',
            style: AppTextStyles.buttonText.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),

        FilledButton(
          onPressed: _isUpdating ? null : _updateStock,
          child: _isUpdating
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Update'),
        ),
      ],
    );
  }
}
