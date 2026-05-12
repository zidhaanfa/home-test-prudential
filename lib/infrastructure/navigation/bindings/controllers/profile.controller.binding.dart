import 'package:get/get.dart';

import '../../../../domain/profile/usecases/get_profile_usecase.dart';
import '../../../../presentation/profile/controllers/profile.controller.dart';
import '../../../dal/services/profile_api_service.dart';
import '../../../platform/secure_storage/flutter_secure_storage_impl.dart';
import '../../../platform/storage/get_storage_impl.dart';

class ProfileControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GetStorageImpl>(() => GetStorageImpl());
    Get.lazyPut<FlutterSecureStorageImpl>(() => FlutterSecureStorageImpl());
    Get.lazyPut<ProfileApiService>(
      () => ProfileApiService(
        secureStorage: Get.find<FlutterSecureStorageImpl>(),
      ),
    );
    Get.lazyPut<GetProfileUseCase>(
      () => GetProfileUseCase(repository: Get.find()),
    );
    Get.lazyPut<ProfileController>(
      () => ProfileController(getProfileUseCase: Get.find<GetProfileUseCase>()),
    );
  }
}
