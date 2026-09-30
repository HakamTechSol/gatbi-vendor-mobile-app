import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';

class VendorProfileAvatar extends StatelessWidget {
  const VendorProfileAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.size = 92,
    this.borderRadius = 24,
  });

  final String? imageUrl;
  final String? name;
  final double size;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final normalizedUrl = imageUrl?.trim();

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.85),
          width: 3,
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowStrong,
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius - 3),
        child: _buildImage(normalizedUrl),
      ),
    );
  }

  Widget _buildImage(String? url) {
    if (url == null || url.isEmpty) {
      return _FallbackAvatar(name: name);
    }

    return Image.network(
      url,
      width: size,
      height: size,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return _FallbackAvatar(name: name);
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }

        return const _AvatarLoading();
      },
    );
  }
}

// ================================================================
// FALLBACK AVATAR
// ================================================================

class _FallbackAvatar extends StatelessWidget {
  const _FallbackAvatar({this.name});

  final String? name;

  @override
  Widget build(BuildContext context) {
    final initials = _getInitials(name);

    return Container(
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: AppTextStyles.titleLarge.copyWith(
          color: AppColors.white,
          fontSize: 28,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  String _getInitials(String? value) {
    final text = value?.trim() ?? '';

    if (text.isEmpty) {
      return 'V';
    }

    final words = text
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();

    if (words.length == 1) {
      final word = words.first;

      if (word.length >= 2) {
        return word.substring(0, 2).toUpperCase();
      }

      return word.toUpperCase();
    }

    return '${words.first[0]}${words.last[0]}'.toUpperCase();
  }
}

// ================================================================
// AVATAR LOADING
// ================================================================

class _AvatarLoading extends StatelessWidget {
  const _AvatarLoading();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.softGradient),
      alignment: Alignment.center,
      child: const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
