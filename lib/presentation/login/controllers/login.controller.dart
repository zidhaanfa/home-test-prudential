import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/auth/usecases/login_usecase.dart';
import '../../../infrastructure/navigation/routes.dart';
import '../../../presentation/core/base_controller.dart';
import '../../../utils/helper/snackbar.dart';

class LoginController extends BaseController {
  final LoginUseCase loginUseCase;

  LoginController({required this.loginUseCase});

  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final isObscure = true.obs;

  @override
  void onInit() {
    usernameController.text = 'emilys';
    passwordController.text = 'emilyspass';

    super.onInit();
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void toggleObscure() => isObscure.toggle();

  Future<void> doLogin() async {
    if (!formKey.currentState!.validate()) return;

    final params = LoginParams(
      username: usernameController.text.trim(),
      password: passwordController.text,
    );

    await callUseCase(
      loginUseCase.execute(params),
      onSuccess: (login) {
        SnackbarHelper.showSuccess('Welcome back, ${login.username}');
        Get.offAllNamed(Routes.home);
      },
    );
  }
}
