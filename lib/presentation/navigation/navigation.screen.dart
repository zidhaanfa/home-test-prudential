import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../products/controllers/products.controller.dart';
import '../profile/controllers/profile.controller.dart';
import 'controllers/navigation.controller.dart';

class NavigationScreen extends GetView<NavigationController> {
  const NavigationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final NavigationController controller = Get.put(NavigationController());
    final theme = Theme.of(context);
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.tabIndex.value,
          children: controller.screens,
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.tabIndex.value,
          onTap: (index) => _handleNavigation(index, controller),
          type: BottomNavigationBarType.shifting,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedItemColor: theme.colorScheme.primary,
          unselectedItemColor: theme.colorScheme.onSurface.withValues(
            alpha: 0.5,
          ),
          selectedLabelStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: 'Products',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Menu 2'),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add'),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Menu 4'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }

  Future<void> _handleNavigation(
    int index,
    NavigationController controller,
  ) async {
    switch (index) {
      case 0:
        final ProductsController productsController = Get.put(Get.find());
        productsController.refreshProducts();
        controller.tabIndex.value = index;
        break;
      case 1:
        controller.tabIndex.value = index;
        break;
      case 2:
        controller.tabIndex.value = index;
        break;
      case 3:
        controller.tabIndex.value = index;

        break;
      case 4:
        final ProfileController profileController = Get.put(Get.find());
        profileController.fetchProfile();

        controller.tabIndex.value = index;
        break;
    }
  }
}
