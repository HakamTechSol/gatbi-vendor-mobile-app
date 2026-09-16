import '../Models/vendor_chat_ws_ticket_model.dart';

class VendorChatWsTicketState {
  const VendorChatWsTicketState({
    this.isLoading = false,
    this.ticket,
    this.errorMessage,
  });

  final bool isLoading;
  final VendorChatWsTicketModel? ticket;
  final String? errorMessage;

  VendorChatWsTicketState copyWith({
    bool? isLoading,
    VendorChatWsTicketModel? ticket,
    String? errorMessage,
    bool clearTicket = false,
    bool clearError = false,
  }) {
    return VendorChatWsTicketState(
      isLoading: isLoading ?? this.isLoading,
      ticket: clearTicket ? null : (ticket ?? this.ticket),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
