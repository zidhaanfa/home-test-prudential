import 'package:get/get.dart';

import '../../../../domain/products/impl/products_repository_impl.dart';
import '../../../../domain/products/repositories/products_repository.dart';
import '../../../../domain/products/usecases/create_product_usecase.dart';
import '../../../../domain/products/usecases/delete_product_usecase.dart';
import '../../../../domain/products/usecases/get_productDetail_usecase.dart';
import '../../../../domain/products/usecases/get_products_usecase.dart';
import '../../../../domain/products/usecases/update_product_usecase.dart';
import '../../../../presentation/navigation/controllers/navigation.controller.dart';
import '../../../dal/services/products_api_service.dart';
import '../../../platform/secure_storage/flutter_secure_storage_impl.dart';
import '../../../platform/storage/get_storage_impl.dart';

class NavigationControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GetStorageImpl>(() => GetStorageImpl());
    Get.lazyPut<FlutterSecureStorageImpl>(() => FlutterSecureStorageImpl());
    Get.lazyPut<ProductsApiService>(
      () => ProductsApiService(
        secureStorage: Get.find<FlutterSecureStorageImpl>(),
      ),
    );
    Get.lazyPut<ProductsRepository>(
      () => ProductsRepositoryImpl(apiService: Get.find()),
    );
    Get.lazyPut<GetProductsUseCase>(() => GetProductsUseCase(Get.find()));
    Get.lazyPut<GetProductDetailUseCase>(
      () => GetProductDetailUseCase(repository: Get.find()),
    );
    Get.lazyPut<CreateProductUseCase>(() => CreateProductUseCase(Get.find()));
    Get.lazyPut<DeleteProductUseCase>(() => DeleteProductUseCase(Get.find()));
    Get.lazyPut<UpdateProductUseCase>(() => UpdateProductUseCase(Get.find()));
    Get.lazyPut<NavigationController>(() => NavigationController());
  }
}
