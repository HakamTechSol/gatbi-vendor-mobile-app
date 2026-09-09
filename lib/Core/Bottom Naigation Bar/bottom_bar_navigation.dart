import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../Features/Chat/Screens/chat_list_screen.dart';
import '../../Features/Dashboard/dashboard_screen.dart';
import '../../Features/More/more_screen.dart';
import '../../Features/My Product/my_products_screen.dart';
import '../../Routes/app_route.dart';
import 'bottom_bar_screen.dart';

class BottomMainScreen extends StatefulWidget {
  const BottomMainScreen({super.key, this.initialTab = BottomTab.dashboard});

  final BottomTab initialTab;

  @override
  State<BottomMainScreen> createState() => _BottomMainScreenState();
}

class _BottomMainScreenState extends State<BottomMainScreen> {
  late BottomTab _currentTab;

  @override
  void initState() {
    super.initState();

    _currentTab = widget.initialTab;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // TAB CHANGE
  // ═══════════════════════════════════════════════════════════════════════════

  void _onTabChanged(BottomTab tab) {
    if (_currentTab == tab) {
      _refreshCurrentTab(tab);
      return;
    }

    setState(() {
      _currentTab = tab;
    });

    _refreshCurrentTab(tab);
  }

  void _refreshCurrentTab(BottomTab tab) {
    switch (tab) {
      case BottomTab.dashboard:
        _refreshDashboard();
        break;

      case BottomTab.products:
        _refreshProducts();
        break;

      case BottomTab.chat:
        _refreshChat();
        break;

      case BottomTab.more:
        _refreshMore();
        break;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // REFRESH
  // ═══════════════════════════════════════════════════════════════════════════

  void _refreshDashboard() {
    debugPrint('Refresh Dashboard API');
  }

  void _refreshProducts() {
    debugPrint('Refresh Products API');
  }

  void _refreshChat() {
    debugPrint('Refresh Chat API');
  }

  void _refreshMore() {
    debugPrint('Refresh More API');
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // MORE SCREEN NAVIGATION
  // ═══════════════════════════════════════════════════════════════════════════

  void _openBulkProducts() {
    context.push(AppRoutes.bulkImport);
  }

  void _openSupportTickets() {
    context.push(AppRoutes.supportTickets);
  }

  void _openCampaigns() {
    context.push(AppRoutes.campaigns);
  }

  void _openAnalytics() {
    context.push(AppRoutes.analytics);
  }

  void _openOrders() {
    context.push(AppRoutes.orders);
  }

  void _openSupport() {
    context.push(AppRoutes.support);
  }

  void _openChangePassword() {
    context.push(AppRoutes.changePassword);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentTab.index,
        children: [
          const DashboardScreen(),

          const MyProductScreen(),

          const ChatListScreen(),

          MoreScreen(
            onBulkProducts: _openBulkProducts,
            onTickets: _openSupportTickets,
            onCampaigns: _openCampaigns,
            onAnalytics: _openAnalytics,
            onOrders: _openOrders,
            onSupport: _openSupport,
            onChangePassword: _openChangePassword,
          ),
        ],
      ),

      bottomNavigationBar: BottomBarScreen(
        currentTab: _currentTab,
        onTabChanged: _onTabChanged,
      ),
    );
  }
}
