import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_test_prudential/presentation/screens.dart';

class NavigationController extends GetxController {
  //TODO: Implement NavigationController

  final tabIndex = 0.obs;
  final indexBefore = 0.obs;
  late List<Widget> screens;
  late ProductsScreen products;
  late AddProductScreen addProduct;
  late ComingSoonScreen comingSoon;
  late ProfileScreen profile;

  @override
  void onInit() {
    super.onInit();

    products = const ProductsScreen();
    addProduct = const AddProductScreen();
    comingSoon = const ComingSoonScreen();
    profile = const ProfileScreen();

    screens = [products, comingSoon, addProduct, comingSoon, profile];
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }
}
