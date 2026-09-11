import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../Category/category_controller.dart';

class CategoryDropdown extends ConsumerStatefulWidget {
  const CategoryDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    this.validator,
  });

  final int? value;
  final ValueChanged<int?> onChanged;
  final FormFieldValidator<int>? validator;

  @override
  ConsumerState<CategoryDropdown> createState() => _CategoryDropdownState();
}

class _CategoryDropdownState extends ConsumerState<CategoryDropdown> {
  late final Future<dynamic> _future;

  @override
  void initState() {
    super.initState();

    _future = ref.read(categoryControllerProvider).getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoading();
        }

        if (snapshot.hasError) {
          return _buildError('Failed to load categories');
        }

        final categories = snapshot.data?.categories ?? [];

        final List<DropdownMenuItem<int>> items = categories
            .map<DropdownMenuItem<int>>(
              (category) => DropdownMenuItem<int>(
                value: category.id as int?,
                child: Text(
                  category.name?.toString() ?? '',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
            .toList();

        return DropdownButtonFormField<int>(
          value: widget.value,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: 'Primary Category *',
            prefixIcon: const Icon(Icons.category_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          items: items,
          onChanged: widget.onChanged,
          validator: widget.validator,
        );
      },
    );
  }

  Widget _buildLoading() {
    return Container(
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.draftLight),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }

  Widget _buildError(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: AppColors.error,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.error,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
