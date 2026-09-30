import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Core/Custom Widgets/custom_button.dart';
import '../../../../Core/Custom Widgets/custom_textfield.dart';
import '../../../../Services/api_exception.dart';
import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../../../Campaign/Create Campaign/Reuse Widgets/product_multiselect_dropdown.dart';

import '../../Event Detail/Controller/event_detail_controller.dart';
import '../../Get Event/Reuse widgets/event_status_badge.dart';

import '../Controller/edit_event_controller.dart';

class EditEventScreen extends ConsumerStatefulWidget {
  const EditEventScreen({
    super.key,
    required this.eventId,
    this.eventName,
    this.eventStatus,
  });

  final int eventId;
  final String? eventName;
  final String? eventStatus;

  @override
  ConsumerState<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends ConsumerState<EditEventScreen> {
  final _formKey = GlobalKey<FormState>();

  final _discountController = TextEditingController();
  final _notesController = TextEditingController();

  final Set<int> _selectedProductIds = <int>{};

  bool _isLoading = true;
  bool _isSubmitting = false;

  String? _errorMessage;
  String? _productsError;

  String _eventName = 'Edit Event';
  String _startDate = '';
  String _endDate = '';
  String? _eventStatus;

  @override
  void initState() {
    super.initState();

    _eventName = widget.eventName?.trim().isNotEmpty == true
        ? widget.eventName!.trim()
        : 'Edit Event';

    _eventStatus = widget.eventStatus;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadEventDetail();
    });
  }

  @override
  void dispose() {
    _discountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // ============================================================
  // Load Event Detail
  // ============================================================

  Future<void> _loadEventDetail() async {
    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await ref
          .read(eventDetailControllerProvider)
          .getEventDetail(widget.eventId);

      if (!mounted) {
        return;
      }

      final event = result.event;

      if (event == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Event details could not be loaded.';
        });

        return;
      }

      final participation = event.myParticipation;

      // ----------------------------------------------------------
      // Event Data
      // ----------------------------------------------------------

      _eventName = event.name?.trim().isNotEmpty == true
          ? event.name!.trim()
          : _eventName;

      _startDate = event.startDate ?? '';
      _endDate = event.endDate ?? '';
      _eventStatus = event.status;

      // ----------------------------------------------------------
      // Existing Participation Data
      // ----------------------------------------------------------

      if (participation != null) {
        final requestedDiscount = participation.requestedDiscountPercentage;

        if (requestedDiscount != null) {
          _discountController.text = _formatNumber(requestedDiscount);
        }

        _selectedProductIds
          ..clear()
          ..addAll(participation.productIds);
      }

      _isLoading = false;

      setState(() {});
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage = error.message.isNotEmpty
            ? error.message
            : 'Unable to load event details.';
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage = 'Something went wrong. Please try again.';
      });
    }
  }

  // ============================================================
  // Update Event
  // ============================================================

  Future<void> _updateEvent() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _productsError = null;
    });

    if (!_formKey.currentState!.validate()) {
      return;
    }

    // ----------------------------------------------------------
    // Product Validation
    // ----------------------------------------------------------

    if (_selectedProductIds.isEmpty) {
      setState(() {
        _productsError = 'Please select at least one product.';
      });

      return;
    }

    // ----------------------------------------------------------
    // Discount
    // ----------------------------------------------------------

    final discount = num.tryParse(_discountController.text.trim());

    if (discount == null || discount <= 0) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final result = await ref
          .read(editEventControllerProvider)
          .updateEvent(
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

      // ========================================================
      // API Failed
      // ========================================================

      if (!result.success) {
        _showError(result.message ?? 'Unable to update event participation.');

        return;
      }

      // ========================================================
      // Success
      // ========================================================

      final successMessage =
          result.message != null && result.message!.trim().isNotEmpty
          ? result.message!.trim()
          : 'Event participation updated successfully.';

      debugPrint('');
      debugPrint('========== EDIT EVENT SUCCESS ==========');
      debugPrint('EVENT ID: ${widget.eventId}');
      debugPrint('EVENT NAME: $_eventName');
      debugPrint('PRODUCT IDS: ${_selectedProductIds.toList()}');
      debugPrint('CAMPAIGN ID: ${result.campaignId ?? 'N/A'}');
      debugPrint('STATUS: ${result.status ?? 'N/A'}');
      debugPrint(
        'REQUESTED DISCOUNT: '
        '${result.requestedDiscountPercentage ?? discount}',
      );
      debugPrint('MESSAGE: $successMessage');
      debugPrint('========================================');
      debugPrint('');

      // ========================================================
      // Return Result To Previous Screen
      // ========================================================

      Navigator.of(context).pop(<String, dynamic>{
        'success': true,
        'message': successMessage,
        'eventId': widget.eventId,
        'campaignId': result.campaignId,
        'status': result.status,
      });
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      _showError(
        error.message.isNotEmpty
            ? error.message
            : 'Unable to update event participation.',
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
  // Error Snackbar
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

  // ============================================================
  // Date Formatter
  // ============================================================

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

  // ============================================================
  // Number Formatter
  // ============================================================

  String _formatNumber(num value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toStringAsFixed(2);
  }

  // ============================================================
  // Build
  // ============================================================

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
        title: Text('Edit Event', style: AppTextStyles.titleLarge),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: AppColors.divider),
        ),
      ),
      body: SafeArea(top: false, child: _buildBody()),
    );
  }

  // ============================================================
  // Body
  // ============================================================

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (_errorMessage != null) {
      return _buildErrorState();
    }

    return Form(
      key: _formKey,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final horizontalPadding = constraints.maxWidth >= 900 ? 32.0 : 20.0;

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
                    _buildEditForm(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // Error State
  // ============================================================

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.errorLight,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 32,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Unable to Load Event',
              style: AppTextStyles.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 7),
            Text(
              _errorMessage ?? 'Something went wrong. Please try again.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            CustomButton(
              text: 'Try Again',
              icon: Icons.refresh_rounded,
              height: 48,
              borderRadius: 12,
              onPressed: _loadEventDetail,
            ),
          ],
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
                            Icons.edit_rounded,
                            size: 14,
                            color: AppColors.white,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'EDIT EVENT',
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
                    if (_eventStatus != null)
                      EventStatusBadge(status: _eventStatus),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  _eventName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  'Update your selected products and '
                  'requested discount for admin review.',
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
                        value: _formatDate(_startDate),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _EventDateInfo(
                        icon: Icons.event_available_rounded,
                        label: 'Ends',
                        value: _formatDate(_endDate),
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
  // Edit Form
  // ============================================================

  Widget _buildEditForm() {
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
          Text('Update Submission', style: AppTextStyles.titleLarge),
          const SizedBox(height: 5),
          Text(
            'Update the products you want to include and '
            'your requested discount.',
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
          // Review Notice
          // ------------------------------------------------------
          _buildReviewNotice(),

          const SizedBox(height: 20),

          // ------------------------------------------------------
          // Update Button
          // ------------------------------------------------------
          CustomButton(
            text: 'Update Participation',
            icon: Icons.check_rounded,
            iconPosition: CustomButtonIconPosition.trailing,
            height: 54,
            borderRadius: 12,
            isLoading: _isSubmitting,
            onPressed: _isSubmitting ? null : _updateEvent,
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
                  'After updating, your submission will '
                  'return to pending until it is reviewed '
                  'by the admin team.',
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
