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
    if (!mounted) {
      return;
    }

    setState(() {
      _order = null;

      _paymentProof = null;

      _isLoading = true;

      _errorMessage = null;

      _selectedStatus = 'pending';
    });

    try {
      final controller = ref.read(vendorOrderDetailControllerProvider);

      debugPrint('');

      debugPrint(
        '════════════════════════════════════════════════════════════',
      );

      debugPrint('VENDOR ORDER DETAIL API');

      debugPrint('ORDER ID: ${widget.orderId}');

      debugPrint('REFRESH: $refresh');

      debugPrint('STATUS: LOADING');

      debugPrint(
        '════════════════════════════════════════════════════════════',
      );

      debugPrint('');

      final result = await controller.getOrderDetail(orderId: widget.orderId);

      if (!mounted) {
        return;
      }

      if (!result.success || result.order == null) {
        setState(() {
          _isLoading = false;

          _errorMessage = 'Unable to load order details.';
        });

        debugPrint('');

        debugPrint(
          '════════════════════════════════════════════════════════════',
        );

        debugPrint('VENDOR ORDER DETAIL API');

        debugPrint('ORDER ID: ${widget.orderId}');

        debugPrint('STATUS: INVALID RESPONSE');

        debugPrint(
          '════════════════════════════════════════════════════════════',
        );

        debugPrint('');

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

      // ========================================================
      // TRACKING LOG
      // ========================================================

      final tracking = order.tracking;

      debugPrint('');

      debugPrint(
        '════════════════════════════════════════════════════════════',
      );

      debugPrint('VENDOR ORDER DETAIL API');

      debugPrint('ORDER ID: ${order.id}');

      debugPrint('ORDER NUMBER: ${order.orderNumber}');

      debugPrint('STATUS: ${order.status}');

      debugPrint('PAYMENT STATUS: ${order.paymentStatus}');

      debugPrint('PAYMENT METHOD: ${order.paymentMethod}');

      debugPrint('ITEMS: ${order.items.length}');

      debugPrint('STATUS HISTORY: ${order.statusHistory.length}');

      debugPrint('TRACKING: ${tracking != null ? 'AVAILABLE' : 'NULL'}');

      debugPrint(
        'TRACKING NUMBER: '
        '${tracking?.trackingNumber ?? 'N/A'}',
      );

      debugPrint(
        'CARRIER: '
        '${tracking?.carrier ?? 'N/A'}',
      );

      debugPrint(
        'PAYMENT PROOF: '
        '${result.paymentProof != null ? 'AVAILABLE' : 'NULL'}',
      );

      debugPrint('STATUS: SUCCESS');

      debugPrint(
        '════════════════════════════════════════════════════════════',
      );

      debugPrint('');
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;

        _errorMessage = error.message;
      });

      debugPrint('');

      debugPrint(
        '════════════════════════════════════════════════════════════',
      );

      debugPrint('VENDOR ORDER DETAIL API ERROR');

      debugPrint('ORDER ID: ${widget.orderId}');

      debugPrint('MESSAGE: ${error.message}');

      debugPrint('CODE: ${error.code}');

      debugPrint(
        '════════════════════════════════════════════════════════════',
      );

      debugPrint('');
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;

        _errorMessage = 'Something went wrong. Please try again.';
      });

      debugPrint('');

      debugPrint(
        '════════════════════════════════════════════════════════════',
      );

      debugPrint('ORDER DETAIL UNKNOWN ERROR');

      debugPrint('ORDER ID: ${widget.orderId}');

      debugPrint('ERROR: $error');

      debugPrint(
        '════════════════════════════════════════════════════════════',
      );

      debugPrint('');
    }
  }

  // ============================================================
  // NEXT STATUS
  // ============================================================

  String _getNextStatus(String? status) {
    final currentStatus = status?.trim().toLowerCase() ?? '';

    const statusFlow = ['pending', 'processing', 'shipped', 'delivered'];

    final currentIndex = statusFlow.indexOf(currentStatus);

    if (currentIndex == -1) {
      return 'pending';
    }

    if (currentIndex >= statusFlow.length - 1) {
      return 'delivered';
    }

    return statusFlow[currentIndex + 1];
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

    setState(() {
      _isUpdatingStatus = true;
    });

    try {
      final controller = ref.read(vendorOrderStatusControllerProvider);

      final notes = _noteController.text.trim();

      final trackingNumber = _trackingController.text.trim();

      final carrier = _carrierController.text.trim();

      debugPrint('');

      debugPrint(
        '════════════════════════════════════════════════════════════',
      );

      debugPrint('UPDATE ORDER STATUS FROM UI');

      debugPrint('ORDER ID: $orderId');

      debugPrint('STATUS: $status');

      debugPrint('NOTES: ${notes.isEmpty ? 'N/A' : notes}');

      debugPrint(
        'TRACKING NUMBER: '
        '${trackingNumber.isEmpty ? 'N/A' : trackingNumber}',
      );

      debugPrint(
        'CARRIER: '
        '${carrier.isEmpty ? 'N/A' : carrier}',
      );

      debugPrint('STATUS: API CALL STARTED');

      debugPrint(
        '════════════════════════════════════════════════════════════',
      );

      debugPrint('');

      final result = await controller.updateOrderStatus(
        orderId: orderId,
        status: status,
        notes: notes.isEmpty ? null : notes,
        trackingNumber: trackingNumber.isEmpty ? null : trackingNumber,
        carrier: carrier.isEmpty ? null : carrier,
        trackingUrl: null,
        estimatedDelivery: null,
      );

      if (!mounted) {
        return;
      }

      if (!result.success) {
        throw ApiException(
          message: result.message ?? 'Unable to update order status.',
          code: 'ORDER_STATUS_UPDATE_FAILED',
        );
      }

      debugPrint('');

      debugPrint(
        '════════════════════════════════════════════════════════════',
      );

      debugPrint('UPDATE ORDER STATUS FROM UI');

      debugPrint('ORDER ID: $orderId');

      debugPrint('STATUS: SUCCESS');

      debugPrint(
        'MESSAGE: '
        '${result.message ?? 'Order status updated successfully'}',
      );

      debugPrint(
        'UPDATED ORDER STATUS: '
        '${result.order?.status ?? status}',
      );

      debugPrint(
        'STATUS HISTORY: '
        '${result.order?.statusHistory.length ?? 0}',
      );

      debugPrint(
        '════════════════════════════════════════════════════════════',
      );

      debugPrint('');

      setState(() {
        _isUpdatingStatus = false;
      });

      _showSnackBar(result.message ?? 'Order status updated successfully.');

      _trackingController.clear();

      _carrierController.clear();

      _noteController.clear();

      await _loadOrderDetail(refresh: true);
    } on ApiException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isUpdatingStatus = false;
      });

      debugPrint('');

      debugPrint(
        '════════════════════════════════════════════════════════════',
      );

      debugPrint('UPDATE ORDER STATUS UI ERROR');

      debugPrint('ORDER ID: $orderId');

      debugPrint('STATUS: $status');

      debugPrint('MESSAGE: ${error.message}');

      debugPrint('CODE: ${error.code}');

      debugPrint(
        '════════════════════════════════════════════════════════════',
      );

      debugPrint('');

      _showSnackBar(error.message);
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isUpdatingStatus = false;
      });

      debugPrint('');

      debugPrint(
        '════════════════════════════════════════════════════════════',
      );

      debugPrint('UPDATE ORDER STATUS UNKNOWN UI ERROR');

      debugPrint('ORDER ID: $orderId');

      debugPrint('STATUS: $status');

      debugPrint('ERROR: $error');

      debugPrint(
        '════════════════════════════════════════════════════════════',
      );

      debugPrint('');

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
              if (isSubmitting) {
                return;
              }

              setDialogState(() {
                isSubmitting = true;
              });

              if (mounted) {
                setState(() {
                  _isPaymentProcessing = true;
                });
              }

              try {
                final controller = ref.read(
                  paymentProofVerifyControllerProvider,
                );

                debugPrint('');

                debugPrint(
                  '════════════════════════════════════════════════════════════',
                );

                debugPrint('VERIFY PAYMENT PROOF FROM UI');

                debugPrint('ORDER ID: ${widget.orderId}');

                debugPrint('STATUS: API CALL STARTED');

                debugPrint('REQUEST BODY: NONE');

                debugPrint(
                  '════════════════════════════════════════════════════════════',
                );

                debugPrint('');

                final result = await controller.verifyPaymentProof(
                  orderId: widget.orderId,
                );

                if (!mounted) {
                  return;
                }

                if (!result.success) {
                  throw ApiException(
                    message:
                        result.message ?? 'Unable to verify payment proof.',
                    code: 'PAYMENT_PROOF_VERIFY_FAILED',
                  );
                }

                debugPrint('');

                debugPrint(
                  '════════════════════════════════════════════════════════════',
                );

                debugPrint('VERIFY PAYMENT PROOF FROM UI');

                debugPrint('ORDER ID: ${widget.orderId}');

                debugPrint('STATUS: SUCCESS');

                debugPrint(
                  'MESSAGE: '
                  '${result.message ?? 'Payment proof accepted'}',
                );

                debugPrint(
                  '════════════════════════════════════════════════════════════',
                );

                debugPrint('');

                setDialogState(() {
                  isSubmitting = false;
                });

                setState(() {
                  _isPaymentProcessing = false;
                });

                Navigator.of(dialogContext).pop();

                _showSnackBar(
                  result.message ?? 'Payment proof accepted successfully.',
                );

                await _loadOrderDetail(refresh: true);
              } on ApiException catch (error) {
                if (!mounted) {
                  return;
                }

                setDialogState(() {
                  isSubmitting = false;
                });

                setState(() {
                  _isPaymentProcessing = false;
                });

                debugPrint('');

                debugPrint(
                  '════════════════════════════════════════════════════════════',
                );

                debugPrint('VERIFY PAYMENT PROOF UI ERROR');

                debugPrint('ORDER ID: ${widget.orderId}');

                debugPrint('MESSAGE: ${error.message}');

                debugPrint('CODE: ${error.code}');

                debugPrint(
                  '════════════════════════════════════════════════════════════',
                );

                debugPrint('');

                _showSnackBar(error.message);
              } catch (error) {
                if (!mounted) {
                  return;
                }

                setDialogState(() {
                  isSubmitting = false;
                });

                setState(() {
                  _isPaymentProcessing = false;
                });

                debugPrint('');

                debugPrint(
                  '════════════════════════════════════════════════════════════',
                );

                debugPrint('VERIFY PAYMENT PROOF UNKNOWN UI ERROR');

                debugPrint('ORDER ID: ${widget.orderId}');

                debugPrint('ERROR: $error');

                debugPrint(
                  '════════════════════════════════════════════════════════════',
                );

                debugPrint('');

                _showSnackBar('Something went wrong. Please try again.');
              }
            }

            return AlertDialog(
              backgroundColor: AppColors.white,
              surfaceTintColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
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
                    child: const Icon(
                      Icons.verified_outlined,
                      color: AppColors.primary,
                      size: 21,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Accept Payment Proof',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.navy,
                      ),
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
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This will mark the payment as paid.',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textMuted,
                    ),
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
                          onPressed: isSubmitting
                              ? null
                              : () {
                                  Navigator.of(dialogContext).pop();
                                },
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

    if (mounted) {
      setState(() {
        _isPaymentProcessing = false;
      });
    }
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
            if (mounted) {
              setState(() {
                _isPaymentProcessing = true;
              });
            }

            try {
              final controller = ref.read(paymentProofRejectControllerProvider);

              debugPrint('');

              debugPrint(
                '════════════════════════════════════════════════════════════',
              );

              debugPrint('REJECT PAYMENT PROOF FROM UI');

              debugPrint('ORDER ID: ${widget.orderId}');

              debugPrint('REASON: $reason');

              debugPrint('NOTES: $notes');

              debugPrint('STATUS: API CALL STARTED');

              debugPrint(
                '════════════════════════════════════════════════════════════',
              );

              debugPrint('');

              final result = await controller.rejectPaymentProof(
                orderId: widget.orderId,
                reason: reason,
                notes: notes,
              );

              if (!mounted) {
                return;
              }

              if (!result.success) {
                throw ApiException(
                  message: result.message ?? 'Unable to reject payment proof.',
                  code: 'PAYMENT_PROOF_REJECT_FAILED',
                );
              }

              debugPrint('');

              debugPrint(
                '════════════════════════════════════════════════════════════',
              );

              debugPrint('REJECT PAYMENT PROOF FROM UI');

              debugPrint('ORDER ID: ${widget.orderId}');

              debugPrint('STATUS: SUCCESS');

              debugPrint(
                'MESSAGE: '
                '${result.message ?? 'Payment proof rejected'}',
              );

              debugPrint(
                '════════════════════════════════════════════════════════════',
              );

              debugPrint('');

              Navigator.of(dialogContext).pop();

              if (mounted) {
                setState(() {
                  _isPaymentProcessing = false;
                });
              }

              _showSnackBar(
                result.message ?? 'Payment proof rejected successfully.',
              );

              await _loadOrderDetail(refresh: true);
            } on ApiException catch (error) {
              if (!mounted) {
                return;
              }

              setState(() {
                _isPaymentProcessing = false;
              });

              debugPrint('');

              debugPrint(
                '════════════════════════════════════════════════════════════',
              );

              debugPrint('REJECT PAYMENT PROOF UI ERROR');

              debugPrint('ORDER ID: ${widget.orderId}');

              debugPrint('MESSAGE: ${error.message}');

              debugPrint('CODE: ${error.code}');

              debugPrint(
                '════════════════════════════════════════════════════════════',
              );

              debugPrint('');

              _showSnackBar(error.message);

              rethrow;
            } catch (error) {
              if (!mounted) {
                return;
              }

              setState(() {
                _isPaymentProcessing = false;
              });

              debugPrint('');

              debugPrint(
                '════════════════════════════════════════════════════════════',
              );

              debugPrint('REJECT PAYMENT PROOF UNKNOWN UI ERROR');

              debugPrint('ORDER ID: ${widget.orderId}');

              debugPrint('ERROR: $error');

              debugPrint(
                '════════════════════════════════════════════════════════════',
              );

              debugPrint('');

              _showSnackBar('Something went wrong. Please try again.');

              rethrow;
            }
          },
        );
      },
    );

    if (mounted) {
      setState(() {
        _isPaymentProcessing = false;
      });
    }
  }

  // ============================================================
  // PAYMENT PROOF VIEW
  // ============================================================

  void _handleViewPaymentProof() {
    final url = _paymentProof?.proofImageUrl;

    if (url == null || url.trim().isEmpty) {
      return;
    }

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: AppColors.white,
          insetPadding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 16, 10, 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Payment Proof',
                          style: AppTextStyles.titleMedium,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(dialogContext).pop();
                        },
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
                            child: Icon(
                              Icons.broken_image_outlined,
                              size: 48,
                              color: AppColors.textMuted,
                            ),
                          ),
                        );
                      },
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) {
                          return child;
                        }

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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
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
    if (_isLoading) {
      return const OrderDetailLoading();
    }

    if (_errorMessage != null) {
      return _DetailError(
        message: _errorMessage!,
        onRetry: () {
          _loadOrderDetail(refresh: true);
        },
      );
    }

    final order = _order;

    if (order == null) {
      return _DetailError(
        message: 'Order details are not available.',
        onRetry: () {
          _loadOrderDetail(refresh: true);
        },
      );
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        await _loadOrderDetail(refresh: true);
      },
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

    final needsPaymentVerification =
        paymentProof != null &&
        paymentProof.verificationStatus?.trim().toLowerCase() == 'pending';

    // ==========================================================
    // TRACKING
    // ==========================================================

    final tracking = order.tracking;

    final hasTracking = tracking?.hasValidTracking == true;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ====================================================
          // ORDER SUMMARY
          // ====================================================
          OrderSummaryCard(order: order),

          const SizedBox(height: 14),

          // ====================================================
          // CUSTOMER
          // ====================================================
          CustomerInfoCard(order: order),

          const SizedBox(height: 14),

          // ====================================================
          // SHIPPING ADDRESS
          // ====================================================
          ShippingAddressCard(address: order.shippingAddress),

          const SizedBox(height: 14),

          // ====================================================
          // ORDER ITEMS
          // ====================================================
          OrderItemsCard(order: order),

          // ====================================================
          // ORDER TRACKING
          //
          // Sirf tab show hoga jab:
          //
          // tracking_number available ho
          // AND
          // carrier available ho
          // ====================================================
          if (hasTracking) ...[
            const SizedBox(height: 14),

            OrderTrackingCard(tracking: tracking!),
          ],

          const SizedBox(height: 14),

          // ====================================================
          // PAYMENT INFORMATION
          // ====================================================
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

          // ====================================================
          // PAYMENT VERIFICATION
          // ====================================================
          if (needsPaymentVerification) ...[
            const SizedBox(height: 14),

            _buildPaymentVerificationCard(),
          ],

          const SizedBox(height: 14),

          // ====================================================
          // STATUS UPDATE
          // ====================================================
          if (!isordercancelled && !isorderdelivered) ...[
            OrderStatusUpdateCard(
              status: _selectedStatus,
              onStatusChanged: (status) {
                setState(() {
                  _selectedStatus = status;
                });
              },
              onUpdate: _handleStatusUpdate,
              trackingController: _trackingController,
              carrierController: _carrierController,
              noteController: _noteController,
              isLoading: _isUpdatingStatus,
            ),

            const SizedBox(height: 14),
          ],

          // ====================================================
          // TIMELINE
          // ====================================================
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
                child: const Icon(
                  Icons.verified_outlined,
                  size: 19,
                  color: AppColors.warning,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment Verification',
                      style: AppTextStyles.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Review the payment proof and choose an action.',
                      style: AppTextStyles.bodySmall,
                    ),
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
// ERROR
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
              child: const Icon(
                Icons.error_outline_rounded,
                size: 32,
                color: AppColors.error,
              ),
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
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
