import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'controllers/products.controller.dart';

class ProductsScreen extends GetView<ProductsController> {
  const ProductsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ProductsScreen'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ProductsScreen is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
