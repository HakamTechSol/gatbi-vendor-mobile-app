import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../Routes/app_route.dart';
import '../../../../Routes/route_observer.dart';
import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../../Cancel Participation/Controller/cancel_participation_controller.dart';
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

class _EventsScreenState extends ConsumerState<EventsScreen> with RouteAware {
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final route = ModalRoute.of(context);

    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  // ============================================================
  // Route Observer
  // ============================================================

  /// Jab Join Event / Edit Event / kisi bhi pushed screen se
  /// EventsScreen par wapas aayenge to ye method call hoga.
  @override
  void didPopNext() {
    debugPrint('');
    debugPrint('==========================================');
    debugPrint('EVENTS SCREEN VISIBLE AGAIN');
    debugPrint('REFRESH EVENTS API');
    debugPrint('SHOW SHIMMER: TRUE');
    debugPrint('==========================================');
    debugPrint('');

    _loadEvents(showShimmer: true);
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

            // --------------------------------------------------
            // Event Detail
            // --------------------------------------------------
            onTap: () {
              _handleEventTap(events[index]);
            },

            // --------------------------------------------------
            // Join Event
            // --------------------------------------------------
            onJoin: () {
              _handleJoinEvent(events[index]);
            },

            // --------------------------------------------------
            // Update Participation
            // --------------------------------------------------
            onUpdateParticipation: () {
              _handleEditEvent(events[index]);
            },

            // --------------------------------------------------
            // Cancel Participation
            // --------------------------------------------------
            onDeleteParticipation: () {
              _handleCancelParticipation(events[index]);
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
    // NAVIGATE
    // ============================================================

    context.push(AppRoutes.eventDetail, extra: eventId);
  }

  // ============================================================
  // Join Event
  // ============================================================

  Future<void> _handleJoinEvent(EventItemModel event) async {
    final eventId = event.id;

    // ============================================================
    // VALIDATE EVENT ID
    // ============================================================

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

    // ============================================================
    // NAVIGATE TO JOIN
    // ============================================================

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
  // Edit Event
  // ============================================================

  void _handleEditEvent(EventItemModel event) {
    final eventId = event.id;

    // ============================================================
    // VALIDATE EVENT ID
    // ============================================================

    if (eventId == null || eventId <= 0) {
      _showErrorMessage('Unable to edit this event. Event ID is missing.');
      return;
    }

    // ============================================================
    // DEBUG LOG
    // ============================================================

    debugPrint('');
    debugPrint('========== EDIT EVENT ==========');
    debugPrint('EVENT ID: $eventId');
    debugPrint('EVENT NAME: ${event.name ?? 'N/A'}');
    debugPrint('START DATE: ${event.startDate ?? 'N/A'}');
    debugPrint('END DATE: ${event.endDate ?? 'N/A'}');
    debugPrint('STATUS: ${event.status ?? 'N/A'}');
    debugPrint('================================');
    debugPrint('');

    // ============================================================
    // NAVIGATE TO EDIT
    // ============================================================

    context.push(AppRoutes.editEvent, extra: eventId);
  }

  // ============================================================
  // Cancel Participation
  // ============================================================

  Future<void> _handleCancelParticipation(EventItemModel event) async {
    final eventId = event.id;

    // ============================================================
    // VALIDATE EVENT ID
    // ============================================================

    if (eventId == null || eventId <= 0) {
      _showErrorMessage('Unable to cancel participation. Event ID is missing.');
      return;
    }

    // ============================================================
    // CONFIRMATION POPUP
    // ============================================================

    final confirmed = await _showCancelConfirmationDialog(event);

    if (!confirmed) {
      return;
    }

    if (!mounted) return;

    // ============================================================
    // CALL CANCEL API
    // ============================================================

    await _cancelParticipation(eventId);
  }

  // ============================================================
  // Cancel Confirmation Dialog
  // ============================================================

  Future<bool> _showCancelConfirmationDialog(EventItemModel event) async {
    if (!mounted) return false;

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          titlePadding: const EdgeInsets.fromLTRB(22, 22, 22, 8),
          contentPadding: const EdgeInsets.fromLTRB(22, 8, 22, 18),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          title: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.errorLight,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.event_busy_rounded,
                  color: AppColors.errorDark,
                  size: 23,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  'Cancel participation?',
                  style: AppTextStyles.titleMedium,
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to cancel your participation '
            'in "${event.name ?? 'this event'}"?\n\n'
            'Your participation will be withdrawn and its status '
            'will become cancelled.',
            style: AppTextStyles.bodySmall.copyWith(
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
                'Keep Participation',
                style: AppTextStyles.labelMedium.copyWith(
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
                  borderRadius: BorderRadius.circular(11),
                ),
              ),
              child: const Text('Cancel Participation'),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  // ============================================================
  // Cancel Participation API
  // ============================================================

  Future<void> _cancelParticipation(int eventId) async {
    if (!mounted) return;

    setState(() {});

    debugPrint('');
    debugPrint('==========================================');
    debugPrint('CANCEL PARTICIPATION API');
    debugPrint('EVENT ID: $eventId');
    debugPrint('==========================================');

    // ============================================================
    // SHOW LOADING POPUP
    // ============================================================

    _showCancelLoadingDialog();

    try {
      final controller = ref.read(cancelParticipationControllerProvider);

      final result = await controller.cancelParticipation(eventId: eventId);

      if (!mounted) return;

      debugPrint('');
      debugPrint('========== CANCEL PARTICIPATION SUCCESS ==========');
      debugPrint('SUCCESS: ${result.success}');
      debugPrint('MESSAGE: ${result.message ?? 'N/A'}');
      debugPrint('EVENT ID: ${result.eventId ?? 'N/A'}');
      debugPrint('CAMPAIGN ID: ${result.campaignId ?? 'N/A'}');
      debugPrint('STATUS: ${result.status ?? 'N/A'}');
      debugPrint('===================================================');
      debugPrint('');

      // ==========================================================
      // CLOSE LOADING POPUP
      // ==========================================================

      Navigator.of(context, rootNavigator: true).pop();

      setState(() {});

      // ==========================================================
      // SUCCESS SNACKBAR
      // ==========================================================

      _showSuccessMessage(
        result.message ?? 'Participation withdrawn successfully.',
      );

      // ==========================================================
      // REFRESH EVENTS
      // ==========================================================

      await _loadEvents(showShimmer: true);
    } catch (error, stackTrace) {
      if (!mounted) return;

      debugPrint('');
      debugPrint('========== CANCEL PARTICIPATION ERROR ==========');
      debugPrint('ERROR: $error');
      debugPrint('STACK TRACE: $stackTrace');
      debugPrint('================================================');
      debugPrint('');

      // ==========================================================
      // CLOSE LOADING POPUP
      // ==========================================================

      Navigator.of(context, rootNavigator: true).pop();

      setState(() {});

      // ==========================================================
      // ERROR SNACKBAR
      // ==========================================================

      _showErrorMessage(_extractErrorMessage(error));
    }
  }

  // ============================================================
  // Cancel Loading Dialog
  // ============================================================

  void _showCancelLoadingDialog() {
    if (!mounted) return;

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            backgroundColor: AppColors.white,
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            content: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2.5),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Text(
                      'Cancelling participation...',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
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

  // ============================================================
  // Success SnackBar
  // ============================================================

  void _showSuccessMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: AppColors.white,
                size: 20,
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  message,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.successDark,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }
}
