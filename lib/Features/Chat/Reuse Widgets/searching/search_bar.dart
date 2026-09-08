// lib/features/chat/presentation/widgets/search_bar.dart

import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class ChatSearchBar extends StatefulWidget {
  final Function(String) onSearch;
  final VoidCallback onClose;
  final TextEditingController controller;

  const ChatSearchBar({
    super.key,
    required this.onSearch,
    required this.onClose,
    required this.controller,
  });

  @override
  State<ChatSearchBar> createState() => _ChatSearchBarState();
}

class _ChatSearchBarState extends State<ChatSearchBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  final FocusNode _focusNode = FocusNode();

  // ignore: unused_field
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();

    // ==========================================================
    // ANIMATION
    // ==========================================================

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
      reverseDuration: const Duration(milliseconds: 160),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _scaleAnimation = Tween<double>(begin: 0.97, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    // ==========================================================
    // FOCUS LISTENER
    // ==========================================================

    _focusNode.addListener(_onFocusChanged);

    _animationController.forward();

    // Automatically focus search field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _focusNode.requestFocus();
    });
  }

  // ============================================================
  // FOCUS CHANGE
  // ============================================================

  void _onFocusChanged() {
    if (!mounted) return;

    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  // ============================================================
  // CLOSE SEARCH
  // ============================================================

  void _closeSearch() {
    _focusNode.unfocus();

    _animationController.reverse().then((_) {
      if (!mounted) return;

      widget.onClose();
    });
  }

  // ============================================================
  // CLEAR SEARCH
  // ============================================================

  void _clearSearch() {
    widget.controller.clear();

    widget.onSearch('');

    _focusNode.requestFocus();
  }

  // ============================================================
  // SEARCH
  // ============================================================

  void _performSearch() {
    final query = widget.controller.text.trim();

    if (query.isEmpty) return;

    widget.onSearch(query);
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();

    _animationController.dispose();

    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        alignment: Alignment.center,
        child: _buildSearchBar(),
      ),
    );
  }

  // ============================================================
  // SEARCH BAR
  // ============================================================

  Widget _buildSearchBar() {
    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          // ======================================================
          // BACK BUTTON
          // ======================================================
          _BackButton(onTap: _closeSearch),

          // ======================================================
          // TEXT FIELD
          // ======================================================
          Expanded(child: _buildTextField()),

          // ======================================================
          // CLEAR / CLOSE BUTTON
          // ======================================================
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: widget.controller,
            builder: (context, value, child) {
              return _CloseButton(
                onTap: value.text.isNotEmpty ? _clearSearch : _closeSearch,
              );
            },
          ),

          const SizedBox(width: 6),
        ],
      ),
    );
  }

  // ============================================================
  // TEXT FIELD
  // ============================================================

  Widget _buildTextField() {
    return TextField(
      controller: widget.controller,
      focusNode: _focusNode,

      autofocus: false,

      maxLines: 1,

      textInputAction: TextInputAction.search,

      keyboardType: TextInputType.text,

      textCapitalization: TextCapitalization.sentences,

      onChanged: widget.onSearch,

      onSubmitted: (_) {
        _performSearch();
      },

      style: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textPrimary,
        fontSize: 17,
        fontWeight: FontWeight.w400,
      ),

      cursorColor: AppColors.primary,

      cursorWidth: 1.5,

      decoration: InputDecoration(
        hintText: 'Search',

        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textMuted,
          fontSize: 17,
          fontWeight: FontWeight.w400,
        ),

        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,

        isDense: true,

        contentPadding: const EdgeInsets.only(
          left: 4,
          right: 4,
          top: 10,
          bottom: 10,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// BACK BUTTON
// ═══════════════════════════════════════════════════════════════

class _BackButton extends StatelessWidget {
  final VoidCallback onTap;

  const _BackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        splashColor: AppColors.primary.withOpacity(0.08),
        highlightColor: AppColors.primary.withOpacity(0.04),
        child: const SizedBox(
          width: 48,
          height: 48,
          child: Center(
            child: Icon(
              Icons.arrow_back_rounded,
              size: 29,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// CLOSE / CLEAR BUTTON
// ═══════════════════════════════════════════════════════════════

class _CloseButton extends StatelessWidget {
  final VoidCallback onTap;

  const _CloseButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        splashColor: AppColors.primary.withOpacity(0.08),
        highlightColor: AppColors.primary.withOpacity(0.04),
        child: const SizedBox(
          width: 48,
          height: 48,
          child: Center(
            child: Icon(
              Icons.close_rounded,
              size: 30,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
