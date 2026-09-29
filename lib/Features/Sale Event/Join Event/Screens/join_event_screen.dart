import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Core/Custom Widgets/custom_button.dart';
import '../../../../Core/Custom Widgets/custom_textfield.dart';
import '../../../../Services/api_exception.dart';
import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../../../Campaign/Create Campaign/Reuse Widgets/product_multiselect_dropdown.dart';
import '../../Get Event/Reuse widgets/event_status_badge.dart';
import '../Controller/join_event_controller.dart';

class JoinEventScreen extends ConsumerStatefulWidget {
  const JoinEventScreen({
    super.key,
    required this.eventId,
    required this.eventName,
    required this.startDate,
    required this.endDate,
    this.eventStatus,
  });

  final int eventId;
  final String eventName;
  final String startDate;
  final String endDate;
  final String? eventStatus;

  @override
  ConsumerState<JoinEventScreen> createState() => _JoinEventScreenState();
}

class _JoinEventScreenState extends ConsumerState<JoinEventScreen> {
  final _formKey = GlobalKey<FormState>();

  final _discountController = TextEditingController();
  final _notesController = TextEditingController();

  final Set<int> _selectedProductIds = <int>{};

  bool _isSubmitting = false;
  String? _productsError;

  @override
  void dispose() {
    _discountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // ============================================================
  // Join Event
  // ============================================================

  Future<void> _joinEvent() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _productsError = null;
    });

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedProductIds.isEmpty) {
      setState(() {
        _productsError = 'Please select at least one product.';
      });
      return;
    }

    final discount = num.tryParse(_discountController.text.trim());

    if (discount == null || discount <= 0) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final result = await ref
          .read(joinEventControllerProvider)
          .joinEvent(
            eventId: widget.eventId,
            productIds: _selectedProductIds.toList(),
            requestedDiscountPercentage: discount,
            notes: _notesController.text.trim().isEmpty
                ? null
                : _notesController.text.trim(),
          );

      if (!mounted) {
        return;
      }

      // ==========================================================
      // API returned unsuccessful response
      // ==========================================================

      if (!result.success) {
        _showError(result.message ?? 'Unable to join this event.');
        return;
      }

      // ==========================================================
      // Success
      // ==========================================================

      final successMessage =
          result.message != null && result.message!.trim().isNotEmpty
          ? result.message!.trim()
          : 'Event joined successfully. Your submission is pending admin review.';

      debugPrint('');
      debugPrint('========== JOIN EVENT SUCCESS ==========');
      debugPrint('EVENT ID: ${widget.eventId}');
      debugPrint('EVENT NAME: ${widget.eventName}');
      debugPrint('PRODUCT IDS: ${_selectedProductIds.toList()}');
      debugPrint('CAMPAIGN ID: ${result.campaignId ?? 'N/A'}');
      debugPrint('TICKET ID: ${result.ticketId ?? 'N/A'}');
      debugPrint('STATUS: ${result.status ?? 'N/A'}');
      debugPrint('MESSAGE: $successMessage');
      debugPrint('========================================');
      debugPrint('');

      // Pop this screen and return the success message
      Navigator.of(context).pop(<String, dynamic>{
        'success': true,
        'message': successMessage,
        'campaignId': result.campaignId,
        'ticketId': result.ticketId,
        'status': result.status,
      });
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      _showError(
        error.message.isNotEmpty ? error.message : 'Unable to join this event.',
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      _showError('Something went wrong. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  // ============================================================
  // Error SnackBar
  // ============================================================

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.errorDark,
          duration: const Duration(seconds: 4),
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Row(
            children: [
              const Icon(Icons.error_outline_rounded, color: AppColors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  String _formatDate(String value) {
    if (value.trim().isEmpty) {
      return 'N/A';
    }

    final parts = value.split('-');

    if (parts.length != 3) {
      return value;
    }

    return '${parts[2]}/${parts[1]}/${parts[0]}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.textPrimary,
          ),
        ),
        title: Text('Join Event', style: AppTextStyles.titleLarge),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: AppColors.divider),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final horizontalPadding = constraints.maxWidth >= 900
                  ? 32.0
                  : 20.0;

              final contentWidth = constraints.maxWidth >= 1000
                  ? 900.0
                  : double.infinity;

              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  20,
                  horizontalPadding,
                  32,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: contentWidth),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildEventHeader(),
                        const SizedBox(height: 20),
                        _buildJoinForm(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // ============================================================
  // Event Header
  // ============================================================

  Widget _buildEventHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowStrong,
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -45,
            right: -35,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -55,
            left: -25,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.06),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: AppColors.white.withValues(alpha: 0.20),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.flash_on_rounded,
                            size: 14,
                            color: AppColors.white,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'JOIN EVENT',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.7,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    if (widget.eventStatus != null)
                      EventStatusBadge(status: widget.eventStatus),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  widget.eventName.isNotEmpty ? widget.eventName : 'Sale Event',
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  'Submit your products and requested discount '
                  'for admin review.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textOnPrimarySecondary,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _EventDateInfo(
                        icon: Icons.calendar_today_rounded,
                        label: 'Starts',
                        value: _formatDate(widget.startDate),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _EventDateInfo(
                        icon: Icons.event_available_rounded,
                        label: 'Ends',
                        value: _formatDate(widget.endDate),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Join Form
  // ============================================================

  Widget _buildJoinForm() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Event Submission', style: AppTextStyles.titleLarge),
          const SizedBox(height: 5),
          Text(
            'Select the products you want to include and '
            'set your requested discount.',
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 22),

          // ------------------------------------------------------
          // Products
          // ------------------------------------------------------
          ProductMultiSelectDropdown(
            selectedIds: _selectedProductIds,
            errorText: _productsError,
            onChanged: (ids) {
              setState(() {
                _selectedProductIds
                  ..clear()
                  ..addAll(ids);

                _productsError = null;
              });
            },
          ),

          const SizedBox(height: 18),

          // ------------------------------------------------------
          // Discount
          // ------------------------------------------------------
          CustomTextField(
            controller: _discountController,
            label: 'Requested Discount',
            hintText: 'Enter discount percentage',
            prefixIcon: Icons.percent_rounded,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.next,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
            validator: (value) {
              final text = value?.trim() ?? '';

              if (text.isEmpty) {
                return 'Please enter requested discount.';
              }

              final discount = num.tryParse(text);

              if (discount == null) {
                return 'Please enter a valid discount.';
              }

              if (discount <= 0) {
                return 'Discount must be greater than 0%.';
              }

              return null;
            },
          ),

          const SizedBox(height: 18),

          // ------------------------------------------------------
          // Notes
          // ------------------------------------------------------
          CustomTextField(
            controller: _notesController,
            label: 'Notes',
            hintText: 'Add any notes for the admin (optional)',
            maxLines: 4,
            minLines: 4,
            maxLength: 500,
            showCounter: true,
            textInputAction: TextInputAction.newline,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),

          const SizedBox(height: 22),

          // ------------------------------------------------------
          // Information
          // ------------------------------------------------------
          _buildReviewNotice(),

          const SizedBox(height: 20),

          // ------------------------------------------------------
          // Submit
          // ------------------------------------------------------
          CustomButton(
            text: 'Join Event',
            icon: Icons.arrow_forward_rounded,
            iconPosition: CustomButtonIconPosition.trailing,
            height: 54,
            borderRadius: 12,
            isLoading: _isSubmitting,
            onPressed: _isSubmitting ? null : _joinEvent,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Review Notice
  // ============================================================

  Widget _buildReviewNotice() {
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
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.info_outline_rounded,
              size: 19,
              color: AppColors.info,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Admin Review',
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.infoDark,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Your submission will remain pending until '
                  'it is reviewed by the admin team.',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// Event Date Info
// ═══════════════════════════════════════════════════════════════════════════

class _EventDateInfo extends StatelessWidget {
  const _EventDateInfo({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.14)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.white),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textOnPrimarySecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
