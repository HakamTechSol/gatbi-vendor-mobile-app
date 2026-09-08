import 'package:flutter/material.dart';


class TicketSearchBar extends StatefulWidget {
  const TicketSearchBar({
    super.key,
    this.controller,
    this.onChanged,
    this.onClear,
  });

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  @override
  State<TicketSearchBar> createState() => _TicketSearchBarState();
}

class _TicketSearchBarState extends State<TicketSearchBar> {
  late final TextEditingController _controller;

  bool _isInternalController = false;

  @override
  void initState() {
    super.initState();

    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = TextEditingController();
      _isInternalController = true;
    }

    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);

    if (_isInternalController) {
      _controller.dispose();
    }

    super.dispose();
  }

  void _clearSearch() {
    _controller.clear();

    if (widget.onClear != null) {
      widget.onClear!();
    }

    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFF0F2F5),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Search Icon
          const Padding(
            padding: EdgeInsets.only(left: 16),
            child: Icon(
              Icons.search_rounded,
              size: 20,
              color: Color(0xFF172B4D),
            ),
          ),

          // Text Field
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: widget.onChanged,
              textInputAction: TextInputAction.search,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF172B4D),
              ),
              decoration: const InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF9AA5B1),
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 0,
                ),
                isDense: true,
              ),
            ),
          ),

          // Clear Icon
          if (_controller.text.isNotEmpty)
            IconButton(
              onPressed: _clearSearch,
              splashRadius: 20,
              padding: const EdgeInsets.only(right: 12),
              constraints: const BoxConstraints(
                minWidth: 40,
                minHeight: 40,
              ),
              icon: const Icon(
                Icons.close_rounded,
                size: 20,
                color: Color(0xFF172B4D),
              ),
            )
          else
            const SizedBox(width: 16),
        ],
      ),
    );
  }
}