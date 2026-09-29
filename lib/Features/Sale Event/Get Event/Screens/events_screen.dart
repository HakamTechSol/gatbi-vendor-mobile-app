import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../Routes/app_route.dart';
import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../Controller/get_events_controller.dart';
import '../Models/get_events_model.dart';
import '../Reuse widgets/event_card.dart';
import '../Reuse widgets/event_kyc_notice.dart';
import '../Reuse widgets/events_empty_state.dart';
import '../Reuse widgets/events_error_state.dart';
import '../Reuse widgets/events_header.dart';
import '../Reuse widgets/events_loading.dart';

class EventsScreen extends ConsumerStatefulWidget {
  const EventsScreen({super.key});

  @override
  ConsumerState<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends ConsumerState<EventsScreen> {
  // ============================================================
  // State
  // ============================================================

  EventsModel? _eventsData;

  bool _isLoading = true;

  String? _errorMessage;

  /// null = All
  String? _selectedStatus;

  // ============================================================
  // Lifecycle
  // ============================================================

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadEvents(showShimmer: true);
    });
  }

  // ============================================================
  // Build
  // ============================================================

  @override
  Widget build(BuildContext context) {
    // ----------------------------------------------------------
    // Initial Loading
    // ----------------------------------------------------------

    if (_isLoading && _eventsData == null) {
      return const EventsLoading(itemCount: 3);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          backgroundColor: AppColors.white,
          onRefresh: _handleRefresh,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // ==================================================
                    // Header
                    // ==================================================
                    const EventsHeader(),

                    const SizedBox(height: 20),

                    // ==================================================
                    // Intro Card
                    // ==================================================
                    _buildIntroCard(),

                    const SizedBox(height: 20),

                    // ==================================================
                    // KYC Notice
                    // ==================================================
                    EventKycNotice(
                      kycStatus: _eventsData?.kycStatus,
                      kycLocked: _eventsData?.kycLocked ?? false,
                    ),

                    if (_eventsData?.kycLocked == true)
                      const SizedBox(height: 20),

                    // ==================================================
                    // Events Section
                    // ==================================================
                    _buildEventsSection(),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // Intro Card
  // ============================================================

  Widget _buildIntroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: AppColors.primaryShadow,
            blurRadius: 16,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Grow with special events',
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.white,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  'Join open events, submit your products, '
                  'and reach more customers.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textOnPrimarySecondary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.rocket_launch_rounded,
              color: AppColors.white,
              size: 27,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Events Section
  // ============================================================

  Widget _buildEventsSection() {
    // ----------------------------------------------------------
    // Error
    // ----------------------------------------------------------

    if (_errorMessage != null && _eventsData == null) {
      return EventsErrorState(
        message: _errorMessage!,
        onRetry: () {
          _loadEvents(showShimmer: true);
        },
      );
    }

    final events = _filteredEvents;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(events),

        const SizedBox(height: 16),

        if (events.isEmpty)
          const EventsEmptyState()
        else
          _buildEventList(events),

        if (_eventsData?.notes != null &&
            _eventsData!.notes!.trim().isNotEmpty) ...[
          const SizedBox(height: 18),
          _buildNotes(),
        ],
      ],
    );
  }

  // ============================================================
  // Section Header
  // ============================================================

  Widget _buildSectionHeader(List<EventItemModel> events) {
    final total = _eventsData?.events.length ?? events.length;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Available events', style: AppTextStyles.titleLarge),
              const SizedBox(height: 4),
              Text(
                total == 0
                    ? 'No events available right now.'
                    : '$total event${total == 1 ? '' : 's'} available',
                style: AppTextStyles.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // Filtered Events
  // ============================================================

  List<EventItemModel> get _filteredEvents {
    final events = _eventsData?.events ?? [];

    if (_selectedStatus == null) {
      return events;
    }

    final selectedStatus = _selectedStatus!.trim().toLowerCase();

    return events.where((event) {
      final status = event.status?.trim().toLowerCase();

      return status == selectedStatus;
    }).toList();
  }

  // ============================================================
  // Event List
  // ============================================================

  Widget _buildEventList(List<EventItemModel> events) {
    return Column(
      children: [
        for (int index = 0; index < events.length; index++) ...[
          EventCard(
            event: events[index],

            onTap: () {
              _handleEventTap(events[index]);
            },

            onJoin: () {
              _handleJoinEvent(events[index]);
            },
          ),

          if (index != events.length - 1) const SizedBox(height: 14),
        ],
      ],
    );
  }

  // ============================================================
  // Notes
  // ============================================================

  Widget _buildNotes() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.infoLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.infoBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 19,
            color: AppColors.infoDark,
          ),

          const SizedBox(width: 9),

          Expanded(
            child: Text(
              _eventsData!.notes!,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.infoDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // API - Load Events
  // ============================================================

  Future<void> _loadEvents({bool showShimmer = true}) async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;

      if (showShimmer) {
        _eventsData = null;
      }
    });

    debugPrint('');
    debugPrint('==========================================');
    debugPrint('EVENTS API LOAD');
    debugPrint('SHOW SHIMMER: $showShimmer');
    debugPrint('==========================================');

    try {
      final controller = ref.read(eventsControllerProvider);

      final result = await controller.getEvents();

      if (!mounted) return;

      debugPrint('');
      debugPrint('========== EVENTS API SUCCESS ==========');
      debugPrint('SUCCESS: ${result.success}');
      debugPrint('EVENTS COUNT: ${result.events.length}');
      debugPrint('KYC STATUS: ${result.kycStatus ?? 'N/A'}');
      debugPrint('KYC LOCKED: ${result.kycLocked}');
      debugPrint('========================================');
      debugPrint('');

      setState(() {
        _eventsData = result;
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (error, stackTrace) {
      if (!mounted) return;

      debugPrint('');
      debugPrint('========== EVENTS API ERROR ==========');
      debugPrint('ERROR: $error');
      debugPrint('STACK TRACE: $stackTrace');
      debugPrint('======================================');
      debugPrint('');

      setState(() {
        _isLoading = false;
        _errorMessage = _extractErrorMessage(error);
      });
    }
  }

  // ============================================================
  // Refresh
  // ============================================================

  Future<void> _handleRefresh() async {
    if (_isLoading) {
      return;
    }

    await _loadEvents(showShimmer: true);
  }

  // ============================================================
  // Event Tap
  // ============================================================

  void _handleEventTap(EventItemModel event) {
    debugPrint('');
    debugPrint('========== EVENT TAP ==========');
    debugPrint('EVENT ID: ${event.id ?? 'N/A'}');
    debugPrint('EVENT NAME: ${event.name ?? 'N/A'}');
    debugPrint('STATUS: ${event.status ?? 'N/A'}');
    debugPrint('===============================');
    debugPrint('');

    final eventId = event.id;

    // ============================================================
    // VALIDATE EVENT ID
    // ============================================================

    if (eventId == null || eventId <= 0) {
      debugPrint('EVENT DETAIL NAVIGATION FAILED: Invalid Event ID');
      return;
    }

    // ============================================================
    // NAVIGATE TO EVENT DETAIL
    // ============================================================

    context.push(AppRoutes.eventDetail, extra: eventId);
  }

  // ============================================================
  // Join Event
  // ============================================================

  void _handleJoinEvent(EventItemModel event) {
    final eventId = event.id;

    if (eventId == null || eventId <= 0) {
      _showErrorMessage('Unable to join this event. Event ID is missing.');
      return;
    }

    final status = event.status?.trim().toLowerCase();

    if (status != 'open') {
      _showErrorMessage('This event is not currently open for joining.');
      return;
    }

    debugPrint('');
    debugPrint('========== JOIN EVENT ==========');
    debugPrint('EVENT ID: $eventId');
    debugPrint('EVENT NAME: ${event.name ?? 'N/A'}');
    debugPrint('START DATE: ${event.startDate ?? 'N/A'}');
    debugPrint('END DATE: ${event.endDate ?? 'N/A'}');
    debugPrint('MIN DISCOUNT: ${event.minDiscountPercentage ?? 0}');
    debugPrint('STATUS: ${event.status ?? 'N/A'}');
    debugPrint('================================');
    debugPrint('');

    // ----------------------------------------------------------
    // Open Join Event / Select Products screen.
    // ----------------------------------------------------------

    context.push(
      AppRoutes.joinEvent,
      extra: {
        'eventId': eventId,
        'eventName': event.name ?? 'Event',
        'startDate': event.startDate ?? '',
        'endDate': event.endDate ?? '',
        'eventStatus': event.status,
      },
    );
  }

  // ============================================================
  // Error Message
  // ============================================================

  String _extractErrorMessage(Object error) {
    try {
      final dynamic value = error;

      final message = value.message;

      if (message is String && message.trim().isNotEmpty) {
        return message;
      }
    } catch (_) {}

    return 'Something went wrong. Please try again.';
  }

  // ============================================================
  // Error SnackBar
  // ============================================================

  void _showErrorMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.white),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.errorDark,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }
}
