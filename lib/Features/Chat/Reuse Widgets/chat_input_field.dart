// lib/features/chat/presentation/widgets/chat_input_field.dart

import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import 'chat_emoji_picker.dart';

class ChatInputField extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSend;
  final bool isLoading;

  const ChatInputField({
    super.key,
    required this.controller,
    required this.onSend,
    this.isLoading = false,
  });

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  bool _hasText = false;
  bool _showEmojiPicker = false;

  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _hasText = widget.controller.text.trim().isNotEmpty;

    widget.controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();

    super.dispose();
  }

  // ============================================================
  // TEXT CHANGE
  // ============================================================

  void _onTextChanged() {
    final hasText = widget.controller.text.trim().isNotEmpty;

    if (hasText != _hasText && mounted) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  // ============================================================
  // FOCUS
  // ============================================================

  void _onFocusChanged() {
    if (_focusNode.hasFocus && _showEmojiPicker) {
      setState(() {
        _showEmojiPicker = false;
      });
    }
  }

  // ============================================================
  // EMOJI PICKER
  // ============================================================

  void _toggleEmojiPicker() {
    if (widget.isLoading) return;

    if (_showEmojiPicker) {
      setState(() {
        _showEmojiPicker = false;
      });

      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _focusNode.requestFocus();
        }
      });
    } else {
      _focusNode.unfocus();

      setState(() {
        _showEmojiPicker = true;
      });
    }
  }

  // ============================================================
  // EMOJI SELECTED
  // ============================================================

  void _onEmojiSelected(String emoji) {
    final text = widget.controller.text;

    final selection = widget.controller.selection;

    int start = selection.start;
    int end = selection.end;

    // Safety if cursor position is invalid
    if (start < 0 || end < 0) {
      start = text.length;
      end = text.length;
    }

    final newText = text.replaceRange(start, end, emoji);

    widget.controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: start + emoji.length),
    );
  }

  // ============================================================
  // SEND MESSAGE
  // ============================================================

  void _sendMessage() {
    if (widget.isLoading) return;

    final message = widget.controller.text.trim();

    if (message.isEmpty) return;

    widget.onSend(message);

    // Close emoji picker after sending
    if (_showEmojiPicker) {
      setState(() {
        _showEmojiPicker = false;
      });
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ========================================================
        // INPUT CONTAINER
        // ========================================================
        Container(
          padding: const EdgeInsets.fromLTRB(10, 7, 7, 7),
          decoration: BoxDecoration(
            color: AppColors.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Container(
              constraints: const BoxConstraints(minHeight: 50),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: AppColors.border, width: 1),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ==================================================
                  // EMOJI BUTTON
                  // ==================================================
                  GestureDetector(
                    onTap: widget.isLoading ? null : _toggleEmojiPicker,
                    behavior: HitTestBehavior.opaque,
                    child: SizedBox(
                      width: 48,
                      height: 48,
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 180),
                          child: Icon(
                            _showEmojiPicker
                                ? Icons.keyboard_rounded
                                : Icons.emoji_emotions_outlined,
                            key: ValueKey(_showEmojiPicker),
                            size: 25,
                            color: _showEmojiPicker
                                ? AppColors.primary
                                : const Color(0xFFF2B94B),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // ==================================================
                  // TEXT FIELD
                  // ==================================================
                  Expanded(
                    child: TextField(
                      controller: widget.controller,
                      focusNode: _focusNode,
                      enabled: !widget.isLoading,
                      minLines: 1,
                      maxLines: 4,
                      textInputAction: TextInputAction.send,
                      keyboardType: TextInputType.multiline,

                      onSubmitted: (_) {
                        _sendMessage();
                      },

                      decoration: InputDecoration(
                        hintText: 'Type your message here',
                        hintStyle: AppTextStyles.chatInput.copyWith(
                          color: AppColors.textMuted,
                          fontSize: 13,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 2,
                          vertical: 13,
                        ),
                      ),

                      style: AppTextStyles.chatInput.copyWith(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),

                  const SizedBox(width: 4),

                  // ==================================================
                  // SEND BUTTON
                  // ==================================================
                  GestureDetector(
                    onTap: _hasText && !widget.isLoading ? _sendMessage : null,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 42,
                      height: 42,
                      margin: const EdgeInsets.only(right: 2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _hasText
                            ? AppColors.primary
                            : AppColors.surfaceMuted,
                      ),
                      child: widget.isLoading
                          ? SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primary,
                              ),
                            )
                          : Icon(
                              Icons.send_rounded,
                              size: 20,
                              color: _hasText
                                  ? Colors.white
                                  : AppColors.textMuted,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // ========================================================
        // EMOJI PICKER
        // ========================================================
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          child: _showEmojiPicker
              ? SizedBox(
                  height: 240,
                  width: double.infinity,
                  child: CustomEmojiPicker(onEmojiSelected: _onEmojiSelected),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
