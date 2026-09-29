import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

import '../Models/get_events_model.dart';
import 'event_status_badge.dart';

class EventCard extends StatelessWidget {
  const EventCard({super.key, required this.event, this.onTap, this.onJoin});

  final EventItemModel event;
  final VoidCallback? onTap;
  final VoidCallback? onJoin;

  @override
  Widget build(BuildContext context) {
    final canJoin = _canJoin;

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 14,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBanner(),

                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 15, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),

                      const SizedBox(height: 12),

                      _buildTitle(),

                      if (_hasDescription) ...[
                        const SizedBox(height: 6),
                        _buildDescription(),
                      ],

                      const SizedBox(height: 15),

                      _buildInfoRow(),

                      const SizedBox(height: 16),

                      _buildJoinButton(enabled: canJoin),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // Banner
  // ============================================================

  Widget _buildBanner() {
    final imageUrl = _bannerUrl;

    debugPrint('');
    debugPrint('========== EVENT BANNER ==========');
    debugPrint('EVENT: ${event.name}');
    debugPrint('MOBILE PATH: ${event.bannerMobileUrl}');
    debugPrint('DESKTOP PATH: ${event.bannerUrl}');
    debugPrint('FINAL IMAGE URL: $imageUrl');
    debugPrint('==================================');

    if (imageUrl == null) {
      return _buildBannerPlaceholder();
    }

    return SizedBox(
      width: double.infinity,
      height: 155,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              debugPrint('');
              debugPrint('========== BANNER IMAGE ERROR ==========');
              debugPrint('URL: $imageUrl');
              debugPrint('ERROR: $error');
              debugPrint('STACK: $stackTrace');
              debugPrint('========================================');

              return _buildBannerPlaceholder();
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                debugPrint('BANNER IMAGE LOADED: $imageUrl');
                return child;
              }

              return _buildBannerPlaceholder(showLoading: true);
            },
          ),

          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  AppColors.navyDark.withValues(alpha: 0.55),
                ],
              ),
            ),
          ),

          Positioned(
            left: 14,
            top: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.94),
                borderRadius: BorderRadius.circular(9),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.local_fire_department_rounded,
                    size: 14,
                    color: AppColors.warningDark,
                  ),
                  SizedBox(width: 5),
                  Text('Special Event', style: AppTextStyles.statusBadge),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerPlaceholder({bool showLoading = false}) {
    return Container(
      width: double.infinity,
      height: 155,
      decoration: const BoxDecoration(gradient: AppColors.heroGradient),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            right: -25,
            top: -25,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: -35,
            bottom: -40,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.07),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Icon(
            showLoading ? Icons.image_outlined : Icons.celebration_rounded,
            size: 42,
            color: AppColors.white.withValues(alpha: 0.90),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Header
  // ============================================================

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Vendor Event',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.captionMedium.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        EventStatusBadge(status: event.status),
      ],
    );
  }

  // ============================================================
  // Title
  // ============================================================

  Widget _buildTitle() {
    return Text(
      event.name ?? 'Untitled event',
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyles.titleLarge,
    );
  }

  // ============================================================
  // Description
  // ============================================================

  bool get _hasDescription {
    final description = event.description;

    return description != null && description.trim().isNotEmpty;
  }

  Widget _buildDescription() {
    return Text(
      event.description!,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyles.bodySmall,
    );
  }

  // ============================================================
  // Info Row
  // ============================================================

  Widget _buildInfoRow() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _InfoItem(icon: Icons.calendar_month_outlined, label: _dateRange),
        _InfoItem(
          icon: Icons.local_offer_outlined,
          label: 'Min ${_formatDiscount}% discount',
          highlight: true,
        ),
      ],
    );
  }

  // ============================================================
  // Join Button
  // ============================================================

  Widget _buildJoinButton({required bool enabled}) {
    final hasParticipation = event.myParticipation != null;

    if (hasParticipation) {
      return Container(
        width: double.infinity,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.successLight,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: AppColors.successBorder),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_rounded,
              size: 19,
              color: AppColors.successDark,
            ),
            SizedBox(width: 7),
            Text('Already Joined', style: AppTextStyles.buttonOutlined),
          ],
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 48,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: enabled ? AppColors.primaryGradient : null,
          color: enabled ? null : AppColors.disabled,
          borderRadius: BorderRadius.circular(11),
          boxShadow: enabled
              ? const [
                  BoxShadow(
                    color: AppColors.primaryShadow,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: enabled ? onJoin : null,
            borderRadius: BorderRadius.circular(11),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_business_rounded,
                  size: 19,
                  color: enabled ? AppColors.white : AppColors.disabledText,
                ),
                const SizedBox(width: 7),
                Text(
                  enabled ? 'Join Event' : 'Event Unavailable',
                  style: AppTextStyles.buttonMedium.copyWith(
                    color: enabled ? AppColors.white : AppColors.disabledText,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // Helpers
  // ============================================================

  bool get _canJoin {
    final status = event.status?.trim().toLowerCase();

    return status == 'open';
  }

  String? get _bannerUrl {
    final mobile = event.bannerMobileUrl?.trim();

    if (mobile != null && mobile.isNotEmpty) {
      return _buildFullImageUrl(mobile);
    }

    final desktop = event.bannerUrl?.trim();

    if (desktop != null && desktop.isNotEmpty) {
      return _buildFullImageUrl(desktop);
    }

    return null;
  }

  String _buildFullImageUrl(String path) {
    // Already complete URL
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }

    // Remove leading slash to avoid //
    final cleanPath = path.startsWith('/') ? path.substring(1) : path;

    return 'https://gatbi.ae/$cleanPath';
  }

  String get _formatDiscount {
    final discount = event.minDiscountPercentage;

    if (discount == null) {
      return '0%';
    }

    if (discount == discount.roundToDouble()) {
      return '${discount.toInt()}%';
    }

    return '$discount%';
  }

  String get _dateRange {
    final start = _formatDate(event.startDate);
    final end = _formatDate(event.endDate);

    if (start == null && end == null) {
      return 'Date not available';
    }

    if (start != null && end != null) {
      if (start == end) {
        return start;
      }

      return '$start - $end';
    }

    return start ?? end!;
  }

  String? _formatDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final parsed = DateTime.tryParse(value);

    if (parsed == null) {
      return value;
    }

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${months[parsed.month - 1]} '
        '${parsed.day}, '
        '${parsed.year}';
  }
}

// ============================================================
// Info Item
// ============================================================

class _InfoItem extends StatelessWidget {
  const _InfoItem({
    required this.icon,
    required this.label,
    this.highlight = false,
  });

  final IconData icon;
  final String label;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: highlight ? AppColors.primarySurface : AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(
          color: highlight ? AppColors.borderPrimary : AppColors.border,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 15,
            color: highlight ? AppColors.primary : AppColors.iconSecondary,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.captionMedium.copyWith(
              color: highlight ? AppColors.primary : AppColors.textSecondary,
              fontWeight: highlight ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
