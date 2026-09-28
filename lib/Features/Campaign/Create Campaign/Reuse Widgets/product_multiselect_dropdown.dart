import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../../../Product Section/My Product/Controller/my_products_controller.dart';
import '../../../Product Section/My Product/Models/my_product_model.dart';

class ProductMultiSelectDropdown extends ConsumerStatefulWidget {
  const ProductMultiSelectDropdown({
    super.key,
    required this.selectedIds,
    required this.onChanged,
    this.errorText,
  });

  final Set<int> selectedIds;
  final ValueChanged<Set<int>> onChanged;
  final String? errorText;

  @override
  ConsumerState<ProductMultiSelectDropdown> createState() =>
      _ProductMultiSelectDropdownState();
}

class _ProductMultiSelectDropdownState
    extends ConsumerState<ProductMultiSelectDropdown> {
  bool _loaded = false;
  bool _sheetOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadProducts());
  }

  Future<void> _loadProducts() async {
    if (_loaded) return;
    _loaded = true;

    final state = ref.read(myProductsControllerProvider);
    final controller = ref.read(myProductsControllerProvider.notifier);
    if (!state.initialized && !state.isLoading) {
      try {
        await controller.getProducts();
      } catch (_) {
        // error handled by state
      }
    }
  }

  Future<void> _openSheet() async {
    if (_sheetOpen) return;
    _sheetOpen = true;

    final state = ref.read(myProductsControllerProvider);
    final controller = ref.read(myProductsControllerProvider.notifier);

    if (!state.initialized && !state.isLoading) {
      try {
        await controller.getProducts();
      } catch (_) {}
    }

    if (!mounted) {
      _sheetOpen = false;
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _ProductSelectionSheet(
        selectedIds: widget.selectedIds,
        onApply: (ids) {
          widget.onChanged(ids);
        },
      ),
    );

    _sheetOpen = false;
  }

  @override
  Widget build(BuildContext context) {
    final count = widget.selectedIds.length;
    final hasError = widget.errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Products', style: AppTextStyles.formLabel),
        const SizedBox(height: 8),
        InkWell(
          onTap: _openSheet,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.inputBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: hasError ? AppColors.error : AppColors.border,
                width: hasError ? 1.4 : 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    count == 0
                        ? 'Select products'
                        : '$count product${count > 1 ? 's' : ''} selected',
                    style: count == 0
                        ? AppTextStyles.authHint
                        : AppTextStyles.authInput,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.iconSecondary,
                ),
              ],
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 6),
          Text(widget.errorText!, style: AppTextStyles.formError),
        ],
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Selection Sheet
// ═══════════════════════════════════════════════════════════════════════════

class _ProductSelectionSheet extends ConsumerStatefulWidget {
  const _ProductSelectionSheet({
    required this.selectedIds,
    required this.onApply,
  });

  final Set<int> selectedIds;
  final ValueChanged<Set<int>> onApply;

  @override
  ConsumerState<_ProductSelectionSheet> createState() =>
      _ProductSelectionSheetState();
}

class _ProductSelectionSheetState
    extends ConsumerState<_ProductSelectionSheet> {
  late Set<int> _tempSelected;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tempSelected = Set<int>.from(widget.selectedIds);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 200) {
      final state = ref.read(myProductsControllerProvider);
      final controller = ref.read(myProductsControllerProvider.notifier);
      if (state.hasMore && !state.isLoadingMore) {
        controller.loadNextPage().catchError((_) {});
      }
    }
  }

  void _toggle(MyProductModel product) {
    final productId = product.id;
    if (productId == null) return;

    setState(() {
      if (_tempSelected.contains(productId)) {
        _tempSelected.remove(productId);
      } else {
        _tempSelected.add(productId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myProductsControllerProvider);
    final media = MediaQuery.of(context);

    return SizedBox(
      height: media.size.height * 0.75,
      child: Column(
        children: [
          // Handle
          const SizedBox(height: 10),
          Container(
            width: 42,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.borderStrong,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Select Products',
                    style: AppTextStyles.bottomSheetTitle,
                  ),
                ),
                if (_tempSelected.isNotEmpty)
                  TextButton(
                    onPressed: () => setState(() => _tempSelected.clear()),
                    child: const Text('Clear'),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  '${_tempSelected.length} selected',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.divider),

          // List
          Expanded(child: _buildList(state)),

          // Footer
          Container(
            padding: EdgeInsets.fromLTRB(20, 12, 20, 12 + media.padding.bottom),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.divider)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Cancel', style: AppTextStyles.buttonOutlined),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onApply(_tempSelected);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Apply', style: AppTextStyles.buttonMedium),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(MyProductsState state) {
    if (state.isLoading && state.products.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (state.errorMessage != null && state.products.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: AppColors.error, size: 42),
              const SizedBox(height: 12),
              Text(
                state.errorMessage!,
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref
                      .read(myProductsControllerProvider.notifier)
                      .getProducts()
                      .catchError((_) {});
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (state.products.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.inventory_2_outlined,
              color: AppColors.iconMuted,
              size: 42,
            ),
            const SizedBox(height: 12),
            Text('No products found', style: AppTextStyles.emptyStateTitle),
          ],
        ),
      );
    }

    return ListView.separated(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 4),
      itemCount: state.products.length + (state.isLoadingMore ? 1 : 0),
      separatorBuilder: (_, __) =>
          const Divider(height: 1, color: AppColors.divider),
      itemBuilder: (context, index) {
        if (index >= state.products.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }

        final product = state.products[index];
        final id = product.id;
        final selected = id != null && _tempSelected.contains(id);

        return CheckboxListTile(
          value: selected,
          onChanged: (_) => _toggle(product),
          activeColor: AppColors.primary,
          checkboxShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          side: const BorderSide(color: AppColors.borderStrong, width: 1.4),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
          title: Text(
            product.name ?? 'Unnamed product',
            style: AppTextStyles.titleSmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
    );
  }
}
