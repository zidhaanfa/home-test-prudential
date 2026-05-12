import 'package:dartz/dartz.dart';
import '/infrastructure/dal/models/pagination_filter.dart';
import '../../core/errors/failures.dart';
import '../entities/products_entity.dart';

abstract class ProductsRepository {
  Future<Either<Failure, ProductsEntity>> getProducts(PaginationFilter filter);
}
