import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Theme/app_colors.dart';

import '../../Cancel Campaign/Controller/cancel_campaign_controller.dart';
import '../../Cancel Campaign/Screens/campaign_cancel_button.dart';

import '../Controller/campaign_detail_controller.dart';
import '../Models/campaign_detail_model.dart';

import '../Reuse Widgets/campaign_date_card.dart';
import '../Reuse Widgets/campaign_detail_error.dart';
import '../Reuse Widgets/campaign_detail_header.dart';
import '../Reuse Widgets/campaign_detail_loading.dart';
import '../Reuse Widgets/campaign_discount_card.dart';
import '../Reuse Widgets/campaign_notes_card.dart';
import '../Reuse Widgets/campaign_overview_card.dart';
import '../Reuse Widgets/campaign_products_card.dart';
import '../Reuse Widgets/campaign_timeline_card.dart';

class CampaignDetailScreen extends ConsumerStatefulWidget {
  const CampaignDetailScreen({
    super.key,
    required this.campaignId,
    this.onBack,
    this.onRefresh,
  });

  final int campaignId;

  /// Optional custom back callback.
  final VoidCallback? onBack;

  /// Called only after a successful explicit refresh.
  final VoidCallback? onRefresh;

  @override
  ConsumerState<CampaignDetailScreen> createState() =>
      _CampaignDetailScreenState();
}

class _CampaignDetailScreenState extends ConsumerState<CampaignDetailScreen> {
  CampaignDetailData? _campaign;

  bool _isLoading = true;

  bool _isCancelling = false;

  String? _errorMessage;

  // ============================================================
  // LIFECYCLE
  // ============================================================

  @override
  void initState() {
    super.initState();

    _loadCampaignDetail();
  }

  // ============================================================
  // GET CAMPAIGN DETAIL
  // ============================================================

