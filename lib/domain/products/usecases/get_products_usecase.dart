import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/products_entity.dart';
import '../repositories/products_repository.dart';

class GetProductsUseCase implements UseCase<ProductsEntity, NoParams> {
  final ProductsRepository repository;

  GetProductsUseCase(this.repository);

  @override
  Future<Either<Failure, ProductsEntity>> execute(NoParams params) async {
    return await repository.getProducts();
  }
}
