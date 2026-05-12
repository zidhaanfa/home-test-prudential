import 'package:get/get.dart';

import '../../../../presentation/comingSoon/controllers/coming_soon.controller.dart';

class ComingSoonControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ComingSoonController>(
      () => ComingSoonController(),
    );
  }
}
