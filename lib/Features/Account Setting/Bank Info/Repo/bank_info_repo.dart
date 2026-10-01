import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';
import '../Models/bank_info_model.dart';

class BankInfoRepository {
  const BankInfoRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Update Bank Information
  // ============================================================

  Future<BankInfoModel> updateBankInfo({
    required String bankAccountName,
    required String bankAccountNumber,
  }) async {
    final response = await _dioClient.post<Map<String, dynamic>>(
      ApiUrls.vendorBankInfo,
      data: {
        'bank_account_name': bankAccountName,
        'bank_account_number': bankAccountNumber,
      },
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
    // Convert API Response -> Model
    // ----------------------------------------------------------

    final result = BankInfoModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Logs
    // ----------------------------------------------------------

    if (kDebugMode) {
      final merchant = result.merchant;

      debugPrint('');
      debugPrint('========== BANK INFO RESULT ==========');

      // --------------------------------------------------------
      // General
      // --------------------------------------------------------

      debugPrint('SUCCESS: ${result.success}');
      debugPrint('MESSAGE: ${result.message ?? 'N/A'}');

      // --------------------------------------------------------
      // Merchant
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- MERCHANT ----------');

      debugPrint('MERCHANT ID: ${merchant?.id ?? 'N/A'}');

      debugPrint('MERCHANT NAME: ${merchant?.name ?? 'N/A'}');

      debugPrint('MERCHANT EMAIL: ${merchant?.email ?? 'N/A'}');

      debugPrint('MERCHANT PHONE: ${merchant?.phone ?? 'N/A'}');

      debugPrint('MERCHANT STATUS: ${merchant?.status ?? 'N/A'}');

      debugPrint('KYC STATUS: ${merchant?.kycStatus ?? 'N/A'}');

      debugPrint('BUSINESS TYPE: ${merchant?.businessType ?? 'N/A'}');

      // --------------------------------------------------------
      // Bank Information
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- BANK INFORMATION ----------');

      debugPrint(
        'BANK ACCOUNT NAME: '
        '${merchant?.bankAccountName ?? 'N/A'}',
      );

      debugPrint(
        'BANK ACCOUNT NUMBER: '
        '${merchant?.bankAccountNumber ?? 'N/A'}',
      );

      // --------------------------------------------------------
      // End
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('======================================');
      debugPrint('');
    }

    return result;
  }
}
