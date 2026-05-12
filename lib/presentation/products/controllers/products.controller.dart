import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:home_test_prudential/domain/products/entities/products_entity.dart';
import 'package:home_test_prudential/domain/products/usecases/get_products_usecase.dart';
import 'package:home_test_prudential/infrastructure/dal/models/pagination_filter.dart';
import 'package:home_test_prudential/presentation/navigation/controllers/navigation.controller.dart';

import '../../../config/lifecycle/app_lifecycle_service.dart';
import '../../../domain/products/models/products_model.dart';
import '../../../domain/products/usecases/create_product_usecase.dart';
import '../../../domain/products/usecases/delete_product_usecase.dart';
import '../../../domain/products/usecases/get_productDetail_usecase.dart';
import '../../../domain/products/usecases/update_product_usecase.dart';
import '../../../utils/config.dart';
import '../../../utils/helper/snackbar.dart';

class ProductsController extends GetxController {
  final GetProductsUseCase _getProductsUseCase;
  final GetProductDetailUseCase _getProductDetailUseCase;
  final CreateProductUseCase _createProductUseCase;
  final DeleteProductUseCase _deleteProductUseCase;
  final UpdateProductUseCase _updateProductUseCase;

  ProductsController({
    required GetProductsUseCase getProductsUseCase,
    required GetProductDetailUseCase getProductDetailUseCase,
    required CreateProductUseCase createProductUseCase,
    required DeleteProductUseCase deleteProductUseCase,
    required UpdateProductUseCase updateProductUseCase,
  }) : _getProductsUseCase = getProductsUseCase,
       _getProductDetailUseCase = getProductDetailUseCase,
       _createProductUseCase = createProductUseCase,
       _deleteProductUseCase = deleteProductUseCase,
       _updateProductUseCase = updateProductUseCase;

  // ═══════════════════════════════════════════════════════════
  //  STATUS — setiap fetch punya ApiCallStatus sendiri
  // ═══════════════════════════════════════════════════════════

  /// Status fetch list products.
  final Rx<ApiCallStatus> productsStatus = ApiCallStatus.holding.obs;
  final Rx<ApiCallStatus> productDetailStatus = ApiCallStatus.holding.obs;
  final Rx<ApiCallStatus> productCreateStatus = ApiCallStatus.holding.obs;
  final Rx<ApiCallStatus> productDeleteStatus = ApiCallStatus.holding.obs;
  final Rx<ApiCallStatus> productUpdateStatus = ApiCallStatus.holding.obs;

  // ═══════════════════════════════════════════════════════════
  //  DATA
  // ═══════════════════════════════════════════════════════════

  /// List products.
  final RxList<ProductEntity> products = <ProductEntity>[].obs;
  final Rx<ProductEntity?> productDetail = Rxn<ProductEntity>();

  // ═══════════════════════════════════════════════════════════
  //  PAGINATION & FILTER STATE
  // ═══════════════════════════════════════════════════════════

  /// Loading state — load more (tetap boolean karena berjalan
  /// bersamaan dengan productsStatus = success).
  final RxBool isLoadingMore = false.obs;

  /// Apakah masih ada halaman berikutnya.
  final RxBool hasMore = true.obs;

  /// Total item dari server (untuk menghitung hasMore).
  final RxInt total = 0.obs;

  /// Pagination
  final RxInt limit = 10.obs;
  final RxInt skip = 0.obs;

  final searchController = TextEditingController();

  // ═══════════════════════════════════════════════════════════
  //  ADD PRODUCT FORM
  // ═══════════════════════════════════════════════════════════

  final addProductFormKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final categoryController = TextEditingController();
  final priceController = TextEditingController();
  final discountController = TextEditingController();
  final ratingController = TextEditingController();
  final stockController = TextEditingController();
  final brandController = TextEditingController();
  final skuController = TextEditingController();

  //═══════════════════════════════════════════════════════════
  // UPDATE PRODUCT FORM
  //═══════════════════════════════════════════════════════════
  final updateProductFormKey = GlobalKey<FormState>();
  final updateTitleController = TextEditingController();
  final updateDescriptionController = TextEditingController();
  final updateCategoryController = TextEditingController();
  final updatePriceController = TextEditingController();
  final updateDiscountController = TextEditingController();
  final updateRatingController = TextEditingController();
  final updateStockController = TextEditingController();
  final updateBrandController = TextEditingController();
  final updateSkuController = TextEditingController();

  // ═══════════════════════════════════════════════════════════
  //  CONFIG
  // ═══════════════════════════════════════════════════════════

  /// Controller untuk menangani scroll.
  final ScrollController scrollController = ScrollController();

  /// Threshold (dalam pixel) sebelum mencapai bawah list
  /// untuk mulai load more.
  static const double _scrollThreshold = 200.0;

  // ═══════════════════════════════════════════════════════════
  //  LIFECYCLE
  // ═══════════════════════════════════════════════════════════

  AppLifecycleService? _lifecycleService;

