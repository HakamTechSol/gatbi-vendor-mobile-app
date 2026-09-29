import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../Controller/event_detail_controller.dart';
import '../Models/event_detail_model.dart';

import '../Reuse Widgets/event_date_card.dart';
import '../Reuse Widgets/event_description_card.dart';
import '../Reuse Widgets/event_detail_error.dart';
import '../Reuse Widgets/event_detail_header.dart';
import '../Reuse Widgets/event_detail_loading.dart';
import '../Reuse Widgets/event_discount_card.dart';
import '../Reuse Widgets/event_hero_card.dart';
import '../Reuse Widgets/event_kyc_card.dart';
import '../Reuse Widgets/event_overview_card.dart';
import '../Reuse Widgets/event_participation_card.dart';

class EventDetailScreen extends ConsumerStatefulWidget {
  const EventDetailScreen({super.key, required this.eventId});

  final int eventId;

  @override
  ConsumerState<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends ConsumerState<EventDetailScreen> {
  EventDetailModel? _eventDetail;

  bool _isLoading = true;
  bool _isRefreshing = false;

  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    _loadEventDetail();
  }

  // ============================================================
  // Load Event Detail
  // ============================================================

  Future<void> _loadEventDetail({bool showFullLoader = true}) async {
    if (showFullLoader) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    } else {
      setState(() {
        _isRefreshing = true;
        _errorMessage = null;
      });
    }

    if (kDebugMode) {
      debugPrint('');
      debugPrint('=========================================');
      debugPrint('EVENT DETAIL SCREEN');
      debugPrint('=========================================');
      debugPrint('EVENT ID: ${widget.eventId}');
      debugPrint(
        'REQUEST TYPE: ${showFullLoader ? 'INITIAL LOAD' : 'REFRESH'}',
      );
      debugPrint('-----------------------------------------');
    }

    try {
      final controller = ref.read(eventDetailControllerProvider);

      final result = await controller.getEventDetail(widget.eventId);

      if (!mounted) {
        return;
      }

      if (kDebugMode) {
        debugPrint('EVENT DETAIL API SUCCESS');
        debugPrint('SUCCESS: ${result.success}');
        debugPrint('KYC STATUS: ${result.kycStatus ?? 'N/A'}');
        debugPrint('KYC LOCKED: ${result.kycLocked}');
        debugPrint('EVENT NAME: ${result.event?.name ?? 'N/A'}');
        debugPrint('EVENT STATUS: ${result.event?.status ?? 'N/A'}');
        debugPrint('=========================================');
        debugPrint('');
      }

      if (!result.success || result.event == null) {
        setState(() {
          _eventDetail = result;
          _errorMessage = 'Event details could not be loaded.';
          _isLoading = false;
          _isRefreshing = false;
        });

        return;
      }

      setState(() {
        _eventDetail = result;
        _errorMessage = null;
        _isLoading = false;
        _isRefreshing = false;
      });
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      if (kDebugMode) {
        debugPrint('');
        debugPrint('========== EVENT DETAIL ERROR ==========');
        debugPrint('MESSAGE: ${error.message}');
        debugPrint('CODE: ${error.code}');
        debugPrint('STATUS CODE: ${error.statusCode}');
        debugPrint('=========================================');
        debugPrint('');
      }

      setState(() {
        _errorMessage = error.message;
        _isLoading = false;
        _isRefreshing = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      if (kDebugMode) {
        debugPrint('');
        debugPrint('========== EVENT DETAIL ERROR ==========');
        debugPrint('UNEXPECTED ERROR: $error');
        debugPrint('=========================================');
        debugPrint('');
      }

      setState(() {
        _errorMessage = 'Something went wrong. Please try again.';
        _isLoading = false;
        _isRefreshing = false;
      });
    }
  }

  // ============================================================
  // Refresh
  // ============================================================

  Future<void> _refreshEventDetail() async {
    await _loadEventDetail(showFullLoader: false);
  }

  // ============================================================
  // Back
  // ============================================================

  void _handleBack() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  // ============================================================
  // Build
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            if (_eventDetail?.event != null)
              EventDetailHeader(
                event: _eventDetail!.event!,
                onBack: _handleBack,
              )
            else
              _buildFallbackHeader(),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // Body
  // ============================================================

  Widget _buildBody() {
    if (_isLoading && _eventDetail == null) {
      return const EventDetailLoading();
    }

    if (_errorMessage != null && _eventDetail?.event == null) {
      return EventDetailError(
        message: _errorMessage,
        onRetry: () {
          _loadEventDetail(showFullLoader: true);
        },
      );
    }

    final detail = _eventDetail;

    if (detail == null || detail.event == null) {
      return EventDetailError(
        message: 'Event details are not available.',
        onRetry: () {
          _loadEventDetail(showFullLoader: true);
        },
      );
    }

    return _buildEventContent(detail);
  }

  // ============================================================
  // Event Content
  // ============================================================

  Widget _buildEventContent(EventDetailModel detail) {
    final event = detail.event!;

    return Stack(
      children: [
        RefreshIndicator(
          color: AppColors.primary,
          backgroundColor: AppColors.white,
          onRefresh: _refreshEventDetail,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
            children: [
              EventHeroCard(event: event),

              const SizedBox(height: 14),

              EventOverviewCard(event: event),

              const SizedBox(height: 14),

              EventDiscountCard(event: event),

              const SizedBox(height: 14),

              EventDateCard(event: event),

              if (_hasDescription(event)) ...[
                const SizedBox(height: 14),
                EventDescriptionCard(event: event),
              ],

              const SizedBox(height: 14),

              EventParticipationCard(event: event),

              const SizedBox(height: 14),

              EventKycCard(
                kycStatus: detail.kycStatus,
                kycLocked: detail.kycLocked,
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),

        if (_isRefreshing)
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: LinearProgressIndicator(
              minHeight: 2,
              backgroundColor: AppColors.primarySurface,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
      ],
    );
  }

  // ============================================================
  // Description Check
  // ============================================================

  bool _hasDescription(EventDetailItemModel event) {
    final description = event.description?.trim();

    return description != null && description.isNotEmpty;
  }

  // ============================================================
  // Fallback Header
  // ============================================================

  Widget _buildFallbackHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Row(
            children: [
              _BackButton(onTap: _handleBack),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Event Details',
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// Back Button
// ============================================================

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primarySurface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: const SizedBox(
          width: 42,
          height: 42,
          child: Icon(
            Icons.arrow_back_rounded,
            size: 21,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
