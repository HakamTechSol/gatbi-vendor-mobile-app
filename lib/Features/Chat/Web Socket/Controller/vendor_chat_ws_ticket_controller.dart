import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/dio.dart';
import '../../../../Services/dio_client.dart';
import '../Models/vendor_chat_ws_ticket_model.dart';
import '../Repo/vendor_chat_ws_ticket_repository.dart';
import 'vendor_chat_ws_ticket_state.dart';

// ============================================================
// Provider
// ============================================================

final vendorChatWsTicketControllerProvider =
    StateNotifierProvider<
      VendorChatWsTicketController,
      VendorChatWsTicketState
    >((ref) {
      final dioClient = ref.read(dioProvider);

      return VendorChatWsTicketController(dioClient);
    });

// ============================================================
// Controller
// ============================================================

class VendorChatWsTicketController
    extends StateNotifier<VendorChatWsTicketState> {
  VendorChatWsTicketController(this._dioClient)
    : super(const VendorChatWsTicketState());

  final DioClient _dioClient;

  late final VendorChatWsTicketRepository _repository =
      VendorChatWsTicketRepository(_dioClient);

  bool _requestInProgress = false;

  // ============================================================
  // Get WebSocket Ticket
  // ============================================================

  Future<VendorChatWsTicketModel?> getWsTicket() async {
    if (_requestInProgress) {
      if (kDebugMode) {
        debugPrint('WS Ticket request already in progress.');
      }

      return state.ticket;
    }

    _requestInProgress = true;

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      if (kDebugMode) {
        debugPrint('');
        debugPrint('========== GET WS TICKET START ==========');
      }

      final result = await _repository.getWsTicket();

      if (!mounted) {
        return result;
      }

      state = state.copyWith(
        isLoading: false,
        ticket: result,
        clearError: true,
      );

      if (kDebugMode) {
        debugPrint('WS Ticket fetched successfully.');
        debugPrint('Expires In: ${result.expiresIn}s');
        debugPrint('Public URL: ${result.publicUrl}');
        debugPrint('========== GET WS TICKET END ==========');
      }

      return result;
    } on ApiException catch (error) {
      if (!mounted) {
        return null;
      }

      state = state.copyWith(isLoading: false, errorMessage: error.message);

      if (kDebugMode) {
        debugPrint('WS Ticket API Exception: ${error.message}');
        debugPrint('Code: ${error.code}');
      }

      return null;
    } catch (error) {
      if (!mounted) {
        return null;
      }

      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Something went wrong.',
      );

      if (kDebugMode) {
        debugPrint('WS Ticket Unexpected Error: $error');
      }

      return null;
    } finally {
      _requestInProgress = false;
    }
  }

  // ============================================================
  // Refresh Ticket
  // ============================================================

  Future<VendorChatWsTicketModel?> refreshTicket() async {
    state = state.copyWith(clearTicket: true, clearError: true);

    return getWsTicket();
  }

  // ============================================================
  // Clear Error
  // ============================================================

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  // ============================================================
  // Clear State
  // ============================================================

  void clearState() {
    state = const VendorChatWsTicketState();
  }
}