  @override
  void onInit() {
    super.onInit();

    // Pasang scroll listener untuk infinite scroll
    scrollController.addListener(_onScroll);

    fetchProducts();

    // Daftarkan callback refresh saat app kembali dari background
    try {
      _lifecycleService = Get.find<AppLifecycleService>();
      _lifecycleService?.addOnResumeCallback(_onAppResumed);
    } catch (_) {
      // AppLifecycleService belum di-register — skip
    }
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    searchController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    categoryController.dispose();
    priceController.dispose();
    discountController.dispose();
    ratingController.dispose();
    stockController.dispose();
    brandController.dispose();
    skuController.dispose();
    // Hapus callback saat controller di-dispose
    _lifecycleService?.removeOnResumeCallback(_onAppResumed);
    super.onClose();
  }

  /// Dipanggil otomatis saat app kembali ke foreground.
  void _onAppResumed() {
    fetchProducts();
  }

  // ═══════════════════════════════════════════════════════════
  //  SCROLL LISTENER
  // ═══════════════════════════════════════════════════════════

  void _onScroll() {
    if (!scrollController.hasClients) return;

    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.position.pixels;

    // Jika mendekati bawah list, trigger load more
    if (maxScroll - currentScroll <= _scrollThreshold) {
      loadMoreProducts();
    }
  }

  // ═══════════════════════════════════════════════════════════
  //  PUBLIC API — LIST
  // ═══════════════════════════════════════════════════════════

  /// Get all products
  Future<void> fetchProducts() async {
    // Reset pagination state
    skip.value = 0;
    hasMore.value = true;
    total.value = 0;
    productsStatus.value = ApiCallStatus.loading;
    update(['products']);

    final filter = _buildFilter();
    final result = await _getProductsUseCase.execute(filter);

    result.fold(
      (error) {
        productsStatus.value = ApiCallStatus.error;
        SnackbarHelper.showError(error.message);
        update(['products']);
      },
      (data) {
        total.value = data.total;
        products.assignAll(data.products);

        // Cek apakah masih ada data setelah batch ini
        hasMore.value = (skip.value + limit.value) < data.total;

        productsStatus.value = data.products.isEmpty
            ? ApiCallStatus.empty
            : ApiCallStatus.success;
        update(['products']);
      },
    );
  }

  /// Get next products
  Future<void> loadMoreProducts() async {
    if (!hasMore.value || isLoadingMore.value) return;

    isLoadingMore.value = true;
    skip.value += limit.value;

    final filter = _buildFilter();
    final result = await _getProductsUseCase.execute(filter);

    result.fold(
      (error) {
        // Rollback skip agar bisa retry
        skip.value -= limit.value;
        isLoadingMore.value = false;
        SnackbarHelper.showError(error.message);
        update(['products']);
      },
      (data) {
        total.value = data.total;
        products.addAll(data.products);

        // Cek apakah masih ada data setelah batch ini
        hasMore.value = (skip.value + limit.value) < data.total;

        isLoadingMore.value = false;
        update(['products']);
      },
    );
  }

  /// get product detail
  Future<void> getProductDetail(String id) async {
    productDetailStatus.value = ApiCallStatus.loading;
    try {
      final result = await _getProductDetailUseCase.execute(id);
      result.fold(
        (error) {
          productDetailStatus.value = ApiCallStatus.error;
          SnackbarHelper.showError(error.message);
          update(['productDetail']);
        },
        (data) {
          productDetail.value = data;
          productDetailStatus.value = ApiCallStatus.success;
          update(['productDetail']);
        },
      );
    } catch (e) {
      productDetailStatus.value = ApiCallStatus.error;
      SnackbarHelper.showError(e.toString());
      update(['productDetail']);
    }
  }

  /// Submit form add product.
  Future<void> submitAddProduct() async {
    if (!(addProductFormKey.currentState?.validate() ?? false)) return;

    final product = ProductModel(
      id: 0,
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      category: categoryController.text.trim(),
      price: double.tryParse(priceController.text.trim()) ?? 0.0,
      discountPercentage:
          double.tryParse(discountController.text.trim()) ?? 0.0,
      rating: double.tryParse(ratingController.text.trim()) ?? 0.0,
      stock: int.tryParse(stockController.text.trim()) ?? 0,
      brand: brandController.text.trim(),
      sku: skuController.text.trim(),
      tags: null,
      weight: null,
      dimensions: null,
      warrantyInformation: null,
      shippingInformation: null,
      availabilityStatus: null,
      reviews: null,
      returnPolicy: null,
      minimumOrderQuantity: null,
      meta: null,
      thumbnail: null,
      images: null,
    );

    productCreateStatus.value = ApiCallStatus.loading;
    EasyLoading.show(status: 'Creating product...');

    try {
      final result = await _createProductUseCase.execute(product);
      result.fold(
        (error) {
          productCreateStatus.value = ApiCallStatus.error;
          EasyLoading.dismiss();
          SnackbarHelper.showError(error.message);
        },
        (data) {
          productCreateStatus.value = ApiCallStatus.success;
          EasyLoading.dismiss();
          SnackbarHelper.showSuccess('Product created successfully!');
          resetAddProductForm();
          fetchProducts();
          final navigationController = Get.find<NavigationController>();
          navigationController.changeTabIndex(0);
        },
      );
    } catch (e) {
      productCreateStatus.value = ApiCallStatus.error;
      EasyLoading.dismiss();
      SnackbarHelper.showError(e.toString());
    }
  }

