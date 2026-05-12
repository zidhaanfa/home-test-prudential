import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_test_prudential/domain/products/entities/products_entity.dart';
import 'package:home_test_prudential/domain/products/usecases/get_products_usecase.dart';
import 'package:home_test_prudential/infrastructure/dal/models/pagination_filter.dart';

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

  /// create
  Future<void> createProduct(ProductModel product) async {
    productCreateStatus.value = ApiCallStatus.loading;
    try {
      final result = await _createProductUseCase.execute(product);
      result.fold(
        (error) {
          productCreateStatus.value = ApiCallStatus.error;
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
