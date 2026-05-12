import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:home_test_prudential/domain/products/entities/products_entity.dart';
import 'package:home_test_prudential/domain/products/usecases/get_products_usecase.dart';
import 'package:home_test_prudential/infrastructure/dal/models/pagination_filter.dart';
import 'package:home_test_prudential/presentation/navigation/controllers/navigation.controller.dart';

import '../../../config/lifecycle/app_lifecycle_service.dart';
import '../../../domain/products/models/products_model.dart';
import '../../../domain/products/usecases/create_product_usecase.dart';
import '../../../domain/products/usecases/get_productDetail_usecase.dart';
import '../../../utils/config.dart';
import '../../../utils/helper/snackbar.dart';

class ProductsController extends GetxController {
  final GetProductsUseCase _getProductsUseCase;
  final GetProductDetailUseCase _getProductDetailUseCase;
  final CreateProductUseCase _createProductUseCase;

  ProductsController({
    required GetProductsUseCase getProductsUseCase,
    required GetProductDetailUseCase getProductDetailUseCase,
    required CreateProductUseCase createProductUseCase,
  }) : _getProductsUseCase = getProductsUseCase,
       _getProductDetailUseCase = getProductDetailUseCase,
       _createProductUseCase = createProductUseCase;

  // ═══════════════════════════════════════════════════════════
  //  STATUS — setiap fetch punya ApiCallStatus sendiri
  // ═══════════════════════════════════════════════════════════

  /// Status fetch list products.
  final Rx<ApiCallStatus> productsStatus = ApiCallStatus.holding.obs;
  final Rx<ApiCallStatus> productDetailStatus = ApiCallStatus.holding.obs;
  final Rx<ApiCallStatus> productCreateStatus = ApiCallStatus.holding.obs;

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

  /// Fetch halaman pertama (reset pagination).
  Future<void> fetchProducts() async {
    // Reset pagination state
    skip.value = 0;
    hasMore.value = true;
    total.value = 0;
    productsStatus.value = ApiCallStatus.loading;

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

  /// Load halaman berikutnya (append ke list).
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

  void searchProducts(String search) {
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
      select: searchController.text,
    );
  }
}
