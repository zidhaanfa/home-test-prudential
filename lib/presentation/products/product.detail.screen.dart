import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/molecules/custom_layout.dart';
import '../../components/molecules/my_widget_animator.dart';
import '../../utils/helper/rupiah.dart';
import 'controllers/products.controller.dart';

class ProductDetailScreen extends GetView<ProductsController> {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Ambil product ID dari arguments dan fetch detail
    final productId = Get.arguments;
    if (productId != null) {
      controller.getProductDetail(productId.toString());
    }

    return CustomLayout(
      appBar: AppBar(
        title: const Text('Product Detail'),
        centerTitle: true,
      ),
      body: GetBuilder<ProductsController>(
        id: 'productDetail',
        builder: (controller) {
          return MyWidgetsAnimator(
            status: controller.productDetailStatus.value,
            successWidget: () {
              final product = controller.productDetail.value;
              if (product == null) return const SizedBox();

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Product Images ──
                    if (product.images != null && product.images!.isNotEmpty)
                      SizedBox(
                        height: 280,
                        width: double.infinity,
                        child: PageView.builder(
                          itemCount: product.images!.length,
                          itemBuilder: (context, index) {
                            return Image.network(
                              product.images![index],
                              fit: BoxFit.contain,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(
                                    Icons.broken_image_outlined,
                                    size: 64,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      )
                    else
                      Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 64,
                          color: Colors.grey,
                        ),
                      ),

                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Title & Brand ──
                          Text(
                            product.title,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            product.brand,
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
                                MoneyHelper()
                                    .formatCurrencyToUSD(product.price),
                                style:
                                    theme.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.primaryColor,
                                ),
                              ),
                              if (product.discountPercentage > 0) ...[
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
                                    '-${product.discountPercentage.toStringAsFixed(1)}%',
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
                          const SizedBox(height: 16),

                          // ── Rating & Stock ──
                          Row(
                            children: [
                              _buildInfoChip(
                                icon: Icons.star,
                                iconColor: Colors.amber,
                                label:
                                    '${product.rating.toStringAsFixed(1)} / 5',
                              ),
                              const SizedBox(width: 12),
                              _buildInfoChip(
                                icon: Icons.inventory_2_outlined,
                                iconColor: product.stock > 0
                                    ? Colors.green
                                    : Colors.red,
                                label: '${product.stock} in stock',
                              ),
                              const SizedBox(width: 12),
                              _buildInfoChip(
                                icon: Icons.category_outlined,
                                iconColor: Colors.blue,
                                label: product.category,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // ── Description ──
                          Text(
                            'Description',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
                            _buildDetailRow(
                                'Weight', '${product.weight}g'),
                          if (product.warrantyInformation != null)
                            _buildDetailRow(
                              'Warranty',
                              product.warrantyInformation!,
                            ),
                          if (product.shippingInformation != null)
                            _buildDetailRow(
                              'Shipping',
                              product.shippingInformation!,
                            ),
                          if (product.returnPolicy != null)
                            _buildDetailRow(
                              'Return Policy',
                              product.returnPolicy!,
                            ),
                          if (product.minimumOrderQuantity != null)
                            _buildDetailRow(
                              'Min. Order',
                              '${product.minimumOrderQuantity}',
                            ),
                          if (product.availabilityStatus != null)
                            _buildDetailRow(
                              'Availability',
                              product.availabilityStatus!,
                            ),

                          // ── Dimensions ──
                          if (product.dimensions != null) ...[
                            const SizedBox(height: 20),
                            _buildSectionTitle('Dimensions', theme),
                            const SizedBox(height: 8),
                            _buildDetailRow(
                              'Width',
                              '${product.dimensions!.width} cm',
                            ),
                            _buildDetailRow(
                              'Height',
                              '${product.dimensions!.height} cm',
                            ),
                            _buildDetailRow(
                              'Depth',
                              '${product.dimensions!.depth} cm',
                            ),
                          ],

                          // ── Tags ──
                          if (product.tags != null &&
                              product.tags!.isNotEmpty) ...[
                            const SizedBox(height: 20),
                            _buildSectionTitle('Tags', theme),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: product.tags!
                                  .map(
                                    (tag) => Chip(
                                      label: Text(
                                        tag,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      backgroundColor: Colors.grey[100],
                                      padding: EdgeInsets.zero,
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],

                          // ── Reviews ──
                          if (product.reviews != null &&
                              product.reviews!.isNotEmpty) ...[
                            const SizedBox(height: 20),
                            _buildSectionTitle(
                              'Reviews (${product.reviews!.length})',
                              theme,
                            ),
                            const SizedBox(height: 8),
                            ...product.reviews!.map(
                              (review) => _buildReviewCard(review, theme),
                            ),
                          ],

                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  HELPER WIDGETS
  // ═══════════════════════════════════════════════════════════

  Widget _buildInfoChip({
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

  Widget _buildReviewCard(dynamic review, ThemeData theme) {
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
