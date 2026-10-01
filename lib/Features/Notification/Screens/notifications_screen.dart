import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Theme/app_colors.dart';

import '../Get Notifications/Controller/get_notifications_controller.dart';
import '../Get Notifications/Models/notification_item_model.dart';

import '../Mark All Read/Controller/mark_all_read_notification_controller.dart';

import '../Mark Read/Controller/mark_read_notification_controller.dart';

import '../Reuse Widgets/notification_card.dart';
import '../Reuse Widgets/notification_filter_chip.dart';
import '../Reuse Widgets/notifications_empty_state.dart';
import '../Reuse Widgets/notifications_error_state.dart';
import '../Reuse Widgets/notifications_header.dart';
import '../Reuse Widgets/notifications_loading.dart';
import '../Reuse Widgets/notifications_unread_banner.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  // ============================================================
  // Controllers
  // ============================================================

  late final ScrollController _scrollController;

  // ============================================================
  // Notifications State
  // ============================================================

  final List<NotificationItemModel> _notifications = <NotificationItemModel>[];

  int _unreadCount = 0;
  int _currentPage = 1;
  int _totalPages = 1;
  int _totalItems = 0;
  int _limit = 20;

  String _selectedFilter = 'all';

  // ============================================================
  // Loading State
  // ============================================================

  bool _isInitialLoading = true;
  bool _isRefreshing = false;
  bool _isLoadingMore = false;
  bool _isMarkingAllRead = false;

  // ============================================================
  // Error State
  // ============================================================

  String? _errorMessage;

  // ============================================================
  // Per Notification Loading
  // ============================================================

  final Set<int> _markingReadIds = <int>{};

  // ============================================================
  // Lifecycle
  // ============================================================

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(_handleScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      _loadNotifications();
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();

    super.dispose();
  }

  // ============================================================
  // Scroll Listener
  // ============================================================

  void _handleScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    final position = _scrollController.position;

    if (position.pixels >= position.maxScrollExtent - 500) {
      _loadMoreNotifications();
    }
  }

  // ============================================================
  // GET Notifications
  //
  // Initial load:
  // Full shimmer.
  //
  // Mutation ke baad:
  // Full shimmer.
  //
  // Filter change:
  // Full shimmer.
  // ============================================================

  Future<void> _loadNotifications({bool showShimmer = true}) async {
    if (!mounted) {
      return;
    }

    if (showShimmer) {
      setState(() {
        _isInitialLoading = true;
        _errorMessage = null;

        _currentPage = 1;
        _totalPages = 1;
        _totalItems = 0;

        _notifications.clear();
      });
    } else {
      setState(() {
        _errorMessage = null;
      });
    }

    try {
      final result = await ref
          .read(getNotificationsControllerProvider)
          .getNotifications(page: 1, limit: _limit, filter: _selectedFilter);

      if (!mounted) {
        return;
      }

      setState(() {
        _notifications
          ..clear()
          ..addAll(result.notifications);

        _unreadCount = result.unreadCount;

        _currentPage = result.pagination?.currentPage ?? 1;
        _totalPages = result.pagination?.totalPages ?? 1;
        _totalItems = result.pagination?.totalItems ?? 0;
        _limit = result.pagination?.limit ?? _limit;

        _errorMessage = null;
        _isInitialLoading = false;
      });

      _logGetResult(result.notifications.length, result.unreadCount);
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isInitialLoading = false;
        _errorMessage = error.message;
      });

      _logError('GET NOTIFICATIONS', error);
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isInitialLoading = false;
        _errorMessage = 'Something went wrong. Please try again.';
      });

      _logUnknownError('GET NOTIFICATIONS', error);
    }
  }

  // ============================================================
  // Pull To Refresh
  //
  // Pull refresh par:
  // 1. Existing list clear
  // 2. Full shimmer
  // 3. Fresh GET
  // 4. Server response show
  // ============================================================

  Future<void> _refreshNotifications() async {
    if (_isRefreshing ||
        _isInitialLoading ||
        _isLoadingMore ||
        _isMarkingAllRead) {
      return;
    }

    setState(() {
      _isRefreshing = true;
      _isInitialLoading = true;

      _errorMessage = null;

      _currentPage = 1;
      _totalPages = 1;
      _totalItems = 0;

      _notifications.clear();
    });

    try {
      final result = await ref
          .read(getNotificationsControllerProvider)
          .getNotifications(page: 1, limit: _limit, filter: _selectedFilter);

      if (!mounted) {
        return;
      }

      setState(() {
        _notifications
          ..clear()
          ..addAll(result.notifications);

        _unreadCount = result.unreadCount;

        _currentPage = result.pagination?.currentPage ?? 1;
        _totalPages = result.pagination?.totalPages ?? 1;
        _totalItems = result.pagination?.totalItems ?? 0;
        _limit = result.pagination?.limit ?? _limit;

        _errorMessage = null;

        _isInitialLoading = false;
        _isRefreshing = false;
      });

      _logGetResult(result.notifications.length, result.unreadCount);
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isInitialLoading = false;
        _isRefreshing = false;
        _errorMessage = error.message;
      });

      _showSnackBar(error.message, isError: true);

      _logError('REFRESH NOTIFICATIONS', error);
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isInitialLoading = false;
        _isRefreshing = false;
        _errorMessage = 'Something went wrong. Please try again.';
      });

      _showSnackBar('Something went wrong. Please try again.', isError: true);

      _logUnknownError('REFRESH NOTIFICATIONS', error);
    }
  }

  // ============================================================
  // Load More
  //
  // Pagination par full shimmer nahi.
  // Sirf bottom loader.
  // ============================================================

  Future<void> _loadMoreNotifications() async {
    if (_isInitialLoading ||
        _isRefreshing ||
        _isLoadingMore ||
        _isMarkingAllRead) {
      return;
    }

    if (_currentPage >= _totalPages) {
      return;
    }

    final nextPage = _currentPage + 1;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final result = await ref
          .read(getNotificationsControllerProvider)
          .getNotifications(
            page: nextPage,
            limit: _limit,
            filter: _selectedFilter,
          );

      if (!mounted) {
        return;
      }

      setState(() {
        _notifications.addAll(result.notifications);

        _currentPage = result.pagination?.currentPage ?? nextPage;

        _totalPages = result.pagination?.totalPages ?? _totalPages;

        _totalItems = result.pagination?.totalItems ?? _totalItems;

        _limit = result.pagination?.limit ?? _limit;

        _unreadCount = result.unreadCount;

        _isLoadingMore = false;
      });

      _logGetResult(
        result.notifications.length,
        result.unreadCount,
        page: nextPage,
      );
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoadingMore = false;
      });

      _showSnackBar(error.message, isError: true);

      _logError('LOAD MORE NOTIFICATIONS', error);
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoadingMore = false;
      });

      _showSnackBar(
        'Something went wrong while loading more notifications.',
        isError: true,
      );

      _logUnknownError('LOAD MORE NOTIFICATIONS', error);
    }
  }

  // ============================================================
  // Filter
  // ============================================================

  Future<void> _changeFilter(String filter) async {
    if (_selectedFilter == filter) {
      return;
    }

    if (_isInitialLoading ||
        _isRefreshing ||
        _isLoadingMore ||
        _isMarkingAllRead) {
      return;
    }

    setState(() {
      _selectedFilter = filter;
    });

    await _loadNotifications(showShimmer: true);

    if (!mounted) {
      return;
    }

    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  // ============================================================
  // Mark Single Notification As Read
  //
  // API success:
  // 1. Clear current data
  // 2. Show shimmer
  // 3. Fresh GET
  // 4. Server response becomes source of truth
  // ============================================================

  Future<void> _markNotificationAsRead(
    NotificationItemModel notification,
  ) async {
    final notificationId = notification.id;

    if (notificationId == null) {
      return;
    }

    if (notification.isRead) {
      return;
    }

    if (_markingReadIds.contains(notificationId)) {
      return;
    }

    if (_isMarkingAllRead) {
      return;
    }

    setState(() {
      _markingReadIds.add(notificationId);
    });

    try {
      final result = await ref
          .read(markReadNotificationControllerProvider)
          .markReadNotification(notificationId: notificationId);

      if (!mounted) {
        return;
      }

      if (!result.success) {
        throw ApiException(
          message: result.message ?? 'Unable to mark notification as read.',
          code: 'MARK_READ_FAILED',
        );
      }

      _logMarkReadResult(notificationId, result.unreadCount);

      // --------------------------------------------------------
      // API SUCCESS
      // --------------------------------------------------------
      //
      // Local notification ko manually isRead=true nahi karna.
      //
      // Server se fresh GET karenge.
      // --------------------------------------------------------

      setState(() {
        _markingReadIds.remove(notificationId);

        _isInitialLoading = true;
        _errorMessage = null;

        _notifications.clear();

        _currentPage = 1;
        _totalPages = 1;
        _totalItems = 0;
      });

      // --------------------------------------------------------
      // Fresh GET
      //
      // showShimmer:false isliye kyun ke shimmer already
      // _isInitialLoading=true ki wajah se visible hai.
      // --------------------------------------------------------

      await _loadNotifications(showShimmer: false);
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _markingReadIds.remove(notificationId);
      });

      _showSnackBar(error.message, isError: true);

      _logError('MARK NOTIFICATION READ', error);
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _markingReadIds.remove(notificationId);
      });

      _showSnackBar('Unable to mark notification as read.', isError: true);

      _logUnknownError('MARK NOTIFICATION READ', error);
    }
  }

  // ============================================================
  // Mark All Notifications As Read
  //
  // API success:
  // 1. Clear current data
  // 2. Show shimmer
  // 3. Fresh GET
  // ============================================================

  Future<void> _markAllNotificationsAsRead() async {
    if (_unreadCount <= 0) {
      return;
    }

    if (_isMarkingAllRead) {
      return;
    }

    if (_markingReadIds.isNotEmpty) {
      return;
    }

    setState(() {
      _isMarkingAllRead = true;
    });

    try {
      final result = await ref
          .read(markAllReadNotificationControllerProvider)
          .markAllReadNotifications();

      if (!mounted) {
        return;
      }

      if (!result.success) {
        throw ApiException(
          message:
              result.message ?? 'Unable to mark all notifications as read.',
          code: 'MARK_ALL_READ_FAILED',
        );
      }

      _logMarkAllReadResult(result.unreadCount);

      // --------------------------------------------------------
      // API SUCCESS
      // --------------------------------------------------------

      setState(() {
        _isMarkingAllRead = false;

        _isInitialLoading = true;
        _errorMessage = null;

        _notifications.clear();

        _currentPage = 1;
        _totalPages = 1;
        _totalItems = 0;
      });

      // --------------------------------------------------------
      // Fresh GET + shimmer
      // --------------------------------------------------------

      await _loadNotifications(showShimmer: false);

      if (!mounted) {
        return;
      }

      if (result.message != null && result.message!.trim().isNotEmpty) {
        _showSnackBar(result.message!, isError: false);
      }
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isMarkingAllRead = false;
      });

      _showSnackBar(error.message, isError: true);

      _logError('MARK ALL NOTIFICATIONS READ', error);
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isMarkingAllRead = false;
      });

      _showSnackBar('Unable to mark all notifications as read.', isError: true);

      _logUnknownError('MARK ALL NOTIFICATIONS READ', error);
    }
  }

  // ============================================================
  // Build
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(child: _buildBody()),
    );
  }

  // ============================================================
  // Body
  // ============================================================

  Widget _buildBody() {
    // ----------------------------------------------------------
    // Full Shimmer
    // ----------------------------------------------------------

    if (_isInitialLoading) {
      return const NotificationsLoading();
    }

    // ----------------------------------------------------------
    // Full Error
    // ----------------------------------------------------------

    if (_errorMessage != null && _notifications.isEmpty) {
      return NotificationsErrorState(
        message: _errorMessage,
        onRetry: () {
          _loadNotifications(showShimmer: true);
        },
      );
    }

    // ----------------------------------------------------------
    // Main Content
    // ----------------------------------------------------------

    return RefreshIndicator(
      color: AppColors.primary,
      backgroundColor: AppColors.white,
      onRefresh: _refreshNotifications,
      child: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          // ======================================================
          // Header
          // ======================================================
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            sliver: SliverToBoxAdapter(
              child: NotificationsHeader(
                onBack: () {
                  Navigator.of(context).maybePop();
                },
              ),
            ),
          ),

          // ======================================================
          // Filters
          // ======================================================
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
            sliver: SliverToBoxAdapter(child: _buildFilters()),
          ),

          // ======================================================
          // Unread Banner
          // ======================================================
          if (_unreadCount > 0)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              sliver: SliverToBoxAdapter(
                child: NotificationsUnreadBanner(
                  unreadCount: _unreadCount,
                  isLoading: _isMarkingAllRead,
                  onMarkAllRead: _markAllNotificationsAsRead,
                ),
              ),
            ),

          // ======================================================
          // Inline Error
          // ======================================================
          if (_errorMessage != null && _notifications.isNotEmpty)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              sliver: SliverToBoxAdapter(child: _buildInlineError()),
            ),

          // ======================================================
          // Empty State
          // ======================================================
          if (_notifications.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: NotificationsEmptyState(
                filter: _selectedFilter,
                onRefresh: _refreshNotifications,
              ),
            )
          else
            // ====================================================
            // Notification List
            // ====================================================
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    // ------------------------------------------
                    // Bottom Pagination Loader
                    // ------------------------------------------

                    if (index >= _notifications.length) {
                      return _buildLoadMoreIndicator();
                    }

                    final notification = _notifications[index];

                    final notificationId = notification.id;

                    final isMarking =
                        notificationId != null &&
                        _markingReadIds.contains(notificationId);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: NotificationCard(
                        notification: notification,
                        isMarkingAsRead: isMarking,
                        onTap: notification.isRead
                            ? null
                            : () {
                                _markNotificationAsRead(notification);
                              },
                      ),
                    );
                  },
                  childCount: _notifications.length + (_isLoadingMore ? 1 : 0),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ============================================================
  // Filters
  // ============================================================

  Widget _buildFilters() {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          NotificationFilterChip(
            label: 'All',
            selected: _selectedFilter == 'all',
            onTap: () {
              _changeFilter('all');
            },
          ),

          const SizedBox(width: 8),

          NotificationFilterChip(
            label: 'Read',
            selected: _selectedFilter == 'read',
            onTap: () {
              _changeFilter('read');
            },
          ),

          const SizedBox(width: 8),

          NotificationFilterChip(
            label: 'Unread',
            selected: _selectedFilter == 'unread',
            onTap: () {
              _changeFilter('unread');
            },
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Inline Error
  // ============================================================

  Widget _buildInlineError() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
      decoration: BoxDecoration(
        color: AppColors.errorLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.errorBorder),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 19,
            color: AppColors.error,
          ),

          const SizedBox(width: 9),

          Expanded(
            child: Text(
              _errorMessage ?? 'Unable to refresh notifications.',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.errorDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(width: 8),

          InkWell(
            onTap: () {
              _refreshNotifications();
            },
            borderRadius: BorderRadius.circular(8),
            child: const Padding(
              padding: EdgeInsets.all(5),
              child: Icon(
                Icons.refresh_rounded,
                size: 19,
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Load More Indicator
  // ============================================================

  Widget _buildLoadMoreIndicator() {
    return const Padding(
      padding: EdgeInsets.only(top: 2, bottom: 4),
      child: Center(
        child: SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(
            strokeWidth: 2.2,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SnackBar
  // ============================================================

  void _showSnackBar(String message, {required bool isError}) {
    if (!mounted) {
      return;
    }

    final messenger = ScaffoldMessenger.of(context);

    messenger.hideCurrentSnackBar();

    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError
                  ? Icons.error_outline_rounded
                  : Icons.check_circle_outline_rounded,
              size: 19,
              color: AppColors.white,
            ),

            const SizedBox(width: 9),

            Expanded(
              child: Text(
                message,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: isError ? AppColors.errorDark : AppColors.successDark,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // ============================================================
  // Debug Logs
  // ============================================================

  void _logGetResult(int loadedCount, int unreadCount, {int? page}) {
    if (!kDebugMode) {
      return;
    }

    debugPrint('');
    debugPrint('========== NOTIFICATIONS SCREEN RESULT ==========');
    debugPrint('FILTER: $_selectedFilter');
    debugPrint('PAGE: ${page ?? _currentPage}');
    debugPrint('LOADED ITEMS: $loadedCount');
    debugPrint('TOTAL ITEMS: $_totalItems');
    debugPrint('TOTAL PAGES: $_totalPages');
    debugPrint('UNREAD COUNT: $unreadCount');
    debugPrint('==================================================');
    debugPrint('');
  }

  void _logMarkReadResult(int notificationId, int unreadCount) {
    if (!kDebugMode) {
      return;
    }

    debugPrint('');
    debugPrint('========== MARK NOTIFICATION READ ==========');
    debugPrint('NOTIFICATION ID: $notificationId');
    debugPrint('NEW UNREAD COUNT: $unreadCount');
    debugPrint('NEXT ACTION: REFRESH GET NOTIFICATIONS');
    debugPrint('============================================');
    debugPrint('');
  }

  void _logMarkAllReadResult(int unreadCount) {
    if (!kDebugMode) {
      return;
    }

    debugPrint('');
    debugPrint('========== MARK ALL NOTIFICATIONS READ ==========');
    debugPrint('NEW UNREAD COUNT: $unreadCount');
    debugPrint('NEXT ACTION: REFRESH GET NOTIFICATIONS');
    debugPrint('==============================================');
    debugPrint('');
  }

  void _logError(String operation, ApiException error) {
    if (!kDebugMode) {
      return;
    }

    debugPrint('');
    debugPrint('========== $operation ERROR ==========');
    debugPrint('MESSAGE: ${error.message}');
    debugPrint('CODE: ${error.code}');
    debugPrint('STATUS CODE: ${error.statusCode}');
    debugPrint('======================================');
    debugPrint('');
  }

  void _logUnknownError(String operation, Object error) {
    if (!kDebugMode) {
      return;
    }

    debugPrint('');
    debugPrint('========== $operation UNKNOWN ERROR ==========');
    debugPrint('ERROR: $error');
    debugPrint('==============================================');
    debugPrint('');
  }
}
