// lib/features/chat/presentation/widgets/custom_emoji_picker.dart
import 'package:flutter/material.dart';
import '../../../../Theme/app_colors.dart';

class CustomEmojiPicker extends StatelessWidget {
  final Function(String) onEmojiSelected;

  const CustomEmojiPicker({
    super.key,
    required this.onEmojiSelected,
  });

  // Common emojis for quick selection
  static const List<String> _commonEmojis = [
    '😊', '😂', '❤️', '🔥', '👍', '🙏', '😍', '🥰',
    '🤩', '😘', '💪', '✨', '🎉', '💯', '😅', '🤔',
    '😭', '🥺', '😎', '🤗', '🙌', '👏', '💕', '💫',
    '🌟', '⭐', '🌈', '☀️', '🦋', '🌸', '🌺', '🍀',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(
            color: AppColors.divider,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Category tabs (recent, smileys, etc.)
          _buildCategoryTabs(),
          const SizedBox(height: 8),
          // Emoji grid
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                childAspectRatio: 1.1,
              ),
              itemCount: _commonEmojis.length,
              itemBuilder: (context, index) {
                final emoji = _commonEmojis[index];
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => onEmojiSelected(emoji),
                    borderRadius: BorderRadius.circular(8),
                    child: Center(
                      child: Text(
                        emoji,
                        style: const TextStyle(fontSize: 26),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildCategoryTab(Icons.history_rounded, true),
        _buildCategoryTab(Icons.emoji_emotions_rounded, false),
        _buildCategoryTab(Icons.food_bank_rounded, false),
        _buildCategoryTab(Icons.directions_car_rounded, false),
        _buildCategoryTab(Icons.sports_rounded, false),
      ],
    );
  }

  Widget _buildCategoryTab(IconData icon, bool isSelected) {
    return IconButton(
      onPressed: () {
        // TODO: Implement category switching
      },
      icon: Icon(
        icon,
        size: 22,
        color: isSelected ? AppColors.primary : AppColors.textSecondary,
      ),
      splashRadius: 20,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 40),
    );
  }
}