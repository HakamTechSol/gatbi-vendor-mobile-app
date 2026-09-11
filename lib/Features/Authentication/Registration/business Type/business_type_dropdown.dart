import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../business Type/business_type_controller.dart';

class BusinessTypeDropdown extends ConsumerStatefulWidget {
  const BusinessTypeDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    this.validator,
  });

  final String? value;
  final ValueChanged<String?> onChanged;
  final FormFieldValidator<String>? validator;

  @override
  ConsumerState<BusinessTypeDropdown> createState() =>
      _BusinessTypeDropdownState();
}

class _BusinessTypeDropdownState extends ConsumerState<BusinessTypeDropdown> {
  late final Future<dynamic> _future;

  @override
  void initState() {
    super.initState();

    _future = ref.read(businessTypeControllerProvider).getBusinessTypes();
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
          return _buildError('Failed to load business types');
        }

        final businessTypes = snapshot.data?.businessTypes ?? [];

        final List<DropdownMenuItem<String>> items = businessTypes
            .map<DropdownMenuItem<String>>(
              (type) => DropdownMenuItem<String>(
                value: type.value?.toString(),
                child: Text(
                  type.label?.toString() ?? '',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
            .toList();

        return DropdownButtonFormField<String>(
          value: widget.value,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: 'Business Type *',
            prefixIcon: const Icon(Icons.business_center_outlined),
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
