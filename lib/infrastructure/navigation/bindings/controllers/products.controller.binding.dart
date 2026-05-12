import 'package:get/get.dart';
import 'package:home_test_prudential/infrastructure/dal/services/products_api_service.dart';

import '../../../../domain/products/impl/products_repository_impl.dart';
import '../../../../domain/products/repositories/products_repository.dart';
import '../../../../domain/products/usecases/create_product_usecase.dart';
import '../../../../domain/products/usecases/delete_product_usecase.dart';
import '../../../../domain/products/usecases/get_productDetail_usecase.dart';
import '../../../../domain/products/usecases/get_products_usecase.dart';
import '../../../../presentation/products/controllers/products.controller.dart';
// import '../../../platform/secure_storage/flutter_secure_storage_impl.dart';

class ProductsControllerBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut<FlutterSecureStorageImpl>(() => FlutterSecureStorageImpl());
    Get.lazyPut<ProductsApiService>(() => ProductsApiService());
    Get.lazyPut<ProductsRepository>(
      () => ProductsRepositoryImpl(apiService: Get.find()),
    );
    Get.lazyPut<GetProductsUseCase>(() => GetProductsUseCase(Get.find()));
    Get.lazyPut<GetProductDetailUseCase>(
      () => GetProductDetailUseCase(repository: Get.find()),
    );
    Get.lazyPut<CreateProductUseCase>(() => CreateProductUseCase(Get.find()));
    Get.lazyPut<DeleteProductUseCase>(() => DeleteProductUseCase(Get.find()));
    Get.lazyPut<ProductsController>(
      () => ProductsController(
        getProductsUseCase: Get.find(),
        getProductDetailUseCase: Get.find(),
        createProductUseCase: Get.find(),
        deleteProductUseCase: Get.find(),
      ),
    );
  }
}
