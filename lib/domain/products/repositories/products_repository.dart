import 'package:dartz/dartz.dart';
import '../models/products_model.dart';
import '/infrastructure/dal/models/pagination_filter.dart';
import '../../core/errors/failures.dart';
import '../entities/products_entity.dart';

abstract class ProductsRepository {
  Future<Either<Failure, ProductsEntity>> getProducts(PaginationFilter filter);
  Future<Either<Failure, ProductEntity>> getProductDetail(String id);
  Future<Either<Failure, ProductModel>> createProduct(ProductModel product);
  Future<Either<Failure, ProductModel>> updateProduct(
    String id,
    ProductModel product,
  );
  Future<Either<Failure, ProductEntity>> deleteProduct(String id);
}
