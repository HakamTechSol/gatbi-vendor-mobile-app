import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:task_project/Core/Bottom%20Naigation%20Bar/bottom_bar_screen.dart';

import '../../../Routes/app_route.dart';
import '../../../Theme/app_colors.dart';
import '../../../Theme/app_text_styles.dart';

import '../Get Campaign/Controllers/get_campaigns_controller.dart';
import '../Get Campaign/Models/campaign_model.dart';
import '../Get Campaign/Models/get_campaigns_model.dart';

import '../Reuse widgets/campaign_card.dart';
import '../Reuse widgets/campaign_filter_chip.dart';
import '../Reuse widgets/campaigns_action_buttons.dart';
import '../Reuse widgets/campaigns_empty_state.dart';
import '../Reuse widgets/campaigns_header.dart';
import '../Reuse widgets/campaigns_how_it_works.dart';
import '../Reuse widgets/campaigns_suggested_ideas.dart';

import '../Reuse widgets/campaigns_loading.dart';

class CampaignsScreen extends ConsumerStatefulWidget {
  const CampaignsScreen({super.key});

  @override
  ConsumerState<CampaignsScreen> createState() => _CampaignsScreenState();
}

class _CampaignsScreenState extends ConsumerState<CampaignsScreen> {
  // ============================================================
  // Constants
  // ============================================================

  static const int _perPage = 50;

  static const List<String> _fixedStatuses = [
    'pending',
    'approved',
    'active',
    'rejected',
    'expired',
    'cancelled',
  ];

  // ============================================================
  // State
  // ============================================================

  GetCampaignsModel? _campaignsData;

  bool _isLoading = true;
  bool _isLoadingNextPage = false;

  String? _errorMessage;

  /// null = All
  String? _selectedStatus;

