import 'package:flutter/material.dart';

import '../../../Theme/app_colors.dart';
import 'Reuse Widgets/affiliate_section.dart';
// import 'Reuse Widgets/dashboard_action_buttons.dart';
import 'Reuse Widgets/dashboard_header.dart';
import 'Reuse Widgets/dashboard_stats_section.dart';
import 'Reuse Widgets/earnings_summary_section.dart';
import 'Reuse Widgets/kyc_banner.dart';
import 'Reuse Widgets/need_help_card.dart';
import 'Reuse Widgets/order_status_section.dart';
import 'Reuse Widgets/products_preview_section.dart';
import 'Reuse Widgets/recent_orders_section.dart';
import 'Reuse Widgets/shop_summary_card.dart';
import 'Reuse Widgets/store_status_banner.dart';

// Dashboard Widgets

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    final horizontalPadding = screenWidth < 360 ? 14.0 : 18.0;

    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),

          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            16,
            horizontalPadding,
            30,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ═══════════════════════════════════════════════════════════════
              // HEADER
              // ═══════════════════════════════════════════════════════════════
              DashboardHeader(vendorName: 'My Store'),

              const SizedBox(height: 12),

              // ═══════════════════════════════════════════════════════════════
              // QUICK ACTION BUTTONS
              // ═══════════════════════════════════════════════════════════════
              // DashboardActionButtons(
              //   isStoreApproved: false,

              //   onAddProduct: () {
              //     debugPrint('Add Product');
              //     // context.push(AppRoutes.addProduct);
              //   },

              //   onViewOrders: () {
              //     debugPrint('View Orders');
              //     // context.push(AppRoutes.orders);
              //   },

              //   onShopSettings: () {
              //     debugPrint('Shop Settings');
              //     // context.push(AppRoutes.shopSettings);
              //   },
              // ),

              // const SizedBox(height: 16),

              // ═══════════════════════════════════════════════════════════════
              // STORE STATUS
              // Shown only when store is pending approval
              // ═══════════════════════════════════════════════════════════════
              StoreStatusBanner(isStoreApproved: false),

              const SizedBox(height: 16),

              // ═══════════════════════════════════════════════════════════════
              // KYC STATUS
              // Shown only when KYC is pending
              // ═══════════════════════════════════════════════════════════════
              KycBanner(
                isPending: true,
                onView: () {
                  // context.push(AppRoutes.kycVerification);
                },
              ),

              const SizedBox(height: 16),

              // ═══════════════════════════════════════════════════════════════
              // EARNINGS SUMMARY
              // ═══════════════════════════════════════════════════════════════
              EarningsSummarySection(
                grossAmount: 0,
                commissionAmount: 0,
                netPayable: 0,
                commissionPercentage: 5,
              ),

              const SizedBox(height: 16),

              // ═══════════════════════════════════════════════════════════════
              // AFFILIATE SECTION
              // ═══════════════════════════════════════════════════════════════
              AffiliateSection(
                affiliateReadyProducts: 0,
                hiddenFromAffiliates: 0,
                commissionPercentage: 2,
              ),

              const SizedBox(height: 18),

              // ═══════════════════════════════════════════════════════════════
              // DASHBOARD STATS
              // ═══════════════════════════════════════════════════════════════
              const DashboardStatsSection(
                totalProducts: 24,
                activeProducts: 20,

                totalOrders: 156,
                pendingOrders: 8,

                totalRevenue: 125000,
                thisMonthRevenue: 18500,

                ordersToday: 12,
                lowStockCount: 3,
                outOfStockCount: 1,
              ),

              const SizedBox(height: 20),

              // ═══════════════════════════════════════════════════════════════
              // RECENT ORDERS
              // ═══════════════════════════════════════════════════════════════
              RecentOrdersSection(
                orders: const [],

                onViewAll: () {
                  debugPrint('View all orders');
                  // context.push(AppRoutes.orders);
                },
              ),

              const SizedBox(height: 20),

              // ═══════════════════════════════════════════════════════════════
              // ORDER STATUS BREAKDOWN
              // ═══════════════════════════════════════════════════════════════
              OrderStatusSection(
                pending: 12,
                processing: 8,
                shipped: 15,
                delivered: 42,
                cancelled: 3,

                onStatusTap: (status) {
                  debugPrint('Selected order status: $status');

                  // Example:
                  // context.push(
                  //   '${AppRoutes.orders}?status=$status',
                  // );
                },
              ),

              const SizedBox(height: 20),

              // ═══════════════════════════════════════════════════════════════
              // PRODUCTS PREVIEW
              // ═══════════════════════════════════════════════════════════════
              ProductsPreviewSection(
                productCount: 12,

                onAddProduct: () {
                  debugPrint('Add first product');
                  // context.push(AppRoutes.addProduct);
                },

                onManageProducts: () {
                  debugPrint('Manage products');
                  // context.push(AppRoutes.products);
                },
              ),

              const SizedBox(height: 20),

              // ═══════════════════════════════════════════════════════════════
              // SHOP SUMMARY
              // ═══════════════════════════════════════════════════════════════
              const ShopSummaryCard(
                status: 'Approved',
                kycStatus: 'Verified',
                businessType: 'Retail',
                primaryCategory: 'Electronics',
                supportEmail: 'support@gatbi.ae',
                warehouseAddress: 'Dubai, United Arab Emirates',
              ),

              const SizedBox(height: 20),

              // ═══════════════════════════════════════════════════════════════
              // NEED HELP
              // ═══════════════════════════════════════════════════════════════
              NeedHelpCard(
                onEmailSupport: () {
                  debugPrint('Email Support');
                },

                onCallSupport: () {
                  debugPrint('Call Support');
                },

                onCreateTicket: () {
                  debugPrint('Create Support Ticket');
                  // context.push(AppRoutes.supportTicket);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
