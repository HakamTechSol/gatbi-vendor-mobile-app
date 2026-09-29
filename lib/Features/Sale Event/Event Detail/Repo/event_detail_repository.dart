import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';

import '../Models/event_detail_model.dart';

class EventDetailRepository {
  const EventDetailRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Get Event Detail
  // ============================================================

  Future<EventDetailModel> getEventDetail(int eventId) async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      '${ApiUrls.getEvents}/$eventId',
    );

    final data = response.data;

    // ----------------------------------------------------------
    // Validate Response
    // ----------------------------------------------------------

    if (data == null) {
      throw const ApiException(
        message: 'Invalid response received from server.',
        code: 'INVALID_RESPONSE',
      );
    }

    // ----------------------------------------------------------
    // Convert API Response -> Event Detail Model
    // ----------------------------------------------------------

    final result = EventDetailModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Logs
    // ----------------------------------------------------------

    if (kDebugMode) {
      final event = result.event;

      debugPrint('');
      debugPrint('========== EVENT DETAIL RESULT ==========');

      // --------------------------------------------------------
      // General
      // --------------------------------------------------------

      debugPrint('SUCCESS: ${result.success}');
      debugPrint('KYC STATUS: ${result.kycStatus ?? 'N/A'}');
      debugPrint('KYC LOCKED: ${result.kycLocked}');

      // --------------------------------------------------------
      // Event
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- EVENT ----------');

      debugPrint('EVENT ID: ${event?.id ?? 'N/A'}');
      debugPrint('EVENT NAME: ${event?.name ?? 'N/A'}');
      debugPrint('EVENT SLUG: ${event?.slug ?? 'N/A'}');
      debugPrint('EVENT DESCRIPTION: ${event?.description ?? 'N/A'}');

      debugPrint(
        'BANNER URL: '
        '${event?.bannerUrl ?? 'N/A'}',
      );

      debugPrint(
        'BANNER MOBILE URL: '
        '${event?.bannerMobileUrl ?? 'N/A'}',
      );

      debugPrint(
        'START DATE: '
        '${event?.startDate ?? 'N/A'}',
      );

      debugPrint(
        'END DATE: '
        '${event?.endDate ?? 'N/A'}',
      );

      debugPrint(
        'MIN DISCOUNT PERCENTAGE: '
        '${event?.minDiscountPercentage ?? 0}',
      );

      debugPrint(
        'STATUS: '
        '${event?.status ?? 'N/A'}',
      );

      debugPrint(
        'MY PARTICIPATION: '
        '${event?.myParticipation ?? 'N/A'}',
      );

      // --------------------------------------------------------
      // End
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('=========================================');
      debugPrint('');
    }

    return result;
  }
}