  Future<void> _loadCampaignDetail({bool isRefresh = false}) async {
    if (!mounted) {
      return;
    }

    if (isRefresh) {
      setState(() {
        _errorMessage = null;
      });
    } else {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    _debugLog('============================================================');

    _debugLog('CAMPAIGN DETAIL API REQUEST');

    _debugLog('Campaign ID: ${widget.campaignId}');

    _debugLog('Refresh: $isRefresh');

    _debugLog('============================================================');

    try {
      final controller = ref.read(campaignDetailControllerProvider);

      final result = await controller.getCampaignDetail(widget.campaignId);

      if (!mounted) {
        return;
      }

      _debugLog('============================================================');

      _debugLog('CAMPAIGN DETAIL API RESPONSE');

      _debugLog('Success: ${result.success}');

      _debugLog('Campaign ID: ${result.campaign?.id ?? 'N/A'}');

      _debugLog('Campaign Name: ${result.campaign?.name ?? 'N/A'}');

      _debugLog('Campaign Status: ${result.campaign?.status ?? 'N/A'}');

      _debugLog(
        'Products Count: '
        '${result.campaign?.products.length ?? 0}',
      );

      _debugLog(
        'Vendor Notes Available: '
        '${_hasText(result.campaign?.vendorNotes)}',
      );

      _debugLog(
        'Admin Notes Available: '
        '${_hasText(result.campaign?.adminNotes)}',
      );

      _debugLog('Campaign: ${result.campaign?.toJson()}');

      _debugLog('============================================================');

      // ----------------------------------------------------------
      // Validate Success
      // ----------------------------------------------------------

      if (!result.success) {
        throw const ApiException(
          message: 'Unable to load campaign details.',
          code: 'CAMPAIGN_DETAIL_FAILED',
        );
      }

      // ----------------------------------------------------------
      // Validate Campaign
      // ----------------------------------------------------------

      if (result.campaign == null) {
        throw const ApiException(
          message: 'Campaign details were not found.',
          code: 'CAMPAIGN_DETAIL_EMPTY',
        );
      }

      // ----------------------------------------------------------
      // Update UI
      // ----------------------------------------------------------

      setState(() {
        _campaign = result.campaign;
        _errorMessage = null;
        _isLoading = false;
      });

      // ----------------------------------------------------------
      // External Refresh Callback
      // ----------------------------------------------------------

      if (isRefresh) {
        widget.onRefresh?.call();
      }
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      _debugLog('============================================================');

      _debugLog('CAMPAIGN DETAIL API ERROR');

      _debugLog('Message: ${error.message}');

      _debugLog('Code: ${error.code}');

      _debugLog('Original Error: ${error.originalError}');

      _debugLog('============================================================');

      setState(() {
        _errorMessage = error.message;
        _isLoading = false;
      });
    } catch (error, stackTrace) {
      if (!mounted) {
        return;
      }

      _debugLog('============================================================');

      _debugLog('CAMPAIGN DETAIL UNEXPECTED ERROR');

      _debugLog('Error: $error');

      _debugLog('StackTrace: $stackTrace');

      _debugLog('============================================================');

      setState(() {
        _errorMessage = 'Something went wrong. Please try again.';
        _isLoading = false;
      });
    }
  }

  // ============================================================
  // REFRESH
  // ============================================================

  Future<void> _handleRefresh() async {
    await _loadCampaignDetail(isRefresh: true);
  }

  // ============================================================
  // CANCEL CAMPAIGN
  // ============================================================

  Future<void> _handleCancelCampaign() async {
    final campaign = _campaign;

    if (campaign == null) {
      return;
    }

    // ----------------------------------------------------------
    // Only Pending Campaign Can Be Cancelled
    // ----------------------------------------------------------

    if (!_isPendingCampaign(campaign)) {
      _debugLog(
        'Cancel blocked because campaign status is '
        '${campaign.status ?? 'N/A'}',
      );

      return;
    }

    final campaignId = campaign.id;

    if (campaignId == null || campaignId <= 0) {
      _showMessage('Campaign ID is missing.', isError: true);

      return;
    }

    // ----------------------------------------------------------
    // Already Cancelling
    // ----------------------------------------------------------

    if (_isCancelling) {
      return;
    }

    // ----------------------------------------------------------
    // Confirmation
    // ----------------------------------------------------------

    final shouldCancel = await _showCancelConfirmation();

    if (!shouldCancel || !mounted) {
      return;
    }

    setState(() {
      _isCancelling = true;
    });

    _debugLog('============================================================');

    _debugLog('CANCEL CAMPAIGN API REQUEST');

    _debugLog('Campaign ID: $campaignId');

    _debugLog('Campaign Name: ${campaign.name ?? 'N/A'}');

    _debugLog('Current Status: ${campaign.status ?? 'N/A'}');

    _debugLog('============================================================');

    try {
      final controller = ref.read(cancelCampaignControllerProvider);

      final result = await controller.cancelCampaign(campaignId);

      if (!mounted) {
        return;
      }

      _debugLog('============================================================');

      _debugLog('CANCEL CAMPAIGN API RESPONSE');

      _debugLog('Success: ${result.success}');

      _debugLog('Message: ${result.message ?? 'N/A'}');

      _debugLog('Campaign ID: ${result.campaignId ?? 'N/A'}');

      _debugLog('Status: ${result.status ?? 'N/A'}');

      _debugLog('============================================================');

      // --------------------------------------------------------
      // API Failed
      // --------------------------------------------------------

      if (!result.success) {
        throw ApiException(
          message: result.message ?? 'Unable to cancel campaign.',
          code: 'CAMPAIGN_CANCEL_FAILED',
        );
      }

      // --------------------------------------------------------
      // Success Message
      // --------------------------------------------------------

      _showMessage(
        result.message ?? 'Campaign request cancelled successfully.',
      );

      // --------------------------------------------------------
      // Reload Detail
      //
      // API status becomes cancelled.
      // After reload cancel button automatically disappears.
      // --------------------------------------------------------

      await _loadCampaignDetail(isRefresh: true);
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      _debugLog('============================================================');

      _debugLog('CANCEL CAMPAIGN API ERROR');

      _debugLog('Message: ${error.message}');

      _debugLog('Code: ${error.code}');

      _debugLog('Original Error: ${error.originalError}');

      _debugLog('============================================================');

      _showMessage(error.message, isError: true);
    } catch (error, stackTrace) {
      if (!mounted) {
        return;
      }

      _debugLog('============================================================');

      _debugLog('CANCEL CAMPAIGN UNEXPECTED ERROR');

      _debugLog('Error: $error');

      _debugLog('StackTrace: $stackTrace');

      _debugLog('============================================================');

      _showMessage('Something went wrong. Please try again.', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _isCancelling = false;
        });
      }
    }
  }

  // ============================================================
  // CANCEL CONFIRMATION
  // ============================================================

  Future<bool> _showCancelConfirmation() async {
    final campaignName = _campaign?.name?.trim().isNotEmpty == true
        ? _campaign!.name!.trim()
        : 'this campaign';

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
          actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          title: const Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: AppColors.warning,
                size: 25,
              ),

              SizedBox(width: 10),

              Expanded(
                child: Text(
                  'Cancel Campaign?',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to cancel '
            '"$campaignName"? '
            'This action will change the campaign '
            'status to cancelled.',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text(
                'Keep Campaign',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: AppColors.error,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Yes, Cancel',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  // ============================================================
  // PENDING STATUS
  // ============================================================

  bool _isPendingCampaign(CampaignDetailData campaign) {
    return campaign.status?.trim().toLowerCase() == 'pending';
  }

  // ============================================================
  // NOTES CHECK
  // ============================================================

  bool _hasCampaignNotes(CampaignDetailData campaign) {
    final hasVendorNotes = _hasText(campaign.vendorNotes);

    final hasAdminNotes = _hasText(campaign.adminNotes);

    return hasVendorNotes || hasAdminNotes;
  }

  // ============================================================
  // TEXT CHECK
  // ============================================================

  bool _hasText(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) {
      return;
    }

    final messenger = ScaffoldMessenger.of(context);

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? AppColors.error : AppColors.success,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }

  // ============================================================
  // BACK
  // ============================================================

  void _handleBack() {
    if (widget.onBack != null) {
      widget.onBack!();
      return;
    }

    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(bottom: false, child: _buildContent()),
    );
  }

  // ============================================================
  // CONTENT
  // ============================================================

  Widget _buildContent() {
    // ----------------------------------------------------------
    // Initial Loading
    // ----------------------------------------------------------

    if (_isLoading && _campaign == null) {
      return const CampaignDetailLoading();
    }

    // ----------------------------------------------------------
    // Error
    // ----------------------------------------------------------

    if (_campaign == null && _errorMessage != null) {
      return CampaignDetailError(
        message: _errorMessage,
        onRetry: () {
          _loadCampaignDetail();
        },
        onBack: _handleBack,
      );
    }

    // ----------------------------------------------------------
    // Empty
    // ----------------------------------------------------------

    if (_campaign == null) {
      return CampaignDetailError(
        message: 'Campaign details are currently unavailable.',
        onRetry: () {
          _loadCampaignDetail();
        },
        onBack: _handleBack,
      );
    }

    return _buildCampaignContent(_campaign!);
  }

  // ============================================================
  // CAMPAIGN CONTENT
  // ============================================================

  Widget _buildCampaignContent(CampaignDetailData campaign) {
    final showCancelButton = _isPendingCampaign(campaign);

    final showNotes = _hasCampaignNotes(campaign);

    return Column(
      children: [
        // ------------------------------------------------------
        // Header
        // ------------------------------------------------------
        CampaignDetailHeader(campaign: campaign, onBack: _handleBack),

        // ------------------------------------------------------
        // Scrollable Content
        // ------------------------------------------------------
        Expanded(
          child: RefreshIndicator(
            onRefresh: _handleRefresh,
            color: AppColors.primary,
            backgroundColor: AppColors.white,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
              children: [
                // ------------------------------------------------
                // Overview
                // ------------------------------------------------
                CampaignOverviewCard(campaign: campaign),

                const SizedBox(height: 14),

                // ------------------------------------------------
                // Discount
                // ------------------------------------------------
                CampaignDiscountCard(campaign: campaign),

                const SizedBox(height: 14),

                // ------------------------------------------------
                // Dates
                // ------------------------------------------------
                CampaignDateCard(campaign: campaign),

                const SizedBox(height: 14),

                // ------------------------------------------------
                // Products
                // ------------------------------------------------
                CampaignProductsCard(campaign: campaign),

                // ------------------------------------------------
                // Notes
                //
                // Entire card hidden when both vendor/admin
                // notes are null or empty.
                // Individual empty note is hidden inside
                // CampaignNotesCard.
                // ------------------------------------------------
                if (showNotes) ...[
                  const SizedBox(height: 14),

                  CampaignNotesCard(campaign: campaign),
                ],

                // ------------------------------------------------
                // Timeline
                // ------------------------------------------------
                const SizedBox(height: 14),

                CampaignTimelineCard(campaign: campaign),

                // ------------------------------------------------
                // Cancel Button
                //
                // ONLY pending status.
                // ------------------------------------------------
                if (showCancelButton) ...[
                  const SizedBox(height: 18),

                  CampaignCancelButton(
                    isLoading: _isCancelling,
                    onPressed: _isCancelling ? null : _handleCancelCampaign,
                  ),
                ],

                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // DEBUG LOGGER
  // ============================================================

  void _debugLog(String message) {
    if (kDebugMode) {
      debugPrint('[CampaignDetail] $message');
    }
  }
}
