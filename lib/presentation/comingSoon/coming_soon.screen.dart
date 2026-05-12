import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'controllers/coming_soon.controller.dart';

class ComingSoonScreen extends GetView<ComingSoonController> {
  const ComingSoonScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ComingSoonScreen'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ComingSoonScreen is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
