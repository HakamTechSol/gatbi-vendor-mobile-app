import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Core/Custom Widgets/custom_button.dart';
import '../../../../Services/api_exception.dart';
import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../Controller/order_detail_controller.dart';
import '../Models/order_detail_model.dart';
import '../Models/order_payment_proof_model.dart';

import '../Oder Status/Controller/order_status_controller.dart';
import '../Payment Proof/Accecpted/Controller/verify_controller.dart';
import '../Payment Proof/Rejected/controller/reject_controller.dart';
import '../Payment Proof/Rejected/rejected_payment_dailog.dart';

import '../Reuse Widgets/courier_shipment_card.dart';
import '../Reuse Widgets/customer_info_card.dart';
import '../Reuse Widgets/order_detail_header.dart';
import '../Reuse Widgets/order_detail_loading.dart';
import '../Reuse Widgets/order_items_card.dart';
import '../Reuse Widgets/order_status_update_card.dart';
import '../Reuse Widgets/order_summary_card.dart';
import '../Reuse Widgets/order_timeline_card.dart';
import '../Reuse Widgets/order_tracking_card.dart';
import '../Reuse Widgets/payment_action_buttons.dart';
import '../Reuse Widgets/payment_info_card.dart';
import '../Reuse Widgets/payment_proof_card.dart';
import '../Reuse Widgets/ready_for_pickup_card.dart'; 
import '../Reuse Widgets/shipping_address_card.dart';

class OrderDetailScreen extends ConsumerStatefulWidget {
  const OrderDetailScreen({
    super.key,
    required this.orderId,
    this.onBack,
    this.onRefresh,
  });

  final int orderId;

  final VoidCallback? onBack;
  final VoidCallback? onRefresh;

