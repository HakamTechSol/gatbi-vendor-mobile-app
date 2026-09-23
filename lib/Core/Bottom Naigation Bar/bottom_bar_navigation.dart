import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../Features/Chat/Screens/chat_list_screen.dart';
import '../../Features/Dashboard/dashboard_screen.dart';
import '../../Features/More/more_screen.dart';
import '../../Features/Product Section/My Product/my_products_screen.dart';
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

  /// Dashboard ko fresh state ke saath rebuild karne ke liye.
  int _dashboardVersion = 0;

  /// My Products screen ko manually refresh karne ke liye.
  final GlobalKey<MyProductScreenState> _myProductsScreenKey =
      GlobalKey<MyProductScreenState>();

  /// Chat screen ko manually refresh karne ke liye.
  final GlobalKey<ChatListScreenState> _chatScreenKey =
      GlobalKey<ChatListScreenState>();

  @override
  void initState() {
    super.initState();

    _currentTab = widget.initialTab;
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // TAB CHANGE
  // ═══════════════════════════════════════════════════════════════════════════

  void _onTabChanged(BottomTab tab) {
    debugPrint('');
    debugPrint('════════════════════════════════════════════════════════════');
    debugPrint('BOTTOM TAB CHANGED');
    debugPrint('Previous Tab: ${_currentTab.name}');
    debugPrint('New Tab: ${tab.name}');
    debugPrint('════════════════════════════════════════════════════════════');

    // ============================================================
    // SAME TAB TAPPED AGAIN
    // ============================================================

    if (_currentTab == tab) {
      debugPrint('Same tab tapped again → refreshing ${tab.name}...');

      _refreshCurrentTab(tab);

      if (tab == BottomTab.dashboard) {
        _resetDashboard();
      }

      return;
    }

    // ============================================================
    // TAB CHANGE
    // ============================================================

    setState(() {
      _currentTab = tab;

      // Dashboard par wapas aane par fresh DashboardScreen create hogi.
      if (tab == BottomTab.dashboard) {
        _dashboardVersion++;
      }
    });

    // ============================================================
    // REFRESH SELECTED TAB
    // ============================================================

    _refreshCurrentTab(tab);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // DASHBOARD RESET
  // ═══════════════════════════════════════════════════════════════════════════

  /// Dashboard ko fresh state mein reset karta hai.
  ///
  /// Is se DashboardScreen dobara create hogi aur
  /// DashboardHeader ka:
  ///
  /// _isExpanded = false
  ///
  /// dobara initialize hoga.
  void _resetDashboard() {
    if (!mounted) {
      return;
    }

    setState(() {
      _dashboardVersion++;
    });
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // REFRESH CURRENT TAB
  // ═══════════════════════════════════════════════════════════════════════════

  void _refreshCurrentTab(BottomTab tab) {
    debugPrint('');
    debugPrint('════════════════════════════════════════════════════════════');
    debugPrint('REFRESH CURRENT TAB');
    debugPrint('TAB: ${tab.name}');
    debugPrint('════════════════════════════════════════════════════════════');

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
  // DASHBOARD REFRESH
  // ═══════════════════════════════════════════════════════════════════════════

  void _refreshDashboard() {
    debugPrint('DASHBOARD REFRESH');
    debugPrint('DashboardScreen recreated with version $_dashboardVersion');
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PRODUCTS REFRESH
  // ═══════════════════════════════════════════════════════════════════════════

  void _refreshProducts() {
    debugPrint('');
    debugPrint('════════════════════════════════════════════════════════════');
    debugPrint('PRODUCTS REFRESH');
    debugPrint('Calling MyProductScreen.refresh()...');
    debugPrint('════════════════════════════════════════════════════════════');

    final productState = _myProductsScreenKey.currentState;

    if (productState == null) {
      debugPrint('PRODUCTS REFRESH: MyProductScreen state is not mounted yet.');
      return;
    }

    productState.refresh();

    debugPrint('PRODUCTS REFRESH: refresh() called successfully.');
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // CHAT REFRESH
  // ═══════════════════════════════════════════════════════════════════════════

  void _refreshChat() {
    final chatState = _chatScreenKey.currentState;

    if (chatState == null) {
      debugPrint('CHAT REFRESH: ChatListScreen state is not mounted yet.');
      return;
    }

    chatState.refresh();

    debugPrint('CHAT REFRESH: refresh() called successfully.');
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // MORE REFRESH
  // ═══════════════════════════════════════════════════════════════════════════

  void _refreshMore() {
    debugPrint('MORE REFRESH API');
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

  void _onKycVerification() {
    context.push(AppRoutes.kyc);
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
          // ============================================================
          // DASHBOARD
          // ============================================================
          DashboardScreen(key: ValueKey<int>(_dashboardVersion)),

          // ============================================================
          // MY PRODUCTS
          // ============================================================
          MyProductScreen(key: _myProductsScreenKey),

          // ============================================================
          // CHAT
          // ============================================================

          /// Important:
          /// const remove kiya gaya hai because GlobalKey use kar rahe hain.
          ChatListScreen(key: _chatScreenKey),

          // ============================================================
          // MORE
          // ============================================================
          MoreScreen(
            onBulkProducts: _openBulkProducts,
            onTickets: _openSupportTickets,
            onCampaigns: _openCampaigns,
            onAnalytics: _openAnalytics,
            onOrders: _openOrders,
            onSupport: _openSupport,
            onChangePassword: _openChangePassword,
            onKycVerification: _onKycVerification,
          ),
        ],
      ),

      // ═══════════════════════════════════════════════════════════════════════
      // BOTTOM NAVIGATION
      // ═══════════════════════════════════════════════════════════════════════
      bottomNavigationBar: BottomBarScreen(
        currentTab: _currentTab,
        onTabChanged: _onTabChanged,
      ),
    );
  }
}
