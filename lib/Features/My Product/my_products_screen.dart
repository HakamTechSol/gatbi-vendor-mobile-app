import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../Theme/app_colors.dart';
import '../../../Theme/app_text_styles.dart';

import '../../Routes/app_route.dart';
import '../Product Detail/Model/product_detail_model.dart';
import 'Data/dummy_my_products.dart';
import 'Edit Stock/edit_stock_screen.dart';
import 'Models/my_product_model.dart';
import 'Reuse Widgets/my_product_card.dart';
import 'Reuse Widgets/my_products_empty_state.dart';
import 'Reuse Widgets/my_products_filter.dart';
import 'Reuse Widgets/my_products_header.dart';
import 'Reuse Widgets/my_products_loading.dart';
import 'Reuse Widgets/my_products_search.dart';

class MyProductScreen extends StatefulWidget {
  const MyProductScreen({
    super.key,
    this.onAddProduct,
    this.onProductTap,
    this.onEditProduct,
    this.onStockEdit,
    this.onDeleteProduct,
  });

  /// Add Product screen callback.
  final VoidCallback? onAddProduct;

  /// Product details callback.
  final ValueChanged<MyProductModel>? onProductTap;

  /// Edit product callback.
  final ValueChanged<MyProductModel>? onEditProduct;

  /// Stock edit callback.
  final ValueChanged<MyProductModel>? onStockEdit;

  /// Delete callback.
  final ValueChanged<MyProductModel>? onDeleteProduct;

  @override
  State<MyProductScreen> createState() => _MyProductScreenState();
}

class _MyProductScreenState extends State<MyProductScreen> {
  // ═══════════════════════════════════════════════════════════════════════════
  // CONTROLLERS
  // ═══════════════════════════════════════════════════════════════════════════

  late final TextEditingController _searchController;
  late final ScrollController _scrollController;

  // ═══════════════════════════════════════════════════════════════════════════
  // STATE
  // ═══════════════════════════════════════════════════════════════════════════

  List<MyProductModel> _allProducts = [];
  List<MyProductModel> _filteredProducts = [];

  String _searchQuery = '';

  String? _selectedCategory;
  String? _selectedStatus;

  bool _isLoading = true;
  bool _isRefreshing = false;

  // Simulates pagination for the future API.
  bool _isLoadingMore = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();

    _searchController = TextEditingController();
    _scrollController = ScrollController();

    _scrollController.addListener(_handleScroll);

    _loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();

    super.dispose();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // LOAD PRODUCTS
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _loadProducts() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    await Future<void>.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;

    setState(() {
      _allProducts = List<MyProductModel>.from(DummyMyProducts.products);

      _isLoading = false;
      _hasMore = false;
    });

    _applyFilters();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // REFRESH
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _refreshProducts() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    await Future<void>.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;

    setState(() {
      _allProducts = List<MyProductModel>.from(DummyMyProducts.products);

      _isRefreshing = false;
    });

