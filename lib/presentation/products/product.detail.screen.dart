import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/molecules/custom_layout.dart';
import '../../components/molecules/my_widget_animator.dart';
import '../../infrastructure/navigation/routes.dart';
import 'controllers/products.controller.dart';
import 'widgets/product_detail/product_details_section.dart';
import 'widgets/product_detail/product_header.dart';
import 'widgets/product_detail/product_image_carousel.dart';
import 'widgets/product_detail/product_info_chips.dart';
import 'widgets/product_detail/product_review_card.dart';

class ProductDetailScreen extends GetView<ProductsController> {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final ProductsController controller = Get.put(
      ProductsController(
        getProductsUseCase: Get.find(),
        getProductDetailUseCase: Get.find(),
        createProductUseCase: Get.find(),
        deleteProductUseCase: Get.find(),
        updateProductUseCase: Get.find(),
      ),
    );

    // Ambil product ID dari arguments dan fetch detail
    final productId = Get.arguments;
    if (productId != null) {
      controller.getProductDetail(productId.toString());
    }

    return CustomLayout(
      appBar: AppBar(
        title: const Text('Product Detail'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              final productDetail = controller.productDetail.value;
              if (productDetail != null) {
                Get.toNamed(Routes.updateProduct, arguments: productDetail);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              Get.dialog(
                AlertDialog(
                  title: const Text('Delete Product'),
                  content: const Text(
                    'Are you sure you want to delete this product?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        controller.deleteProduct(productId.toString());
                        Get.back();
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: GetBuilder<ProductsController>(
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
                      // ── Images ──
                      ProductImageCarousel(images: product.images),

                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ── Title, Brand, Price ──
                            ProductHeader(
                              title: product.title,
                              brand: product.brand,
                              price: product.price,
                              discountPercentage: product.discountPercentage,
                            ),
                            const SizedBox(height: 16),

                            // ── Rating, Stock, Category ──
                            ProductInfoChips(
                              rating: product.rating,
                              stock: product.stock,
                              category: product.category,
                            ),
                            const SizedBox(height: 20),

                            // ── Description, Details, Dimensions, Tags ──
                            ProductDetailsSection(product: product),

                            // ── Reviews ──
                            if (product.reviews != null &&
                                product.reviews!.isNotEmpty) ...[
                              const SizedBox(height: 20),
                              Text(
                                'Reviews (${product.reviews!.length})',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ...product.reviews!.map(
                                (review) => ProductReviewCard(review: review),
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
      ),
    );
  }
}
