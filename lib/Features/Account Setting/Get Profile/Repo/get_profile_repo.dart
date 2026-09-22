import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';
import '../Models/get_profile_model.dart';

class VendorSettingsRepository {
  const VendorSettingsRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Get Vendor Settings
  // ============================================================

  Future<VendorSettingsModel> getVendorSettings() async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      ApiUrls.getProfile,
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
    // Convert API Response -> Vendor Settings Model
    // ----------------------------------------------------------

    final result = VendorSettingsModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Logs
    // ----------------------------------------------------------

    if (kDebugMode) {
      final merchant = result.merchant;
      final user = result.user;

      debugPrint('');
      debugPrint('========== VENDOR SETTINGS RESULT ==========');

      // --------------------------------------------------------
      // General
      // --------------------------------------------------------

      debugPrint('SUCCESS: ${result.success}');

      // --------------------------------------------------------
      // Merchant
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- MERCHANT ----------');

      debugPrint('MERCHANT ID: ${merchant?.id ?? 'N/A'}');
      debugPrint('MERCHANT NAME: ${merchant?.name ?? 'N/A'}');
      debugPrint('MERCHANT SLUG: ${merchant?.slug ?? 'N/A'}');
      debugPrint('MERCHANT EMAIL: ${merchant?.email ?? 'N/A'}');
      debugPrint('MERCHANT PHONE: ${merchant?.phone ?? 'N/A'}');
      debugPrint('MERCHANT LOGO: ${merchant?.logo ?? 'N/A'}');
      debugPrint('MERCHANT ABOUT: ${merchant?.about ?? 'N/A'}');
      debugPrint('MERCHANT STATUS: ${merchant?.status ?? 'N/A'}');
      debugPrint('KYC STATUS: ${merchant?.kycStatus ?? 'N/A'}');
      debugPrint(
        'PRIMARY CATEGORY ID: '
        '${merchant?.primaryCategoryId ?? 'N/A'}',
      );
      debugPrint(
        'WAREHOUSE ADDRESS: '
        '${merchant?.warehouseAddress ?? 'N/A'}',
      );
      debugPrint(
        'BUSINESS TYPE: '
        '${merchant?.businessType ?? 'N/A'}',
      );
      debugPrint(
        'TRADE LICENSE NUMBER: '
        '${merchant?.tradeLicenseNumber ?? 'N/A'}',
      );
      debugPrint(
        'BANK ACCOUNT NAME: '
        '${merchant?.bankAccountName ?? 'N/A'}',
      );
      debugPrint(
        'BANK ACCOUNT NUMBER: '
        '${merchant?.bankAccountNumber ?? 'N/A'}',
      );

      // --------------------------------------------------------
      // User
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- USER ----------');

      debugPrint('USER ID: ${user?.id ?? 'N/A'}');
      debugPrint('FIRST NAME: ${user?.firstName ?? 'N/A'}');
      debugPrint('LAST NAME: ${user?.lastName ?? 'N/A'}');
      debugPrint('EMAIL: ${user?.email ?? 'N/A'}');
      debugPrint('PHONE: ${user?.phone ?? 'N/A'}');
      debugPrint(
        'EMAIL NOTIFICATIONS: '
        '${user?.emailNotifications ?? false}',
      );
      debugPrint(
        'SMS NOTIFICATIONS: '
        '${user?.smsNotifications ?? false}',
      );
      debugPrint(
        'MARKETING EMAILS: '
        '${user?.marketingEmails ?? false}',
      );
      debugPrint('LANGUAGE: ${user?.language ?? 'N/A'}');
      debugPrint('CURRENCY: ${user?.currency ?? 'N/A'}');

      // --------------------------------------------------------
      // End
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('============================================');
      debugPrint('');
    }

    return result;
  }
}