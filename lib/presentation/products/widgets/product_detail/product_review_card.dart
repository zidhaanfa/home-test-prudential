import 'package:flutter/material.dart';

import '../../../../domain/products/entities/products_entity.dart';

class ProductReviewCard extends StatelessWidget {
  const ProductReviewCard({super.key, required this.review});

  final ProductReviewEntity review;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      color: Colors.grey[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  review.reviewerName,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Row(
                  children: List.generate(
                    5,
                    (i) => Icon(
                      i < review.rating ? Icons.star : Icons.star_border,
                      size: 16,
                      color: Colors.amber,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              review.comment,
              style: TextStyle(color: Colors.grey[700], height: 1.4),
            ),
            if (review.date != null) ...[
              const SizedBox(height: 4),
              Text(
                _formatDate(review.date!),
                style: TextStyle(color: Colors.grey[400], fontSize: 11),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
