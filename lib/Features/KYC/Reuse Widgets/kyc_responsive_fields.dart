import 'package:flutter/material.dart';

class KycResponsiveFields extends StatelessWidget {
  const KycResponsiveFields({
    super.key,
    required this.first,
    required this.second,
    this.breakpoint = 600,
    this.spacing = 14,
    this.verticalSpacing = 18,
  });

  final Widget first;
  final Widget second;

  final double breakpoint;
  final double spacing;
  final double verticalSpacing;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < breakpoint) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              first,
              SizedBox(height: verticalSpacing),
              second,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: first),
            SizedBox(width: spacing),
            Expanded(child: second),
          ],
        );
      },
    );
  }
}
