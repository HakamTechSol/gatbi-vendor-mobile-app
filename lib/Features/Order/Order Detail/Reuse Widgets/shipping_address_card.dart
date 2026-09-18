import 'package:flutter/material.dart';

import '../../../../Theme/app_colors.dart';
import '../../../../Theme/app_text_styles.dart';
import '../Models/order_shipping_address_model.dart';

class ShippingAddressCard extends StatelessWidget {
  const ShippingAddressCard({
    super.key,
    required this.address,
    this.title = 'Shipping Address',
  });

  final VendorOrderShippingAddressModel? address;
  final String title;

  @override
  Widget build(BuildContext context) {
    final currentAddress = address;

    if (currentAddress == null) {
      return _EmptyAddressCard(title: title);
    }

    final fullName = _clean(currentAddress.fullName);
    final phone = _clean(currentAddress.phone);

    final addressLines = _buildPrimaryAddress(currentAddress);
    final locationParts = _buildLocationParts(currentAddress);

    final hasName = fullName != null;
    final hasPhone = phone != null;
    final hasAddress = addressLines.isNotEmpty;
    final hasLocation = locationParts.isNotEmpty;

    final hasContent = hasName || hasPhone || hasAddress || hasLocation;

    if (!hasContent) {
      return _EmptyAddressCard(title: title);
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowStrong.withValues(alpha: 0.035),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),

            // Customer information
            if (hasName || hasPhone)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _IconContainer(
                    icon: Icons.person_outline_rounded,
                    backgroundColor: AppColors.primaryLight,
                    iconColor: AppColors.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (hasName)
                          Text(
                            fullName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        if (hasPhone) ...[
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Icon(
                                Icons.phone_outlined,
                                size: 14,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(width: 5),
                              Flexible(
                                child: Text(
                                  phone,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),

            if ((hasName || hasPhone) && hasAddress) const SizedBox(height: 14),

            // Address block
            if (hasAddress)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(color: AppColors.primaryLight),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.home_work_outlined,
                      size: 19,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        addressLines.join('\n'),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textPrimary,
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            if (hasAddress && hasLocation) const SizedBox(height: 12),

            // Location metadata
            if (hasLocation)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: locationParts
                    .map(
                      (part) => _LocationChip(icon: part.icon, text: part.text),
                    )
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.18),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.location_on_outlined,
            size: 21,
            color: AppColors.white,
          ),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.navy,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Delivery address',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.success.withValues(alpha: 0.18),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                'Address',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<String> _buildPrimaryAddress(
    VendorOrderShippingAddressModel currentAddress,
  ) {
    final lines = <String>[];

    _add(lines, currentAddress.addressLine1);
    _add(lines, currentAddress.addressLine2);

    return lines;
  }

  List<_LocationPart> _buildLocationParts(
    VendorOrderShippingAddressModel currentAddress,
  ) {
    final parts = <_LocationPart>[];

    final city = _clean(currentAddress.city);
    final state = _clean(currentAddress.state);
    final postalCode = _clean(currentAddress.postalCode);
    final country = _clean(currentAddress.country);

    if (city != null) {
      parts.add(_LocationPart(icon: Icons.location_city_outlined, text: city));
    }

    if (state != null) {
      parts.add(_LocationPart(icon: Icons.map_outlined, text: state));
    }

    if (postalCode != null) {
      parts.add(
        _LocationPart(
          icon: Icons.markunread_mailbox_outlined,
          text: postalCode,
        ),
      );
    }

    if (country != null) {
      parts.add(_LocationPart(icon: Icons.public_outlined, text: country));
    }

    return parts;
  }

  String? _clean(String? value) {
    if (value == null) {
      return null;
    }

    final text = value.trim();

    if (text.isEmpty) {
      return null;
    }

    return text;
  }

  void _add(List<String> lines, String? value) {
    final text = _clean(value);

    if (text == null) {
      return;
    }

    if (!lines.contains(text)) {
      lines.add(text);
    }
  }
}

class _IconContainer extends StatelessWidget {
  const _IconContainer({
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
  });

  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(11),
      ),
      child: Icon(icon, size: 20, color: iconColor),
    );
  }
}

class _LocationChip extends StatelessWidget {
  const _LocationChip({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 180),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.iconSecondary),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyAddressCard extends StatelessWidget {
  const _EmptyAddressCard({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowStrong.withValues(alpha: 0.035),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.location_off_outlined,
              color: AppColors.primary,
              size: 21,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.navy,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'No shipping address available',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationPart {
  const _LocationPart({required this.icon, required this.text});

  final IconData icon;
  final String text;
}
