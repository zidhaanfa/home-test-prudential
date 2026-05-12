import 'package:flutter/material.dart';

import '../../../../domain/products/entities/products_entity.dart';

class ProductDetailsSection extends StatelessWidget {
  const ProductDetailsSection({super.key, required this.product});

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Description ──
        _buildSectionTitle('Description', theme),
        const SizedBox(height: 8),
        Text(
          product.description,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.grey[700],
            height: 1.5,
          ),
        ),
        const SizedBox(height: 20),

        // ── Details Table ──
        _buildSectionTitle('Details', theme),
        const SizedBox(height: 8),
        _buildDetailRow('SKU', product.sku),
        if (product.weight != null)
          _buildDetailRow('Weight', '${product.weight}g'),
        if (product.warrantyInformation != null)
          _buildDetailRow('Warranty', product.warrantyInformation!),
        if (product.shippingInformation != null)
          _buildDetailRow('Shipping', product.shippingInformation!),
        if (product.returnPolicy != null)
          _buildDetailRow('Return Policy', product.returnPolicy!),
        if (product.minimumOrderQuantity != null)
          _buildDetailRow('Min. Order', '${product.minimumOrderQuantity}'),
        if (product.availabilityStatus != null)
          _buildDetailRow('Availability', product.availabilityStatus!),

        // ── Dimensions ──
        if (product.dimensions != null) ...[
          const SizedBox(height: 20),
          _buildSectionTitle('Dimensions', theme),
          const SizedBox(height: 8),
          _buildDetailRow('Width', '${product.dimensions!.width} cm'),
          _buildDetailRow('Height', '${product.dimensions!.height} cm'),
          _buildDetailRow('Depth', '${product.dimensions!.depth} cm'),
        ],

        // ── Tags ──
        if (product.tags != null && product.tags!.isNotEmpty) ...[
          const SizedBox(height: 20),
          _buildSectionTitle('Tags', theme),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: product.tags!
                .map(
                  (tag) => Chip(
                    label: Text(tag, style: const TextStyle(fontSize: 12)),
                    backgroundColor: Colors.grey[100],
                    padding: EdgeInsets.zero,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }
}
