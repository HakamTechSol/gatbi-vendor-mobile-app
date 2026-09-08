import 'package:flutter/material.dart';

import '../../../Theme/app_colors.dart';
import '../../../Theme/app_text_styles.dart';

/// Main navigation tabs used inside the vendor/ application.
enum BottomTab {
  dashboard,
  products,
  chat,
  more,
}

class BottomBarScreen extends StatelessWidget {
  const BottomBarScreen({
    super.key,
    required this.currentTab,
    required this.onTabChanged,
  });

  final BottomTab currentTab;
  final ValueChanged<BottomTab> onTabChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowStrong.withValues(alpha: 0.10),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
          child: Row(
            children: [
              Expanded(
                child: _buildItem(
                  context,
                  tab: BottomTab.dashboard,
                  icon: Icons.dashboard_outlined,
                  activeIcon: Icons.dashboard_rounded,
                  label: 'Dashboard',
                ),
              ),

              Expanded(
                child: _buildItem(
                  context,
                  tab: BottomTab.products,
                  icon: Icons.inventory_2_outlined,
                  activeIcon: Icons.inventory_2_rounded,
                  label: 'Products',
                ),
              ),

              Expanded(
                child: _buildItem(
                  context,
                  tab: BottomTab.chat,
                  icon: Icons.chat_bubble_outline_rounded,
                  activeIcon: Icons.chat_bubble_rounded,
                  label: 'Chat',
                ),
              ),

              Expanded(
                child: _buildItem(
                  context,
                  tab: BottomTab.more,
                  icon: Icons.menu_rounded,
                  activeIcon: Icons.menu_rounded,
                  label: 'More',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(
    BuildContext context, {
    required BottomTab tab,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final bool isSelected = currentTab == tab;

    return InkWell(
      onTap: () => onTabChanged(tab),
      borderRadius: BorderRadius.circular(16),
      splashColor: AppColors.primaryLight.withValues(alpha: 0.35),
      highlightColor: Colors.transparent,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        padding: const EdgeInsets.symmetric(
          horizontal: 6,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryLight.withValues(alpha: 0.70)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              width: isSelected ? 38 : 30,
              height: isSelected ? 30 : 28,
              decoration: BoxDecoration(
                gradient: isSelected
                    ? AppColors.primaryGradient
                    : null,
                borderRadius: BorderRadius.circular(
                  isSelected ? 10 : 9,
                ),
              ),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: child,
                    );
                  },
                  child: Icon(
                    isSelected ? activeIcon : icon,
                    key: ValueKey(isSelected),
                    size: isSelected ? 17 : 19,
                    color: isSelected
                        ? AppColors.white
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 3),

            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 180),
              style: AppTextStyles.caption.copyWith(
                fontSize: 9.5,
                fontWeight:
                    isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected
                    ? AppColors.primary
                    : AppColors.textSecondary,
              ),
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}