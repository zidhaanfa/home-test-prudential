import 'package:get/get.dart';

import '../../../domain/core/usecases/usecase.dart';
import '../../../domain/profile/entities/profile_entity.dart';
import '../../../domain/profile/usecases/get_profile_usecase.dart';
import '../../../utils/config.dart';
import '../../../utils/helper/snackbar.dart';

class ProfileController extends GetxController {
  final GetProfileUseCase _getProfileUseCase;

  ProfileController({required GetProfileUseCase getProfileUseCase})
    : _getProfileUseCase = getProfileUseCase;

  // ═══════════════════════════════════════════════════════════
  //  STATUS — setiap fetch punya ApiCallStatus sendiri
  // ═══════════════════════════════════════════════════════════

  /// Status fetch profile.
  final Rx<ApiCallStatus> profileStatus = ApiCallStatus.holding.obs;

  // ═══════════════════════════════════════════════════════════
  //  DATA
  // ═══════════════════════════════════════════════════════════

  final Rx<ProfileEntity?> profile = Rxn<ProfileEntity>();

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> fetchProfile() async {
    profileStatus.value = ApiCallStatus.loading;

    final result = await _getProfileUseCase.execute(NoParams());

    result.fold(
      (error) {
        profileStatus.value = ApiCallStatus.error;
        SnackbarHelper.showError(error.message);
        update(['profile']);
      },
      (data) {
        profile.value = data;
        profileStatus.value = ApiCallStatus.success;
        update(['profile']);
      },
    );
  }
}
