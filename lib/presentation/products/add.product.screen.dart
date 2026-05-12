import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../components/molecules/custom_layout.dart';
import '../../utils/config.dart';
import 'controllers/products.controller.dart';

class AddProductScreen extends GetView<ProductsController> {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomLayout(
      appBar: AppBar(title: const Text('Add Product'), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Form(
            key: controller.addProductFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Title ──
                _buildTextField(
                  controller: controller.titleController,
                  label: 'Title',
                  hint: 'e.g. iPhone 15 Pro',
                  icon: Icons.title,
                  validator: (v) => _requiredValidator(v, 'Title'),
                ),
                const SizedBox(height: 16),

                // ── Description ──
                _buildTextField(
                  controller: controller.descriptionController,
                  label: 'Description',
                  hint: 'Describe the product...',
                  icon: Icons.description_outlined,
                  maxLines: 3,
                  validator: (v) => _requiredValidator(v, 'Description'),
                ),
                const SizedBox(height: 16),

                // ── Category ──
                _buildTextField(
                  controller: controller.categoryController,
                  label: 'Category',
                  hint: 'e.g. smartphones',
                  icon: Icons.category_outlined,
                  validator: (v) => _requiredValidator(v, 'Category'),
                ),
                const SizedBox(height: 16),

                // ── Brand ──
                _buildTextField(
                  controller: controller.brandController,
                  label: 'Brand',
                  hint: 'e.g. Apple',
                  icon: Icons.business_outlined,
                  validator: (v) => _requiredValidator(v, 'Brand'),
                ),
                const SizedBox(height: 16),

                // ── SKU ──
                _buildTextField(
                  controller: controller.skuController,
                  label: 'SKU',
                  hint: 'e.g. SKU-001',
                  icon: Icons.qr_code,
                  validator: (v) => _requiredValidator(v, 'SKU'),
                ),
                const SizedBox(height: 16),

                // ── Price & Discount (row) ──
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: controller.priceController,
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
                      child: _buildTextField(
                        controller: controller.discountController,
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
                      child: _buildTextField(
                        controller: controller.stockController,
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
                      child: _buildTextField(
                        controller: controller.ratingController,
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
                        controller.productCreateStatus.value ==
                            ApiCallStatus.loading
                        ? null
                        : controller.submitAddProduct,
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
                        controller.productCreateStatus.value ==
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
                            'Create Product',
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

  // ═══════════════════════════════════════════════════════════
  //  HELPERS
  // ═══════════════════════════════════════════════════════════

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }

  String? _requiredValidator(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
}
