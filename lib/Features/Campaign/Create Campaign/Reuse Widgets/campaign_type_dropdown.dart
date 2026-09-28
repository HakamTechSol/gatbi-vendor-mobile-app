import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../../Campaign Types/Controller/campaign_type_controller.dart';
import '../../Campaign Types/Models/campaign_type_model.dart';

class CampaignTypeDropdown extends ConsumerStatefulWidget {
  const CampaignTypeDropdown({
    super.key,
    required this.selectedId,
    required this.onChanged,
    this.errorText,
  });

  final String? selectedId;
  final ValueChanged<CampaignTypeData?> onChanged;
  final String? errorText;

  @override
  ConsumerState<CampaignTypeDropdown> createState() =>
      _CampaignTypeDropdownState();
}

class _CampaignTypeDropdownState extends ConsumerState<CampaignTypeDropdown> {
  List<CampaignTypeData> _types = const [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final controller = ref.read(campaignTypeControllerProvider);
      final result = await controller.getCampaignTypes();

      if (!mounted) return;

      setState(() {
        _types = result.campaignTypes
            .where((e) => e.isActive && e.id != null)
            .toList();
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Campaign Type', style: AppTextStyles.formLabel),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.inputBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hasError ? AppColors.error : AppColors.border,
              width: hasError ? 1.4 : 1,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: _buildContent(),
        ),
        if (hasError) ...[
          const SizedBox(height: 6),
          Text(widget.errorText!, style: AppTextStyles.formError),
        ],
      ],
    );
  }

  Widget _buildContent() {
    if (_loading) {
      return const SizedBox(
        height: 52,
        child: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    if (_error != null) {
      return SizedBox(
        height: 52,
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Failed to load campaign types',
                style: AppTextStyles.formError,
              ),
            ),
            TextButton(onPressed: _load, child: const Text('Retry')),
          ],
        ),
      );
    }

    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: widget.selectedId,
        isExpanded: true,
        hint: Text('Select campaign type', style: AppTextStyles.authHint),
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: AppColors.iconSecondary,
        ),
        dropdownColor: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        style: AppTextStyles.authInput,
        items: _types.map((type) {
          return DropdownMenuItem<String>(
            value: type.id,
            child: Text(
              type.name ?? 'Unnamed',
              style: AppTextStyles.authInput,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        onChanged: (value) {
          if (value == null) {
            widget.onChanged(null);
            return;
          }
          final selected = _types.firstWhere((e) => e.id == value);
          widget.onChanged(selected);
        },
      ),
    );
  }
}