    _applyFilters();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SEARCH
  // ═══════════════════════════════════════════════════════════════════════════

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value.trim().toLowerCase();
    });

    _applyFilters();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // FILTER
  // ═══════════════════════════════════════════════════════════════════════════

  void _applyFilters() {
    final query = _searchQuery;

    final result = _allProducts.where((product) {
      final matchesSearch =
          query.isEmpty ||
          product.name.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query) ||
          (product.sku?.toLowerCase().contains(query) ?? false);

      final matchesCategory =
          _selectedCategory == null ||
          _selectedCategory == 'All' ||
          product.category == _selectedCategory;

      final matchesStatus =
          _selectedStatus == null ||
          _selectedStatus == 'All' ||
          product.status.toLowerCase() == _selectedStatus!.toLowerCase();

      return matchesSearch && matchesCategory && matchesStatus;
    }).toList();

    if (!mounted) return;

    setState(() {
      _filteredProducts = result;
    });
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // FILTER CALLBACK
  // ═══════════════════════════════════════════════════════════════════════════

  void _onCategoryChanged(String? category) {
    setState(() {
      _selectedCategory = category;
    });

    _applyFilters();
  }

  void _onStatusChanged(String? status) {
    setState(() {
      _selectedStatus = status;
    });

    _applyFilters();
  }

  void _clearFilters() {
    setState(() {
      _selectedCategory = null;
      _selectedStatus = null;
      _searchQuery = '';

      _searchController.clear();
    });

    _applyFilters();
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PAGINATION
  // ═══════════════════════════════════════════════════════════════════════════

  void _handleScroll() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;

    if (position.pixels >= position.maxScrollExtent - 300) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMore || _isLoading) {
      return;
    }

    setState(() {
      _isLoadingMore = true;
    });

    // Later:
    //
    // GET /api/mobile/vendor/products?page=2&per_page=20
    //
    // Then append new products to _allProducts.

    await Future<void>.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;

    setState(() {
      _isLoadingMore = false;
      _hasMore = false;
    });
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DELETE PRODUCT
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _handleDeleteProduct(MyProductModel product) async {
    final shouldDelete = await _showDeleteConfirmation(product);

    if (!shouldDelete || !mounted) {
      return;
    }

    if (widget.onDeleteProduct != null) {
      widget.onDeleteProduct!(product);
      return;
    }

    setState(() {
      _allProducts.removeWhere((item) => item.id == product.id);
    });

    _applyFilters();

    _showMessage('Product deleted successfully');
  }

  Future<bool> _showDeleteConfirmation(MyProductModel product) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
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
            'Are you sure you want to delete "${product.name}"? '
            'This action cannot be undone.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
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
                Navigator.pop(context, true);
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

  // ═══════════════════════════════════════════════════════════════════════════
  // STOCK EDIT
  // ═══════════════════════════════════════════════════════════════════════════

  Future<void> _handleStockEdit(MyProductModel product) async {
    if (widget.onStockEdit != null) {
      widget.onStockEdit!(product);
      return;
    }

    final newStock = await showDialog<int>(
      context: context,
      builder: (_) => StockEditDialog(product: product),
    );

    if (newStock == null || !mounted) {
      return;
    }

    final index = _allProducts.indexWhere((item) => item.id == product.id);

    if (index == -1) return;

    final current = _allProducts[index];

    final updated = MyProductModel(
      id: current.id,
      name: current.name,
      price: current.price,
      originalPrice: current.originalPrice,
      stockQuantity: newStock,
      status: current.status,
      imageUrl: current.imageUrl,
      category: current.category,
      inStock: newStock > 0,
      sku: current.sku,
      createdAt: current.createdAt,
    );

    setState(() {
      _allProducts[index] = updated;
    });

    _applyFilters();

    _showMessage('Stock updated successfully');
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ACTION HANDLERS
  // ═══════════════════════════════════════════════════════════════════════════

  void _handleProductTap(MyProductModel product) {
    if (widget.onProductTap != null) {
      widget.onProductTap!(product);
      return;
    }

    final detailProduct = _convertToDetailProduct(product);

    context.push(AppRoutes.productDetail, extra: detailProduct);
  }

  ProductDetailModel _convertToDetailProduct(MyProductModel product) {
    return ProductDetailModel(
      id: product.id,

      productName: product.name,

      price: product.price,

      compareAtPrice: product.originalPrice,

      stock: product.stockQuantity,

      status: product.status,

      images: product.imageUrl.trim().isNotEmpty
          ? [product.imageUrl]
          : const [],

      categoryName: product.category,

      sku: product.sku,

      createdAt: product.createdAt,

      // UI dummy data
      shortDescription:
          'Premium quality product with reliable performance and excellent value.',

      fullDescription:
          'This product is designed with quality, durability and performance in mind. '
          'It provides a reliable experience for customers and is suitable for everyday use.',

      arabicName: null,

      arabicShortDescription: null,

      arabicFullDescription: null,

      allowAffiliates: true,

      costPrice: null,

      inventoryType: 'track',

      categoryId: null,

      brandId: null,

      brandName: null,

      isFeatured: false,

      isTrending: false,

      isFlashDeal: false,

      totalSales: 0,

      views: 0,

      slug: null,

      metaTitle: null,

      metaDescription: null,

      metaKeywords: null,

      arabicMetaTitle: null,

      arabicMetaDescription: null,

      arabicMetaKeywords: null,

      variants: const [],

      updatedAt: null,
    );
  }

  void _handleEditProduct(MyProductModel product) {
    if (widget.onEditProduct != null) {
      widget.onEditProduct!(product);
      return;
    }

    context.push(AppRoutes.editProduct, extra: product);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // MESSAGE
  // ═══════════════════════════════════════════════════════════════════════════

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message, maxLines: 2, overflow: TextOverflow.ellipsis),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          backgroundColor: AppColors.white,
          onRefresh: _refreshProducts,
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              SliverToBoxAdapter(child: _buildHeader()),

              SliverToBoxAdapter(child: _buildSearchSection()),

              if (_isLoading)
                SliverToBoxAdapter(child: _buildLoading())
              else
                _buildProductsContent(),

              if (_isLoadingMore)
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

              const SliverToBoxAdapter(child: SizedBox(height: 30)),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // HEADER
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
      child: MyProductsHeader(
        onAddProduct: () {
          if (widget.onAddProduct != null) {
            widget.onAddProduct!();
            return;
          }

          context.push(AppRoutes.addProduct);
        },
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SEARCH + FILTER
  // ═══════════════════════════════════════════════════════════════════════════

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
            selectedCategory: _selectedCategory,
            selectedStatus: _selectedStatus,
            categories: _categories,
            statuses: _statuses,
            onCategoryChanged: _onCategoryChanged,
            onStatusChanged: _onStatusChanged,
            onClear: _clearFilters,
          ),

          if (_searchQuery.isNotEmpty ||
              _selectedCategory != null ||
              _selectedStatus != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: _buildResultSummary(),
            ),
        ],
      ),
    );
  }

  Widget _buildResultSummary() {
    return Row(
      children: [
        Icon(Icons.filter_list_rounded, size: 15, color: AppColors.primary),

        const SizedBox(width: 6),

        Expanded(
          child: Text(
            '${_filteredProducts.length} product${_filteredProducts.length == 1 ? '' : 's'} found',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        GestureDetector(
          onTap: _clearFilters,
          child: Text(
            'Clear all',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primary,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // LOADING
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildLoading() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: MyProductsLoading(itemCount: 4),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PRODUCTS CONTENT
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildProductsContent() {
    if (_filteredProducts.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          child: MyProductsEmptyState(onAddProduct: widget.onAddProduct),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList.separated(
        itemCount: _filteredProducts.length,
        separatorBuilder: (_, _) {
          return const SizedBox(height: 12);
        },
        itemBuilder: (context, index) {
          final product = _filteredProducts[index];

          return MyProductCard(
            product: product,

            onTap: () {
              _handleProductTap(product);
            },

            onEdit: () {
              _handleEditProduct(product);
            },

            onStockEdit: () {
              _handleStockEdit(product);
            },

            onDelete: () {
              _handleDeleteProduct(product);
            },
          );
        },
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // FILTER OPTIONS
  // ═══════════════════════════════════════════════════════════════════════════

  List<String> get _categories {
    final values = _allProducts
        .map((product) => product.category)
        .where((category) => category.trim().isNotEmpty)
        .toSet()
        .toList();

    values.sort();

    return values;
  }

  List<String> get _statuses {
    final values = _allProducts
        .map((product) => product.status)
        .where((status) => status.trim().isNotEmpty)
        .toSet()
        .toList();

    values.sort();

    return values;
  }
}
