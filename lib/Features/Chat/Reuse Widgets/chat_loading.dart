// lib/core/widgets/custom_loading.dart
import 'package:flutter/material.dart';
import '../../../Theme/app_colors.dart';

class ChatLoading extends StatelessWidget {
  final double? size;
  final Color? color;

  const ChatLoading({super.key, this.size, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size ?? 40,
        height: size ?? 40,
        child: CircularProgressIndicator(
          strokeWidth: 3,
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? AppColors.primary,
          ),
        ),
      ),
    );
  }
}