import 'package:flutter/material.dart';

import '../../../Theme/app_colors.dart';
import '../../../Theme/app_text_styles.dart';
import '../Models/my_product_model.dart';

class StockEditDialog extends StatefulWidget {
  const StockEditDialog({
    super.key,
    required this.product,
  });

  final MyProductModel product;

  @override
  State<StockEditDialog> createState() => _StockEditDialogState();
}

class _StockEditDialogState extends State<StockEditDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(
      text: widget.product.stockQuantity.toString(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateStock() {
    final value = int.tryParse(
      _controller.text.trim(),
    );

    if (value == null || value < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter a valid stock quantity.',
          ),
        ),
      );

      return;
    }

    Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(
        'Update Stock',
        style: AppTextStyles.titleLarge.copyWith(
          color: AppColors.navy,
          fontWeight: FontWeight.w800,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.product.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 18),

          TextField(
            controller: _controller,
            autofocus: true,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _updateStock(),
            decoration: InputDecoration(
              labelText: 'Stock Quantity',
              hintText: 'Enter quantity',
              prefixIcon: const Icon(
                Icons.inventory_2_outlined,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancel',
            style: AppTextStyles.buttonText.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        FilledButton(
          onPressed: _updateStock,
          child: const Text('Update'),
        ),
      ],
    );
  }
}
