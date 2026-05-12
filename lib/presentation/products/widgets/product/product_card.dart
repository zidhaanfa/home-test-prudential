import 'package:flutter/material.dart';
import 'package:home_test_prudential/domain/products/entities/products_entity.dart';

import '../../../../utils/helper/rupiah.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product});

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(product.title),
      subtitle: Text(
        product.description,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      leading: Container(
        width: 50,
        height: 50,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: product.images.isNotEmpty
            ? Image.network(
                product.images.first,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(strokeWidth: 2),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error_outline, color: Colors.red);
                },
              )
            : const Icon(Icons.image_not_supported),
      ),
      trailing: Text(MoneyHelper().formatCurrencyToUSD(product.price)),
    );
  }
}
