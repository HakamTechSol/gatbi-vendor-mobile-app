import 'campaign_model.dart';
import 'campaign_pagination_model.dart';
import 'campaign_type_model.dart';

class GetCampaignsModel {
  const GetCampaignsModel({
    this.success,
    this.campaignTypes = const [],
    this.campaigns = const [],
    this.pagination,
    this.notes,
  });

  // ============================================================
  // Main Response Fields
  // ============================================================

  final bool? success;

  final List<CampaignTypeModel> campaignTypes;

  final List<CampaignModel> campaigns;

  final CampaignPaginationModel? pagination;

  final String? notes;

  // ============================================================
  // Convenience Getters
  // ============================================================

  bool get hasNextPage {
    return pagination?.hasNextPage ?? false;
  }

  bool get hasPreviousPage {
    return pagination?.hasPreviousPage ?? false;
  }

  int get currentPage {
    return pagination?.currentPage ?? 1;
  }

  int get lastPage {
    return pagination?.lastPage ?? 1;
  }

  int get total {
    return pagination?.total ?? 0;
  }

  int get perPage {
    return pagination?.perPage ?? 0;
  }

  // ============================================================
  // From JSON
  // ============================================================

  factory GetCampaignsModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const GetCampaignsModel();
    }

    return GetCampaignsModel(
      success: _parseBool(json['success']),
      campaignTypes: _parseCampaignTypes(json['campaign_types']),
      campaigns: _parseCampaigns(json['campaigns']),
      pagination: json['pagination'] is Map
          ? CampaignPaginationModel.fromJson(
              Map<String, dynamic>.from(json['pagination'] as Map),
            )
          : null,
      notes: _parseString(json['notes']),
    );
  }

  // ============================================================
  // To JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'campaign_types': campaignTypes.map((e) => e.toJson()).toList(),
      'campaigns': campaigns.map((e) => e.toJson()).toList(),
      'pagination': pagination?.toJson(),
      'notes': notes,
    };
  }

  // ============================================================
  // Campaign Types Parser
  // ============================================================

  static List<CampaignTypeModel> _parseCampaignTypes(dynamic value) {
    if (value is! List) {
      return const [];
    }

    return value
        .whereType<Map>()
        .map(
          (item) => CampaignTypeModel.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList();
  }

  // ============================================================
  // Campaigns Parser
  // ============================================================

  static List<CampaignModel> _parseCampaigns(dynamic value) {
    if (value is! List) {
      return const [];
    }

    return value
        .whereType<Map>()
        .map((item) => CampaignModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  // ============================================================
  // Parsers
  // ============================================================

  static bool? _parseBool(dynamic value) {
    if (value == null) return null;

    if (value is bool) {
      return value;
    }

    if (value is String) {
      final normalized = value.toLowerCase().trim();

      if (normalized == 'true' || normalized == '1') {
        return true;
      }

      if (normalized == 'false' || normalized == '0') {
        return false;
      }
    }

    if (value is num) {
      return value != 0;
    }

    return null;
  }

  static String? _parseString(dynamic value) {
    if (value == null) return null;

    if (value is String) {
      return value;
    }

    return value.toString();
  }
}
