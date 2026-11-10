class SocialProvider {
  const SocialProvider({
    required this.provider,
    required this.enabled,
    this.clientId,
    this.mobileClientIds = const <String>[],
  });

  final String provider;
  final bool enabled;
  final String? clientId;
  final List<String> mobileClientIds;

  String? get primaryMobileClientId {
    for (final id in mobileClientIds) {
      final value = id.trim();
      if (value.isNotEmpty) return value;
    }
    return null;
  }

  bool get isGoogle => provider.toLowerCase() == 'google';
  bool get isApple => provider.toLowerCase() == 'apple';
  bool get isFacebook => provider.toLowerCase() == 'facebook';

  factory SocialProvider.fromJson(Map<String, dynamic> json) {
    final rawIds = json['mobile_client_ids'];

    return SocialProvider(
      provider: _string(json['provider']) ?? '',
      enabled: _bool(json['enabled']) ?? false,
      clientId: _string(json['client_id']),
      mobileClientIds: rawIds is List
          ? rawIds
                .map((value) => _string(value))
                .whereType<String>()
                .where((value) => value.isNotEmpty)
                .toList(growable: false)
          : const <String>[],
    );
  }

  static String? _string(Object? value) {
    if (value is String) {
      final result = value.trim();
      if (result.isNotEmpty) return result;
    }
    return null;
  }

  static bool? _bool(Object? value) {
    if (value is bool) return value;
    if (value is num) {
      if (value == 1) return true;
      if (value == 0) return false;
    }
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      if (normalized == 'true' || normalized == '1') return true;
      if (normalized == 'false' || normalized == '0') return false;
    }
    return null;
  }
}

class SocialProvidersResponse {
  const SocialProvidersResponse({
    required this.socialLoginEnabled,
    required this.providers,
  });

  final bool socialLoginEnabled;
  final List<SocialProvider> providers;

  List<SocialProvider> get enabledProviders => providers
      .where((provider) => provider.enabled && provider.provider.isNotEmpty)
      .toList(growable: false);

  factory SocialProvidersResponse.fromJson(Map<String, dynamic> json) {
    final rawProviders = json['providers'];

    return SocialProvidersResponse(
      socialLoginEnabled: _bool(json['social_login_enabled']) ?? true,
      providers: rawProviders is List
          ? rawProviders
                .whereType<Map>()
                .map(
                  (value) => SocialProvider.fromJson(
                    Map<String, dynamic>.from(value),
                  ),
                )
                .toList(growable: false)
          : const <SocialProvider>[],
    );
  }

  static SocialProvidersResponse fallback() {
    return const SocialProvidersResponse(
      socialLoginEnabled: true,
      providers: [
        SocialProvider(
          provider: 'google',
          enabled: true,
          clientId:
              '669083811411-2k6e7pp41n65v3h4t2nf42398n63qn5j.apps.googleusercontent.com',
          mobileClientIds: [
            '391572737407-8c5s56e0r0rkksoil3uhugfs8earbtbm.apps.googleusercontent.com',
          ],
        ),
        SocialProvider(
          provider: 'apple',
          enabled: true,
          clientId: 'com.gatbi.app.auth',
          mobileClientIds: ['com.gatbi.gatbivender', 'com.gatbi.app'],
        ),
      ],
    );
  }

  static bool? _bool(Object? value) {
    if (value is bool) return value;
    if (value is num) {
      if (value == 1) return true;
      if (value == 0) return false;
    }
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      if (normalized == 'true' || normalized == '1') return true;
      if (normalized == 'false' || normalized == '0') return false;
    }
    return null;
  }
}
