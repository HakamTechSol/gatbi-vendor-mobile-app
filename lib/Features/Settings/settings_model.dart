class SettingsModel {
  const SettingsModel({this.success = false, this.data});

  final bool success;
  final SettingsDataModel? data;

  factory SettingsModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const SettingsModel();
    }

    return SettingsModel(
      success: _parseBool(json['success']),
      data: json['data'] is Map
          ? SettingsDataModel.fromJson(
              Map<String, dynamic>.from(json['data'] as Map),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'data': data?.toJson()};
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;

    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }

    if (value is num) {
      return value != 0;
    }

    return false;
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SETTINGS DATA
// ═══════════════════════════════════════════════════════════════════════════

class SettingsDataModel {
  const SettingsDataModel({
    this.app,
    this.vendorSupport,
    this.shipping,
    this.payment,
  });

  final SettingsAppModel? app;
  final SettingsVendorSupportModel? vendorSupport;
  final SettingsShippingModel? shipping;
  final SettingsPaymentModel? payment;

  factory SettingsDataModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const SettingsDataModel();
    }

    return SettingsDataModel(
      app: json['app'] is Map
          ? SettingsAppModel.fromJson(
              Map<String, dynamic>.from(json['app'] as Map),
            )
          : null,
      vendorSupport: json['vendor_support'] is Map
          ? SettingsVendorSupportModel.fromJson(
              Map<String, dynamic>.from(json['vendor_support'] as Map),
            )
          : null,
      shipping: json['shipping'] is Map
          ? SettingsShippingModel.fromJson(
              Map<String, dynamic>.from(json['shipping'] as Map),
            )
          : null,
      payment: json['payment'] is Map
          ? SettingsPaymentModel.fromJson(
              Map<String, dynamic>.from(json['payment'] as Map),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'app': app?.toJson(),
      'vendor_support': vendorSupport?.toJson(),
      'shipping': shipping?.toJson(),
      'payment': payment?.toJson(),
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// APP SETTINGS
// ═══════════════════════════════════════════════════════════════════════════

class SettingsAppModel {
  const SettingsAppModel({
    this.name = '',
    this.tagline = '',
    this.logo = '',
    this.splash = '',
    this.supportEmail = '',
    this.supportPhone = '',
    this.contactUrl = '',
    this.aboutUsUrl = '',
    this.privacyPolicyUrl = '',
    this.termsUrl = '',
    this.faqUrl = '',
    this.version = '',
    this.defaultLanguage = '',
    this.maintenanceMode = false,
    this.currency,
    this.socialLinks,
    this.socialLogin,
  });

  final String name;
  final String tagline;
  final String logo;
  final String splash;
  final String supportEmail;
  final String supportPhone;
  final String contactUrl;
  final String aboutUsUrl;
  final String privacyPolicyUrl;
  final String termsUrl;
  final String faqUrl;
  final String version;
  final String defaultLanguage;
  final bool maintenanceMode;
  final SettingsCurrencyModel? currency;
  final SettingsSocialLinksModel? socialLinks;
  final SettingsSocialLoginModel? socialLogin;

  factory SettingsAppModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const SettingsAppModel();
    }

    return SettingsAppModel(
      name: _parseString(json['name']),
      tagline: _parseString(json['tagline']),
      logo: _parseString(json['logo']),
      splash: _parseString(json['splash']),
      supportEmail: _parseString(json['support_email']),
      supportPhone: _parseString(json['support_phone']),
      contactUrl: _parseString(json['contact_url']),
      aboutUsUrl: _parseString(json['about_us_url']),
      privacyPolicyUrl: _parseString(json['privacy_policy_url']),
      termsUrl: _parseString(json['terms_url']),
      faqUrl: _parseString(json['faq_url']),
      version: _parseString(json['version']),
      defaultLanguage: _parseString(json['default_language']),
      maintenanceMode: _parseBool(json['maintenance_mode']),
      currency: json['currency'] is Map
          ? SettingsCurrencyModel.fromJson(
              Map<String, dynamic>.from(json['currency'] as Map),
            )
          : null,
      socialLinks: json['social_links'] is Map
          ? SettingsSocialLinksModel.fromJson(
              Map<String, dynamic>.from(json['social_links'] as Map),
            )
          : null,
      socialLogin: json['social_login'] is Map
          ? SettingsSocialLoginModel.fromJson(
              Map<String, dynamic>.from(json['social_login'] as Map),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'tagline': tagline,
      'logo': logo,
      'splash': splash,
      'support_email': supportEmail,
      'support_phone': supportPhone,
      'contact_url': contactUrl,
      'about_us_url': aboutUsUrl,
      'privacy_policy_url': privacyPolicyUrl,
      'terms_url': termsUrl,
      'faq_url': faqUrl,
      'version': version,
      'default_language': defaultLanguage,
      'maintenance_mode': maintenanceMode,
      'currency': currency?.toJson(),
      'social_links': socialLinks?.toJson(),
      'social_login': socialLogin?.toJson(),
    };
  }

  static String _parseString(dynamic value) {
    if (value == null) return '';

    return value.toString();
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;

    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }

    if (value is num) {
      return value != 0;
    }

    return false;
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// CURRENCY
// ═══════════════════════════════════════════════════════════════════════════

class SettingsCurrencyModel {
  const SettingsCurrencyModel({
    this.code = '',
    this.symbol = '',
    this.position = '',
  });

  final String code;
  final String symbol;
  final String position;

  factory SettingsCurrencyModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const SettingsCurrencyModel();
    }

    return SettingsCurrencyModel(
      code: _parseString(json['code']),
      symbol: _parseString(json['symbol']),
      position: _parseString(json['position']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'code': code, 'symbol': symbol, 'position': position};
  }

  static String _parseString(dynamic value) {
    if (value == null) return '';

    return value.toString();
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SOCIAL LINKS
// ═══════════════════════════════════════════════════════════════════════════

class SettingsSocialLinksModel {
  const SettingsSocialLinksModel({
    this.facebook = '',
    this.instagram = '',
    this.twitter = '',
    this.linkedin = '',
    this.youtube = '',
  });

  final String facebook;
  final String instagram;
  final String twitter;
  final String linkedin;
  final String youtube;

  factory SettingsSocialLinksModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const SettingsSocialLinksModel();
    }

    return SettingsSocialLinksModel(
      facebook: _parseString(json['facebook']),
      instagram: _parseString(json['instagram']),
      twitter: _parseString(json['twitter']),
      linkedin: _parseString(json['linkedin']),
      youtube: _parseString(json['youtube']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'facebook': facebook,
      'instagram': instagram,
      'twitter': twitter,
      'linkedin': linkedin,
      'youtube': youtube,
    };
  }

  static String _parseString(dynamic value) {
    if (value == null) return '';

    return value.toString();
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SOCIAL LOGIN
// ═══════════════════════════════════════════════════════════════════════════

class SettingsSocialLoginModel {
  const SettingsSocialLoginModel({
    this.enabled = false,
    this.providers = const [],
  });

  final bool enabled;
  final List<SettingsSocialProviderModel> providers;

  factory SettingsSocialLoginModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const SettingsSocialLoginModel();
    }

    return SettingsSocialLoginModel(
      enabled: _parseBool(json['enabled']),
      providers: _parseList(
        json['providers'],
        SettingsSocialProviderModel.fromJson,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'providers': providers.map((e) => e.toJson()).toList(),
    };
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;

    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }

    if (value is num) {
      return value != 0;
    }

    return false;
  }

  static List<T> _parseList<T>(
    dynamic value,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (value is! List) return const [];

    return value
        .whereType<Map>()
        .map((item) => fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SOCIAL PROVIDER
// ═══════════════════════════════════════════════════════════════════════════

class SettingsSocialProviderModel {
  const SettingsSocialProviderModel({
    this.provider = '',
    this.enabled = false,
    this.clientId = '',
  });

  final String provider;
  final bool enabled;
  final String clientId;

  factory SettingsSocialProviderModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const SettingsSocialProviderModel();
    }

    return SettingsSocialProviderModel(
      provider: _parseString(json['provider']),
      enabled: _parseBool(json['enabled']),
      clientId: _parseString(json['client_id']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'provider': provider, 'enabled': enabled, 'client_id': clientId};
  }

  static String _parseString(dynamic value) {
    if (value == null) return '';

    return value.toString();
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;

    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }

    if (value is num) {
      return value != 0;
    }

    return false;
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// VENDOR SUPPORT
// ═══════════════════════════════════════════════════════════════════════════

class SettingsVendorSupportModel {
  const SettingsVendorSupportModel({
    this.email = '',
    this.phone = '',
    this.whatsapp = '',
    this.whatsappLink = '',
    this.supportHours = '',
    this.helpCenterUrl = '',
  });

  final String email;
  final String phone;
  final String whatsapp;
  final String whatsappLink;
  final String supportHours;
  final String helpCenterUrl;

  factory SettingsVendorSupportModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const SettingsVendorSupportModel();
    }

    return SettingsVendorSupportModel(
      email: _parseString(json['email']),
      phone: _parseString(json['phone']),
      whatsapp: _parseString(json['whatsapp']),
      whatsappLink: _parseString(json['whatsapp_link']),
      supportHours: _parseString(json['support_hours']),
      helpCenterUrl: _parseString(json['help_center_url']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'phone': phone,
      'whatsapp': whatsapp,
      'whatsapp_link': whatsappLink,
      'support_hours': supportHours,
      'help_center_url': helpCenterUrl,
    };
  }

  static String _parseString(dynamic value) {
    if (value == null) return '';

    return value.toString();
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SHIPPING
// ═══════════════════════════════════════════════════════════════════════════

class SettingsShippingModel {
  const SettingsShippingModel({
    this.currency = '',
    this.flatRate = 0,
    this.freeShippingThreshold = 0,
    this.estimatedDeliveryDays = 0,
    this.supportsCashOnDelivery = false,
    this.taxAppliesOnShipping = false,
    this.regions = const [],
  });

  final String currency;
  final double flatRate;
  final double freeShippingThreshold;
  final int estimatedDeliveryDays;
  final bool supportsCashOnDelivery;
  final bool taxAppliesOnShipping;
  final List<dynamic> regions;

  factory SettingsShippingModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const SettingsShippingModel();
    }

    return SettingsShippingModel(
      currency: _parseString(json['currency']),
      flatRate: _parseDouble(json['flat_rate']),
      freeShippingThreshold: _parseDouble(json['free_shipping_threshold']),
      estimatedDeliveryDays: _parseInt(json['estimated_delivery_days']),
      supportsCashOnDelivery: _parseBool(json['supports_cash_on_delivery']),
      taxAppliesOnShipping: _parseBool(json['tax_applies_on_shipping']),
      regions: _parseList(json['regions']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currency': currency,
      'flat_rate': flatRate,
      'free_shipping_threshold': freeShippingThreshold,
      'estimated_delivery_days': estimatedDeliveryDays,
      'supports_cash_on_delivery': supportsCashOnDelivery,
      'tax_applies_on_shipping': taxAppliesOnShipping,
      'regions': regions,
    };
  }

  static String _parseString(dynamic value) {
    if (value == null) return '';

    return value.toString();
  }

  static double _parseDouble(dynamic value) {
    if (value is num) return value.toDouble();

    if (value is String) {
      return double.tryParse(value) ?? 0;
    }

    return 0;
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;

    if (value is num) return value.toInt();

    if (value is String) {
      return int.tryParse(value) ?? 0;
    }

    return 0;
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;

    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }

    if (value is num) {
      return value != 0;
    }

    return false;
  }

  static List<dynamic> _parseList(dynamic value) {
    if (value is List) {
      return List<dynamic>.from(value);
    }

    return const [];
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// PAYMENT
// ═══════════════════════════════════════════════════════════════════════════

class SettingsPaymentModel {
  const SettingsPaymentModel({
    this.currencyCode = '',
    this.currencySymbol = '',
    this.taxLabel = '',
    this.taxEnabled = false,
    this.taxRatePercent = 0,
    this.taxApplyOnShipping = false,
    this.otherTaxRatePercent = 0,
    this.defaultMethod = '',
    this.stripe,
    this.tabby,
    this.tamara,
    this.methods = const [],
  });

  final String currencyCode;
  final String currencySymbol;
  final String taxLabel;
  final bool taxEnabled;
  final double taxRatePercent;
  final bool taxApplyOnShipping;
  final double otherTaxRatePercent;
  final String defaultMethod;
  final SettingsStripeModel? stripe;
  final SettingsTabbyModel? tabby;
  final SettingsTamaraModel? tamara;
  final List<SettingsPaymentMethodModel> methods;

  factory SettingsPaymentModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const SettingsPaymentModel();
    }

    return SettingsPaymentModel(
      currencyCode: _parseString(json['currency_code']),
      currencySymbol: _parseString(json['currency_symbol']),
      taxLabel: _parseString(json['tax_label']),
      taxEnabled: _parseBool(json['tax_enabled']),
      taxRatePercent: _parseDouble(json['tax_rate_percent']),
      taxApplyOnShipping: _parseBool(json['tax_apply_on_shipping']),
      otherTaxRatePercent: _parseDouble(json['other_tax_rate_percent']),
      defaultMethod: _parseString(json['default_method']),
      stripe: json['stripe'] is Map
          ? SettingsStripeModel.fromJson(
              Map<String, dynamic>.from(json['stripe'] as Map),
            )
          : null,
      tabby: json['tabby'] is Map
          ? SettingsTabbyModel.fromJson(
              Map<String, dynamic>.from(json['tabby'] as Map),
            )
          : null,
      tamara: json['tamara'] is Map
          ? SettingsTamaraModel.fromJson(
              Map<String, dynamic>.from(json['tamara'] as Map),
            )
          : null,
      methods: _parseList(json['methods'], SettingsPaymentMethodModel.fromJson),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currency_code': currencyCode,
      'currency_symbol': currencySymbol,
      'tax_label': taxLabel,
      'tax_enabled': taxEnabled,
      'tax_rate_percent': taxRatePercent,
      'tax_apply_on_shipping': taxApplyOnShipping,
      'other_tax_rate_percent': otherTaxRatePercent,
      'default_method': defaultMethod,
      'stripe': stripe?.toJson(),
      'tabby': tabby?.toJson(),
      'tamara': tamara?.toJson(),
      'methods': methods.map((e) => e.toJson()).toList(),
    };
  }

  static String _parseString(dynamic value) {
    if (value == null) return '';

    return value.toString();
  }

  static double _parseDouble(dynamic value) {
    if (value is num) return value.toDouble();

    if (value is String) {
      return double.tryParse(value) ?? 0;
    }

    return 0;
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;

    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }

    if (value is num) {
      return value != 0;
    }

    return false;
  }

  static List<T> _parseList<T>(
    dynamic value,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (value is! List) return const [];

    return value
        .whereType<Map>()
        .map((item) => fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// STRIPE
// ═══════════════════════════════════════════════════════════════════════════

class SettingsStripeModel {
  const SettingsStripeModel({
    this.enabled = false,
    this.mode = '',
    this.publishableKey = '',
    this.test,
    this.live,
  });

  final bool enabled;
  final String mode;
  final String publishableKey;
  final SettingsStripeKeysModel? test;
  final SettingsStripeKeysModel? live;

  factory SettingsStripeModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const SettingsStripeModel();
    }

    return SettingsStripeModel(
      enabled: _parseBool(json['enabled']),
      mode: _parseString(json['mode']),
      publishableKey: _parseString(json['publishable_key']),
      test: json['test'] is Map
          ? SettingsStripeKeysModel.fromJson(
              Map<String, dynamic>.from(json['test'] as Map),
            )
          : null,
      live: json['live'] is Map
          ? SettingsStripeKeysModel.fromJson(
              Map<String, dynamic>.from(json['live'] as Map),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'mode': mode,
      'publishable_key': publishableKey,
      'test': test?.toJson(),
      'live': live?.toJson(),
    };
  }

  static String _parseString(dynamic value) {
    if (value == null) return '';

    return value.toString();
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;

    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }

    if (value is num) {
      return value != 0;
    }

    return false;
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// STRIPE KEYS
// ═══════════════════════════════════════════════════════════════════════════

class SettingsStripeKeysModel {
  const SettingsStripeKeysModel({this.publishableKey = ''});

  final String publishableKey;

  factory SettingsStripeKeysModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const SettingsStripeKeysModel();
    }

    return SettingsStripeKeysModel(
      publishableKey: _parseString(json['publishable_key']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'publishable_key': publishableKey};
  }

  static String _parseString(dynamic value) {
    if (value == null) return '';

    return value.toString();
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// TABBY
// ═══════════════════════════════════════════════════════════════════════════

class SettingsTabbyModel {
  const SettingsTabbyModel({
    this.enabled = false,
    this.mode = '',
    this.currency = '',
    this.merchantCode = '',
  });

  final bool enabled;
  final String mode;
  final String currency;
  final String merchantCode;

  factory SettingsTabbyModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const SettingsTabbyModel();
    }

    return SettingsTabbyModel(
      enabled: _parseBool(json['enabled']),
      mode: _parseString(json['mode']),
      currency: _parseString(json['currency']),
      merchantCode: _parseString(json['merchant_code']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'mode': mode,
      'currency': currency,
      'merchant_code': merchantCode,
    };
  }

  static String _parseString(dynamic value) {
    if (value == null) return '';

    return value.toString();
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;

    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }

    if (value is num) {
      return value != 0;
    }

    return false;
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// TAMARA
// ═══════════════════════════════════════════════════════════════════════════

class SettingsTamaraModel {
  const SettingsTamaraModel({
    this.enabled = false,
    this.mode = '',
    this.currency = '',
  });

  final bool enabled;
  final String mode;
  final String currency;

  factory SettingsTamaraModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const SettingsTamaraModel();
    }

    return SettingsTamaraModel(
      enabled: _parseBool(json['enabled']),
      mode: _parseString(json['mode']),
      currency: _parseString(json['currency']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'enabled': enabled, 'mode': mode, 'currency': currency};
  }

  static String _parseString(dynamic value) {
    if (value == null) return '';

    return value.toString();
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;

    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }

    if (value is num) {
      return value != 0;
    }

    return false;
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// PAYMENT METHOD
// ═══════════════════════════════════════════════════════════════════════════

class SettingsPaymentMethodModel {
  const SettingsPaymentMethodModel({
    this.code = '',
    this.name = '',
    this.enabled = false,
    this.instructions = '',
    this.feesPercentage = 0,
    this.supportsRefund = false,
    this.bankDetails,
  });

  final String code;
  final String name;
  final bool enabled;
  final String instructions;
  final double feesPercentage;
  final bool supportsRefund;
  final SettingsBankDetailsModel? bankDetails;

  factory SettingsPaymentMethodModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const SettingsPaymentMethodModel();
    }

    return SettingsPaymentMethodModel(
      code: _parseString(json['code']),
      name: _parseString(json['name']),
      enabled: _parseBool(json['enabled']),
      instructions: _parseString(json['instructions']),
      feesPercentage: _parseDouble(json['fees_percentage']),
      supportsRefund: _parseBool(json['supports_refund']),
      bankDetails: json['bank_details'] is Map
          ? SettingsBankDetailsModel.fromJson(
              Map<String, dynamic>.from(json['bank_details'] as Map),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'enabled': enabled,
      'instructions': instructions,
      'fees_percentage': feesPercentage,
      'supports_refund': supportsRefund,
      'bank_details': bankDetails?.toJson(),
    };
  }

  static String _parseString(dynamic value) {
    if (value == null) return '';

    return value.toString();
  }

  static double _parseDouble(dynamic value) {
    if (value is num) return value.toDouble();

    if (value is String) {
      return double.tryParse(value) ?? 0;
    }

    return 0;
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;

    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }

    if (value is num) {
      return value != 0;
    }

    return false;
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// BANK DETAILS
// ═══════════════════════════════════════════════════════════════════════════

class SettingsBankDetailsModel {
  const SettingsBankDetailsModel({
    this.bankName = '',
    this.accountTitle = '',
    this.accountNumber = '',
    this.iban = '',
    this.swiftCode = '',
    this.branch = '',
  });

  final String bankName;
  final String accountTitle;
  final String accountNumber;
  final String iban;
  final String swiftCode;
  final String branch;

  factory SettingsBankDetailsModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const SettingsBankDetailsModel();
    }

    return SettingsBankDetailsModel(
      bankName: _parseString(json['bank_name']),
      accountTitle: _parseString(json['account_title']),
      accountNumber: _parseString(json['account_number']),
      iban: _parseString(json['iban']),
      swiftCode: _parseString(json['swift_code']),
      branch: _parseString(json['branch']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bank_name': bankName,
      'account_title': accountTitle,
      'account_number': accountNumber,
      'iban': iban,
      'swift_code': swiftCode,
      'branch': branch,
    };
  }

  static String _parseString(dynamic value) {
    if (value == null) return '';

    return value.toString();
  }
}
