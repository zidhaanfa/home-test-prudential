import 'package:flutter/material.dart';

class ProductInfoChips extends StatelessWidget {
  const ProductInfoChips({
    super.key,
    required this.rating,
    required this.stock,
    required this.category,
  });

  final double rating;
  final int stock;
  final String category;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        _buildChip(
          icon: Icons.star,
          iconColor: Colors.amber,
          label: '${rating.toStringAsFixed(1)} / 5',
        ),
        _buildChip(
          icon: Icons.inventory_2_outlined,
          iconColor: stock > 0 ? Colors.green : Colors.red,
          label: '$stock in stock',
        ),
        _buildChip(
          icon: Icons.category_outlined,
          iconColor: Colors.blue,
          label: category,
        ),
      ],
    );
  }

  Widget _buildChip({
    required IconData icon,
    required Color iconColor,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
