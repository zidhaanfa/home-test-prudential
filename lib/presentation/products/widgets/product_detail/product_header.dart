import 'package:flutter/material.dart';

import '../../../../utils/helper/rupiah.dart';

class ProductHeader extends StatelessWidget {
  const ProductHeader({
    super.key,
    required this.title,
    required this.brand,
    required this.price,
    required this.discountPercentage,
  });

  final String title;
  final String brand;
  final double price;
  final double discountPercentage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Title ──
        Text(
          title,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),

        // ── Brand ──
        Text(
          brand,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 12),

        // ── Price & Discount ──
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              MoneyHelper().formatCurrencyToUSD(price),
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            if (discountPercentage > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '-${discountPercentage.toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: Colors.red[700],
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