  // ============================================================
  // Lifecycle
  // ============================================================

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCampaigns(showShimmer: true);
    });
  }

  // ============================================================
  // Build
  // ============================================================

  @override
  Widget build(BuildContext context) {
    // ============================================================
    // Full Screen Shimmer
    // ============================================================

    if (_isLoading && _campaignsData == null) {
      return const CampaignsLoading(itemCount: 3);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          backgroundColor: AppColors.white,
          onRefresh: _handleRefresh,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // ======================================================
                    // Header
                    // ======================================================
                    const CampaignsHeader(),

                    const SizedBox(height: 18),

                    // ======================================================
                    // Action Buttons
                    // ======================================================
                    CampaignsActionButtons(
                      onPickProducts: _handlePickProducts,
                      onRequestCampaign: _handleRequestCampaign,
                    ),

                    const SizedBox(height: 26),

                    // ======================================================
                    // Campaigns Section
                    // ======================================================
                    _buildCampaignsSection(),

                    const SizedBox(height: 26),

                    // ======================================================
                    // How It Works
                    // ======================================================
                    const CampaignsHowItWorks(),

                    const SizedBox(height: 26),

                    // ======================================================
                    // Suggested Ideas
                    // ======================================================
                    _buildSuggestedIdeas(),

                    const SizedBox(height: 26),

                    // ======================================================
                    // Pagination
                    // ======================================================
                    _buildPagination(),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // Campaigns Section
  // ============================================================

  Widget _buildCampaignsSection() {
    if (_errorMessage != null && _campaignsData == null) {
      return _buildErrorState();
    }

    final campaigns = _filteredCampaigns;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          title: 'Your campaigns',
          subtitle: _buildCampaignSubtitle(campaigns),
        ),

        const SizedBox(height: 14),

        _buildStatusFilters(),

        const SizedBox(height: 14),

        if (campaigns.isEmpty)
          CampaignsEmptyState(onContactSupport: _handleRequestCampaign)
        else
          _buildCampaignList(campaigns),
      ],
    );
  }

  // ============================================================
  // Section Header
  // ============================================================

  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.titleLarge),
              const SizedBox(height: 4),
              Text(subtitle, style: AppTextStyles.bodySmall),
            ],
          ),
        ),
      ],
    );
  }

  String _buildCampaignSubtitle(List<CampaignModel> campaigns) {
    final total = _campaignsData?.total ?? campaigns.length;

    if (total == 0) {
      return 'No campaigns available right now.';
    }

    return '$total campaign${total == 1 ? '' : 's'}';
  }

  // ============================================================
  // Status Filters
  // ============================================================

  Widget _buildStatusFilters() {
    final filters = <_CampaignFilter>[
      const _CampaignFilter(label: 'All', status: null),
      ..._fixedStatuses.map(
        (status) =>
            _CampaignFilter(label: _formatStatus(status), status: status),
      ),
    ];

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 1),
        itemCount: filters.length,
        separatorBuilder: (_, __) {
          return const SizedBox(width: 9);
        },
        itemBuilder: (context, index) {
          final filter = filters[index];

          final isSelected = _selectedStatus == filter.status;

          return CampaignFilterChip(
            label: filter.label,
            isSelected: isSelected,
            onTap: () {
              if (_selectedStatus == filter.status) {
                return;
              }

              setState(() {
                _selectedStatus = filter.status;
              });
            },
          );
        },
      ),
    );
  }

  // ============================================================
  // Filtered Campaigns
  // ============================================================

  List<CampaignModel> get _filteredCampaigns {
    final campaigns = _campaignsData?.campaigns ?? [];

    if (_selectedStatus == null) {
      return campaigns;
    }

    final selectedStatus = _selectedStatus!.trim().toLowerCase();

    return campaigns.where((campaign) {
      final campaignStatus = campaign.status?.trim().toLowerCase();

      return campaignStatus == selectedStatus;
    }).toList();
  }

  // ============================================================
  // Campaign List
  // ============================================================

  Widget _buildCampaignList(List<CampaignModel> campaigns) {
    return Column(
      children: [
        for (int index = 0; index < campaigns.length; index++) ...[
          CampaignCard(
            campaign: campaigns[index],
            onTap: () {
              _handleCampaignTap(campaigns[index]);
            },
          ),

          if (index != campaigns.length - 1) const SizedBox(height: 12),
        ],
      ],
    );
  }

  // ============================================================
  // Suggested Ideas
  // ============================================================

  Widget _buildSuggestedIdeas() {
    final campaignTypes = _campaignsData?.campaignTypes ?? [];

    return CampaignsSuggestedIdeas(
      campaignTypes: campaignTypes,
      isLoading: false,
    );
  }

  // ============================================================
  // Pagination
  // ============================================================

  Widget _buildPagination() {
    final data = _campaignsData;

    if (data == null) {
      return const SizedBox.shrink();
    }

    if (!data.hasNextPage && !data.hasPreviousPage) {
      return const SizedBox.shrink();
    }

    final pagination = data.pagination;

    if (pagination == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Page ${pagination.currentPage ?? 1} '
              'of ${pagination.lastPage ?? 1}',
              style: AppTextStyles.captionMedium,
            ),
          ),

          if (data.hasPreviousPage)
            _PaginationButton(
              icon: Icons.chevron_left_rounded,
              onTap: _isLoadingNextPage ? null : _loadPreviousPage,
            ),

          const SizedBox(width: 8),

          if (data.hasNextPage)
            _PaginationButton(
              icon: Icons.chevron_right_rounded,
              onTap: _isLoadingNextPage ? null : _loadNextPage,
            ),
        ],
      ),
    );
  }

  // ============================================================
  // Error State
  // ============================================================

  Widget _buildErrorState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.errorLight,
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.error_outline_rounded,
              color: AppColors.errorDark,
            ),
          ),

          const SizedBox(height: 12),

          Text('Unable to load campaigns', style: AppTextStyles.titleMedium),

          const SizedBox(height: 5),

          Text(
            _errorMessage ?? 'Something went wrong. Please try again.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall,
          ),

          const SizedBox(height: 14),

          ElevatedButton(
            onPressed: () {
              _loadCampaigns(showShimmer: true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // API - Initial / Full Refresh
  // ============================================================

  Future<void> _loadCampaigns({bool showShimmer = true}) async {
    if (!mounted) return;

    if (showShimmer) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
        _campaignsData = null;
      });
    } else {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    debugPrint('');
    debugPrint('==============================================');
    debugPrint('CAMPAIGNS API LOAD');
    debugPrint('SHOW SHIMMER: $showShimmer');
    debugPrint('PAGE: 1');
    debugPrint('PER PAGE: $_perPage');
    debugPrint('==============================================');

    try {
      final controller = ref.read(getCampaignsControllerProvider);

      final result = await controller.getCampaigns(page: 1, perPage: _perPage);

      if (!mounted) return;

      debugPrint('');
      debugPrint('========== CAMPAIGNS API SUCCESS ==========');
      debugPrint('SUCCESS: ${result.success}');
      debugPrint('CAMPAIGNS COUNT: ${result.campaigns.length}');
      debugPrint('TOTAL: ${result.total}');
      debugPrint('HAS NEXT PAGE: ${result.hasNextPage}');
      debugPrint('HAS PREVIOUS PAGE: ${result.hasPreviousPage}');
      debugPrint('===========================================');
      debugPrint('');

      setState(() {
        _campaignsData = result;
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (error, stackTrace) {
      if (!mounted) return;

      debugPrint('');
      debugPrint('========== CAMPAIGNS API ERROR ==========');
      debugPrint('ERROR: $error');
      debugPrint('STACK TRACE: $stackTrace');
      debugPrint('=========================================');
      debugPrint('');

      setState(() {
        _isLoading = false;
        _errorMessage = _extractErrorMessage(error);
      });
    }
  }

  // ============================================================
  // Pull To Refresh
  // ============================================================

  Future<void> _handleRefresh() async {
    if (_isLoading) {
      return;
    }

    // ----------------------------------------------------------
    // Full shimmer show hoga.
    // ----------------------------------------------------------

    await _loadCampaigns(showShimmer: true);
  }

  // ============================================================
  // API - Next Page
  // ============================================================

  Future<void> _loadNextPage() async {
    final currentData = _campaignsData;

    if (currentData == null || !currentData.hasNextPage || _isLoadingNextPage) {
      return;
    }

    setState(() {
      _isLoadingNextPage = true;
    });

    debugPrint('');
    debugPrint('========== CAMPAIGNS NEXT PAGE ==========');
    debugPrint(
      'CURRENT PAGE: '
      '${currentData.pagination?.currentPage ?? 'N/A'}',
    );
    debugPrint('=========================================');

    try {
      final controller = ref.read(getCampaignsControllerProvider);

      final result = await controller.getNextPage(
        currentData: currentData,
        perPage: _perPage,
      );

      if (!mounted) return;

      setState(() {
        _campaignsData = result;
        _isLoadingNextPage = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isLoadingNextPage = false;
      });

      _showErrorMessage(_extractErrorMessage(error));
    }
  }

  // ============================================================
  // API - Previous Page
  // ============================================================

  Future<void> _loadPreviousPage() async {
    final currentData = _campaignsData;

    if (currentData == null ||
        !currentData.hasPreviousPage ||
        _isLoadingNextPage) {
      return;
    }

    setState(() {
      _isLoadingNextPage = true;
    });

    try {
      final controller = ref.read(getCampaignsControllerProvider);

      final result = await controller.getPreviousPage(
        currentData: currentData,
        perPage: _perPage,
      );

      if (!mounted) return;

      setState(() {
        _campaignsData = result;
        _isLoadingNextPage = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isLoadingNextPage = false;
      });

      _showErrorMessage(_extractErrorMessage(error));
    }
  }

  // ============================================================
  // Actions
  // ============================================================

  Future<void> _handlePickProducts() async {
    await context.push(AppRoutes.bottombar, extra: BottomTab.products);

    // ----------------------------------------------------------
    // User Products screen se back aya.
    // Campaigns API refresh + shimmer.
    // ----------------------------------------------------------

    if (!mounted) return;

    await _loadCampaigns(showShimmer: true);
  }

  // ============================================================
  // Request Campaign
  // ============================================================

  Future<void> _handleRequestCampaign() async {
    await context.push(AppRoutes.createCampaigns);

    // ----------------------------------------------------------
    // User Create Campaign screen se back aya.
    // Campaigns API refresh + shimmer.
    // ----------------------------------------------------------

    if (!mounted) return;

    await _loadCampaigns(showShimmer: true);
  }

  // ============================================================
  // Campaign Detail
  // ============================================================

  Future<void> _handleCampaignTap(CampaignModel campaign) async {
    final campaignId = campaign.id;

    // ============================================================
    // Validate Campaign ID
    // ============================================================

    if (campaignId == null || campaignId <= 0) {
      debugPrint('');
      debugPrint('========== CAMPAIGN DETAIL NAVIGATION ==========');
      debugPrint('ERROR: Campaign ID is missing.');
      debugPrint('CAMPAIGN NAME: ${campaign.name ?? 'N/A'}');
      debugPrint('CAMPAIGN ID: ${campaignId ?? 'N/A'}');
      debugPrint('=================================================');
      debugPrint('');

      _showComingSoonMessage(
        'Campaign details are unavailable because '
        'the campaign ID is missing.',
      );

      return;
    }

    // ============================================================
    // Debug
    // ============================================================

    debugPrint('');
    debugPrint('========== CAMPAIGN DETAIL NAVIGATION ==========');
    debugPrint('CAMPAIGN ID: $campaignId');
    debugPrint('CAMPAIGN NAME: ${campaign.name ?? 'N/A'}');
    debugPrint('STATUS: ${campaign.status ?? 'N/A'}');
    debugPrint('=================================================');
    debugPrint('');

    // ============================================================
    // Open Detail
    // ============================================================

    await context.push(AppRoutes.campaignDetail, extra: campaignId);

    // ============================================================
    // Detail se Back -> Refresh Campaigns
    // ============================================================

    if (!mounted) return;

    await _loadCampaigns(showShimmer: true);
  }

  // ============================================================
  // Error Message
  // ============================================================

  String _extractErrorMessage(Object error) {
    try {
      final dynamic value = error;

      final message = value.message;

      if (message is String && message.trim().isNotEmpty) {
        return message;
      }
    } catch (_) {}

    return 'Something went wrong. Please try again.';
  }

  // ============================================================
  // SnackBar - Error
  // ============================================================

  void _showErrorMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.white),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.errorDark,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }

  // ============================================================
  // SnackBar - Coming Soon
  // ============================================================

  void _showComingSoonMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.white),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.navy,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }
}

// ============================================================
// Filter Model
// ============================================================

class _CampaignFilter {
  const _CampaignFilter({required this.label, required this.status});

  final String label;
  final String? status;
}

// ============================================================
// Pagination Button
// ============================================================

class _PaginationButton extends StatelessWidget {
  const _PaginationButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: onTap == null ? AppColors.background : AppColors.primaryLight,
      borderRadius: BorderRadius.circular(9),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: SizedBox(
          width: 38,
          height: 38,
          child: Icon(
            icon,
            size: 21,
            color: onTap == null ? AppColors.iconSecondary : AppColors.primary,
          ),
        ),
      ),
    );
  }
}

// ============================================================
// Fixed Status Formatting
// ============================================================

String _formatStatus(String value) {
  switch (value.trim().toLowerCase()) {
    case 'pending':
      return 'Pending';

    case 'approved':
      return 'Approved';

    case 'active':
      return 'Active';

    case 'rejected':
      return 'Rejected';

    case 'expired':
      return 'Expired';

    case 'cancelled':
      return 'Cancelled';

    default:
      return value;
  }
}