  @override
  ConsumerState<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends ConsumerState<OrderDetailScreen> {
  // ============================================================
  // API DATA
  // ============================================================

  VendorOrderDetailModel? _order;

  VendorOrderPaymentProofModel? _paymentProof;

  // ============================================================
  // FORM STATE
  // ============================================================

  String _selectedStatus = 'pending';

  late final TextEditingController _trackingController;

  late final TextEditingController _carrierController;

  late final TextEditingController _noteController;

  // ============================================================
  // LOADING STATE
  // ============================================================

  bool _isLoading = true;

  bool _isUpdatingStatus = false;

  bool _isPaymentProcessing = false;

  bool _isPickupRequesting = false;

  // ============================================================
  // ERROR
  // ============================================================

  String? _errorMessage;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    _trackingController = TextEditingController();
    _carrierController = TextEditingController();
    _noteController = TextEditingController();

    _loadOrderDetail();
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _trackingController.dispose();
    _carrierController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  // ============================================================
  // LOAD ORDER DETAIL API
  // ============================================================

  Future<void> _loadOrderDetail({bool refresh = false}) async {
    if (!mounted) return;

    setState(() {
      _order = null;
      _paymentProof = null;
      _isLoading = true;
      _errorMessage = null;
      _selectedStatus = 'pending';
    });

    try {
      final controller = ref.read(vendorOrderDetailControllerProvider);
      final result = await controller.getOrderDetail(orderId: widget.orderId);

      if (!mounted) return;

      if (!result.success || result.order == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Unable to load order details.';
        });
        return;
      }

      final order = result.order!;

      setState(() {
        _order = order;
        _paymentProof = result.paymentProof;
        _selectedStatus = _getNextStatus(order.status);
        _isLoading = false;
        _errorMessage = null;
      });

    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = error.message;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Something went wrong. Please try again.';
      });
    }
  }

  // ============================================================
  // NEXT STATUS
  // ============================================================

  String _getNextStatus(String? status) {
    final currentStatus = status?.trim().toLowerCase() ?? '';
    const statusFlow = ['pending', 'processing', 'shipped', 'delivered'];
    final currentIndex = statusFlow.indexOf(currentStatus);

    if (currentIndex == -1) return 'pending';
    if (currentIndex >= statusFlow.length - 1) return 'delivered';

    return statusFlow[currentIndex + 1];
  }

  // ============================================================
  // READY FOR PICKUP — request / retry
  // ============================================================

  Future<void> _handleRequestPickup({bool isRetry = false}) async {
    final order = _order;
    if (order == null) return;

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        title: Text(
          isRetry ? 'Retry courier booking?' : 'Parcel packed & ready?',
          style: AppTextStyles.titleMedium.copyWith(color: AppColors.navy),
        ),
        content: Text(
          isRetry
              ? 'A courier will be re-booked for this order. Make sure the parcel is still packed and ready.'
              : 'A courier will be booked to collect this parcel from your warehouse. Only tap if the parcel is packed and ready.',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
            height: 1.45,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'Cancel',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: isRetry ? AppColors.warning : AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(isRetry ? 'Retry' : 'Confirm & Book'),
          ),
        ],
      ),
    );
    
    if (ok != true) return;

    setState(() => _isPickupRequesting = true);

    try {
      final controller = ref.read(vendorOrderDetailControllerProvider);
      final result = await controller.requestPickup(orderId: widget.orderId);

      final success = result['success'] == true;
      final message = (result['message'] ?? '').toString().trim();

      if (!success) {
        throw ApiException(
          message: message.isNotEmpty ? message : 'Pickup request failed.',
          code: (result['error_code'] ?? 'PICKUP_REQUEST_FAILED').toString(),
        );
      }

      _showSnackBar(
        message.isNotEmpty
            ? message
            : (isRetry
                  ? 'Courier booking retried.'
                  : 'Courier booked — keep the parcel ready.'),
      );

      await _loadOrderDetail(refresh: true);
    } on ApiException catch (error) {
      _showSnackBar(error.message);
    } catch (_) {
      _showSnackBar('Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _isPickupRequesting = false);
    }
  }

  // ============================================================
  // STATUS UPDATE
  // ============================================================

  Future<void> _handleStatusUpdate() async {
    FocusScope.of(context).unfocus();

    final order = _order;
    if (order == null) {
      _showSnackBar('Order details are not available.');
      return;
    }

    final orderId = order.id ?? widget.orderId;
    if (orderId <= 0) {
      _showSnackBar('Invalid order ID.');
      return;
    }

    final status = _selectedStatus.trim().toLowerCase();
    if (status.isEmpty) {
      _showSnackBar('Please select an order status.');
      return;
    }

    setState(() => _isUpdatingStatus = true);

    try {
      final controller = ref.read(vendorOrderStatusControllerProvider);
      final notes = _noteController.text.trim();
      final trackingNumber = _trackingController.text.trim();
      final carrier = _carrierController.text.trim();

      final result = await controller.updateOrderStatus(
        orderId: orderId,
        status: status,
        notes: notes.isEmpty ? null : notes,
        trackingNumber: trackingNumber.isEmpty ? null : trackingNumber,
        carrier: carrier.isEmpty ? null : carrier,
        trackingUrl: null,
        estimatedDelivery: null,
      );

      if (!mounted) return;

      if (!result.success) {
        throw ApiException(
          message: result.message ?? 'Unable to update order status.',
          code: 'ORDER_STATUS_UPDATE_FAILED',
        );
      }

      setState(() => _isUpdatingStatus = false);

      _showSnackBar(result.message ?? 'Order status updated successfully.');
      _trackingController.clear();
      _carrierController.clear();
      _noteController.clear();

      await _loadOrderDetail(refresh: true);
      
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() => _isUpdatingStatus = false);
      _showSnackBar(error.message);
    } catch (error) {
      if (!mounted) return;
      setState(() => _isUpdatingStatus = false);
      _showSnackBar('Something went wrong. Please try again.');
    }
  }

  // ============================================================
  // PAYMENT APPROVE / VERIFY
  // ============================================================

  Future<void> _handleApprovePayment() async {
    final paymentProof = _paymentProof;
    if (paymentProof == null) {
      _showSnackBar('Payment proof is not available.');
      return;
    }
    await _showVerifyPaymentDialog();
  }

  // ============================================================
  // VERIFY PAYMENT DIALOG
  // ============================================================

  Future<void> _showVerifyPaymentDialog() async {
    bool isSubmitting = false;

    await showDialog<void>(
      context: context,
      barrierDismissible: !isSubmitting,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            Future<void> confirmVerify() async {
              if (isSubmitting) return;

              setDialogState(() => isSubmitting = true);

              if (mounted) setState(() => _isPaymentProcessing = true);

              try {
                final controller = ref.read(paymentProofVerifyControllerProvider);
                final result = await controller.verifyPaymentProof(orderId: widget.orderId);

                if (!mounted) return;

                if (!result.success) {
                  throw ApiException(
                    message: result.message ?? 'Unable to verify payment proof.',
                    code: 'PAYMENT_PROOF_VERIFY_FAILED',
                  );
                }

                setDialogState(() => isSubmitting = false);
                setState(() => _isPaymentProcessing = false);

                Navigator.of(dialogContext).pop();
                _showSnackBar(result.message ?? 'Payment proof accepted successfully.');

                await _loadOrderDetail(refresh: true);
              } on ApiException catch (error) {
                if (!mounted) return;
                setDialogState(() => isSubmitting = false);
                setState(() => _isPaymentProcessing = false);
                _showSnackBar(error.message);
              } catch (error) {
                if (!mounted) return;
                setDialogState(() => isSubmitting = false);
                setState(() => _isPaymentProcessing = false);
                _showSnackBar('Something went wrong. Please try again.');
              }
            }

            return AlertDialog(
              backgroundColor: AppColors.white,
              surfaceTintColor: AppColors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              contentPadding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              title: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: const Icon(Icons.verified_outlined, color: AppColors.primary, size: 21),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Accept Payment Proof',
                      style: AppTextStyles.titleMedium.copyWith(color: AppColors.navy),
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Are you sure you want to accept this payment proof?',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This will mark the payment as paid.',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: 'Cancel',
                          type: CustomButtonType.outlined,
                          height: 46,
                          borderRadius: 11,
                          isEnabled: !isSubmitting,
                          onPressed: isSubmitting ? null : () => Navigator.of(dialogContext).pop(),
                          foregroundColor: AppColors.textSecondary,
                          borderColor: AppColors.backgroundSecondary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CustomButton(
                          text: 'Confirm Accepted',
                          height: 46,
                          borderRadius: 11,
                          isLoading: isSubmitting,
                          isEnabled: !isSubmitting,
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.white,
                          onPressed: isSubmitting ? null : confirmVerify,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (mounted) setState(() => _isPaymentProcessing = false);
  }

  // ============================================================
  // PAYMENT REJECT
  // ============================================================

  Future<void> _handleRejectPayment() async {
    final paymentProof = _paymentProof;
    if (paymentProof == null) {
      _showSnackBar('Payment proof is not available.');
      return;
    }
    await _showRejectPaymentDialog();
  }

  // ============================================================
  // REJECT PAYMENT DIALOG
  // ============================================================

  Future<void> _showRejectPaymentDialog() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return RejectPaymentDialog(
          onSubmit: ({required String reason, required String notes}) async {
            if (mounted) setState(() => _isPaymentProcessing = true);

            try {
              final controller = ref.read(paymentProofRejectControllerProvider);
              final result = await controller.rejectPaymentProof(
                orderId: widget.orderId,
                reason: reason,
                notes: notes,
              );

              if (!mounted) return;

              if (!result.success) {
                throw ApiException(
                  message: result.message ?? 'Unable to reject payment proof.',
                  code: 'PAYMENT_PROOF_REJECT_FAILED',
                );
              }

              Navigator.of(dialogContext).pop();
              if (mounted) setState(() => _isPaymentProcessing = false);

              _showSnackBar(result.message ?? 'Payment proof rejected successfully.');
              await _loadOrderDetail(refresh: true);
            } on ApiException catch (error) {
              if (!mounted) return;
              setState(() => _isPaymentProcessing = false);
              _showSnackBar(error.message);
              rethrow;
            } catch (error) {
              if (!mounted) return;
              setState(() => _isPaymentProcessing = false);
              _showSnackBar('Something went wrong. Please try again.');
              rethrow;
            }
          },
        );
      },
    );

    if (mounted) setState(() => _isPaymentProcessing = false);
  }

  // ============================================================
  // PAYMENT PROOF VIEW
  // ============================================================

  void _handleViewPaymentProof() {
    final url = _paymentProof?.proofImageUrl;
    if (url == null || url.trim().isEmpty) return;

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: AppColors.white,
          insetPadding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 16, 10, 10),
                  child: Row(
                    children: [
                      Expanded(child: Text('Payment Proof', style: AppTextStyles.titleMedium)),
                      IconButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: InteractiveViewer(
                    child: Image.network(
                      url,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) {
                        return const SizedBox(
                          height: 300,
                          child: Center(
                            child: Icon(Icons.broken_image_outlined, size: 48, color: AppColors.textMuted),
                          ),
                        );
                      },
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const SizedBox(
                          height: 300,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // SNACKBAR
  // ============================================================

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            if (_isLoading)
              const OrderDetailHeaderLoading()
            else if (_order != null)
              _buildHeader(_order!),

            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader(VendorOrderDetailModel order) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: OrderDetailHeader(order: order, onBack: widget.onBack),
    );
  }

  // ============================================================
  // BODY
  // ============================================================

  Widget _buildBody() {
    if (_isLoading) return const OrderDetailLoading();

    if (_errorMessage != null) {
      return _DetailError(
        message: _errorMessage!,
        onRetry: () => _loadOrderDetail(refresh: true),
      );
    }

    final order = _order;
    if (order == null) {
      return _DetailError(
        message: 'Order details are not available.',
        onRetry: () => _loadOrderDetail(refresh: true),
      );
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async => await _loadOrderDetail(refresh: true),
      child: _buildContent(order),
    );
  }

  // ============================================================
  // CONTENT
  // ============================================================

  Widget _buildContent(VendorOrderDetailModel order) {
    final paymentProof = _paymentProof;
    final hasPaymentProof = paymentProof != null;
    final isPaymentPaid = order.paymentStatus?.trim().toLowerCase() == 'paid';
    final isordercancelled = order.status?.trim().toLowerCase() == 'cancelled';
    final isorderdelivered = order.status?.trim().toLowerCase() == 'delivered';
    final needsPaymentVerification = paymentProof != null && paymentProof.verificationStatus?.trim().toLowerCase() == 'pending';

    final tracking = order.tracking;
    final hasTracking = tracking?.hasValidTracking == true;

    final shipment = order.courierShipment;
    final shipmentActive = shipment != null && shipment.isActive;
    final shipmentBookingFailed = shipment?.isBookingFailed == true;

    final showReadyForPickup = shipment == null && (order.canRequestPickup || (order.pickupBlockReason ?? '').trim().isNotEmpty);

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OrderSummaryCard(order: order),
          const SizedBox(height: 14),
          CustomerInfoCard(order: order),
          const SizedBox(height: 14),
          ShippingAddressCard(address: order.shippingAddress),
          const SizedBox(height: 14),
          OrderItemsCard(order: order),

          if (showReadyForPickup) ...[
            const SizedBox(height: 14),
            ReadyForPickupCard(
              providerName: order.pickupProvider,
              canRequestPickup: order.canRequestPickup,
              blockReason: order.pickupBlockReason,
              isRetryMode: false,
              isLoading: _isPickupRequesting,
              onRequestPickup: () => _handleRequestPickup(isRetry: false),
              onOpenSettings: null,
            ),
          ],

          if (order.courierShipment != null) ...[
            const SizedBox(height: 14),
            CourierShipmentCard(
              shipment: order.courierShipment!,
              onRetryPickup: shipmentBookingFailed ? () => _handleRequestPickup(isRetry: true) : null,
              isRetryLoading: _isPickupRequesting,
            ),
          ],

          if (hasTracking) ...[
            const SizedBox(height: 14),
            OrderTrackingCard(tracking: tracking!),
          ],

          const SizedBox(height: 14),
          PaymentInfoCard(
            order: order,
            paymentProof: paymentProof,
            onViewProof: hasPaymentProof ? _handleViewPaymentProof : null,
          ),

          if (hasPaymentProof && !isPaymentPaid && !isordercancelled) ...[
            const SizedBox(height: 14),
            PaymentProofCard(
              paymentProof: paymentProof,
              onView: _handleViewPaymentProof,
            ),
          ],

          if (needsPaymentVerification) ...[
            const SizedBox(height: 14),
            _buildPaymentVerificationCard(),
          ],

          const SizedBox(height: 14),

          if (!isordercancelled && !isorderdelivered && !shipmentActive) ...[
            OrderStatusUpdateCard(
              status: _selectedStatus,
              onStatusChanged: (status) => setState(() => _selectedStatus = status),
              onUpdate: _handleStatusUpdate,
              trackingController: _trackingController,
              carrierController: _carrierController,
              noteController: _noteController,
              isLoading: _isUpdatingStatus,
            ),
            const SizedBox(height: 14),
          ],

          if (!isordercancelled && !isorderdelivered && shipmentActive) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.20)),
              ),
              child: Row(
                children: [
                  Icon(Icons.lock_outline_rounded, size: 18, color: AppColors.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      shipment.isEmx
                          ? 'Shipment is active — status updates automatically via EMX tracking. Manual "Mark Shipped/Delivered" is disabled.'
                          : 'Shipment is active — status updates via rider. Manual "Mark Shipped/Delivered" is disabled.',
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.navy, height: 1.45),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
          ],

          OrderTimelineCard(timeline: order.statusHistory),
        ],
      ),
    );
  }

  // ============================================================
  // PAYMENT VERIFICATION CARD
  // ============================================================

  Widget _buildPaymentVerificationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.30)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowStrong.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.verified_outlined, size: 19, color: AppColors.warning),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Payment Verification', style: AppTextStyles.titleMedium),
                    const SizedBox(height: 2),
                    Text('Review the payment proof and choose an action.', style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          PaymentActionButtons(
            onApprove: _handleApprovePayment,
            onReject: _handleRejectPayment,
            isLoading: _isPaymentProcessing,
          ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// ERROR WIDGET
// ═════════════════════════════════════════════════════════════════════════════

class _DetailError extends StatelessWidget {
  const _DetailError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
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
                color: AppColors.error.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.error_outline_rounded, size: 32, color: AppColors.error),
            ),
            const SizedBox(height: 14),
            Text(
              'Unable to load order',
              style: AppTextStyles.titleMedium.copyWith(color: AppColors.navy),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              message,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}