  // update product
  void loadProductForUpdate(ProductEntity product) {
    updateTitleController.text = product.title;
    updateDescriptionController.text = product.description;
    updateCategoryController.text = product.category;
    updatePriceController.text = product.price.toString();
    updateDiscountController.text = product.discountPercentage.toString();
    updateRatingController.text = product.rating.toString();
    updateStockController.text = product.stock.toString();
    updateBrandController.text = product.brand;
    updateSkuController.text = product.sku;
  }

  void resetUpdateProductForm() {
    updateTitleController.clear();
    updateDescriptionController.clear();
    updateCategoryController.clear();
    updatePriceController.clear();
    updateDiscountController.clear();
    updateRatingController.clear();
    updateStockController.clear();
    updateBrandController.clear();
    updateSkuController.clear();
  }

  Future<void> updateProduct() async {
    if (!updateProductFormKey.currentState!.validate()) return;

    productUpdateStatus.value = ApiCallStatus.loading;
    EasyLoading.show(status: 'Updating product...');

    final product = ProductModel(
      id: productDetail.value!.id,
      title: updateTitleController.text.trim(),
      description: updateDescriptionController.text.trim(),
      category: updateCategoryController.text.trim(),
      price: double.tryParse(updatePriceController.text.trim()) ?? 0.0,
      discountPercentage:
          double.tryParse(updateDiscountController.text.trim()) ?? 0.0,
      rating: double.tryParse(updateRatingController.text.trim()) ?? 0.0,
      stock: int.tryParse(updateStockController.text.trim()) ?? 0,
      brand: updateBrandController.text.trim(),
      sku: updateSkuController.text.trim(),
      tags: null,
      weight: null,
      dimensions: null,
      warrantyInformation: null,
      shippingInformation: null,
      availabilityStatus: null,
      reviews: null,
      returnPolicy: null,
      minimumOrderQuantity: null,
      meta: null,
      thumbnail: null,
      images: null,
    );

    try {
      final result = await _updateProductUseCase.execute(product);
      result.fold(
        (error) {
          productUpdateStatus.value = ApiCallStatus.error;
          EasyLoading.dismiss();
          SnackbarHelper.showError(error.message);
        },
        (data) {
          productUpdateStatus.value = ApiCallStatus.success;
          EasyLoading.dismiss();
          SnackbarHelper.showSuccess('Product updated successfully!');
          resetUpdateProductForm();
          refreshProducts();
        },
      );
    } catch (e) {
      productUpdateStatus.value = ApiCallStatus.error;
      EasyLoading.dismiss();
      SnackbarHelper.showError(e.toString());
    }
  }

  // delete product
  Future<void> deleteProduct(String id) async {
    productDeleteStatus.value = ApiCallStatus.loading;
    EasyLoading.show(status: 'Deleting product...');
    try {
      final result = await _deleteProductUseCase.execute(id);
      result.fold(
        (error) {
          productDeleteStatus.value = ApiCallStatus.error;
          EasyLoading.dismiss();
          SnackbarHelper.showError(error.message);
        },
        (data) {
          Get.back();
          productDeleteStatus.value = ApiCallStatus.success;
          EasyLoading.dismiss();
          SnackbarHelper.showSuccess('Product deleted successfully!');

          refreshProducts();
        },
      );
    } catch (e) {
      productDeleteStatus.value = ApiCallStatus.error;
      EasyLoading.dismiss();
      SnackbarHelper.showError(e.toString());
    }
  }

  /// Reset semua form field add product.
  void resetAddProductForm() {
    titleController.clear();
    descriptionController.clear();
    categoryController.clear();
    priceController.clear();
    discountController.clear();
    ratingController.clear();
    stockController.clear();
    brandController.clear();
    skuController.clear();
  }

  /// Refresh — pull-to-refresh support.
  Future<void> refreshProducts() async {
    await fetchProducts();
  }

  void searchProducts() {
    skip.value = 0;
    products.clear();
    fetchProducts();
  }

  void clearProducts() {
    skip.value = 0;
    products.clear();
    hasMore.value = true;
    isLoadingMore.value = false;
  }

  // ═══════════════════════════════════════════════════════════
  //  INTERNAL HELPERS
  // ═══════════════════════════════════════════════════════════

  PaginationFilter _buildFilter() {
    return PaginationFilter(
      limit: limit.value,
      skip: skip.value,
      search: searchController.text,
    );
  }

  Widget buildTextField({
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

  String? requiredValidator(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
}
