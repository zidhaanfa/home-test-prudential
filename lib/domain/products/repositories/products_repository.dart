import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/products_entity.dart';

abstract class ProductsRepository {
  Future<Either<Failure, ProductsEntity>> getProducts();
}
