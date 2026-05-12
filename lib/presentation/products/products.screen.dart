import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../components/molecules/custom_layout.dart';
import '../../components/molecules/my_widget_animator.dart';
import 'controllers/products.controller.dart';
import 'widgets/product/product_card.dart';

class ProductsScreen extends GetView<ProductsController> {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductsController controller = Get.put(
      ProductsController(
        getProductsUseCase: Get.find(),
        getProductDetailUseCase: Get.find(),
        createProductUseCase: Get.find(),
        deleteProductUseCase: Get.find(),
        updateProductUseCase: Get.find(),
      ),
    );

    return CustomLayout(
      appBar: AppBar(
        title: const Text('ProductsScreen'),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextFormField(
              controller: controller.searchController,
              textInputAction: TextInputAction.search,
              onFieldSubmitted: (_) => controller.searchProducts(),
              decoration: InputDecoration(
                hintText: 'Search products',
                prefixIcon: const Icon(Icons.search),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 0,
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.5),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Theme.of(
                      context,
                    ).colorScheme.outline.withValues(alpha: 0.5),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: GetBuilder<ProductsController>(
        init: controller,
        id: 'products',
        key: const Key('products'),
        builder: (controller) {
          return MyWidgetsAnimator(
            status: controller.productsStatus.value,
            successWidget: () {
              return RefreshIndicator(
                onRefresh: controller.refreshProducts,
                child: ListView.builder(
                  controller: controller.scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  // +1 untuk loading indicator di bawah
                  itemCount:
                      controller.products.length +
                      (controller.hasMore.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Item terakhir = loading indicator
                    if (index >= controller.products.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final product = controller.products[index];
                    return ProductCard(product: product);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
