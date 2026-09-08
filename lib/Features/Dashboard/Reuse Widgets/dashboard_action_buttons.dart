import 'package:flutter/material.dart';

import '../../../Core/Custom Widgets/custom_button.dart';

class DashboardActionButtons extends StatelessWidget {
  const DashboardActionButtons({
    super.key,
    this.onAddProduct,
    this.onViewOrders,
    this.onShopSettings,
    this.isStoreApproved = true,
  });

  final VoidCallback? onAddProduct;
  final VoidCallback? onViewOrders;
  final VoidCallback? onShopSettings;

  /// Store pending ho to Add Product disabled rahega.
  final bool isStoreApproved;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        // ═══════════════════════════════════════════════════════════════════
        // VERY SMALL MOBILE
        // ═══════════════════════════════════════════════════════════════════

        if (width < 360) {
          return Column(
            children: [
              _buildAddProductButton(),

              const SizedBox(height: 10),

              _buildViewOrdersButton(),

              const SizedBox(height: 10),

              _buildShopSettingsButton(),
            ],
          );
        }

        // ═══════════════════════════════════════════════════════════════════
        // NORMAL MOBILE
        // ═══════════════════════════════════════════════════════════════════

        if (width < 600) {
          return Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              SizedBox(
                width: (width - 10) / 2,
                child: _buildAddProductButton(),
              ),

              SizedBox(
                width: (width - 10) / 2,
                child: _buildViewOrdersButton(),
              ),

              SizedBox(width: width, child: _buildShopSettingsButton()),
            ],
          );
        }

        // ═══════════════════════════════════════════════════════════════════
        // TABLET / WEB
        // ═══════════════════════════════════════════════════════════════════

        return Row(
          children: [
            Expanded(child: _buildAddProductButton()),

            const SizedBox(width: 10),

            Expanded(child: _buildViewOrdersButton()),

            const SizedBox(width: 10),

            Expanded(child: _buildShopSettingsButton()),
          ],
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ADD PRODUCT
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildAddProductButton() {
    return CustomButton(
      text: 'Add Product',
      icon: Icons.add_box_outlined,

      /// Pending store ke case mein button disabled.
      onPressed: isStoreApproved ? onAddProduct : null,

      type: CustomButtonType.outlined,
      height: 44,
      borderRadius: 11,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // VIEW ORDERS
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildViewOrdersButton() {
    return CustomButton(
      text: 'View Orders',
      icon: Icons.receipt_long_outlined,
      onPressed: onViewOrders,
      type: CustomButtonType.outlined,
      height: 44,
      borderRadius: 11,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SHOP SETTINGS
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildShopSettingsButton() {
    return CustomButton(
      text: 'Shop Settings',
      icon: Icons.settings_outlined,
      onPressed: onShopSettings,
      type: CustomButtonType.outlined,
      height: 44,
      borderRadius: 11,
    );
  }
}
