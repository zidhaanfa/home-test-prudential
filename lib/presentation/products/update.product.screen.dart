import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../../components/molecules/custom_layout.dart';
import '../../utils/config.dart';
import 'controllers/products.controller.dart';

class UpdateProductScreen extends GetView<ProductsController> {
  const UpdateProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Ambil product dari arguments dan fetch detail
    final product = Get.arguments;
    if (product != null) {
      controller.loadProductForUpdate(product);
    }

    return CustomLayout(
      appBar: AppBar(title: const Text('Add Product'), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Form(
            key: controller.updateProductFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Title ──
                controller.buildTextField(
                  controller: controller.updateTitleController,
                  label: 'Title',
                  hint: 'e.g. iPhone 15 Pro',
                  icon: Icons.title,
                  validator: (v) => controller.requiredValidator(v, 'Title'),
                ),
                const SizedBox(height: 16),

                // ── Description ──
                controller.buildTextField(
                  controller: controller.updateDescriptionController,
                  label: 'Description',
                  hint: 'Describe the product...',
                  icon: Icons.description_outlined,
                  maxLines: 3,
                  validator: (v) =>
                      controller.requiredValidator(v, 'Description'),
                ),
                const SizedBox(height: 16),

                // ── Category ──
                controller.buildTextField(
                  controller: controller.updateCategoryController,
                  label: 'Category',
                  hint: 'e.g. smartphones',
                  icon: Icons.category_outlined,
                  validator: (v) => controller.requiredValidator(v, 'Category'),
                ),
                const SizedBox(height: 16),

                // ── Brand ──
                controller.buildTextField(
                  controller: controller.updateBrandController,
                  label: 'Brand',
                  hint: 'e.g. Apple',
                  icon: Icons.business_outlined,
                  validator: (v) => controller.requiredValidator(v, 'Brand'),
                ),
                const SizedBox(height: 16),

                // ── SKU ──
                controller.buildTextField(
                  controller: controller.updateSkuController,
                  label: 'SKU',
                  hint: 'e.g. SKU-001',
                  icon: Icons.qr_code,
                  validator: (v) => controller.requiredValidator(v, 'SKU'),
                ),
                const SizedBox(height: 16),

                // ── Price & Discount (row) ──
                Row(
                  children: [
                    Expanded(
                      child: controller.buildTextField(
                        controller: controller.updatePriceController,
                        label: 'Price',
                        hint: '0.00',
                        icon: Icons.attach_money,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d*'),
                          ),
                        ],
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Required';
                          }
                          if (double.tryParse(v) == null) {
                            return 'Invalid number';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: controller.buildTextField(
                        controller: controller.updateDiscountController,
                        label: 'Discount %',
                        hint: '0.0',
                        icon: Icons.percent,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d*'),
                          ),
                        ],
                        validator: (v) {
                          if (v != null && v.isNotEmpty) {
                            final val = double.tryParse(v);
                            if (val == null || val < 0 || val > 100) {
                              return '0-100';
                            }
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ── Stock & Rating (row) ──
                Row(
                  children: [
                    Expanded(
                      child: controller.buildTextField(
                        controller: controller.updateStockController,
                        label: 'Stock',
                        hint: '0',
                        icon: Icons.inventory_2_outlined,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Required';
                          }
                          if (int.tryParse(v) == null) {
                            return 'Invalid';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: controller.buildTextField(
                        controller: controller.updateRatingController,
                        label: 'Rating',
                        hint: '0.0',
                        icon: Icons.star_outline,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d*'),
                          ),
                        ],
                        validator: (v) {
                          if (v != null && v.isNotEmpty) {
                            final val = double.tryParse(v);
                            if (val == null || val < 0 || val > 5) {
                              return '0-5';
                            }
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // ── Submit Button ──
                Obx(
                  () => ElevatedButton(
                    onPressed:
                        controller.productUpdateStatus.value ==
                            ApiCallStatus.loading
                        ? null
                        : controller.updateProduct,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: theme.primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                    ),
                    child:
                        controller.productUpdateStatus.value ==
                            ApiCallStatus.loading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Update Product',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
