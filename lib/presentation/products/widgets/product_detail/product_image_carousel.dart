import 'package:flutter/material.dart';

class ProductImageCarousel extends StatelessWidget {
  const ProductImageCarousel({super.key, required this.images});

  final List<String>? images;

  @override
  Widget build(BuildContext context) {
    if (images != null && images!.isNotEmpty) {
      return SizedBox(
        height: 280,
        width: double.infinity,
        child: PageView.builder(
          itemCount: images!.length,
          itemBuilder: (context, index) {
            return Image.network(
              images![index],
              fit: BoxFit.contain,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(
                    Icons.broken_image_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                );
              },
            );
          },
        ),
      );
    }

    return Container(
      height: 200,
      width: double.infinity,
      color: Colors.grey[200],
      child: const Icon(
        Icons.image_not_supported,
        size: 64,
        color: Colors.grey,
      ),
    );
  }
}
