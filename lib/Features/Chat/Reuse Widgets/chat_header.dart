// lib/features/chat/presentation/widgets/chat_header.dart
import 'package:flutter/material.dart';
import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class ChatHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final Color? titleColor;

  const ChatHeader({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.showBackButton = true,
    this.onBackPressed,
    this.backgroundColor,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? AppColors.surface,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      surfaceTintColor: Colors.transparent,
      leading: leading ?? (showBackButton ? _buildBackButton(context) : null),
      title: Text(
        title,
        style: AppTextStyles.headlineSmall.copyWith(
          color: titleColor ?? AppColors.textPrimary,
        ),
      ),
      actions: actions,
      iconTheme: const IconThemeData(color: AppColors.iconPrimary, size: 22),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return IconButton(
      onPressed: onBackPressed ?? () => Navigator.pop(context),
      icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      splashRadius: 20,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
