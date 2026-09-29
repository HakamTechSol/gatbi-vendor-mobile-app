import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';
import '../Models/get_events_model.dart';

class EventsRepository {
  const EventsRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Get Events
  // ============================================================

  Future<EventsModel> getEvents() async {
    final response = await _dioClient.get<Map<String, dynamic>>(ApiUrls.getEvents);

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
    // Convert API Response -> Events Model
    // ----------------------------------------------------------

    final result = EventsModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Logs
    // ----------------------------------------------------------

    if (kDebugMode) {
      debugPrint('');
      debugPrint('========== EVENTS RESULT ==========');

      // --------------------------------------------------------
      // General
      // --------------------------------------------------------

      debugPrint('SUCCESS: ${result.success}');
      debugPrint('KYC STATUS: ${result.kycStatus ?? 'N/A'}');
      debugPrint('KYC LOCKED: ${result.kycLocked}');
      debugPrint('NOTES: ${result.notes ?? 'N/A'}');

      // --------------------------------------------------------
      // Events
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- EVENTS ----------');
      debugPrint('EVENTS COUNT: ${result.events.length}');

      if (result.events.isNotEmpty) {
        for (final event in result.events) {
          debugPrint(
            'EVENT: '
            '${event.name ?? 'N/A'} | '
            'ID: ${event.id ?? 'N/A'} | '
            'SLUG: ${event.slug ?? 'N/A'} | '
            'STATUS: ${event.status ?? 'N/A'} | '
            'START DATE: ${event.startDate ?? 'N/A'} | '
            'END DATE: ${event.endDate ?? 'N/A'} | '
            'MIN DISCOUNT: '
            '${event.minDiscountPercentage ?? 0}% | '
            'MY PARTICIPATION: '
            '${event.myParticipation ?? 'N/A'}',
          );

          debugPrint(
            'DESCRIPTION: '
            '${event.description ?? 'N/A'}',
          );

          debugPrint(
            'BANNER URL: '
            '${event.bannerUrl ?? 'N/A'}',
          );

          debugPrint(
            'BANNER MOBILE URL: '
            '${event.bannerMobileUrl ?? 'N/A'}',
          );
        }
      }

      // --------------------------------------------------------
      // End
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('=================================');
      debugPrint('');
    }

    return result;
  }
}
