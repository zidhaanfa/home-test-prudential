import 'package:dartz/dartz.dart';
import '/infrastructure/dal/models/pagination_filter.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/products_entity.dart';
import '../repositories/products_repository.dart';

class GetProductsUseCase implements UseCase<ProductsEntity, PaginationFilter> {
  final ProductsRepository repository;

  GetProductsUseCase(this.repository);

  @override
  Future<Either<Failure, ProductsEntity>> execute(
    PaginationFilter params,
  ) async {
    return await repository.getProducts(params);
  }
}
