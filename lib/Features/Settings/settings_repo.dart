import 'package:flutter/foundation.dart';

import '../../../../Services/api_exception.dart';
import '../../../../Services/api_url.dart';
import '../../../../Services/dio_client.dart';
import 'settings_model.dart';

class SettingsRepository {
  const SettingsRepository(this._dioClient);

  final DioClient _dioClient;

  // ============================================================
  // Get Settings
  // ============================================================

  Future<SettingsModel> getSettings() async {
    final response = await _dioClient.get<Map<String, dynamic>>(
      ApiUrls.settings,
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
    // Convert API Response -> Settings Model
    // ----------------------------------------------------------

    final result = SettingsModel.fromJson(data);

    // ----------------------------------------------------------
    // Debug Logs
    // ----------------------------------------------------------

    if (kDebugMode) {
      final settingsData = result.data;
      final app = settingsData?.app;
      final vendorSupport = settingsData?.vendorSupport;
      final shipping = settingsData?.shipping;
      final payment = settingsData?.payment;

      debugPrint('');
      debugPrint('========== SETTINGS RESULT ==========');

      // --------------------------------------------------------
      // General
      // --------------------------------------------------------

      debugPrint('SUCCESS: ${result.success}');

      // --------------------------------------------------------
      // App
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- APP ----------');
      debugPrint('APP NAME: ${app?.name ?? 'N/A'}');
      debugPrint('TAGLINE: ${app?.tagline ?? 'N/A'}');
      debugPrint('LOGO: ${app?.logo ?? 'N/A'}');
      debugPrint('SPLASH: ${app?.splash ?? 'N/A'}');
      debugPrint('SUPPORT EMAIL: ${app?.supportEmail ?? 'N/A'}');
      debugPrint('SUPPORT PHONE: ${app?.supportPhone ?? 'N/A'}');
      debugPrint('VERSION: ${app?.version ?? 'N/A'}');
      debugPrint('DEFAULT LANGUAGE: ${app?.defaultLanguage ?? 'N/A'}');
      debugPrint('MAINTENANCE MODE: ${app?.maintenanceMode ?? false}');

      // --------------------------------------------------------
      // Currency
      // --------------------------------------------------------

      final currency = app?.currency;

      debugPrint('');
      debugPrint('---------- APP CURRENCY ----------');
      debugPrint('CODE: ${currency?.code ?? 'N/A'}');
      debugPrint('SYMBOL: ${currency?.symbol ?? 'N/A'}');
      debugPrint('POSITION: ${currency?.position ?? 'N/A'}');

      // --------------------------------------------------------
      // Social Links
      // --------------------------------------------------------

      final socialLinks = app?.socialLinks;

      debugPrint('');
      debugPrint('---------- SOCIAL LINKS ----------');
      debugPrint('FACEBOOK: ${socialLinks?.facebook ?? 'N/A'}');
      debugPrint('INSTAGRAM: ${socialLinks?.instagram ?? 'N/A'}');
      debugPrint('TWITTER: ${socialLinks?.twitter ?? 'N/A'}');
      debugPrint('LINKEDIN: ${socialLinks?.linkedin ?? 'N/A'}');
      debugPrint('YOUTUBE: ${socialLinks?.youtube ?? 'N/A'}');

      // --------------------------------------------------------
      // Social Login
      // --------------------------------------------------------

      final socialLogin = app?.socialLogin;

      debugPrint('');
      debugPrint('---------- SOCIAL LOGIN ----------');
      debugPrint('ENABLED: ${socialLogin?.enabled ?? false}');
      debugPrint(
        'PROVIDERS COUNT: '
        '${socialLogin?.providers.length ?? 0}',
      );

      if (socialLogin?.providers.isNotEmpty == true) {
        for (final provider in socialLogin!.providers) {
          debugPrint(
            'PROVIDER: ${provider.provider} | '
            'ENABLED: ${provider.enabled} | '
            'CLIENT ID: ${provider.clientId.isEmpty ? 'N/A' : provider.clientId}',
          );
        }
      }

      // --------------------------------------------------------
      // Vendor Support
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- VENDOR SUPPORT ----------');
      debugPrint('EMAIL: ${vendorSupport?.email ?? 'N/A'}');
      debugPrint('PHONE: ${vendorSupport?.phone ?? 'N/A'}');
      debugPrint('WHATSAPP: ${vendorSupport?.whatsapp ?? 'N/A'}');
      debugPrint(
        'WHATSAPP LINK: '
        '${vendorSupport?.whatsappLink ?? 'N/A'}',
      );
      debugPrint(
        'SUPPORT HOURS: '
        '${vendorSupport?.supportHours ?? 'N/A'}',
      );
      debugPrint(
        'HELP CENTER: '
        '${vendorSupport?.helpCenterUrl ?? 'N/A'}',
      );

      // --------------------------------------------------------
      // Shipping
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- SHIPPING ----------');
      debugPrint('CURRENCY: ${shipping?.currency ?? 'N/A'}');
      debugPrint('FLAT RATE: ${shipping?.flatRate ?? 0}');
      debugPrint(
        'FREE SHIPPING THRESHOLD: '
        '${shipping?.freeShippingThreshold ?? 0}',
      );
      debugPrint(
        'ESTIMATED DELIVERY DAYS: '
        '${shipping?.estimatedDeliveryDays ?? 0}',
      );
      debugPrint(
        'CASH ON DELIVERY: '
        '${shipping?.supportsCashOnDelivery ?? false}',
      );
      debugPrint(
        'TAX ON SHIPPING: '
        '${shipping?.taxAppliesOnShipping ?? false}',
      );
      debugPrint(
        'REGIONS COUNT: '
        '${shipping?.regions.length ?? 0}',
      );

      // --------------------------------------------------------
      // Payment
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- PAYMENT ----------');
      debugPrint(
        'CURRENCY CODE: '
        '${payment?.currencyCode ?? 'N/A'}',
      );
      debugPrint(
        'CURRENCY SYMBOL: '
        '${payment?.currencySymbol ?? 'N/A'}',
      );
      debugPrint('TAX LABEL: ${payment?.taxLabel ?? 'N/A'}');
      debugPrint(
        'TAX ENABLED: '
        '${payment?.taxEnabled ?? false}',
      );
      debugPrint(
        'TAX RATE: '
        '${payment?.taxRatePercent ?? 0}',
      );
      debugPrint(
        'TAX ON SHIPPING: '
        '${payment?.taxApplyOnShipping ?? false}',
      );
      debugPrint(
        'OTHER TAX RATE: '
        '${payment?.otherTaxRatePercent ?? 0}',
      );
      debugPrint(
        'DEFAULT METHOD: '
        '${payment?.defaultMethod ?? 'N/A'}',
      );
      debugPrint(
        'PAYMENT METHODS COUNT: '
        '${payment?.methods.length ?? 0}',
      );

      // --------------------------------------------------------
      // Stripe
      // --------------------------------------------------------

      final stripe = payment?.stripe;

      debugPrint('');
      debugPrint('---------- STRIPE ----------');
      debugPrint('ENABLED: ${stripe?.enabled ?? false}');
      debugPrint('MODE: ${stripe?.mode ?? 'N/A'}');
      debugPrint(
        'PUBLISHABLE KEY: '
        '${stripe?.publishableKey.isEmpty == true ? 'N/A' : 'AVAILABLE'}',
      );

      // --------------------------------------------------------
      // Tabby
      // --------------------------------------------------------

      final tabby = payment?.tabby;

      debugPrint('');
      debugPrint('---------- TABBY ----------');
      debugPrint('ENABLED: ${tabby?.enabled ?? false}');
      debugPrint('MODE: ${tabby?.mode ?? 'N/A'}');
      debugPrint('CURRENCY: ${tabby?.currency ?? 'N/A'}');
      debugPrint(
        'MERCHANT CODE: '
        '${tabby?.merchantCode ?? 'N/A'}',
      );

      // --------------------------------------------------------
      // Tamara
      // --------------------------------------------------------

      final tamara = payment?.tamara;

      debugPrint('');
      debugPrint('---------- TAMARA ----------');
      debugPrint('ENABLED: ${tamara?.enabled ?? false}');
      debugPrint('MODE: ${tamara?.mode ?? 'N/A'}');
      debugPrint('CURRENCY: ${tamara?.currency ?? 'N/A'}');

      // --------------------------------------------------------
      // Payment Methods
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('---------- PAYMENT METHODS ----------');

      if (payment?.methods.isNotEmpty == true) {
        for (final method in payment!.methods) {
          debugPrint(
            'METHOD: ${method.code} | '
            'NAME: ${method.name} | '
            'ENABLED: ${method.enabled} | '
            'FEES: ${method.feesPercentage}% | '
            'REFUND: ${method.supportsRefund}',
          );

          final bank = method.bankDetails;

          if (bank != null) {
            debugPrint(
              'BANK: ${bank.bankName} | '
              'ACCOUNT TITLE: ${bank.accountTitle} | '
              'BRANCH: ${bank.branch}',
            );
          }
        }
      }

      // --------------------------------------------------------
      // End
      // --------------------------------------------------------

      debugPrint('');
      debugPrint('=====================================');
      debugPrint('');
    }

    return result;
  }
}
