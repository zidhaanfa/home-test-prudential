import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/products.controller.dart';

class AddProductScreen extends GetView<ProductsController> {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),
      body: const Center(child: Text('Add Product')),
    );
  }
}
